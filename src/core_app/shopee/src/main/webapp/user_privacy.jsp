<%@page import="model.User" %>
<%@page contentType="text/html" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thiết Lập Riêng Tư | Shopee Việt Nam</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/normalize/8.0.1/normalize.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=2.0">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/user_profile.css?v=2.0">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/user_account.css?v=2.0">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
    <div class="app">
        <header class="header">
            <nav class="header__navbar">
                <ul class="header__navbar-list">
                    <li class="header__navbar-item header__navbar-item--separate"><a href="${pageContext.request.contextPath}/seller-onboarding" class="header__navbar-item-link">Kênh Người Bán</a></li>
                    <li class="header__navbar-item header__navbar-item--separate"><a href="#" class="header__navbar-item-link">Tải ứng dụng</a></li>
                    <li class="header__navbar-item">Kết nối <a href="#" class="header__navbar-item-link"><i class="fab fa-facebook"></i></a> <a href="#" class="header__navbar-item-link"><i class="fab fa-instagram"></i></a></li>
                </ul>
                <ul class="header__navbar-list">
                    <li class="header__navbar-item"><a href="#" class="header__navbar-item-link"><i class="far fa-bell"></i> Thông báo</a></li>
                    <li class="header__navbar-item"><a href="#" class="header__navbar-item-link"><i class="far fa-question-circle"></i> Hỗ Trợ</a></li>
                    <% User acc=(User) session.getAttribute("account"); if (acc !=null) { %>
                        <li class="header__navbar-item header__navbar-item--separate" style="font-weight: 500;">
                            <div class="user-dropdown-wrapper">
                                <div class="user-dropdown-trigger" id="userDropdownTrigger"><span class="user-avatar-small"><% if (acc.getAvatar() != null && !acc.getAvatar().trim().isEmpty()) { %><img src="<%= acc.getAvatar() %>" alt="Avatar" onerror="this.onerror=null; this.src='https://cf.shopee.vn/file/40acfe9cc5ba0856aa76d0aece330f89_tn';" style="width:22px;height:22px;border-radius:50%;object-fit:cover;vertical-align:middle;"><% } else { %><i class="fas fa-user-circle"></i><% } %></span><span><%= acc.getFullName() %></span><i class="fas fa-chevron-down user-dropdown-arrow"></i></div>
                                <div class="user-dropdown-menu" id="userDropdownMenu">
                                    <a href="${pageContext.request.contextPath}/user/account/profile" class="user-dropdown-item">Tài Khoản Của Tôi</a>
                                    <a href="${pageContext.request.contextPath}/user/purchase" class="user-dropdown-item">Đơn Mua</a>
                                    <a href="${pageContext.request.contextPath}/logout" class="user-dropdown-item">Đăng Xuất</a>
                                </div>
                            </div>
                        </li>
                    <% } %>
                </ul>
            </nav>
            <div class="header-with-search">
                <div class="header__logo"><a href="${pageContext.request.contextPath}/home" class="header__logo-img-wrapper"><i class="fa-solid fa-bag-shopping"></i> Shopee</a></div>
                <div style="flex: 1;"><div class="header__search"><form action="${pageContext.request.contextPath}/search" method="get" class="header__search-input-wrap" style="width:100%; display:flex;"><input type="text" name="txt" class="header__search-input" placeholder="Tìm kiếm sản phẩm" style="flex:1;"><button type="submit" class="header__search-btn"><i class="fas fa-search header__search-btn-icon"></i></button></form></div></div>
                <div class="header__cart"><div class="header__cart-wrap"><a href="${pageContext.request.contextPath}/cart" style="text-decoration:none; color:inherit;"><i class="fas fa-shopping-cart header__cart-icon"></i><span class="header__cart-notice">${sessionScope.cart != null ? sessionScope.cart.totalQuantity : 0}</span></a></div></div>
            </div>
        </header>
        <div class="app__container">
            <div class="profile-container">
                <div class="profile-sidebar">
                    <div class="profile-sidebar-mobile-toggle" id="sidebarToggle"><span class="toggle-text"><i class="fas fa-bars"></i> Menu tài khoản</span><i class="fas fa-chevron-down"></i></div>
                    <div class="profile-sidebar-menu" id="sidebarMenu">
                        <div class="profile-sidebar-user"><div class="profile-sidebar-avatar"><% if (acc != null && acc.getAvatar() != null && !acc.getAvatar().trim().isEmpty()) { %><img src="<%= acc.getAvatar() %>" alt="Avatar" onerror="this.onerror=null; this.src='https://cf.shopee.vn/file/40acfe9cc5ba0856aa76d0aece330f89_tn';" style="width:100%;height:100%;border-radius:50%;object-fit:cover;"><% } else { %><i class="fas fa-user"></i><% } %></div><div><div class="profile-sidebar-name"><%= acc != null ? acc.getFullName() : "" %></div><a href="${pageContext.request.contextPath}/user/account/profile" class="profile-sidebar-edit"><i class="fas fa-edit"></i> Sửa Hồ Sơ</a></div></div>
                        <div class="profile-menu-section">
                            <div class="profile-menu-heading blue"><i class="fas fa-user"></i> Tài Khoản Của Tôi</div>
                            <a href="${pageContext.request.contextPath}/user/account/profile" class="profile-menu-item"><i class="fas fa-id-card"></i> Hồ Sơ</a>
                            <a href="${pageContext.request.contextPath}/user/account/bank" class="profile-menu-item"><i class="fas fa-university"></i> Ngân Hàng</a>
                            <a href="${pageContext.request.contextPath}/user/account/address" class="profile-menu-item"><i class="fas fa-map-marker-alt"></i> Địa Chỉ</a>
                            <a href="${pageContext.request.contextPath}/user/account/password" class="profile-menu-item"><i class="fas fa-lock"></i> Đổi Mật Khẩu</a>
                            <a href="${pageContext.request.contextPath}/user/account/notification" class="profile-menu-item"><i class="fas fa-bell"></i> Cài Đặt Thông Báo</a>
                            <a href="${pageContext.request.contextPath}/user/account/privacy" class="profile-menu-item active"><i class="fas fa-shield-alt"></i> Những Thiết Lập Riêng Tư</a>
                            <a href="${pageContext.request.contextPath}/user/account/personal" class="profile-menu-item"><i class="fas fa-user-tag"></i> Thông Tin Cá Nhân</a>
                        </div>
                        <div class="profile-menu-section"><a href="${pageContext.request.contextPath}/user/purchase" class="profile-menu-heading red" style="text-decoration:none;"><i class="fas fa-clipboard-list"></i> Đơn Mua</a></div>
                        <div class="profile-menu-section"><a href="${pageContext.request.contextPath}/user/voucher" class="profile-menu-heading orange" style="text-decoration:none;"><i class="fas fa-ticket-alt"></i> Kho Voucher</a></div>
                        <div class="profile-menu-section"><a href="${pageContext.request.contextPath}/user/coins" class="profile-menu-heading green" style="text-decoration:none;"><i class="fas fa-coins"></i> Shopee Xu</a></div>
                    </div>
                </div>
                <div class="profile-main">
                    <div class="account-card">
                        <div class="account-card-title">Những Thiết Lập Riêng Tư</div>
                        <div class="account-card-subtitle">Quản lý quyền riêng tư của bạn trên Shopee</div>
                        <div class="toggle-row">
                            <div class="toggle-info"><div class="toggle-title">Hiển thị hồ sơ công khai</div><div class="toggle-desc">Cho phép người khác xem hồ sơ của bạn</div></div>
                            <label class="toggle-switch"><input type="checkbox"><span class="toggle-slider"></span></label>
                        </div>
                        <div class="toggle-row">
                            <div class="toggle-info"><div class="toggle-title">Hiển thị đánh giá của tôi</div><div class="toggle-desc">Cho phép người khác xem các đánh giá sản phẩm của bạn</div></div>
                            <label class="toggle-switch"><input type="checkbox" checked><span class="toggle-slider"></span></label>
                        </div>
                        <div class="toggle-row">
                            <div class="toggle-info"><div class="toggle-title">Hiển thị danh sách yêu thích</div><div class="toggle-desc">Cho phép người khác xem sản phẩm bạn đã thích</div></div>
                            <label class="toggle-switch"><input type="checkbox"><span class="toggle-slider"></span></label>
                        </div>
                        <div class="toggle-row">
                            <div class="toggle-info"><div class="toggle-title">Cho phép đề xuất cá nhân hóa</div><div class="toggle-desc">Shopee sẽ đề xuất sản phẩm dựa trên hoạt động của bạn</div></div>
                            <label class="toggle-switch"><input type="checkbox" checked><span class="toggle-slider"></span></label>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <script>(function() { var toggle = document.getElementById('sidebarToggle'), menu = document.getElementById('sidebarMenu'); if (!toggle || !menu) return; if (window.innerWidth > 992) menu.classList.add('show'); toggle.addEventListener('click', function() { menu.classList.toggle('show'); }); window.addEventListener('resize', function() { if (window.innerWidth > 992) menu.classList.add('show'); }); })();</script>
</body>
</html>

