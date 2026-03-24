<%@page import="model.User, java.util.List, java.util.Map" %>
<%@page contentType="text/html" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đơn Mua | Shopee Việt Nam</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/normalize/8.0.1/normalize.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=2.0">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/user_profile.css?v=2.0">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/user_purchase.css?v=2.0">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/user_account.css?v=2.0">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
    <div class="app">
        <!-- HEADER -->
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
                <!-- SIDEBAR -->
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
                        <div class="profile-menu-section">
                            <a href="${pageContext.request.contextPath}/user/purchase" class="profile-menu-heading red" style="text-decoration:none; color:#ee4d2d;"><i class="fas fa-clipboard-list"></i> Đơn Mua</a>
                        </div>
                        <div class="profile-menu-section"><a href="${pageContext.request.contextPath}/user/voucher" class="profile-menu-heading orange" style="text-decoration:none;"><i class="fas fa-ticket-alt"></i> Kho Voucher</a></div>
                        <div class="profile-menu-section"><a href="${pageContext.request.contextPath}/user/coins" class="profile-menu-heading green" style="text-decoration:none;"><i class="fas fa-coins"></i> Shopee Xu</a></div>
                    </div>
                </div>

                <!-- MAIN PURCHASE CONTENT -->
                <div class="profile-main">
                    <%
                        String currentTab = (String) request.getAttribute("currentTab");
                        if (currentTab == null) currentTab = "ALL";
                    %>
                    <!-- Tabs -->
                    <div class="purchase-tabs">
                        <a href="${pageContext.request.contextPath}/user/purchase?tab=ALL" class="purchase-tab <%= "ALL".equals(currentTab) ? "active" : "" %>">Tất cả</a>
                        <a href="${pageContext.request.contextPath}/user/purchase?tab=PENDING" class="purchase-tab <%= "PENDING".equals(currentTab) ? "active" : "" %>">Chờ thanh toán</a>
                        <a href="${pageContext.request.contextPath}/user/purchase?tab=SHIPPING" class="purchase-tab <%= "SHIPPING".equals(currentTab) ? "active" : "" %>">Vận chuyển</a>
                        <a href="${pageContext.request.contextPath}/user/purchase?tab=DELIVERING" class="purchase-tab <%= "DELIVERING".equals(currentTab) ? "active" : "" %>">Chờ giao hàng</a>
                        <a href="${pageContext.request.contextPath}/user/purchase?tab=COMPLETED" class="purchase-tab <%= "COMPLETED".equals(currentTab) ? "active" : "" %>">Hoàn thành</a>
                        <a href="${pageContext.request.contextPath}/user/purchase?tab=CANCELLED" class="purchase-tab <%= "CANCELLED".equals(currentTab) ? "active" : "" %>">Đã hủy</a>
                        <a href="${pageContext.request.contextPath}/user/purchase?tab=REFUND" class="purchase-tab <%= "REFUND".equals(currentTab) ? "active" : "" %>">Trả hàng/Hoàn tiền</a>
                    </div>

                    <!-- Search -->
                    <div class="purchase-search">
                        <i class="fas fa-search"></i>
                        <input type="text" class="purchase-search-input" placeholder="Bạn có thể tìm kiếm theo tên Shop, ID đơn hàng hoặc Tên Sản phẩm">
                    </div>

                    <!-- Content -->
                    <div class="purchase-content">
                        <%
                            List<String[]> orders = (List<String[]>) request.getAttribute("orders");
                            Map<String, List<String[]>> orderItemsMap = (Map<String, List<String[]>>) request.getAttribute("orderItemsMap");

                            if (orders != null && !orders.isEmpty()) {
                                for (String[] order : orders) {
                                    String orderId = order[0];
                                    String totalPrice = order[1];
                                    String status = order[2];
                                    String createdAt = order[3];

                                    // Map status to Vietnamese
                                    String statusVi = "";
                                    String statusClass = "";
                                    switch (status) {
                                        case "PENDING": statusVi = "Chờ thanh toán"; statusClass = "pending"; break;
                                        case "SHIPPING": statusVi = "Đang vận chuyển"; statusClass = "shipping"; break;
                                        case "DELIVERING": statusVi = "Chờ giao hàng"; statusClass = "delivering"; break;
                                        case "COMPLETED": statusVi = "Hoàn thành"; statusClass = "completed"; break;
                                        case "CANCELLED": statusVi = "Đã hủy"; statusClass = "cancelled"; break;
                                        case "REFUND": statusVi = "Trả hàng/Hoàn tiền"; statusClass = "refund"; break;
                                        default: statusVi = status; statusClass = ""; break;
                                    }

                                    List<String[]> items = orderItemsMap != null ? orderItemsMap.get(orderId) : null;
                        %>
                        <div class="purchase-order-card">
                            <div class="purchase-order-header">
                                <div class="purchase-order-id">Đơn hàng #<%= orderId %></div>
                                <div class="purchase-order-status <%= statusClass %>"><%= statusVi %></div>
                            </div>
                            <%
                                if (items != null && !items.isEmpty()) {
                                    for (String[] item : items) {
                                        String pName = item[0];
                                        String pImage = item[1];
                                        String qty = item[2];
                                        String price = item[3];
                                        String productId = item.length > 4 ? item[4] : "";
                            %>
                            <div class="purchase-order-item">
                                <div class="purchase-item-img">
                                    <% if (pImage != null && !pImage.isEmpty()) { %>
                                        <a href="${pageContext.request.contextPath}/product_detail?id=<%= productId %>">
                                            <img src="<%= pImage %>" alt="<%= pName %>" style="width:80px;height:80px;object-fit:cover;border-radius:4px;">
                                        </a>
                                    <% } else { %>
                                        <div style="width:80px;height:80px;background:#f5f5f5;border-radius:4px;display:flex;align-items:center;justify-content:center;"><i class="fas fa-box" style="font-size:24px;color:#ccc;"></i></div>
                                    <% } %>
                                </div>
                                <div class="purchase-item-info">
                                    <a href="${pageContext.request.contextPath}/product_detail?id=<%= productId %>" class="purchase-item-name" style="text-decoration:none; color:inherit; display:block;">
                                        <%= pName %>
                                    </a>
                                    <div class="purchase-item-qty">x<%= qty %></div>
                                </div>
                                <div class="purchase-item-price">₫<%= String.format("%,.0f", Double.parseDouble(price)) %></div>
                            </div>
                            <%  }
                                } else { %>
                            <div class="purchase-order-item">
                                <div class="purchase-item-info"><div class="purchase-item-name" style="color:#999;">Không có thông tin sản phẩm</div></div>
                            </div>
                            <% } %>
                            <div class="purchase-order-footer">
                                <div class="purchase-order-date"><%= createdAt %></div>
                                <div style="display:flex; align-items:center; gap:15px;">
                                    <% if ("DELIVERING".equals(status)) { %>
                                        <form action="${pageContext.request.contextPath}/user/confirm-received" method="post" style="display:inline;"
                                              onsubmit="return confirm('Xác nhận bạn đã nhận được hàng?');">
                                            <input type="hidden" name="orderId" value="<%= orderId %>">
                                            <button type="submit" style="background:#ee4d2d; color:#fff; border:none; padding:8px 20px; border-radius:4px; font-size:14px; font-weight:600; cursor:pointer; transition:background 0.2s;"
                                                    onmouseover="this.style.background='#d73211'" onmouseout="this.style.background='#ee4d2d'">
                                                <i class="fas fa-check-circle" style="margin-right:5px;"></i>Đã nhận hàng
                                            </button>
                                        </form>
                                    <% } %>
                                    <div class="purchase-order-total">Tổng đơn hàng: <span style="color:#ee4d2d; font-size:18px; font-weight:600;">₫<%= String.format("%,.0f", Double.parseDouble(totalPrice)) %></span></div>
                                </div>
                            </div>
                        </div>
                        <%  }
                            } else { %>
                        <!-- Empty State -->
                        <div class="purchase-empty" id="purchaseEmpty">
                            <div class="purchase-empty-icon">
                                <div class="clipboard-body"></div>
                                <div class="clipboard-clip"></div>
                                <div class="clipboard-line"></div>
                                <div class="clipboard-line"></div>
                                <div class="clipboard-line"></div>
                                <div class="clipboard-circle"><i class="fas fa-clipboard-list"></i></div>
                            </div>
                            <div class="purchase-empty-text">Chưa có đơn hàng</div>
                        </div>
                        <% } %>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        // Sidebar toggle
        (function() {
            var toggle = document.getElementById('sidebarToggle'), menu = document.getElementById('sidebarMenu');
            if (!toggle || !menu) return;
            if (window.innerWidth > 992) menu.classList.add('show');
            toggle.addEventListener('click', function() { menu.classList.toggle('show'); });
            window.addEventListener('resize', function() { if (window.innerWidth > 992) menu.classList.add('show'); });
        })();
        // User dropdown
        (function() {
            var trigger = document.getElementById('userDropdownTrigger'), menu = document.getElementById('userDropdownMenu');
            if (!trigger || !menu) return;
            trigger.addEventListener('click', function(e) { e.stopPropagation(); menu.classList.toggle('show'); });
            document.addEventListener('click', function() { menu.classList.remove('show'); });
        })();
    </script>
</body>
</html>
