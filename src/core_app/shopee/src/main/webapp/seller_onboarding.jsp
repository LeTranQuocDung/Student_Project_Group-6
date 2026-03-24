<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.User" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng ký trở thành Người bán — MarketplaceX</title>
    <meta name="description" content="Đăng ký bán hàng trên MarketplaceX — Nền tảng thương mại điện tử hàng đầu Việt Nam">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/normalize/8.0.1/normalize.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link rel="stylesheet" href="css/seller_onboarding.css">
</head>
<body>
<div class="so-page">

    <!-- ==================== HEADER ==================== -->
    <header class="so-header">
        <div class="so-header__left">
            <a href="home" class="so-header__logo">
                <i class="fa-solid fa-bag-shopping"></i> Shopee
            </a>
            <span class="so-header__title">Đăng ký trở thành Người bán Shopee</span>
        </div>
        <div class="so-header__right">
            <button class="so-theme-toggle" id="themeToggleBtn" title="Chuyển giao diện" aria-label="Chuyển đổi giao diện sáng/tối">
                <i class="fas fa-moon"></i>
            </button>
            <% User acc = (User) session.getAttribute("account");
               if (acc != null) { %>
                <span style="color:#fff;font-size:14px;font-weight:500;">
                    <i class="fas fa-user-circle"></i> <%= acc.getFullName() %>
                </span>
            <% } %>
        </div>
    </header>

    <!-- ==================== MAIN CONTAINER ==================== -->
    <main class="so-container">

        <!-- ==================== STEPPER ==================== -->
        <div class="so-card" style="padding-bottom:0">
            <div class="so-stepper" role="navigation" aria-label="Tiến trình đăng ký">
                <div class="so-stepper__item so-stepper__item--active" tabindex="0" role="tab" aria-label="Bước 1: Thông tin Shop">
                    <div class="so-stepper__dot"><i class="fas fa-check so-stepper__dot-check"></i></div>
                    <span class="so-stepper__label">Thông tin Shop</span>
                    <div class="so-stepper__connector"></div>
                </div>
                <div class="so-stepper__item" tabindex="0" role="tab" aria-label="Bước 2: Cài đặt vận chuyển">
                    <div class="so-stepper__dot"><i class="fas fa-check so-stepper__dot-check"></i></div>
                    <span class="so-stepper__label">Cài đặt vận chuyển</span>
                    <div class="so-stepper__connector"></div>
                </div>
                <div class="so-stepper__item" tabindex="0" role="tab" aria-label="Bước 3: Thông tin thuế">
                    <div class="so-stepper__dot"><i class="fas fa-check so-stepper__dot-check"></i></div>
                    <span class="so-stepper__label">Thông tin thuế</span>
                    <div class="so-stepper__connector"></div>
                </div>
                <div class="so-stepper__item" tabindex="0" role="tab" aria-label="Bước 4: Thông tin định danh">
                    <div class="so-stepper__dot"><i class="fas fa-check so-stepper__dot-check"></i></div>
                    <span class="so-stepper__label">Thông tin định danh</span>
                    <div class="so-stepper__connector"></div>
                </div>
                <div class="so-stepper__item" tabindex="0" role="tab" aria-label="Bước 5: Hoàn tất">
                    <div class="so-stepper__dot"><i class="fas fa-check so-stepper__dot-check"></i></div>
                    <span class="so-stepper__label">Hoàn tất</span>
                </div>
            </div>
        </div>

        <!-- ==================== STEP CONTENTS ==================== -->
        <div class="so-card">

            <!-- ========== STEP 1: THÔNG TIN SHOP ========== -->
            <div class="so-step-content" id="step0">
                <h2 class="so-step__title">Thông tin Shop</h2>
                <p class="so-step__subtitle">Vui lòng điền thông tin cơ bản của Shop bạn</p>

                <!-- Tên Shop -->
                <div class="so-form-group">
                    <label class="so-label so-label--required" for="shopName">Tên Shop</label>
                    <div class="so-input-wrap">
                        <input type="text" class="so-input" id="shopName" placeholder="Nhập tên Shop" data-maxlength="30" autocomplete="off">
                        <span class="so-input-counter">0/30</span>
                    </div>
                    <div class="so-error-text" id="shopNameError"></div>
                </div>

                <!-- Địa chỉ -->
                <div class="so-form-group">
                    <label class="so-label so-label--required">Địa chỉ lấy hàng</label>
                    <div id="addressDisplay" style="padding:12px 16px;border:1px solid var(--so-border);border-radius:var(--so-radius-sm);min-height:48px;margin-bottom:8px;color:var(--so-text-hint);font-size:14px">
                        Chưa có địa chỉ — bấm nút bên dưới để thêm
                    </div>
                    <button type="button" class="so-btn so-btn--secondary so-open-address-modal" style="font-size:13px;padding:8px 20px">
                        <i class="fas fa-plus"></i> Thêm Địa Chỉ Mới
                    </button>
                </div>

                <!-- Email -->
                <div class="so-form-group">
                    <label class="so-label" for="shopEmail">Email</label>
                    <div class="so-input-wrap">
                        <input type="email" class="so-input" id="shopEmail" placeholder="Nhập email liên hệ" data-maxlength="100">
                        <span class="so-input-counter">0/100</span>
                    </div>
                    <div class="so-error-text"></div>
                </div>

                <!-- Buttons -->
                <div class="so-btn-group">
                    <div></div>
                    <div class="so-btn-group__right">
                        <button type="button" class="so-btn so-btn--secondary" onclick="soSave()">Lưu</button>
                        <button type="button" class="so-btn so-btn--primary" id="nextBtn0" onclick="soNext()">Tiếp theo</button>
                    </div>
                </div>
            </div>

            <!-- ========== STEP 2: CÀI ĐẶT VẬN CHUYỂN ========== -->
            <div class="so-step-content" id="step1" hidden>
                <h2 class="so-step__title">Phương thức vận chuyển</h2>
                <p class="so-step__subtitle">Kích hoạt phương thức vận chuyển phù hợp</p>

                <!-- Hỏa Tốc -->
                <div class="so-shipping-card">
                    <div class="so-shipping-header" onclick="toggleShippingBody('shippingBody1')">
                        <h3>Hỏa Tốc</h3>
                        <button type="button" class="so-shipping-collapse-btn">Thu gọn <i class="fas fa-chevron-up"></i></button>
                    </div>
                    <div class="so-shipping-body" id="shippingBody1">
                        <div class="so-shipping-row">
                            <div class="so-shipping-row__left">
                                <span class="so-shipping-name">Hỏa Tốc</span>
                                <span class="so-cod-badge">COD đã được kích hoạt</span>
                            </div>
                            <div class="so-shipping-row__right">
                                <label class="so-toggle">
                                    <input type="checkbox" id="toggleHoaToc" checked>
                                    <span class="so-toggle__slider"></span>
                                </label>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Nhanh -->
                <div class="so-shipping-card">
                    <div class="so-shipping-header" onclick="toggleShippingBody('shippingBody2')">
                        <h3>Nhanh</h3>
                        <button type="button" class="so-shipping-collapse-btn">Thu gọn <i class="fas fa-chevron-up"></i></button>
                    </div>
                    <div class="so-shipping-body" id="shippingBody2">
                        <div class="so-shipping-row">
                            <div class="so-shipping-row__left">
                                <span class="so-shipping-name">Nhanh</span>
                                <span class="so-cod-badge">COD đã được kích hoạt</span>
                            </div>
                            <div class="so-shipping-row__right">
                                <label class="so-toggle">
                                    <input type="checkbox" id="toggleNhanh" checked>
                                    <span class="so-toggle__slider"></span>
                                </label>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Tiết Kiệm -->
                <div class="so-shipping-card">
                    <div class="so-shipping-header" onclick="toggleShippingBody('shippingBody3')">
                        <h3>Tiết Kiệm</h3>
                        <button type="button" class="so-shipping-collapse-btn">Thu gọn <i class="fas fa-chevron-up"></i></button>
                    </div>
                    <div class="so-shipping-body" id="shippingBody3">
                        <div class="so-shipping-row">
                            <div class="so-shipping-row__left">
                                <span class="so-shipping-name">Tiết kiệm</span>
                                <span class="so-cod-badge">COD đã được kích hoạt</span>
                            </div>
                            <div class="so-shipping-row__right">
                                <label class="so-toggle">
                                    <input type="checkbox" id="toggleTietKiem" checked>
                                    <span class="so-toggle__slider"></span>
                                </label>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Thêm đơn vị vận chuyển -->
                <div class="so-shipping-card" style="border-style:dashed;opacity:.7">
                    <div class="so-shipping-header">
                        <div>
                            <h3 style="font-size:14px">Thêm Đơn Vị Vận Chuyển</h3>
                            <span style="font-size:12px;color:var(--so-text-hint)">Các đơn vị vận chuyển khác được MarketplaceX hỗ trợ</span>
                        </div>
                        <button type="button" class="so-shipping-collapse-btn">Thu gọn <i class="fas fa-chevron-down"></i></button>
                    </div>
                </div>

                <!-- Buttons -->
                <div class="so-btn-group">
                    <button type="button" class="so-btn so-btn--secondary" onclick="soPrev()">Quay lại</button>
                    <div class="so-btn-group__right">
                        <button type="button" class="so-btn so-btn--secondary" onclick="soSave()">Lưu</button>
                        <button type="button" class="so-btn so-btn--primary" id="nextBtn1" onclick="soNext()">Tiếp theo</button>
                    </div>
                </div>
            </div>

            <!-- ========== STEP 3: THÔNG TIN THUẾ ========== -->
            <div class="so-step-content" id="step2" hidden>
                <h2 class="so-step__title">Thông tin thuế</h2>

                <div class="so-info-banner">
                    <i class="fas fa-info-circle"></i>
                    <span>Việc thu thập Thông Tin Thuế và Thông Tin Định Danh là bắt buộc theo quy định của Luật an ninh mạng, Thương mại điện tử và Thuế của Việt Nam. Thông Tin Thuế và Thông Tin Định Danh sẽ được bảo vệ theo chính sách bảo mật của MarketplaceX. Người bán hoàn toàn chịu trách nhiệm về tính chính xác của thông tin.</span>
                </div>

                <!-- Loại hình kinh doanh -->
                <div class="so-form-group">
                    <label class="so-label so-label--required">Loại hình kinh doanh</label>
                    <div class="so-radio-group">
                        <label class="so-radio"><input type="radio" name="businessType" value="caNhan"> Cá nhân</label>
                        <label class="so-radio"><input type="radio" name="businessType" value="hoKinhDoanh" checked> Hộ kinh doanh</label>
                        <label class="so-radio"><input type="radio" name="businessType" value="congTy"> Công ty</label>
                    </div>
                </div>

                <!-- Tên công ty -->
                <div class="so-form-group">
                    <label class="so-label so-label--required" for="companyName">Tên công ty</label>
                    <div class="so-input-wrap">
                        <input type="text" class="so-input" id="companyName" placeholder="Nhập vào" data-maxlength="500">
                        <span class="so-input-counter">0/500</span>
                    </div>
                    <p class="so-label__hint">Vui lòng điền đầy đủ tên công ty, không viết tắt. Ví dụ: "Công ty Trách Nhiệm Hữu Hạn ABC"</p>
                    <div class="so-error-text"></div>
                </div>

                <!-- Địa chỉ đăng ký kinh doanh -->
                <div class="so-form-group">
                    <label class="so-label so-label--required">Địa chỉ đăng ký kinh doanh</label>
                    <div class="so-form-row">
                        <div class="so-form-group">
                            <select class="so-select" id="taxProvince">
                                <option value="">Chọn Tỉnh/Thành phố</option>
                            </select>
                        </div>
                        <div class="so-form-group">
                            <select class="so-select" id="taxDistrict">
                                <option value="">Chọn Quận/Huyện</option>
                            </select>
                        </div>
                        <div class="so-form-group">
                            <select class="so-select" id="taxWard">
                                <option value="">Chọn Phường/Xã</option>
                            </select>
                        </div>
                    </div>
                    <textarea class="so-textarea" id="taxAddressDetail" placeholder="Số nhà, tên đường, v.v.." rows="3"></textarea>
                </div>

                <!-- Email nhận hóa đơn -->
                <div class="so-form-group">
                    <label class="so-label so-label--required">Email nhận hóa đơn điện tử</label>
                    <div id="taxEmailList" class="so-email-list">
                        <div class="so-email-row">
                            <div class="so-input-wrap" style="flex:1">
                                <input type="email" class="so-input so-tax-email-input" id="taxEmail0" placeholder="Nhập email" data-maxlength="100">
                                <span class="so-input-counter">0/100</span>
                            </div>
                        </div>
                    </div>
                    <button type="button" class="so-add-email-btn" onclick="addTaxEmail()">
                        <i class="fas fa-plus"></i> Thêm Email (tối đa 5)
                    </button>
                    <p class="so-label__hint">Hóa đơn điện tử của bạn sẽ được gửi đến địa chỉ email này</p>
                    <div class="so-error-text"></div>
                </div>

                <!-- Mã số thuế -->
                <div class="so-form-group">
                    <label class="so-label so-label--required" for="taxId">Mã số thuế</label>
                    <div class="so-input-wrap">
                        <input type="text" class="so-input" id="taxId" placeholder="Nhập vào" data-maxlength="14">
                        <span class="so-input-counter">0/14</span>
                    </div>
                    <p class="so-label__hint">Theo Quy định về Thương mại điện tử Việt Nam (Nghị định 52/2013/NĐ-CP), Người Bán phải cung cấp thông tin Mã số thuế cho sàn Thương mại điện tử.</p>
                </div>

                <!-- Giấy phép đăng ký kinh doanh -->
                <div class="so-form-group">
                    <label class="so-label so-label--required">Giấy phép đăng ký kinh doanh</label>
                    <div class="so-upload">
                        <label class="so-upload__zone" id="licenseUploadZone">
                            <i class="fas fa-cloud-upload-alt"></i>
                            <span>Upload</span>
                            <input type="file" id="licenseUpload" accept=".jpg,.jpeg,.png" onchange="handleFileUpload('licenseUpload','licensePreview','licenseFile')">
                        </label>
                        <div id="licensePreview"></div>
                    </div>
                    <div class="so-error-text"></div>
                </div>

                <!-- Buttons -->
                <div class="so-btn-group">
                    <button type="button" class="so-btn so-btn--secondary" onclick="soPrev()">Quay lại</button>
                    <div class="so-btn-group__right">
                        <button type="button" class="so-btn so-btn--secondary" onclick="soSave()">Lưu</button>
                        <button type="button" class="so-btn so-btn--primary" id="nextBtn2" onclick="soNext()">Tiếp theo</button>
                    </div>
                </div>
            </div>

            <!-- ========== STEP 4: THÔNG TIN ĐỊNH DANH ========== -->
            <div class="so-step-content" id="step3" hidden>
                <h2 class="so-step__title">Thông tin định danh</h2>

                <div class="so-info-banner">
                    <i class="fas fa-info-circle"></i>
                    <span>Vui lòng cung cấp Thông Tin Định Danh của Chủ Shop (nếu là cá nhân), hoặc Người Đại Diện Pháp Lý trên giấy đăng ký kinh doanh.</span>
                </div>

                <!-- Hình thức định danh -->
                <div class="so-form-group">
                    <label class="so-label so-label--required">Hình Thức Định Danh</label>
                    <div class="so-radio-group">
                        <label class="so-radio"><input type="radio" name="idType" value="cccd" checked onchange="updateIdTypeLabel()"> Căn Cước Công Dân (CCCD)</label>
                        <label class="so-radio"><input type="radio" name="idType" value="cmnd" onchange="updateIdTypeLabel()"> Chứng Minh Nhân Dân (CMND)</label>
                        <label class="so-radio"><input type="radio" name="idType" value="passport" onchange="updateIdTypeLabel()"> Hộ chiếu</label>
                    </div>
                </div>

                <!-- Số CCCD -->
                <div class="so-form-group">
                    <label class="so-label so-label--required" for="idNumber" id="idNumberLabel">Số Căn Cước Công Dân (CCCD)</label>
                    <div class="so-input-wrap">
                        <input type="text" class="so-input" id="idNumber" placeholder="Nhập vào" data-maxlength="12">
                        <span class="so-input-counter">0/12</span>
                    </div>
                    <div class="so-error-text"></div>
                </div>

                <!-- Họ & Tên -->
                <div class="so-form-group">
                    <label class="so-label so-label--required" for="idFullName">Họ & Tên</label>
                    <div class="so-input-wrap">
                        <input type="text" class="so-input" id="idFullName" placeholder="Nhập vào" data-maxlength="100">
                        <span class="so-input-counter">0/100</span>
                    </div>
                    <p class="so-label__hint">Theo CMND/CCCD/Hộ Chiếu</p>
                    <div class="so-error-text"></div>
                </div>

                <!-- Upload ảnh mặt trước -->
                <div class="so-form-group">
                    <label class="so-label so-label--required">Hình chụp của thẻ CMND/CCCD/Hộ chiếu</label>
                    <div class="so-upload">
                        <label class="so-upload__zone" id="idFrontUpload">
                            <i class="fas fa-plus"></i>
                            <span>Tải lên</span>
                            <input type="file" id="idFrontInput" accept=".jpg,.jpeg,.png" onchange="handleFileUpload('idFrontInput','idFrontPreview','idFrontFile')">
                        </label>
                        <div id="idFrontPreview"></div>
                        <div class="so-upload__sample">
                            <div style="width:100%;height:100%;display:flex;align-items:center;justify-content:center;background:var(--so-bg);flex-direction:column;gap:4px">
                                <i class="fas fa-id-card" style="font-size:32px;color:var(--so-text-hint)"></i>
                                <span style="font-size:10px;color:var(--so-text-hint)">Ảnh mẫu</span>
                            </div>
                        </div>
                    </div>
                    <p class="so-upload-hint">Vui lòng cung cấp ảnh chụp của CMND/CCCD/Hộ chiếu của bạn.<br>Các thông tin trong CMND/CCCD/Hộ chiếu phải được hiển thị rõ ràng (kích thước ảnh không vượt quá 5.0 MB)</p>
                    <div class="so-error-text"></div>
                </div>

                <!-- Upload ảnh cầm -->
                <div class="so-form-group">
                    <label class="so-label so-label--required">Ảnh đang cầm CMND/CCCD/Hộ chiếu của bạn</label>
                    <div class="so-upload">
                        <label class="so-upload__zone" id="idHoldUpload">
                            <i class="fas fa-plus"></i>
                            <span>Tải lên</span>
                            <input type="file" id="idHoldInput" accept=".jpg,.jpeg,.png" onchange="handleFileUpload('idHoldInput','idHoldPreview','idHoldFile')">
                        </label>
                        <div id="idHoldPreview"></div>
                        <div class="so-upload__sample">
                            <div style="width:100%;height:100%;display:flex;align-items:center;justify-content:center;background:var(--so-bg);flex-direction:column;gap:4px">
                                <i class="fas fa-user" style="font-size:32px;color:var(--so-text-hint)"></i>
                                <span style="font-size:10px;color:var(--so-text-hint)">Ảnh mẫu</span>
                            </div>
                        </div>
                    </div>
                    <p class="so-upload-hint">Vui lòng cung cấp ảnh bạn đang cầm CMND/CCCD/Hộ chiếu như ảnh mẫu.<br>Các thông tin trong CMND/CCCD/Hộ chiếu và hình ảnh của bạn phải được hiển thị rõ ràng (kích thước ảnh không vượt quá 5.0 MB)</p>
                    <div class="so-error-text"></div>
                </div>

                <!-- Checkbox xác nhận -->
                <div class="so-form-group">
                    <label class="so-checkbox">
                        <input type="checkbox" id="agreePolicy">
                        <span>Tôi xác nhận tất cả dữ liệu đã cung cấp là chính xác và trung thực. Tôi đã đọc và đồng ý với <a href="#" style="color:var(--so-blue)">Chính Sách Bảo Mật</a> của MarketplaceX.</span>
                    </label>
                    <div class="so-error-text"></div>
                </div>

                <!-- Buttons -->
                <div class="so-btn-group">
                    <button type="button" class="so-btn so-btn--secondary" onclick="soPrev()">Quay lại</button>
                    <div class="so-btn-group__right">
                        <button type="button" class="so-btn so-btn--secondary" onclick="soSave()">Lưu</button>
                        <button type="button" class="so-btn so-btn--primary" id="completeBtn" onclick="soComplete()">Hoàn tất</button>
                    </div>
                </div>
            </div>

            <!-- ========== STEP 5: HOÀN TẤT ========== -->
            <div class="so-step-content" id="step4" hidden>
                <div class="so-success">
                    <div class="so-success__icon">
                        <i class="fas fa-check"></i>
                    </div>
                    <h2 class="so-success__title">Đăng ký thành công</h2>
                    <p class="so-success__text">
                        Hãy đăng bán sản phẩm đầu tiên để khởi động hành trình bán hàng cùng MarketplaceX nhé!
                    </p>
                    <a href="home" class="so-btn so-btn--primary" style="padding:12px 40px;font-size:15px">
                        <i class="fas fa-plus-circle"></i> Thêm sản phẩm
                    </a>
                </div>
            </div>

        </div><!-- /.so-card -->
    </main>

    <!-- ==================== ADDRESS MODAL ==================== -->
    <div class="so-modal-overlay" id="addressModalOverlay" role="dialog" aria-modal="true" aria-label="Thêm Địa Chỉ Mới">
        <div class="so-modal">
            <div class="so-modal__header">
                <h3 class="so-modal__title">Thêm Địa Chỉ Mới</h3>
                <button type="button" class="so-modal__close" id="addressModalClose" aria-label="Đóng">
                    <i class="fas fa-times"></i>
                </button>
            </div>

            <!-- Họ & Tên -->
            <div class="so-form-group">
                <label class="so-label" for="addrName">Họ & Tên</label>
                <input type="text" class="so-input" id="addrName" placeholder="Nhập vào">
            </div>

            <!-- Số điện thoại -->
            <div class="so-form-group">
                <label class="so-label" for="addrPhone">Số điện thoại</label>
                <input type="tel" class="so-input" id="addrPhone" placeholder="Nhập vào">
            </div>

            <!-- Địa chỉ -->
            <div class="so-form-group">
                <label class="so-label" style="font-weight:600;font-size:15px">Địa chỉ</label>
                <label class="so-label" style="font-size:13px;margin-top:8px">Tỉnh/Thành phố/Quận/Huyện/Phường/Xã</label>
                <select class="so-select" id="addrProvince" style="margin-bottom:8px">
                    <option value="">Chọn</option>
                </select>
                <select class="so-select" id="addrDistrict" style="margin-bottom:8px">
                    <option value="">Chọn Quận/Huyện</option>
                </select>
                <select class="so-select" id="addrWard" style="margin-bottom:8px">
                    <option value="">Chọn Phường/Xã</option>
                </select>
            </div>

            <!-- Địa chỉ chi tiết -->
            <div class="so-form-group">
                <label class="so-label" for="addrDetail">Địa chỉ chi tiết</label>
                <textarea class="so-textarea" id="addrDetail" placeholder="Số nhà, tên đường, v.v.." rows="3"></textarea>
            </div>

            <!-- Định vị -->
            <div class="so-form-group">
                <button type="button" class="so-geo-btn" id="geoBtn">
                    <i class="fas fa-map-marker-alt"></i>
                    <div>
                        <div>Định vị</div>
                        <div class="so-geo-btn__sub">Giúp đơn hàng được giao nhanh nhất</div>
                    </div>
                </button>
            </div>

            <div class="so-modal__footer">
                <button type="button" class="so-btn so-btn--secondary" id="addressModalCancel">Hủy</button>
                <button type="button" class="so-btn so-btn--primary" id="addressModalSave">Lưu</button>
            </div>
        </div>
    </div>

    <!-- ==================== LIGHTBOX ==================== -->
    <div class="so-lightbox" id="lightbox" role="dialog" aria-label="Xem ảnh phóng to">
        <img src="" alt="Preview phóng to">
    </div>

</div><!-- /.so-page -->

<!-- Populate province dropdowns -->
<script>
document.addEventListener('DOMContentLoaded', function() {
    var provinces = [
        {id:'hcm',name:'TP. Hồ Chí Minh'},
        {id:'hn',name:'Hà Nội'},
        {id:'dn',name:'Đà Nẵng'},
        {id:'ag',name:'An Giang'},
        {id:'bdg',name:'Bình Dương'}
    ];
    ['addrProvince','taxProvince'].forEach(function(selId) {
        var sel = document.getElementById(selId);
        if (!sel) return;
        provinces.forEach(function(p) {
            var opt = document.createElement('option');
            opt.value = p.id;
            opt.textContent = p.name;
            sel.appendChild(opt);
        });
    });
});
</script>
<script src="js/seller_onboarding.js"></script>
</body>
</html>
