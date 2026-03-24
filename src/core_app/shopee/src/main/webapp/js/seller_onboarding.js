/**
 * MarketplaceX — Seller Onboarding JavaScript
 * =============================================
 * Handles: step navigation, validation, localStorage drafts,
 * mock API, modal, file upload, theme toggle, toast, geolocation
 */

(function () {
    'use strict';

    // ========================================
    // CONFIG
    // ========================================
    const TOTAL_STEPS = 5;
    const STORAGE_KEY = 'so_draft';
    const THEME_KEY = 'so_theme';

    // ========================================
    // STATE
    // ========================================
    let currentStep = 0;
    let formData = {
        step1: { shopName: '', email: '', address: null },
        step2: { hoaToc: true, nhanh: true, tietKiem: true },
        step3: { businessType: 'hoKinhDoanh', companyName: '', taxId: '', emails: [''], address: '', addressDetail: '', licenseFile: null },
        step4: { idType: 'cccd', idNumber: '', fullName: '', idFrontFile: null, idHoldingFile: null, agreePolicy: false },
    };

    // ========================================
    // DOM HELPERS
    // ========================================
    const $ = (sel, ctx) => (ctx || document).querySelector(sel);
    const $$ = (sel, ctx) => Array.from((ctx || document).querySelectorAll(sel));

    // ========================================
    // INITIALIZATION
    // ========================================
    document.addEventListener('DOMContentLoaded', () => {
        loadTheme();
        loadDraft();
        renderStep(currentStep);
        bindStepper();
        bindThemeToggle();
        bindAddressModal();
        bindLightbox();
    });

    // ========================================
    // THEME TOGGLE
    // ========================================
    function loadTheme() {
        const saved = localStorage.getItem(THEME_KEY);
        if (saved === 'dark') {
            document.documentElement.setAttribute('data-theme', 'dark');
        }
        updateThemeIcon();
    }

    function bindThemeToggle() {
        const btn = $('#themeToggleBtn');
        if (!btn) return;
        btn.addEventListener('click', () => {
            const isDark = document.documentElement.getAttribute('data-theme') === 'dark';
            document.documentElement.setAttribute('data-theme', isDark ? 'light' : 'dark');
            localStorage.setItem(THEME_KEY, isDark ? 'light' : 'dark');
            updateThemeIcon();
        });
    }

    function updateThemeIcon() {
        const btn = $('#themeToggleBtn');
        if (!btn) return;
        const isDark = document.documentElement.getAttribute('data-theme') === 'dark';
        btn.innerHTML = isDark ? '<i class="fas fa-sun"></i>' : '<i class="fas fa-moon"></i>';
        btn.title = isDark ? 'Chuyển sang sáng' : 'Chuyển sang tối';
    }

    // ========================================
    // STEPPER
    // ========================================
    function bindStepper() {
        $$('.so-stepper__item').forEach((item, idx) => {
            item.addEventListener('click', () => {
                if (idx < currentStep) {
                    currentStep = idx;
                    renderStep(currentStep);
                }
            });
            item.addEventListener('keydown', (e) => {
                if (e.key === 'Enter' || e.key === ' ') {
                    e.preventDefault();
                    item.click();
                }
            });
        });
    }

    function updateStepper() {
        $$('.so-stepper__item').forEach((item, idx) => {
            item.classList.remove('so-stepper__item--active', 'so-stepper__item--completed');
            if (idx === currentStep) {
                item.classList.add('so-stepper__item--active');
                item.setAttribute('aria-current', 'step');
            } else {
                item.removeAttribute('aria-current');
            }
            if (idx < currentStep) {
                item.classList.add('so-stepper__item--completed');
            }
        });
    }

    // ========================================
    // STEP RENDERING
    // ========================================
    function renderStep(step) {
        updateStepper();
        $$('.so-step-content').forEach((el, idx) => {
            if (idx === step) {
                el.removeAttribute('hidden');
                el.style.animation = 'none';
                el.offsetHeight; // trigger reflow
                el.style.animation = '';
            } else {
                el.setAttribute('hidden', '');
            }
        });
        restoreFormState(step);
        updateInputCounters();
        // scroll to top of card
        const card = $('.so-card');
        if (card) card.scrollIntoView({ behavior: 'smooth', block: 'start' });
    }

    // ========================================
    // INPUT COUNTERS
    // ========================================
    function updateInputCounters() {
        $$('.so-input[data-maxlength]').forEach(input => {
            const counter = input.parentElement.querySelector('.so-input-counter');
            if (counter) {
                const max = input.getAttribute('data-maxlength');
                counter.textContent = `${input.value.length}/${max}`;
            }
        });
    }

    document.addEventListener('input', (e) => {
        if (e.target.matches('.so-input[data-maxlength]')) {
            const max = parseInt(e.target.getAttribute('data-maxlength'));
            if (e.target.value.length > max) {
                e.target.value = e.target.value.substring(0, max);
            }
            const counter = e.target.parentElement.querySelector('.so-input-counter');
            if (counter) {
                counter.textContent = `${e.target.value.length}/${max}`;
            }
            // clear error on input
            clearFieldError(e.target);
        }
    });

    document.addEventListener('input', (e) => {
        if (e.target.matches('.so-textarea, .so-select')) {
            clearFieldError(e.target);
        }
    });

    // ========================================
    // VALIDATION
    // ========================================
    function validateStep(step) {
        const errors = [];
        const stepEl = $$('.so-step-content')[step];
        if (!stepEl) return [];

        // Clear all previous errors in this step
        $$('.so-input--error', stepEl).forEach(el => el.classList.remove('so-input--error'));
        $$('.so-error-text--show', stepEl).forEach(el => el.classList.remove('so-error-text--show'));

        if (step === 0) {
            const shopName = $('#shopName');
            if (!shopName.value.trim()) {
                errors.push({ el: shopName, msg: 'Vui lòng nhập tên Shop' });
            }
            const email = $('#shopEmail');
            if (email && email.value.trim() && !isValidEmail(email.value)) {
                errors.push({ el: email, msg: 'Email không hợp lệ' });
            }
        }

        if (step === 2) {
            const companyName = $('#companyName');
            if (companyName && !companyName.value.trim()) {
                errors.push({ el: companyName, msg: 'Vui lòng nhập tên công ty/ hộ kinh doanh' });
            }
            const taxEmail = $('#taxEmail0');
            if (taxEmail && taxEmail.value.trim() && !isValidEmail(taxEmail.value)) {
                errors.push({ el: taxEmail, msg: 'Email không hợp lệ' });
            }
        }

        if (step === 3) {
            const idNumber = $('#idNumber');
            if (idNumber && !idNumber.value.trim()) {
                errors.push({ el: idNumber, msg: 'Vui lòng nhập số định danh' });
            }
            const idFullName = $('#idFullName');
            if (idFullName && !idFullName.value.trim()) {
                errors.push({ el: idFullName, msg: 'Vui lòng nhập họ và tên' });
            }
            // Check file uploads
            const frontPreview = $('#idFrontPreview');
            if (frontPreview && !frontPreview.querySelector('img')) {
                const zone = $('#idFrontUpload');
                if (zone) errors.push({ el: zone, msg: 'Vui lòng tải ảnh mặt trước CMND/CCCD/Hộ chiếu' });
            }
            const holdPreview = $('#idHoldPreview');
            if (holdPreview && !holdPreview.querySelector('img')) {
                const zone = $('#idHoldUpload');
                if (zone) errors.push({ el: zone, msg: 'Vui lòng tải ảnh cầm CMND/CCCD/Hộ chiếu' });
            }
            // Policy checkbox
            const agree = $('#agreePolicy');
            if (agree && !agree.checked) {
                errors.push({ el: agree, msg: 'Vui lòng xác nhận và đồng ý chính sách' });
            }
        }

        // Show errors
        errors.forEach(err => {
            showFieldError(err.el, err.msg);
        });

        // Scroll to first error
        if (errors.length > 0) {
            errors[0].el.scrollIntoView({ behavior: 'smooth', block: 'center' });
            errors[0].el.focus && errors[0].el.focus();
        }

        return errors;
    }

    function showFieldError(el, msg) {
        if (el.classList.contains('so-input') || el.classList.contains('so-textarea') || el.classList.contains('so-select')) {
            el.classList.add('so-input--error');
            el.setAttribute('aria-invalid', 'true');
        }
        // Find or create error text
        let errorEl = el.parentElement.querySelector('.so-error-text');
        if (!errorEl) {
            // Try the parent's parent for checkbox/upload
            errorEl = el.closest('.so-form-group')?.querySelector('.so-error-text');
        }
        if (errorEl) {
            errorEl.textContent = msg;
            errorEl.classList.add('so-error-text--show');
        }
    }

    function clearFieldError(el) {
        el.classList.remove('so-input--error');
        el.removeAttribute('aria-invalid');
        const errorEl = el.parentElement.querySelector('.so-error-text');
        if (errorEl) errorEl.classList.remove('so-error-text--show');
    }

    function isValidEmail(email) {
        return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email);
    }

    function isValidPhone(phone) {
        return /^[0-9]{9,11}$/.test(phone.replace(/\s/g, ''));
    }

    // ========================================
    // NAVIGATION BUTTONS
    // ========================================
    window.soNext = async function () {
        if (currentStep >= TOTAL_STEPS - 1) return;

        // Skip validation for step 1 (shipping — no required fields)
        if (currentStep !== 1) {
            const errors = validateStep(currentStep);
            if (errors.length > 0) return;
        }

        collectFormData(currentStep);
        saveDraft();

        // Mock API
        const btn = $(`#nextBtn${currentStep}`);
        if (btn) {
            btn.disabled = true;
            btn.innerHTML = '<span class="so-spinner"></span> Đang xử lý...';
        }

        try {
            await mockApiSubmit(currentStep);
            currentStep++;
            renderStep(currentStep);
        } catch (err) {
            showToast('Lỗi kết nối mạng. Vui lòng thử lại.', 'error');
        } finally {
            if (btn) {
                btn.disabled = false;
                btn.innerHTML = currentStep >= TOTAL_STEPS - 1 ? 'Hoàn tất' : 'Tiếp theo';
            }
        }
    };

    window.soPrev = function () {
        if (currentStep <= 0) return;
        collectFormData(currentStep);
        saveDraft();
        currentStep--;
        renderStep(currentStep);
    };

    window.soSave = function () {
        collectFormData(currentStep);
        saveDraft();
        showToast('Đã lưu nháp thành công!', 'success');
    };

    window.soComplete = async function () {
        const errors = validateStep(currentStep);
        if (errors.length > 0) return;

        collectFormData(currentStep);

        const btn = $('#completeBtn');
        if (btn) {
            btn.disabled = true;
            btn.innerHTML = '<span class="so-spinner"></span> Đang xử lý...';
        }

        try {
            await mockApiSubmit(currentStep);
            clearDraft();
            currentStep = TOTAL_STEPS - 1;
            renderStep(currentStep);
        } catch (err) {
            showToast('Lỗi kết nối mạng. Vui lòng thử lại.', 'error');
        } finally {
            if (btn) {
                btn.disabled = false;
                btn.innerHTML = 'Hoàn tất';
            }
        }
    };

    // ========================================
    // FORM DATA COLLECTION & RESTORE
    // ========================================
    function collectFormData(step) {
        if (step === 0) {
            formData.step1.shopName = ($('#shopName')?.value || '');
            formData.step1.email = ($('#shopEmail')?.value || '');
        }
        if (step === 1) {
            formData.step2.hoaToc = $('#toggleHoaToc')?.checked ?? true;
            formData.step2.nhanh = $('#toggleNhanh')?.checked ?? true;
            formData.step2.tietKiem = $('#toggleTietKiem')?.checked ?? true;
        }
        if (step === 2) {
            formData.step3.businessType = document.querySelector('input[name="businessType"]:checked')?.value || 'hoKinhDoanh';
            formData.step3.companyName = ($('#companyName')?.value || '');
            formData.step3.taxId = ($('#taxId')?.value || '');
            formData.step3.addressDetail = ($('#taxAddressDetail')?.value || '');
            // Collect emails
            formData.step3.emails = $$('.so-tax-email-input').map(el => el.value);
        }
        if (step === 3) {
            formData.step4.idType = document.querySelector('input[name="idType"]:checked')?.value || 'cccd';
            formData.step4.idNumber = ($('#idNumber')?.value || '');
            formData.step4.fullName = ($('#idFullName')?.value || '');
            formData.step4.agreePolicy = ($('#agreePolicy')?.checked || false);
        }
    }

    function restoreFormState(step) {
        if (step === 0) {
            const shopName = $('#shopName');
            if (shopName) shopName.value = formData.step1.shopName || '';
            const email = $('#shopEmail');
            if (email) email.value = formData.step1.email || '';
        }
        if (step === 1) {
            const t1 = $('#toggleHoaToc');
            if (t1) t1.checked = formData.step2.hoaToc;
            const t2 = $('#toggleNhanh');
            if (t2) t2.checked = formData.step2.nhanh;
            const t3 = $('#toggleTietKiem');
            if (t3) t3.checked = formData.step2.tietKiem;
        }
        if (step === 2) {
            const bt = document.querySelector(`input[name="businessType"][value="${formData.step3.businessType}"]`);
            if (bt) bt.checked = true;
            const cn = $('#companyName');
            if (cn) cn.value = formData.step3.companyName || '';
            const ti = $('#taxId');
            if (ti) ti.value = formData.step3.taxId || '';
            const ad = $('#taxAddressDetail');
            if (ad) ad.value = formData.step3.addressDetail || '';
            // Restore emails
            if (formData.step3.emails && formData.step3.emails.length > 0) {
                const firstInput = $('#taxEmail0');
                if (firstInput) firstInput.value = formData.step3.emails[0] || '';
            }
        }
        if (step === 3) {
            const it = document.querySelector(`input[name="idType"][value="${formData.step4.idType}"]`);
            if (it) it.checked = true;
            const idn = $('#idNumber');
            if (idn) idn.value = formData.step4.idNumber || '';
            const fn = $('#idFullName');
            if (fn) fn.value = formData.step4.fullName || '';
            const ap = $('#agreePolicy');
            if (ap) ap.checked = formData.step4.agreePolicy || false;
            updateIdTypeLabel();
        }
    }

    // ========================================
    // ID TYPE LABEL UPDATE
    // ========================================
    window.updateIdTypeLabel = function () {
        const selected = document.querySelector('input[name="idType"]:checked');
        if (!selected) return;
        const labels = {
            'cccd': 'Căn Cước Công Dân (CCCD)',
            'cmnd': 'Chứng Minh Nhân Dân (CMND)',
            'passport': 'Hộ chiếu'
        };
        const idLabel = $('#idNumberLabel');
        if (idLabel) idLabel.textContent = 'Số ' + (labels[selected.value] || '');
    };

    // ========================================
    // MOCK API
    // ========================================
    function mockApiSubmit(step) {
        return new Promise((resolve, reject) => {
            setTimeout(() => {
                if (Math.random() < 0.9) {
                    resolve({ success: true, step });
                } else {
                    reject(new Error('Network error'));
                }
            }, 800 + Math.random() * 700);
        });
    }

    // ========================================
    // LOCAL STORAGE DRAFTING
    // ========================================
    function saveDraft() {
        try {
            const draft = {
                currentStep,
                formData,
                timestamp: Date.now()
            };
            localStorage.setItem(STORAGE_KEY, JSON.stringify(draft));
        } catch (e) { /* ignore quota errors */ }
    }

    function loadDraft() {
        try {
            const raw = localStorage.getItem(STORAGE_KEY);
            if (!raw) return;
            const draft = JSON.parse(raw);
            if (draft.formData) {
                formData = { ...formData, ...draft.formData };
            }
            if (typeof draft.currentStep === 'number' && draft.currentStep < TOTAL_STEPS - 1) {
                currentStep = draft.currentStep;
            }
        } catch (e) { /* ignore parse errors */ }
    }

    function clearDraft() {
        localStorage.removeItem(STORAGE_KEY);
    }

    // ========================================
    // TOAST NOTIFICATIONS
    // ========================================
    function showToast(message, type = 'success') {
        let container = $('.so-toast-container');
        if (!container) {
            container = document.createElement('div');
            container.className = 'so-toast-container';
            document.body.appendChild(container);
        }

        const toast = document.createElement('div');
        toast.className = `so-toast so-toast--${type}`;
        const icon = type === 'error' ? 'fa-exclamation-circle' : 'fa-check-circle';
        toast.innerHTML = `<i class="fas ${icon}"></i><span>${message}</span>`;
        container.appendChild(toast);

        setTimeout(() => {
            toast.classList.add('so-toast--exit');
            setTimeout(() => toast.remove(), 300);
        }, 3000);
    }
    window.showToast = showToast;

    // ========================================
    // ADDRESS MODAL
    // ========================================
    function bindAddressModal() {
        const overlay = $('#addressModalOverlay');
        if (!overlay) return;

        // Open
        $$('.so-open-address-modal').forEach(btn => {
            btn.addEventListener('click', () => openModal());
        });

        // Close
        const closeBtn = $('#addressModalClose');
        if (closeBtn) closeBtn.addEventListener('click', closeModal);

        const cancelBtn = $('#addressModalCancel');
        if (cancelBtn) cancelBtn.addEventListener('click', closeModal);

        overlay.addEventListener('click', (e) => {
            if (e.target === overlay) closeModal();
        });

        // Escape key
        document.addEventListener('keydown', (e) => {
            if (e.key === 'Escape' && overlay.classList.contains('so-modal-overlay--show')) {
                closeModal();
            }
        });

        // Save address
        const saveBtn = $('#addressModalSave');
        if (saveBtn) {
            saveBtn.addEventListener('click', () => {
                const name = $('#addrName')?.value?.trim();
                const phone = $('#addrPhone')?.value?.trim();

                if (!name) {
                    showToast('Vui lòng nhập họ và tên', 'error');
                    return;
                }
                if (!phone || !isValidPhone(phone)) {
                    showToast('Số điện thoại không hợp lệ', 'error');
                    return;
                }

                // Save to form data
                const province = $('#addrProvince')?.selectedOptions[0]?.text || '';
                const district = $('#addrDistrict')?.selectedOptions[0]?.text || '';
                const ward = $('#addrWard')?.selectedOptions[0]?.text || '';
                const detail = $('#addrDetail')?.value || '';

                formData.step1.address = {
                    name, phone,
                    location: [province, district, ward].filter(Boolean).join(' / '),
                    detail
                };

                // Update display
                const display = $('#addressDisplay');
                if (display) {
                    display.innerHTML = `
                        <div style="font-weight:500;margin-bottom:4px">${name} — ${phone}</div>
                        <div style="color:var(--so-text-secondary);font-size:13px">${formData.step1.address.location}</div>
                        <div style="color:var(--so-text-secondary);font-size:13px">${detail}</div>
                    `;
                }

                showToast('Đã lưu địa chỉ thành công!', 'success');
                closeModal();
            });
        }

        // Geolocation
        const geoBtn = $('#geoBtn');
        if (geoBtn) {
            geoBtn.addEventListener('click', () => {
                if (!navigator.geolocation) {
                    showToast('Trình duyệt không hỗ trợ định vị', 'error');
                    return;
                }
                geoBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Đang định vị...';
                navigator.geolocation.getCurrentPosition(
                    (pos) => {
                        geoBtn.innerHTML = `<i class="fas fa-map-marker-alt"></i> <span>Đã định vị: ${pos.coords.latitude.toFixed(4)}, ${pos.coords.longitude.toFixed(4)}</span>`;
                        showToast('Đã lấy vị trí thành công!', 'success');
                    },
                    () => {
                        geoBtn.innerHTML = '<i class="fas fa-map-marker-alt"></i> <span>Định vị</span><span class="so-geo-btn__sub">Không thể lấy vị trí</span>';
                        showToast('Không thể lấy vị trí. Vui lòng cho phép quyền truy cập.', 'error');
                    },
                    { timeout: 10000 }
                );
            });
        }

        // Cascading address dropdowns
        bindCascadingAddress();
    }

    function openModal() {
        const overlay = $('#addressModalOverlay');
        if (!overlay) return;
        overlay.classList.add('so-modal-overlay--show');
        document.body.style.overflow = 'hidden';
        // Focus first input
        setTimeout(() => $('#addrName')?.focus(), 300);
        // Keyboard trap
        trapFocus(overlay);
    }

    function closeModal() {
        const overlay = $('#addressModalOverlay');
        if (!overlay) return;
        overlay.classList.remove('so-modal-overlay--show');
        document.body.style.overflow = '';
    }

    function trapFocus(container) {
        const focusable = container.querySelectorAll('input, select, textarea, button, [tabindex]:not([tabindex="-1"])');
        if (focusable.length === 0) return;

        container.addEventListener('keydown', function handler(e) {
            if (e.key !== 'Tab') return;
            const first = focusable[0];
            const last = focusable[focusable.length - 1];
            if (e.shiftKey) {
                if (document.activeElement === first) {
                    e.preventDefault();
                    last.focus();
                }
            } else {
                if (document.activeElement === last) {
                    e.preventDefault();
                    first.focus();
                }
            }
        });
    }

    // ========================================
    // CASCADING ADDRESS DROPDOWNS
    // ========================================
    const addressData = {
        provinces: [
            { id: 'hcm', name: 'TP. Hồ Chí Minh' },
            { id: 'hn', name: 'Hà Nội' },
            { id: 'dn', name: 'Đà Nẵng' },
            { id: 'ag', name: 'An Giang' },
            { id: 'bdg', name: 'Bình Dương' }
        ],
        districts: {
            'hcm': [{ id: 'q1', name: 'Quận 1' }, { id: 'q3', name: 'Quận 3' }, { id: 'q7', name: 'Quận 7' }, { id: 'td', name: 'Thủ Đức' }, { id: 'btan', name: 'Bình Tân' }],
            'hn': [{ id: 'hk', name: 'Hoàn Kiếm' }, { id: 'cg', name: 'Cầu Giấy' }, { id: 'dd', name: 'Đống Đa' }, { id: 'tx', name: 'Thanh Xuân' }],
            'dn': [{ id: 'hc', name: 'Hải Châu' }, { id: 'tk', name: 'Thanh Khê' }, { id: 'sth', name: 'Sơn Trà' }],
            'ag': [{ id: 'lx', name: 'Long Xuyên' }, { id: 'cv', name: 'Châu Đốc' }, { id: 'ap', name: 'Huyện An Phú' }],
            'bdg': [{ id: 'tdi', name: 'Thủ Dầu Một' }, { id: 'da', name: 'Dĩ An' }, { id: 'ta', name: 'Thuận An' }]
        },
        wards: {
            'q1': [{ id: 'bn', name: 'Phường Bến Nghé' }, { id: 'bt', name: 'Phường Bến Thành' }, { id: 'nt', name: 'Phường Nguyễn Thái Bình' }],
            'q3': [{ id: 'p1', name: 'Phường 1' }, { id: 'p4', name: 'Phường 4' }, { id: 'p5', name: 'Phường 5' }],
            'q7': [{ id: 'tn', name: 'Phường Tân Phú' }, { id: 'tp', name: 'Phường Tân Phong' }, { id: 'pm', name: 'Phường Phú Mỹ' }],
            'td': [{ id: 'lt', name: 'Phường Linh Trung' }, { id: 'hd', name: 'Phường Hiệp Bình Chánh' }],
            'btan': [{ id: 'bh', name: 'Phường Bình Hưng Hòa' }, { id: 'btb', name: 'Phường Bình Trị Đông B' }],
            'hk': [{ id: 'hg', name: 'Phường Hàng Gai' }, { id: 'hb', name: 'Phường Hàng Bạc' }],
            'cg': [{ id: 'dh', name: 'Phường Dịch Vọng Hậu' }, { id: 'my', name: 'Phường Mai Dịch' }],
            'dd': [{ id: 'vh', name: 'Phường Văn Hội' }, { id: 'oc', name: 'Ô Chợ Dừa' }],
            'tx': [{ id: 'kd', name: 'Phường Khương Đình' }],
            'hc': [{ id: 'th', name: 'Phường Thanh Bình' }],
            'tk': [{ id: 'an', name: 'Phường An Khê' }],
            'sth': [{ id: 'mp', name: 'Phường Mân Thái' }],
            'lx': [{ id: 'mb', name: 'Phường Mỹ Bình' }, { id: 'ml', name: 'Phường Mỹ Long' }],
            'cv': [{ id: 'vd', name: 'Phường Vĩnh Mỹ' }],
            'ap': [{ id: 'tt', name: 'Thị Trấn An Phú' }],
            'tdi': [{ id: 'pd', name: 'Phường Phú Cường' }],
            'da': [{ id: 'dh2', name: 'Phường Đông Hòa' }],
            'ta': [{ id: 'la', name: 'Phường Lái Thiêu' }]
        }
    };

    function bindCascadingAddress() {
        // For modal address
        bindCascade('addrProvince', 'addrDistrict', 'addrWard', addressData);
        // For tax address
        bindCascade('taxProvince', 'taxDistrict', 'taxWard', addressData);
    }

    function bindCascade(provId, distId, wardId, data) {
        const provSel = $(`#${provId}`);
        const distSel = $(`#${distId}`);
        const wardSel = $(`#${wardId}`);
        if (!provSel || !distSel) return;

        provSel.addEventListener('change', () => {
            const pid = provSel.value;
            distSel.innerHTML = '<option value="">Chọn Quận/Huyện</option>';
            if (wardSel) wardSel.innerHTML = '<option value="">Chọn Phường/Xã</option>';
            if (pid && data.districts[pid]) {
                data.districts[pid].forEach(d => {
                    distSel.innerHTML += `<option value="${d.id}">${d.name}</option>`;
                });
            }
        });

        if (distSel && wardSel) {
            distSel.addEventListener('change', () => {
                const did = distSel.value;
                wardSel.innerHTML = '<option value="">Chọn Phường/Xã</option>';
                if (did && data.wards[did]) {
                    data.wards[did].forEach(w => {
                        wardSel.innerHTML += `<option value="${w.id}">${w.name}</option>`;
                    });
                }
            });
        }
    }

    // ========================================
    // FILE UPLOAD
    // ========================================
    window.handleFileUpload = function (inputId, previewId, fieldName) {
        const input = $(`#${inputId}`);
        if (!input || !input.files || !input.files[0]) return;

        const file = input.files[0];

        // Validate type
        if (!['image/jpeg', 'image/png'].includes(file.type)) {
            showToast('Chỉ chấp nhận file JPG hoặc PNG', 'error');
            input.value = '';
            return;
        }

        // Validate size (5MB)
        if (file.size > 5 * 1024 * 1024) {
            showToast('Kích thước file không được vượt quá 5MB', 'error');
            input.value = '';
            return;
        }

        const reader = new FileReader();
        reader.onload = (e) => {
            const previewContainer = $(`#${previewId}`);
            if (previewContainer) {
                previewContainer.innerHTML = `
                    <div class="so-upload__preview">
                        <img src="${e.target.result}" alt="Preview" onclick="openLightbox('${e.target.result}')" style="cursor:zoom-in">
                        <button class="so-upload__remove" onclick="removeUpload('${inputId}', '${previewId}')" title="Xóa" type="button">
                            <i class="fas fa-times"></i>
                        </button>
                    </div>
                `;
            }
            // Clear error
            const zone = $(`#${inputId}`)?.closest('.so-form-group');
            if (zone) {
                const errEl = zone.querySelector('.so-error-text');
                if (errEl) errEl.classList.remove('so-error-text--show');
            }
        };
        reader.readAsDataURL(file);
    };

    window.removeUpload = function (inputId, previewId) {
        const input = $(`#${inputId}`);
        if (input) input.value = '';
        const preview = $(`#${previewId}`);
        if (preview) preview.innerHTML = '';
    };

    // ========================================
    // LIGHTBOX
    // ========================================
    function bindLightbox() {
        const lb = $('#lightbox');
        if (!lb) return;
        lb.addEventListener('click', () => {
            lb.classList.remove('so-lightbox--show');
        });
        document.addEventListener('keydown', (e) => {
            if (e.key === 'Escape' && lb.classList.contains('so-lightbox--show')) {
                lb.classList.remove('so-lightbox--show');
            }
        });
    }

    window.openLightbox = function (src) {
        const lb = $('#lightbox');
        if (!lb) return;
        const img = lb.querySelector('img');
        if (img) img.src = src;
        lb.classList.add('so-lightbox--show');
    };

    // ========================================
    // TAX EMAIL MANAGEMENT
    // ========================================
    window.addTaxEmail = function () {
        const container = $('#taxEmailList');
        if (!container) return;
        const count = container.children.length;
        if (count >= 5) {
            showToast('Tối đa 5 email', 'error');
            return;
        }
        const row = document.createElement('div');
        row.className = 'so-email-row';
        row.innerHTML = `
            <div class="so-input-wrap" style="flex:1">
                <input type="email" class="so-input so-tax-email-input" id="taxEmail${count}" placeholder="Nhập email" data-maxlength="100">
                <span class="so-input-counter">0/100</span>
            </div>
            <button type="button" class="so-btn--link" onclick="this.parentElement.remove()" style="color:var(--so-red)">
                <i class="fas fa-trash"></i>
            </button>
        `;
        container.appendChild(row);
    };

    // ========================================
    // SHIPPING TOGGLE COLLAPSE
    // ========================================
    window.toggleShippingBody = function (id) {
        const body = $(`#${id}`);
        if (!body) return;
        const btn = body.previousElementSibling?.querySelector('.so-shipping-collapse-btn');
        if (body.hasAttribute('hidden')) {
            body.removeAttribute('hidden');
            if (btn) btn.innerHTML = 'Thu gọn <i class="fas fa-chevron-up"></i>';
        } else {
            body.setAttribute('hidden', '');
            if (btn) btn.innerHTML = 'Thu gọn <i class="fas fa-chevron-down"></i>';
        }
    };

})();
