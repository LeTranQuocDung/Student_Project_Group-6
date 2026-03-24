<%@page import="model.User" %>
<%@page contentType="text/html" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Kho Voucher | Shopee Việt Nam</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/normalize/8.0.1/normalize.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=2.0">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/user_profile.css?v=2.0">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/user_account.css?v=2.0">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .voucher-tabs { display:flex; gap:0; border-bottom:2px solid #f0f0f0; margin-bottom:20px; }
        .voucher-tab { padding:12px 24px; cursor:pointer; color:#555; font-size:14px; font-weight:500; border-bottom:2px solid transparent; margin-bottom:-2px; text-decoration:none; transition:all 0.2s; }
        .voucher-tab:hover { color:#ee4d2d; }
        .voucher-tab.active { color:#ee4d2d; border-bottom-color:#ee4d2d; }

        .voucher-list { display:flex; flex-direction:column; gap:16px; }
        .voucher-card { display:flex; border:1px solid #e8e8e8; border-radius:8px; overflow:hidden; background:#fff; transition:box-shadow 0.2s; }
        .voucher-card:hover { box-shadow:0 2px 12px rgba(0,0,0,0.08); }

        .voucher-left { width:120px; min-height:120px; display:flex; flex-direction:column; align-items:center; justify-content:center; gap:6px; position:relative; }
        .voucher-left.shopee { background:linear-gradient(135deg, #ee4d2d 0%, #ff6633 100%); }
        .voucher-left.freeship { background:linear-gradient(135deg, #00bfa5 0%, #26c6da 100%); }
        .voucher-left.shop { background:linear-gradient(135deg, #ff9100 0%, #ffab40 100%); }
        .voucher-left.special { background:linear-gradient(135deg, #7c4dff 0%, #b388ff 100%); }
        .voucher-left i { font-size:28px; color:rgba(255,255,255,0.95); }
        .voucher-left-label { color:#fff; font-size:11px; font-weight:600; text-transform:uppercase; letter-spacing:0.5px; }
        .voucher-left::after { content:''; position:absolute; right:-6px; top:50%; transform:translateY(-50%); width:12px; height:12px; background:#fff; border-radius:50%; }

        .voucher-right { flex:1; padding:16px 20px; display:flex; align-items:center; gap:16px; }
        .voucher-info { flex:1; }
        .voucher-title { font-size:15px; font-weight:600; color:#222; margin-bottom:4px; }
        .voucher-desc { font-size:13px; color:#666; margin-bottom:6px; }
        .voucher-condition { font-size:12px; color:#999; margin-bottom:4px; }
        .voucher-expiry { font-size:12px; color:#ee4d2d; }
        .voucher-progress-wrap { margin-top:6px; }
        .voucher-progress { height:4px; background:#f0f0f0; border-radius:2px; overflow:hidden; margin-bottom:3px; }
        .voucher-progress-bar { height:100%; border-radius:2px; }
        .voucher-progress-bar.shopee { background:#ee4d2d; }
        .voucher-progress-bar.freeship { background:#00bfa5; }
        .voucher-progress-bar.shop { background:#ff9100; }
        .voucher-progress-bar.special { background:#7c4dff; }
        .voucher-progress-text { font-size:11px; color:#999; }

        .voucher-action { flex-shrink:0; }
        .voucher-use-btn { padding:8px 24px; background:#ee4d2d; color:#fff; border:none; border-radius:4px; cursor:pointer; font-size:13px; font-weight:600; transition:background 0.2s; text-decoration:none; display:inline-block; }
        .voucher-use-btn:hover { background:#d73211; }
        .voucher-use-btn.saved { background:#fff; color:#ee4d2d; border:1px solid #ee4d2d; }

        .voucher-count { font-size:13px; color:#666; margin-bottom:16px; }

        @media (max-width: 576px) {
            .voucher-card { flex-direction:column; }
            .voucher-left { width:100%; min-height:60px; flex-direction:row; padding:10px 16px; }
            .voucher-left::after { display:none; }
            .voucher-right { flex-direction:column; align-items:stretch; }
        }
    </style>
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
                                <div class="user-dropdown-trigger" id="userDropdownTrigger">
                                    <span class="user-avatar-small">
                                        <% if (acc.getAvatar() != null && !acc.getAvatar().trim().isEmpty()) { %>
                                            <img src="<%= acc.getAvatar() %>" alt="Avatar" onerror="this.onerror=null; this.src='https://cf.shopee.vn/file/40acfe9cc5ba0856aa76d0aece330f89_tn';" style="width:22px;height:22px;border-radius:50%;object-fit:cover;vertical-align:middle;">
                                        <% } else { %>
                                            <i class="fas fa-user-circle"></i>
                                        <% } %>
                                    </span>
                                    <span><%= acc.getFullName() %></span>
                                    <i class="fas fa-chevron-down user-dropdown-arrow"></i>
                                </div>
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
                        <div class="profile-sidebar-user">
                            <div class="profile-sidebar-avatar">
                                <% if (acc != null && acc.getAvatar() != null && !acc.getAvatar().trim().isEmpty()) { %>
                                    <img src="<%= acc.getAvatar() %>" alt="Avatar" onerror="this.onerror=null; this.src='https://cf.shopee.vn/file/40acfe9cc5ba0856aa76d0aece330f89_tn';" style="width:100%;height:100%;border-radius:50%;object-fit:cover;">
                                <% } else { %>
                                    <i class="fas fa-user"></i>
                                <% } %>
                            </div>
                            <div>
                                <div class="profile-sidebar-name"><%= acc != null ? acc.getFullName() : "" %></div>
                                <a href="${pageContext.request.contextPath}/user/account/profile" class="profile-sidebar-edit"><i class="fas fa-edit"></i> Sửa Hồ Sơ</a>
                            </div>
                        </div>
                        <div class="profile-menu-section">
                            <a href="${pageContext.request.contextPath}/user/account/profile" class="profile-menu-heading blue" style="text-decoration:none;"><i class="fas fa-user"></i> Tài Khoản Của Tôi</a>
                        </div>
                        <div class="profile-menu-section"><a href="${pageContext.request.contextPath}/user/purchase" class="profile-menu-heading red" style="text-decoration:none;"><i class="fas fa-clipboard-list"></i> Đơn Mua</a></div>
                        <div class="profile-menu-section"><a href="${pageContext.request.contextPath}/user/voucher" class="profile-menu-heading orange" style="text-decoration:none; color:#ee4d2d;"><i class="fas fa-ticket-alt"></i> Kho Voucher</a></div>
                        <div class="profile-menu-section"><a href="${pageContext.request.contextPath}/user/coins" class="profile-menu-heading green" style="text-decoration:none;"><i class="fas fa-coins"></i> Shopee Xu</a></div>
                    </div>
                </div>
                <div class="profile-main">
                    <div class="account-card">
                        <div class="account-card-title">Kho Voucher</div>
                        <div class="account-card-subtitle">Quản lý các voucher giảm giá của bạn</div>

                        <!-- Tabs -->
                        <div class="voucher-tabs">
                            <a href="#" class="voucher-tab active" data-tab="all">Tất cả</a>
                            <a href="#" class="voucher-tab" data-tab="shopee">Shopee</a>
                            <a href="#" class="voucher-tab" data-tab="shop">Shop</a>
                            <a href="#" class="voucher-tab" data-tab="freeship">Miễn phí vận chuyển</a>
                        </div>

                        <div class="voucher-count">Bạn đang có <strong>6</strong> voucher</div>

                        <!-- Voucher List -->
                        <div class="voucher-list" id="voucherList">
                            <!-- Voucher 1: Shopee giảm 50k -->
                            <div class="voucher-card" data-type="shopee">
                                <div class="voucher-left shopee">
                                    <i class="fa-solid fa-bag-shopping"></i>
                                    <div class="voucher-left-label">Shopee</div>
                                </div>
                                <div class="voucher-right">
                                    <div class="voucher-info">
                                        <div class="voucher-title">Giảm ₫50.000</div>
                                        <div class="voucher-desc">Đơn tối thiểu ₫300.000</div>
                                        <div class="voucher-condition">Áp dụng cho tất cả sản phẩm</div>
                                        <div class="voucher-expiry"><i class="far fa-clock"></i> HSD: 15/03/2026</div>
                                        <div class="voucher-progress-wrap">
                                            <div class="voucher-progress"><div class="voucher-progress-bar shopee" style="width:35%;"></div></div>
                                            <div class="voucher-progress-text">Đã dùng 35%</div>
                                        </div>
                                    </div>
                                    <div class="voucher-action">
                                        <a href="${pageContext.request.contextPath}/home" class="voucher-use-btn">Dùng ngay</a>
                                    </div>
                                </div>
                            </div>

                            <!-- Voucher 2: Freeship -->
                            <div class="voucher-card" data-type="freeship">
                                <div class="voucher-left freeship">
                                    <i class="fas fa-shipping-fast"></i>
                                    <div class="voucher-left-label">Freeship</div>
                                </div>
                                <div class="voucher-right">
                                    <div class="voucher-info">
                                        <div class="voucher-title">Miễn phí vận chuyển</div>
                                        <div class="voucher-desc">Giảm tối đa ₫30.000 phí vận chuyển</div>
                                        <div class="voucher-condition">Đơn tối thiểu ₫50.000</div>
                                        <div class="voucher-expiry"><i class="far fa-clock"></i> HSD: 20/03/2026</div>
                                        <div class="voucher-progress-wrap">
                                            <div class="voucher-progress"><div class="voucher-progress-bar freeship" style="width:60%;"></div></div>
                                            <div class="voucher-progress-text">Đã dùng 60%</div>
                                        </div>
                                    </div>
                                    <div class="voucher-action">
                                        <a href="${pageContext.request.contextPath}/home" class="voucher-use-btn">Dùng ngay</a>
                                    </div>
                                </div>
                            </div>

                            <!-- Voucher 3: Shop giảm 20% -->
                            <div class="voucher-card" data-type="shop">
                                <div class="voucher-left shop">
                                    <i class="fas fa-store"></i>
                                    <div class="voucher-left-label">Shop</div>
                                </div>
                                <div class="voucher-right">
                                    <div class="voucher-info">
                                        <div class="voucher-title">Giảm 20%</div>
                                        <div class="voucher-desc">Giảm tối đa ₫100.000</div>
                                        <div class="voucher-condition">Đơn tối thiểu ₫200.000 | Shop Mall</div>
                                        <div class="voucher-expiry"><i class="far fa-clock"></i> HSD: 25/03/2026</div>
                                        <div class="voucher-progress-wrap">
                                            <div class="voucher-progress"><div class="voucher-progress-bar shop" style="width:20%;"></div></div>
                                            <div class="voucher-progress-text">Đã dùng 20%</div>
                                        </div>
                                    </div>
                                    <div class="voucher-action">
                                        <a href="${pageContext.request.contextPath}/home" class="voucher-use-btn">Dùng ngay</a>
                                    </div>
                                </div>
                            </div>

                            <!-- Voucher 4: Shopee giảm 15% -->
                            <div class="voucher-card" data-type="shopee">
                                <div class="voucher-left shopee">
                                    <i class="fa-solid fa-bag-shopping"></i>
                                    <div class="voucher-left-label">Shopee</div>
                                </div>
                                <div class="voucher-right">
                                    <div class="voucher-info">
                                        <div class="voucher-title">Giảm 15%</div>
                                        <div class="voucher-desc">Giảm tối đa ₫50.000</div>
                                        <div class="voucher-condition">Đơn tối thiểu ₫150.000 | Thanh toán ShopeePay</div>
                                        <div class="voucher-expiry"><i class="far fa-clock"></i> HSD: 31/03/2026</div>
                                        <div class="voucher-progress-wrap">
                                            <div class="voucher-progress"><div class="voucher-progress-bar shopee" style="width:50%;"></div></div>
                                            <div class="voucher-progress-text">Đã dùng 50%</div>
                                        </div>
                                    </div>
                                    <div class="voucher-action">
                                        <a href="${pageContext.request.contextPath}/home" class="voucher-use-btn">Dùng ngay</a>
                                    </div>
                                </div>
                            </div>

                            <!-- Voucher 5: Freeship Xtra -->
                            <div class="voucher-card" data-type="freeship">
                                <div class="voucher-left freeship">
                                    <i class="fas fa-shipping-fast"></i>
                                    <div class="voucher-left-label">Freeship</div>
                                </div>
                                <div class="voucher-right">
                                    <div class="voucher-info">
                                        <div class="voucher-title">Freeship Xtra - Giảm ₫70.000</div>
                                        <div class="voucher-desc">Giảm tối đa ₫70.000 phí vận chuyển</div>
                                        <div class="voucher-condition">Đơn tối thiểu ₫300.000</div>
                                        <div class="voucher-expiry"><i class="far fa-clock"></i> HSD: 10/04/2026</div>
                                        <div class="voucher-progress-wrap">
                                            <div class="voucher-progress"><div class="voucher-progress-bar freeship" style="width:10%;"></div></div>
                                            <div class="voucher-progress-text">Đã dùng 10%</div>
                                        </div>
                                    </div>
                                    <div class="voucher-action">
                                        <a href="${pageContext.request.contextPath}/home" class="voucher-use-btn">Dùng ngay</a>
                                    </div>
                                </div>
                            </div>

                            <!-- Voucher 6: Special deal -->
                            <div class="voucher-card" data-type="shopee">
                                <div class="voucher-left special">
                                    <i class="fas fa-gift"></i>
                                    <div class="voucher-left-label">Đặc biệt</div>
                                </div>
                                <div class="voucher-right">
                                    <div class="voucher-info">
                                        <div class="voucher-title">Giảm ₫200.000</div>
                                        <div class="voucher-desc">Đơn tối thiểu ₫1.000.000</div>
                                        <div class="voucher-condition">Áp dụng cho Shopee Mall | Số lượng có hạn</div>
                                        <div class="voucher-expiry"><i class="far fa-clock"></i> HSD: 01/04/2026</div>
                                        <div class="voucher-progress-wrap">
                                            <div class="voucher-progress"><div class="voucher-progress-bar special" style="width:80%;"></div></div>
                                            <div class="voucher-progress-text">Đã dùng 80%</div>
                                        </div>
                                    </div>
                                    <div class="voucher-action">
                                        <a href="${pageContext.request.contextPath}/home" class="voucher-use-btn">Dùng ngay</a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <script>
        // Sidebar toggle
        (function() { var toggle = document.getElementById('sidebarToggle'), menu = document.getElementById('sidebarMenu'); if (!toggle || !menu) return; if (window.innerWidth > 992) menu.classList.add('show'); toggle.addEventListener('click', function() { menu.classList.toggle('show'); }); window.addEventListener('resize', function() { if (window.innerWidth > 992) menu.classList.add('show'); }); })();
        // User dropdown
        (function() { var trigger = document.getElementById('userDropdownTrigger'), menu = document.getElementById('userDropdownMenu'); if (!trigger || !menu) return; trigger.addEventListener('click', function(e) { e.stopPropagation(); menu.classList.toggle('show'); }); document.addEventListener('click', function() { menu.classList.remove('show'); }); })();
        // Voucher tab filtering
        (function() {
            var tabs = document.querySelectorAll('.voucher-tab');
            var cards = document.querySelectorAll('.voucher-card');
            tabs.forEach(function(tab) {
                tab.addEventListener('click', function(e) {
                    e.preventDefault();
                    tabs.forEach(function(t) { t.classList.remove('active'); });
                    tab.classList.add('active');
                    var type = tab.getAttribute('data-tab');
                    var count = 0;
                    cards.forEach(function(card) {
                        if (type === 'all' || card.getAttribute('data-type') === type) {
                            card.style.display = 'flex';
                            count++;
                        } else {
                            card.style.display = 'none';
                        }
                    });
                    document.querySelector('.voucher-count strong').textContent = count;
                });
            });
        })();
    </script>
</body>
</html>
