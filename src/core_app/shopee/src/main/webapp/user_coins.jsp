<%@page import="model.User" %>
<%@page contentType="text/html" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Shopee Xu | Shopee Việt Nam</title>
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
                            <a href="${pageContext.request.contextPath}/user/account/profile" class="profile-menu-heading blue" style="text-decoration:none;"><i class="fas fa-user"></i> Tài Khoản Của Tôi</a>
                        </div>
                        <div class="profile-menu-section"><a href="${pageContext.request.contextPath}/user/purchase" class="profile-menu-heading red" style="text-decoration:none;"><i class="fas fa-clipboard-list"></i> Đơn Mua</a></div>
                        <div class="profile-menu-section"><a href="${pageContext.request.contextPath}/user/voucher" class="profile-menu-heading orange" style="text-decoration:none;"><i class="fas fa-ticket-alt"></i> Kho Voucher</a></div>
                        <div class="profile-menu-section"><a href="${pageContext.request.contextPath}/user/coins" class="profile-menu-heading green" style="text-decoration:none; color:#ee4d2d;"><i class="fas fa-coins"></i> Shopee Xu</a></div>
                    </div>
                </div>
                <div class="profile-main">
                    <div class="account-card">
                        <div class="account-card-title">Shopee Xu</div>
                        <div class="account-card-subtitle">Theo dõi số xu và lịch sử giao dịch</div>

                        <div class="coins-balance">
                            <div class="coins-icon"><i class="fas fa-coins"></i></div>
                            <div>
                                <div class="coins-amount"><%= acc != null ? String.format("%.0f", acc.getWallet()) : "0" %> Xu</div>
                                <div class="coins-label">Số dư Shopee Xu hiện tại</div>
                            </div>
                        </div>

                        <div class="account-card-title" style="font-size:16px; margin-top:24px;">Lịch sử giao dịch</div>
                        <div class="account-empty" style="padding:40px 20px;">
                            <div class="account-empty-icon" style="font-size:40px;"><i class="fas fa-history"></i></div>
                            <div class="account-empty-text">Chưa có giao dịch nào</div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <script>(function() { var toggle = document.getElementById('sidebarToggle'), menu = document.getElementById('sidebarMenu'); if (!toggle || !menu) return; if (window.innerWidth > 992) menu.classList.add('show'); toggle.addEventListener('click', function() { menu.classList.toggle('show'); }); window.addEventListener('resize', function() { if (window.innerWidth > 992) menu.classList.add('show'); }); })();</script>
</body>
</html>

