<%@page import="model.User" %>
<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hồ Sơ Của Tôi | Shopee Việt Nam</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/normalize/8.0.1/normalize.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=2.0">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/user_profile.css?v=2.0">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>

<body>
    <div class="app">
        <!-- HEADER (Giống shopee_home.jsp) -->
        <header class="header">
            <nav class="header__navbar">
                <ul class="header__navbar-list">
                    <li class="header__navbar-item header__navbar-item--separate"><a href="#" class="header__navbar-item-link">Kênh Người Bán</a></li>
                    <li class="header__navbar-item header__navbar-item--separate"><a href="#" class="header__navbar-item-link">Trở thành Người bán Shopee</a></li>
                    <li class="header__navbar-item header__navbar-item--separate"><a href="#" class="header__navbar-item-link">Tải ứng dụng</a></li>
                    <li class="header__navbar-item">
                        Kết nối
                        <a href="#" class="header__navbar-item-link"><i class="fab fa-facebook"></i></a>
                        <a href="#" class="header__navbar-item-link"><i class="fab fa-instagram"></i></a>
                    </li>
                </ul>

                <ul class="header__navbar-list">
                    <li class="header__navbar-item"><a href="#" class="header__navbar-item-link"><i class="far fa-bell"></i> Thông báo</a></li>
                    <li class="header__navbar-item"><a href="#" class="header__navbar-item-link"><i class="far fa-question-circle"></i> Hỗ trợ</a></li>
                    <% User acc=(User) session.getAttribute("account"); if (acc !=null) { %>
                        <li class="header__navbar-item header__navbar-item--separate" style="font-weight: 500;">
                            <div class="user-dropdown-wrapper">
                                <div class="user-dropdown-trigger" id="userDropdownTrigger">
                                    <span class="user-avatar-small"><i class="fas fa-user-circle"></i></span>
                                    <span><%= acc.getFullName() %></span>
                                    <% if ("admin".equalsIgnoreCase(acc.getRole())) { %>
                                        <a href="${pageContext.request.contextPath}/admin" style="color: #ffce3d; margin-left:5px; font-weight: bold; text-decoration:none;" onclick="event.stopPropagation();">[ADMIN]</a>
                                    <% } %>
                                    <i class="fas fa-chevron-down user-dropdown-arrow"></i>
                                </div>
                                <div class="user-dropdown-menu" id="userDropdownMenu">
                                    <a href="${pageContext.request.contextPath}/user/account/profile" class="user-dropdown-item">Tài Khoản Của Tôi</a>
                                    <a href="${pageContext.request.contextPath}/user/purchase" class="user-dropdown-item">Đơn Mua</a>
                                    <a href="${pageContext.request.contextPath}/logout" class="user-dropdown-item">Đăng Xuất</a>
                                </div>
                            </div>
                        </li>
                    <% } else { %>
                        <li class="header__navbar-item header__navbar-item--separate"><a href="${pageContext.request.contextPath}/register" class="header__navbar-item-link" style="font-weight: 500;">Đăng ký</a></li>
                        <li class="header__navbar-item"><a href="${pageContext.request.contextPath}/login" class="header__navbar-item-link" style="font-weight: 500;">Đăng nhập</a></li>
                    <% } %>
                </ul>
            </nav>

            <div class="header-with-search">
                <div class="header__logo">
                    <a href="${pageContext.request.contextPath}/home" class="header__logo-img-wrapper">
                        <i class="fa-solid fa-bag-shopping"></i> Shopee
                    </a>
                </div>
                <div style="flex: 1;">
                    <div class="header__search">
                        <form action="${pageContext.request.contextPath}/search" method="get" class="header__search-input-wrap" style="width:100%; display:flex;">
                            <input type="text" name="txt" class="header__search-input" placeholder="Tìm kiếm sản phẩm" style="flex:1;">
                            <button type="submit" class="header__search-btn">
                                <i class="fas fa-search header__search-btn-icon"></i>
                            </button>
                        </form>
                    </div>
                </div>
                <div class="header__cart">
                    <div class="header__cart-wrap">
                        <a href="${pageContext.request.contextPath}/cart" style="text-decoration:none; color:inherit;">
                            <i class="fas fa-shopping-cart header__cart-icon"></i>
                            <span class="header__cart-notice">${sessionScope.cart != null ? sessionScope.cart.totalQuantity : 0}</span>
                        </a>
                    </div>
                </div>
            </div>
        </header>

        <!-- TOAST NOTIFICATION -->
        <%
            String successMsg = (String) session.getAttribute("success");
            String errorMsg = (String) session.getAttribute("error");
            if (successMsg != null) session.removeAttribute("success");
            if (errorMsg != null) session.removeAttribute("error");
        %>
        <% if (successMsg != null) { %>
            <div class="profile-toast success show" id="profileToast">
                <i class="fas fa-check-circle"></i>
                <span><%= successMsg %></span>
            </div>
        <% } %>
        <% if (errorMsg != null) { %>
            <div class="profile-toast error show" id="profileToast">
                <i class="fas fa-exclamation-circle"></i>
                <span><%= errorMsg %></span>
            </div>
        <% } %>

        <!-- MAIN CONTENT -->
        <div class="app__container">
            <div class="profile-container">

                <!-- SIDEBAR -->
                <div class="profile-sidebar">
                    <!-- Mobile toggle -->
                    <div class="profile-sidebar-mobile-toggle" id="sidebarToggle">
                        <span class="toggle-text"><i class="fas fa-bars"></i> Menu tài khoản</span>
                        <i class="fas fa-chevron-down"></i>
                    </div>

                    <div class="profile-sidebar-menu" id="sidebarMenu">
                        <!-- User Info -->
                        <div class="profile-sidebar-user">
                            <div class="profile-sidebar-avatar">
                                <i class="fas fa-user"></i>
                            </div>
                            <div>
                                <div class="profile-sidebar-name"><%= acc != null ? acc.getFullName() : "" %></div>
                                <a href="${pageContext.request.contextPath}/user/account/profile" class="profile-sidebar-edit">
                                    <i class="fas fa-edit"></i> Sửa Hồ Sơ
                                </a>
                            </div>
                        </div>

                        <!-- Menu Items -->
                        <div class="profile-menu-section">
                            <div class="profile-menu-heading blue">
                                <i class="fas fa-user"></i> Tài Khoản Của Tôi
                            </div>
                            <a href="${pageContext.request.contextPath}/user/account/profile" class="profile-menu-item active">
                                <i class="fas fa-id-card"></i> Hồ Sơ
                            </a>
                            <a href="#" class="profile-menu-item">
                                <i class="fas fa-university"></i> Ngân Hàng
                            </a>
                            <a href="#" class="profile-menu-item">
                                <i class="fas fa-map-marker-alt"></i> Địa Chỉ
                            </a>
                            <a href="#" class="profile-menu-item">
                                <i class="fas fa-lock"></i> Đổi Mật Khẩu
                            </a>
                            <a href="#" class="profile-menu-item">
                                <i class="fas fa-bell"></i> Cài Đặt Thông Báo
                            </a>
                            <a href="#" class="profile-menu-item">
                                <i class="fas fa-shield-alt"></i> Những Thiết Lập Riêng Tư
                            </a>
                            <a href="#" class="profile-menu-item">
                                <i class="fas fa-user-tag"></i> Thông Tin Cá Nhân
                            </a>
                        </div>

                        <div class="profile-menu-section">
                            <a href="${pageContext.request.contextPath}/user/purchase" class="profile-menu-heading red" style="text-decoration:none;">
                                <i class="fas fa-clipboard-list"></i> Đơn Mua
                            </a>
                        </div>

                        <div class="profile-menu-section">
                            <a href="#" class="profile-menu-heading orange" style="text-decoration:none;">
                                <i class="fas fa-ticket-alt"></i> Kho Voucher
                            </a>
                        </div>

                        <div class="profile-menu-section">
                            <a href="#" class="profile-menu-heading green" style="text-decoration:none;">
                                <i class="fas fa-coins"></i> Shopee Xu
                            </a>
                        </div>
                    </div>
                </div>

                <!-- MAIN PROFILE FORM -->
                <div class="profile-main">
                    <div class="profile-card">
                        <div class="profile-card-title">Hồ Sơ Của Tôi</div>
                        <div class="profile-card-subtitle">Quản lý thông tin hồ sơ để bảo mật tài khoản</div>

                        <%
                            User user = (User) request.getAttribute("user");
                            if (user == null) user = acc;
                            String userName = user != null ? (user.getEmail() != null ? user.getEmail() : "") : "";
                            String fullName = user != null ? (user.getFullName() != null ? user.getFullName() : "") : "";
                            String email = user != null ? (user.getEmail() != null ? user.getEmail() : "") : "";
                            String phone = user != null ? (user.getPhone() != null ? user.getPhone() : "") : "";
                            String gender = user != null ? (user.getGender() != null ? user.getGender() : "") : "";
                            String dob = user != null ? (user.getDateOfBirth() != null ? user.getDateOfBirth() : "") : "";

                            // Mask email
                            String maskedEmail = "";
                            if (!email.isEmpty() && email.contains("@")) {
                                int atIdx = email.indexOf("@");
                                if (atIdx > 2) {
                                    maskedEmail = email.substring(0, 2) + "****" + email.substring(atIdx);
                                } else {
                                    maskedEmail = email;
                                }
                            }
                        %>

                        <form action="${pageContext.request.contextPath}/user/account/profile" method="post">
                            <div class="profile-form-body">
                                <div class="profile-form-left">
                                    <!-- Tên đăng nhập -->
                                    <div class="profile-form-row">
                                        <div class="profile-form-label">Tên đăng nhập</div>
                                        <div class="profile-form-value">
                                            <input type="text" value="<%= userName %>" readonly>
                                        </div>
                                    </div>

                                    <!-- Tên -->
                                    <div class="profile-form-row">
                                        <div class="profile-form-label">Tên</div>
                                        <div class="profile-form-value">
                                            <input type="text" name="fullName" value="<%= fullName %>" placeholder="Nhập tên của bạn">
                                        </div>
                                    </div>

                                    <!-- Email -->
                                    <div class="profile-form-row">
                                        <div class="profile-form-label">Email</div>
                                        <div class="profile-form-value">
                                            <div class="profile-form-static">
                                                <span><%= maskedEmail %></span>
                                                <a href="#" class="profile-form-link">Thay Đổi</a>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Số điện thoại -->
                                    <div class="profile-form-row">
                                        <div class="profile-form-label">Số điện thoại</div>
                                        <div class="profile-form-value">
                                            <% if (phone != null && !phone.isEmpty()) { %>
                                                <div class="profile-form-static">
                                                    <input type="text" name="phone" value="<%= phone %>" style="border: 1px solid #ddd; border-radius: 4px; padding: 0 12px; height: 40px; font-size: 14px; max-width: 380px; width: 100%;">
                                                </div>
                                            <% } else { %>
                                                <div class="profile-form-static">
                                                    <input type="text" name="phone" value="" placeholder="Nhập số điện thoại">
                                                    <a href="#" class="profile-form-link">Thêm</a>
                                                </div>
                                            <% } %>
                                        </div>
                                    </div>

                                    <!-- Giới tính -->
                                    <div class="profile-form-row">
                                        <div class="profile-form-label">Giới tính</div>
                                        <div class="profile-form-value">
                                            <div class="profile-radio-group">
                                                <label>
                                                    <input type="radio" name="gender" value="Nam" <%= "Nam".equals(gender) ? "checked" : "" %>> Nam
                                                </label>
                                                <label>
                                                    <input type="radio" name="gender" value="Nữ" <%= "Nữ".equals(gender) ? "checked" : "" %>> Nữ
                                                </label>
                                                <label>
                                                    <input type="radio" name="gender" value="Khác" <%= "Khác".equals(gender) ? "checked" : "" %>> Khác
                                                </label>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Ngày sinh -->
                                    <div class="profile-form-row">
                                        <div class="profile-form-label">Ngày sinh</div>
                                        <div class="profile-form-value">
                                            <div class="profile-form-static">
                                                <input type="date" name="dateOfBirth" value="<%= dob %>">
                                                <% if (!dob.isEmpty()) { %>
                                                    <a href="#" class="profile-form-link">Thay Đổi</a>
                                                <% } %>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Save Button -->
                                    <div class="profile-form-row">
                                        <div class="profile-form-label"></div>
                                        <div class="profile-form-value">
                                            <button type="submit" class="profile-save-btn" style="margin-left: 0;">Lưu</button>
                                        </div>
                                    </div>
                                </div>

                                <!-- Avatar Upload -->
                                <div class="profile-form-right">
                                    <div class="profile-avatar-preview">
                                        <i class="fas fa-user"></i>
                                    </div>
                                    <label class="profile-avatar-upload-btn">
                                        Chọn Ảnh
                                        <input type="file" accept=".jpg,.jpeg,.png" style="display:none;" id="avatarUpload">
                                    </label>
                                    <div class="profile-avatar-hint">
                                        Dung lượng file tối đa 1 MB<br>
                                        Định dạng: .JPEG, .PNG
                                    </div>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>

            </div>
        </div>
    </div>

    <!-- SCRIPTS -->
    <script>


        // Sidebar Mobile Toggle
        (function() {
            var toggle = document.getElementById('sidebarToggle');
            var menu = document.getElementById('sidebarMenu');
            if (!toggle || !menu) return;

            // On desktop, always show
            if (window.innerWidth > 992) {
                menu.classList.add('show');
            }

            toggle.addEventListener('click', function() {
                menu.classList.toggle('show');
                var icon = toggle.querySelector('.fa-chevron-down, .fa-chevron-up');
                if (icon) {
                    icon.classList.toggle('fa-chevron-down');
                    icon.classList.toggle('fa-chevron-up');
                }
            });

            window.addEventListener('resize', function() {
                if (window.innerWidth > 992) {
                    menu.classList.add('show');
                }
            });
        })();

        // Toast auto-hide
        (function() {
            var toast = document.getElementById('profileToast');
            if (toast) {
                setTimeout(function() {
                    toast.classList.remove('show');
                }, 3000);
            }
        })();

        // Avatar preview
        (function() {
            var fileInput = document.getElementById('avatarUpload');
            if (!fileInput) return;
            fileInput.addEventListener('change', function(e) {
                var file = e.target.files[0];
                if (!file) return;
                if (file.size > 1024 * 1024) {
                    window.alert && false; // Don't use alert
                    return;
                }
                var reader = new FileReader();
                reader.onload = function(ev) {
                    var preview = document.querySelector('.profile-avatar-preview');
                    preview.innerHTML = '<img src="' + ev.target.result + '" alt="Avatar">';
                };
                reader.readAsDataURL(file);
            });
        })();
    </script>
</body>

</html>
