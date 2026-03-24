/**
 * ShopeeWeb Home Page JavaScript
 * Extracted from inline <script> tags for caching & defer loading
 */

document.addEventListener("DOMContentLoaded", function () {
    // ===================================================
    // CAROUSEL NAVIGATION LOGIC
    // ===================================================
    function initCarousel(gridId, btnLeftId, btnRightId, displayStyle) {
        displayStyle = displayStyle || "block";
        const grid = document.getElementById(gridId);
        const btnLeft = document.getElementById(btnLeftId);
        const btnRight = document.getElementById(btnRightId);

        if (grid && btnLeft && btnRight) {
            function updateNavButtons() {
                const maxScroll = grid.scrollWidth - grid.clientWidth;
                const currentScroll = grid.scrollLeft;

                if (maxScroll <= 1) {
                    btnLeft.style.display = "none";
                    btnRight.style.display = "none";
                } else {
                    btnLeft.style.display = currentScroll <= 50 ? "none" : displayStyle;
                    btnRight.style.display = currentScroll >= maxScroll - 50 ? "none" : displayStyle;
                }
            }

            updateNavButtons();

            grid.addEventListener("scroll", updateNavButtons);
            window.addEventListener("resize", updateNavButtons);

            btnLeft.addEventListener("click", function () {
                const currentScroll = grid.scrollLeft;
                const scrollAmount = currentScroll <= grid.clientWidth * 1.5 ? currentScroll : grid.clientWidth;
                grid.scrollBy({ left: -scrollAmount, behavior: "smooth" });
            });
            btnRight.addEventListener("click", function () {
                const maxScroll = grid.scrollWidth - grid.clientWidth;
                const currentScroll = grid.scrollLeft;
                const remainingScroll = maxScroll - currentScroll;
                const scrollAmount = remainingScroll <= grid.clientWidth * 1.5 ? remainingScroll : grid.clientWidth;
                grid.scrollBy({ left: scrollAmount, behavior: "smooth" });
            });

            var observer = new ResizeObserver(function () {
                updateNavButtons();
            });
            observer.observe(grid);

            window.addEventListener('load', updateNavButtons);
        }
    }

    // Apply carousel to all grid sections
    initCarousel("categoryGrid", "btnCategoryLeft", "btnCategoryRight", "flex");
    initCarousel("flashSaleGrid", "btnFlashSaleLeft", "btnFlashSaleRight", "flex");
    initCarousel("shopeeMallGrid", "btnMallLeft", "btnMallRight", "flex");
    initCarousel("topSearchGrid", "btnTopSearchLeft", "btnTopSearchRight", "flex");

    // ===================================================
    // MAIN BANNER CAROUSEL
    // ===================================================
    var mainBannerCarousel = document.getElementById("mainBannerCarousel");
    var mainBannerWrapper = document.getElementById("mainBannerWrapper");
    var mainBannerLeftBtn = document.getElementById("mainBannerLeftBtn");
    var mainBannerRightBtn = document.getElementById("mainBannerRightBtn");
    var dots = document.querySelectorAll(".banner-dot");
    var currentIndex = 0;
    var totalBanners = 2;
    var autoPlayInterval;

    if (mainBannerCarousel) {
        mainBannerWrapper.addEventListener("mouseenter", function () {
            mainBannerLeftBtn.style.display = "block";
            mainBannerRightBtn.style.display = "block";
        });
        mainBannerWrapper.addEventListener("mouseleave", function () {
            mainBannerLeftBtn.style.display = "none";
            mainBannerRightBtn.style.display = "none";
        });

        function updateDots(index) {
            dots.forEach(function (dot) {
                dot.style.opacity = "0.5";
                dot.classList.remove("active");
            });
            if (dots[index]) {
                dots[index].style.opacity = "1";
                dots[index].classList.add("active");
            }
        }

        function scrollToBanner(index) {
            if (index < 0) index = totalBanners - 1;
            if (index >= totalBanners) index = 0;
            currentIndex = index;
            mainBannerCarousel.scrollTo({ left: mainBannerCarousel.clientWidth * currentIndex, behavior: "smooth" });
            updateDots(currentIndex);
        }

        mainBannerLeftBtn.addEventListener("click", function () {
            scrollToBanner(currentIndex - 1);
            resetAutoPlay();
        });

        mainBannerRightBtn.addEventListener("click", function () {
            scrollToBanner(currentIndex + 1);
            resetAutoPlay();
        });

        dots.forEach(function (dot) {
            dot.addEventListener("click", function (e) {
                var idx = parseInt(e.target.getAttribute("data-index"));
                scrollToBanner(idx);
                resetAutoPlay();
            });
        });

        function startAutoPlay() {
            autoPlayInterval = setInterval(function () {
                scrollToBanner(currentIndex + 1);
            }, 3000);
        }

        function resetAutoPlay() {
            clearInterval(autoPlayInterval);
            startAutoPlay();
        }

        mainBannerCarousel.addEventListener("scrollend", function () {
            var scrollPortion = mainBannerCarousel.scrollLeft / mainBannerCarousel.clientWidth;
            var idx = Math.round(scrollPortion);
            if (idx !== currentIndex) {
                currentIndex = idx;
                updateDots(currentIndex);
                resetAutoPlay();
            }
        });

        startAutoPlay();
    }

    // ===================================================
    // SHOPEE AI CHAT WIDGET
    // ===================================================
    var chatBtn = document.getElementById("shopeeChatBtn");
    var chatWindow = document.getElementById("shopeeChatWindow");
    var chatClose = document.getElementById("shopeeChatClose");
    var chatInput = document.getElementById("shopeeChatInput");
    var chatSend = document.getElementById("shopeeChatSend");
    var chatMessages = document.getElementById("shopeeChatMessages");
    var chatImageInput = document.getElementById("chatImageInput");
    var chatFileInput = document.getElementById("chatFileInput");
    var chatImageBtn = document.getElementById("chatImageBtn");
    var chatFileBtn = document.getElementById("chatFileBtn");
    var chatPreview = document.getElementById("chatPreview");

    // API Proxypal qua Ngrok (public URL)
    var apiKey = "proxypal-local";
    var apiUrl = "https://chopfallen-will-steamily.ngrok-free.dev/v1/chat/completions";
    var chatHistory = [];

    // Trạng thái đính kèm hiện tại
    var pendingAttachment = null;

    // Lời nhắc hệ thống (System Prompt)
    var systemInstruction = {
        role: "system",
        content: "Bạn là trợ lý ảo thân thiện của Shopee. Tư vấn khách hàng ngắn gọn, lịch sự, chuyên nghiệp và hữu ích. Dùng emoji sinh động. Khi người dùng gửi ảnh, hãy phân tích và mô tả nội dung ảnh. Khi người dùng gửi file, hãy phân tích nội dung file."
    };

    if (chatBtn && chatWindow) {
        chatBtn.addEventListener("click", function () {
            var isHidden = chatWindow.style.display === "none" || chatWindow.style.display === "";
            chatWindow.style.display = isHidden ? "flex" : "none";
            if (isHidden) {
                chatInput.focus();
            }
        });

        chatClose.addEventListener("click", function () {
            chatWindow.style.display = "none";
        });

        // === Xử lý chọn ảnh ===
        chatImageBtn.addEventListener("click", function () { chatImageInput.click(); });
        chatImageInput.addEventListener("change", function () {
            var file = this.files[0];
            if (!file) return;
            if (file.size > 10 * 1024 * 1024) {
                alert("Ảnh quá lớn! Vui lòng chọn ảnh dưới 10MB.");
                this.value = '';
                return;
            }
            var reader = new FileReader();
            var self = this;
            reader.onload = function (e) {
                var dataUrl = e.target.result;
                pendingAttachment = {
                    type: 'image',
                    dataUrl: dataUrl,
                    name: file.name,
                    mimeType: file.type
                };
                showPreview();
            };
            reader.readAsDataURL(file);
            this.value = '';
        });

        // === Xử lý chọn file ===
        chatFileBtn.addEventListener("click", function () { chatFileInput.click(); });
        chatFileInput.addEventListener("change", function () {
            var file = this.files[0];
            if (!file) return;
            if (file.size > 10 * 1024 * 1024) {
                alert("File quá lớn! Vui lòng chọn file dưới 10MB.");
                this.value = '';
                return;
            }
            var reader = new FileReader();
            reader.onload = function (e) {
                pendingAttachment = {
                    type: 'file',
                    textContent: e.target.result,
                    name: file.name,
                    size: file.size
                };
                showPreview();
            };
            reader.readAsText(file);
            this.value = '';
        });

        // === Hiển thị preview ===
        function showPreview() {
            if (!pendingAttachment) {
                chatPreview.style.display = 'none';
                return;
            }
            chatPreview.style.display = 'flex';
            chatPreview.innerHTML = '';

            if (pendingAttachment.type === 'image') {
                var prevImg = document.createElement('img');
                prevImg.src = pendingAttachment.dataUrl;
                prevImg.alt = 'Preview';
                chatPreview.appendChild(prevImg);

                var prevName = document.createElement('span');
                prevName.style.cssText = 'font-size:12px;color:#666;flex:1;overflow:hidden;text-overflow:ellipsis;white-space:nowrap';
                prevName.textContent = pendingAttachment.name;
                chatPreview.appendChild(prevName);
            } else {
                var fileInfo = document.createElement('div');
                fileInfo.className = 'preview-file-info';
                var fileIcon = document.createElement('i');
                fileIcon.className = 'fas fa-file-alt';
                fileInfo.appendChild(fileIcon);
                var fileDetail = document.createElement('div');
                var fileName = document.createElement('div');
                fileName.style.cssText = 'font-weight:500;max-width:180px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap';
                fileName.textContent = pendingAttachment.name;
                fileDetail.appendChild(fileName);
                var fileSize = document.createElement('div');
                fileSize.style.cssText = 'color:#999;font-size:11px';
                fileSize.textContent = (pendingAttachment.size / 1024).toFixed(1) + ' KB';
                fileDetail.appendChild(fileSize);
                fileInfo.appendChild(fileDetail);
                chatPreview.appendChild(fileInfo);
            }

            var removeBtn = document.createElement('button');
            removeBtn.className = 'preview-remove';
            removeBtn.title = 'Xóa';
            removeBtn.innerHTML = '&times;';
            removeBtn.addEventListener('click', clearAttachment);
            chatPreview.appendChild(removeBtn);
        }

        function clearAttachment() {
            pendingAttachment = null;
            chatPreview.style.display = 'none';
            chatPreview.innerHTML = '';
        }

        // === Hiển thị tin nhắn ===
        function addMessage(text, sender, attachment) {
            var wrapper = document.createElement('div');
            wrapper.className = 'chat-msg-wrapper ' + sender;

            var avatar = document.createElement('div');
            avatar.className = 'chat-avatar';
            var avatarIcon = document.createElement('i');
            avatarIcon.className = sender === 'bot' ? 'fas fa-robot' : 'fas fa-user';
            avatar.appendChild(avatarIcon);
            wrapper.appendChild(avatar);

            var msgDiv = document.createElement('div');
            msgDiv.className = 'chat-msg ' + sender;

            if (attachment && attachment.type === 'image') {
                var img = document.createElement('img');
                img.src = attachment.dataUrl;
                img.className = 'chat-image';
                img.alt = 'Ảnh';
                img.addEventListener('click', function() { window.open(this.src, '_blank'); });
                msgDiv.appendChild(img);
            }

            if (attachment && attachment.type === 'file') {
                var badge = document.createElement('div');
                badge.className = 'chat-file-badge';
                var fIcon = document.createElement('i');
                fIcon.className = 'fas fa-file-alt';
                badge.appendChild(fIcon);
                badge.appendChild(document.createTextNode(' ' + attachment.name));
                msgDiv.appendChild(badge);
            }

            if (text) {
                if (msgDiv.childNodes.length > 0) {
                    msgDiv.appendChild(document.createElement('br'));
                }
                var textSpan = document.createElement('span');
                var safeText = text.replace(/</g, '&lt;').replace(/>/g, '&gt;');
                textSpan.innerHTML = safeText.replace(/\n/g, '<br>');
                msgDiv.appendChild(textSpan);
            }

            wrapper.appendChild(msgDiv);
            chatMessages.appendChild(wrapper);
            chatMessages.scrollTop = chatMessages.scrollHeight;
        }

        function addTypingIndicator() {
            var wrapper = document.createElement('div');
            wrapper.className = 'chat-msg-wrapper bot';
            wrapper.id = 'typingIndicator';

            var avatar = document.createElement('div');
            avatar.className = 'chat-avatar';
            var icon = document.createElement('i');
            icon.className = 'fas fa-robot';
            avatar.appendChild(icon);
            wrapper.appendChild(avatar);

            var msgDiv = document.createElement('div');
            msgDiv.className = 'chat-msg bot typing';
            msgDiv.innerHTML = '<span class="typing-indicator"></span><span class="typing-indicator"></span><span class="typing-indicator"></span>';
            wrapper.appendChild(msgDiv);

            chatMessages.appendChild(wrapper);
            chatMessages.scrollTop = chatMessages.scrollHeight;
        }

        function removeTypingIndicator() {
            var typing = document.getElementById("typingIndicator");
            if (typing) typing.remove();
        }

        async function fetchFromAI() {
            var messages = [systemInstruction].concat(chatHistory);

            try {
                var response = await fetch(apiUrl, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                        'Authorization': 'Bearer ' + apiKey,
                        'ngrok-skip-browser-warning': 'true'
                    },
                    body: JSON.stringify({
                        model: "gpt-5",
                        messages: messages,
                        temperature: 0.7
                    })
                });

                if (!response.ok) {
                    var errData = await response.json().catch(function() { return {}; });
                    console.error("API Error details:", errData);
                    var errMsg = (errData.error && errData.error.message) ? errData.error.message : 'Unknown';
                    throw new Error("HTTP Error " + response.status + ": " + errMsg);
                }

                var data = await response.json();
                if (data && data.choices && data.choices.length > 0 && data.choices[0].message) {
                    var replyText = data.choices[0].message.content;
                    chatHistory.push({ role: "assistant", content: replyText });
                    return replyText;
                }
                return "Xin lỗi, tôi không thể hiểu yêu cầu này, bạn có thể hỏi câu khác không?";
            } catch (error) {
                console.error("[Shopee AI] Lỗi hệ thống:", error);

                if (error instanceof TypeError && error.message === "Failed to fetch") {
                    return "Xin lỗi, hệ thống AI không thể kết nối tới máy chủ. Vui lòng thử lại sau.";
                }
                return "Xin lỗi, hệ thống AI đang gặp sự cố: " + error.message;
            }
        }

        async function handleSend() {
            var text = chatInput.value.trim();
            var attachment = pendingAttachment;

            if (!text && !attachment) return;

            addMessage(text, "user", attachment);
            chatInput.value = "";
            clearAttachment();
            addTypingIndicator();

            var userMessage;

            if (attachment && attachment.type === 'image') {
                var contentParts = [];
                if (text) {
                    contentParts.push({ type: "text", text: text });
                } else {
                    contentParts.push({ type: "text", text: "Hãy mô tả và phân tích ảnh này." });
                }
                contentParts.push({
                    type: "image_url",
                    image_url: { url: attachment.dataUrl }
                });
                userMessage = { role: "user", content: contentParts };
            } else if (attachment && attachment.type === 'file') {
                var fileContext = '[File đính kèm: ' + attachment.name + ']\n\nNội dung file:\n' + attachment.textContent;
                var fullText = text ? text + '\n\n' + fileContext : fileContext;
                userMessage = { role: "user", content: fullText };
            } else {
                userMessage = { role: "user", content: text };
            }

            chatHistory.push(userMessage);

            var reply = await fetchFromAI();

            removeTypingIndicator();

            if (reply.startsWith("Xin lỗi, hệ thống AI")) {
                addMessage(reply, "bot");
                chatHistory.pop();
                return;
            }

            addMessage(reply, "bot");
        }

        chatSend.addEventListener("click", handleSend);
        chatInput.addEventListener("keypress", function (e) {
            if (e.key === "Enter") handleSend();
        });
    }

    // ===================================================
    // VIP PROMO MODAL
    // ===================================================
    if (!sessionStorage.getItem('shopeeVipPromoShown')) {
        var modal = document.getElementById('vipPromoModal');
        var closeBtn = document.querySelector('.shopee-vip-close-btn');

        if (modal && closeBtn) {
            setTimeout(function () {
                modal.classList.add('show');
            }, 1000);

            var closeModal = function () {
                modal.classList.remove('show');
                sessionStorage.setItem('shopeeVipPromoShown', 'true');
            };

            closeBtn.addEventListener('click', closeModal);

            modal.addEventListener('click', function (e) {
                if (e.target === modal) {
                    closeModal();
                }
            });
        }
    }

    // ===================================================
    // LANGUAGE SWITCHER
    // ===================================================
    var savedLang = localStorage.getItem('shopee_lang');
    if (savedLang) {
        var langItem = document.querySelector('.lang-dropdown-item[data-lang="' + savedLang + '"]');
        if (langItem) {
            document.getElementById('currentLangLabel').textContent = langItem.textContent;
            document.querySelectorAll('.lang-dropdown-item').forEach(function(item) {
                item.classList.remove('active');
            });
            langItem.classList.add('active');
        }
    }
});

// Language Switcher (global function for onclick handlers)
function switchLang(langCode, langLabel, event) {
    event.preventDefault();
    document.getElementById('currentLangLabel').textContent = langLabel;
    document.querySelectorAll('.lang-dropdown-item').forEach(function(item) {
        item.classList.remove('active');
    });
    event.target.classList.add('active');
    localStorage.setItem('shopee_lang', langCode);
}
