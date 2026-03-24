<%@page import="model.ProductDTO" %>
    <%@page import="model.Admin" %>
        <%@page import="model.User" %>
            <%@page import="java.util.List" %>
                <%@page contentType="text/html" pageEncoding="UTF-8" %>
                    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
                    <%
                        // Cho phép revalidation cache (nhanh hơn no-store nhưng vẫn luôn kiểm tra session mới)
                        response.setHeader("Cache-Control", "no-cache, must-revalidate");
                        // Preload critical CSS
                        response.setHeader("Link", "<css/style.css?v=3.0>; rel=preload; as=style, <css/home_inline.css?v=1.0>; rel=preload; as=style");
                    %>
                        <!DOCTYPE html>
                        <html lang="vi">

                        <head>
                            <meta charset="UTF-8">
                            <meta name="viewport" content="width=device-width, initial-scale=1.0">
                            <meta name="referrer" content="no-referrer">
                            <title>${applicationScope.globalSettings['site_name'] != null ? applicationScope.globalSettings['site_name'] : 'Shopee'} | Mua và Bán Trên Ứng Dụng Di Động Hoặc Website</title>
                            <!-- Resource hints for faster CDN connections -->
                            <link rel="preconnect" href="https://cdnjs.cloudflare.com" crossorigin>
                            <link rel="dns-prefetch" href="https://cdnjs.cloudflare.com">
                            <link rel="preconnect" href="https://down-vn.img.susercontent.com" crossorigin>
                            <link rel="preconnect" href="https://cf.shopee.vn" crossorigin>
                            <link rel="dns-prefetch" href="https://down-vn.img.susercontent.com">
                            <link rel="dns-prefetch" href="https://cf.shopee.vn">
                            <!-- Critical CSS -->
                            <link rel="stylesheet"
                                href="https://cdnjs.cloudflare.com/ajax/libs/normalize/8.0.1/normalize.min.css">
                            <link rel="stylesheet" href="css/style.css?v=3.0">
                            <link rel="stylesheet" href="css/home_inline.css?v=1.0">
                            <!-- Font Awesome: async load (non-render-blocking) -->
                            <link rel="stylesheet"
                                href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"
                                media="print" onload="this.media='all'">
                            <noscript><link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"></noscript>
                        </head>

                        <body>
                            <div class="app">
                                <!-- HEADER -->
                                <header class="header">
                                    <!-- Navbar -->
                                    <nav class="header__navbar">
                                        <ul class="header__navbar-list">
                                            <li class="header__navbar-item header__navbar-item--separate"><a href="seller-onboarding"
                                                    class="header__navbar-item-link">Kênh Người Bán</a></li>
                                            <li class="header__navbar-item header__navbar-item--separate"><a href="seller-login"
                                                    class="header__navbar-item-link">Trở thành Người bán Shopee</a>
                                            </li>
                                            <li class="header__navbar-item header__navbar-item--separate header__navbar-item--has-qr">
                                                <a href="#" class="header__navbar-item-link">Tải ứng dụng</a>
                                                <div class="header__qr-dropdown" style="width:190px;max-width:190px;overflow:hidden;">
                                                    <img src="images/qr_download_app.png" alt="QR Code tải ứng dụng Shopee" class="header__qr-img" style="width:160px;height:160px;max-width:160px;max-height:160px;">
                                                    <div class="header__qr-apps">
                                                        <a href="#"><img src="https://deo.shopeemobile.com/shopee/shopee-pcmall-live-sg/assets/d91264e165ed6facc985.png" alt="App Store" class="header__qr-app-img"></a>
                                                        <a href="#"><img src="https://deo.shopeemobile.com/shopee/shopee-pcmall-live-sg/assets/39f189e19764dab688d3.png" alt="Google Play" class="header__qr-app-img"></a>
                                                        <a href="#"><img src="https://deo.shopeemobile.com/shopee/shopee-pcmall-live-sg/assets/f4f5426ce757aea491c0.png" alt="AppGallery" class="header__qr-app-img"></a>
                                                    </div>
                                                </div>
                                            </li>
                                            <li class="header__navbar-item">
                                                Kết nối
                                                <a href="#" class="header__navbar-item-link"><i
                                                        class="fab fa-facebook"></i></a>
                                                <a href="#" class="header__navbar-item-link"><i
                                                        class="fab fa-instagram"></i></a>
                                            </li>
                                        </ul>

                                        <ul class="header__navbar-list">
                                            <li class="header__navbar-item"><a href="#"
                                                    class="header__navbar-item-link"><i class="far fa-bell"></i> Thông
                                                    báo</a></li>
                                            <li class="header__navbar-item"><a href="#"
                                                    class="header__navbar-item-link"><i
                                                        class="far fa-question-circle"></i> Hỗ Trợ</a></li>
                                            <li class="header__navbar-item">
                                                <div class="lang-dropdown-wrapper">
                                                    <div class="lang-dropdown-trigger" id="langDropdownTrigger">
                                                        <i class="fas fa-globe"></i>
                                                        <span id="currentLangLabel">Tiếng Việt</span>
                                                        <i class="fas fa-chevron-down lang-dropdown-arrow"></i>
                                                    </div>
                                                    <div class="lang-dropdown-menu" id="langDropdownMenu">
                                                        <a href="#" class="lang-dropdown-item active" data-lang="vi" onclick="switchLang('vi', 'Tiếng Việt', event)">Tiếng Việt</a>
                                                        <a href="#" class="lang-dropdown-item" data-lang="en" onclick="switchLang('en', 'English', event)">English</a>
                                                        <a href="#" class="lang-dropdown-item" data-lang="km" onclick="switchLang('km', 'ខ្មែរ', event)">ខ្មែរ</a>
                                                    </div>
                                                </div>
                                            </li>
                                            <% User acc=(User) session.getAttribute("account"); if (acc !=null) { %>
                                                <li class="header__navbar-item header__navbar-item--separate" style="font-weight: 500;">
                                                    <div class="user-dropdown-wrapper">
                                                        <div class="user-dropdown-trigger" id="userDropdownTrigger">
                                                            <span class="user-avatar-small">
                                                                <% if (acc.getAvatar() != null && !acc.getAvatar().trim().isEmpty()) { %>
                                                                    <img src="<%= acc.getAvatar() %>" alt="Avatar" 
                                                                         onerror="this.onerror=null; this.src='https://cf.shopee.vn/file/40acfe9cc5ba0856aa76d0aece330f89_tn';" 
                                                                         style="width:22px;height:22px;border-radius:50%;object-fit:cover;vertical-align:middle;">
                                                                <% } else { %>
                                                                    <i class="fas fa-user-circle"></i>
                                                                <% } %>
                                                            </span>
                                                            <span><%= acc.getFullName() %></span>
                                                            <% if ("admin".equalsIgnoreCase(acc.getRole())) { %>
                                                                <a href="admin" style="color: #ffce3d; margin-left:5px; font-weight: bold; text-decoration:none;" onclick="event.stopPropagation();">[ADMIN]</a>
                                                            <% } %>
                                                            <i class="fas fa-chevron-down user-dropdown-arrow"></i>
                                                        </div>
                                                        <div class="user-dropdown-menu" id="userDropdownMenu">
                                                            <a href="user/account/profile" class="user-dropdown-item">Tài Khoản Của Tôi</a>
                                                            <a href="user/purchase" class="user-dropdown-item">Đơn Mua</a>
                                                            <a href="logout" class="user-dropdown-item" id="logoutBtn">Đăng Xuất</a>
                                                        </div>
                                                    </div>
                                                </li>
                                                <% } else { %>
                                                    <li class="header__navbar-item header__navbar-item--separate"><a
                                                            href="register" class="header__navbar-item-link"
                                                            style="font-weight: 500;">Đăng ký</a></li>
                                                    <li class="header__navbar-item"><a href="login"
                                                            class="header__navbar-item-link"
                                                            style="font-weight: 500;">Đăng
                                                            nhập</a></li>
                                                    <% } %>
                                        </ul>
                                    </nav>

                                    <!-- Header with Search -->
                                    <div class="header-with-search">
                                        <div class="header__logo">
                                            <a href="home" class="header__logo-img-wrapper">
                                                <i class="fa-solid fa-bag-shopping"></i> Shopee
                                            </a>
                                        </div>

                                        <div style="flex: 1;">
                                            <div class="header__search">
                                                <form action="search" method="get"
                                                    class="header__search-input-wrap d-flex"
                                                    style="width:100%; display:flex;">
                                                    <input type="text" name="txt" class="header__search-input"
                                                        placeholder="Dùng thẻ S REWARDS hoàn xu 12%"
                                                        value="<%= request.getAttribute(" txtS")==null ? "" :
                                                        request.getAttribute("txtS") %>" style="flex:1;">
                                                    <button type="submit" class="header__search-btn">
                                                        <i class="fas fa-search header__search-btn-icon"></i>
                                                    </button>
                                                </form>
                                            </div>
                                            <div class="header__search-suggest"
                                                style="margin-top: 5px; font-size: 12px;">
                                                <a href="#"
                                                    style="color: white; margin-right: 13px; text-decoration: none;">Săn
                                                    iPhone 0 Đồng</a>
                                                <a href="#"
                                                    style="color: white; margin-right: 13px; text-decoration: none;">Đồ
                                                    Ren
                                                    Nữ</a>
                                                <a href="#"
                                                    style="color: white; margin-right: 13px; text-decoration: none;">Ốp
                                                    Lưng
                                                    iPhone</a>
                                                <a href="#"
                                                    style="color: white; margin-right: 13px; text-decoration: none;">iPhone
                                                    16pro Max</a>
                                                <a href="#"
                                                    style="color: white; margin-right: 13px; text-decoration: none;">Áo
                                                    Khoác Nam Đẹp</a>
                                                <a href="#"
                                                    style="color: white; margin-right: 13px; text-decoration: none;">Mũ
                                                    Bảo
                                                    Hiểm</a>
                                                <a href="#"
                                                    style="color: white; margin-right: 13px; text-decoration: none;">1k
                                                    Điện
                                                    Thoại</a>
                                                <a href="#"
                                                    style="color: white; margin-right: 13px; text-decoration: none;">Dép
                                                    Crocs Chính Hãng</a>
                                            </div>
                                        </div>

                                        <!-- Cart -->
                                        <div class="header__cart">
                                            <div class="header__cart-wrap">
                                                <a href="cart" style="text-decoration:none; color:inherit;">
                                                    <i class="fas fa-shopping-cart header__cart-icon"></i>
                                                    <span class="header__cart-notice">${sessionScope.cart != null ?
                                                        sessionScope.cart.totalQuantity : 0}</span>
                                                </a>
                                            </div>
                                        </div>
                                    </div>
                                </header>

                                <!-- CONTAINER -->
                                <div class="app__container">
                                    <div class="grid">

                                        <!-- Super Shopee Banner 2/3 - 1/3 -->
                                        <div class="shopee-main-banner-container"
                                            style="display: flex; gap: 5px; margin-bottom: 20px; height: 235px; border-radius: 2px;">
                                            <!-- Banner Trái 2/3 (Carousel Mode) -->
                                            <div style="flex: 2; border-radius: 2px; overflow: hidden; box-shadow: var(--box-shadow); position: relative;"
                                                id="mainBannerWrapper">
                                                <div id="mainBannerCarousel"
                                                    style="display: flex; width: 100%; height: 100%; overflow-x: auto; scroll-snap-type: x mandatory; scrollbar-width: none; scroll-behavior: smooth;">
                                                    <a href="#" style="flex: 0 0 100%; scroll-snap-align: start;">
                                                        <img src="images/main_banner_1.webp" alt="Shopee Banner 1"
                                                            fetchpriority="high"
                                                            style="width: 100%; height: 100%; object-fit: cover; display: block;">
                                                    </a>
                                                    <a href="#" style="flex: 0 0 100%; scroll-snap-align: start;">
                                                        <img src="images/main_banner_2.webp" alt="Shopee Banner 2"
                                                            loading="lazy" decoding="async"
                                                            style="width: 100%; height: 100%; object-fit: cover; display: block;">
                                                    </a>
                                                </div>
                                                <!-- Nút tiến lùi cho main banner -->
                                                <button id="mainBannerLeftBtn"
                                                    style="position: absolute; left: 0; top: 50%; transform: translateY(-50%); background: rgba(0,0,0,0.2); color: white; border: none; padding: 15px 5px; cursor: pointer; display: none;"><i
                                                        class="fas fa-chevron-left"></i></button>
                                                <button id="mainBannerRightBtn"
                                                    style="position: absolute; right: 0; top: 50%; transform: translateY(-50%); background: rgba(0,0,0,0.2); color: white; border: none; padding: 15px 5px; cursor: pointer; display: none;"><i
                                                        class="fas fa-chevron-right"></i></button>

                                                <!-- Chấm tròn chuyển trang -->
                                                <div
                                                    style="position: absolute; bottom: 10px; left: 50%; transform: translateX(-50%); display: flex; gap: 8px;">
                                                    <div class="banner-dot active" data-index="0"
                                                        style="width: 8px; height: 8px; border-radius: 50%; background: #fff; cursor: pointer; opacity: 1;">
                                                    </div>
                                                    <div class="banner-dot" data-index="1"
                                                        style="width: 8px; height: 8px; border-radius: 50%; background: #fff; cursor: pointer; opacity: 0.5;">
                                                    </div>
                                                </div>
                                            </div>
                                            <!-- Banner Phải 1/3 (Gồm 2 banner nhỏ chồng lên nhau) -->
                                            <div style="flex: 1; display: flex; flex-direction: column; gap: 5px;">
                                                <div
                                                    style="flex: 1; border-radius: 2px; overflow: hidden; box-shadow: var(--box-shadow);">
                                                    <a href="#"><img src="images/sub_banner_1.webp" alt="Banner Nhỏ 1"
                                                            loading="lazy" decoding="async"
                                                            style="width: 100%; height: 100%; object-fit: cover; display: block;"></a>
                                                </div>
                                                <div
                                                    style="flex: 1; border-radius: 2px; overflow: hidden; box-shadow: var(--box-shadow);">
                                                    <a href="#"><img src="images/sub_banner_2.webp" alt="Banner Nhỏ 2"
                                                            loading="lazy" decoding="async"
                                                            style="width: 100%; height: 100%; object-fit: cover; display: block;"></a>
                                                </div>
                                            </div>
                                        </div>

                                        <!-- Category Icon Menu Row -->
                                        <div class="category-icon-row"
                                            style="display: flex; justify-content: space-between; margin-bottom: 25px; background: transparent; padding: 10px 0; border-radius: 2px; flex-wrap: wrap;">
                                            <a href="#"
                                                style="display: flex; flex-direction: column; align-items: center; width: 100px; text-decoration: none; color: #333;">
                                                <div
                                                    style="width: 50px; height: 50px; border-radius: 20px; background-image: url('https://down-vn.img.susercontent.com/file/vn-11134258-7ras8-mb6e1ufaxoldb9@resize_w90_nl.webp'); background-size: cover; margin-bottom: 15px; border: 1px solid #f2f2f2; box-shadow: var(--box-shadow);">
                                                </div>
                                                <span
                                                    style="font-size: 13px; text-align: center; line-height: 1.2;">Deal
                                                    Từ
                                                    1.000Đ</span>
                                            </a>
                                            <a href="#"
                                                style="display: flex; flex-direction: column; align-items: center; width: 100px; text-decoration: none; color: #333;">
                                                <div
                                                    style="width: 50px; height: 50px; border-radius: 20px; background-image: url('https://down-vn.img.susercontent.com/file/vn-11134258-820l4-mesa9g3ee4g214@resize_w90_nl.webp'); background-size: cover; margin-bottom: 15px; border: 1px solid #f2f2f2; box-shadow: var(--box-shadow);">
                                                </div>
                                                <span
                                                    style="font-size: 13px; text-align: center; line-height: 1.2;">Shopee
                                                    Xử Lý</span>
                                            </a>
                                            <a href="#"
                                                style="display: flex; flex-direction: column; align-items: center; width: 100px; text-decoration: none; color: #333;">
                                                <div
                                                    style="width: 50px; height: 50px; border-radius: 20px; background-image: url('https://down-vn.img.susercontent.com/file/vn-11134258-7ras8-mb6e1ufaxoldb9@resize_w90_nl.webp'); background-size: cover; margin-bottom: 15px; border: 1px solid #f2f2f2; box-shadow: var(--box-shadow);">
                                                </div>
                                                <span
                                                    style="font-size: 13px; text-align: center; line-height: 1.2;">Deal
                                                    Hot Giờ Vàng</span>
                                            </a>
                                            <a href="#"
                                                style="display: flex; flex-direction: column; align-items: center; width: 100px; text-decoration: none; color: #333;">
                                                <div
                                                    style="width: 50px; height: 50px; border-radius: 20px; background-image: url('https://down-vn.img.susercontent.com/file/vn-50009109-c02353c969d19918c53deaa4ea15bdbe@resize_w90_nl.webp'); background-size: cover; margin-bottom: 15px; border: 1px solid #f2f2f2; box-shadow: var(--box-shadow);">
                                                </div>
                                                <span
                                                    style="font-size: 13px; text-align: center; line-height: 1.2;">Shopee
                                                    Style<br>Voucher 30%</span>
                                            </a>
                                            <a href="#"
                                                style="display: flex; flex-direction: column; align-items: center; width: 100px; text-decoration: none; color: #333;">
                                                <div
                                                    style="width: 50px; height: 50px; border-radius: 20px; background-image: url('https://cf.shopee.vn/file/vn-50009109-f6c34d719c3e4d33857371458e7a7059_xhdpi'); background-size: cover; margin-bottom: 15px; border: 1px solid #f2f2f2; box-shadow: var(--box-shadow);">
                                                </div>
                                                <span
                                                    style="font-size: 13px; text-align: center; line-height: 1.2;">Khách
                                                    Hàng<br>Thân Thiết</span>
                                            </a>
                                            <a href="#"
                                                style="display: flex; flex-direction: column; align-items: center; width: 100px; text-decoration: none; color: #333;">
                                                <div
                                                    style="width: 50px; height: 50px; border-radius: 20px; background-image: url('https://cf.shopee.vn/file/vn-50009109-c7a2e1ae720f9704f92f72c9ef1a494a_xhdpi'); background-size: cover; margin-bottom: 15px; border: 1px solid #f2f2f2; box-shadow: var(--box-shadow);">
                                                </div>
                                                <span style="font-size: 13px; text-align: center; line-height: 1.2;">Mã
                                                    Giảm
                                                    Giá</span>
                                            </a>
                                            <a href="#"
                                                style="display: flex; flex-direction: column; align-items: center; width: 100px; text-decoration: none; color: #333;">
                                                <div
                                                    style="width: 50px; height: 50px; border-radius: 20px; background-image: url('https://cf.shopee.vn/file/e4a404283b3824c211c1549aedd28d5f_xhdpi'); background-size: cover; margin-bottom: 15px; border: 1px solid #f2f2f2; box-shadow: var(--box-shadow);">
                                                </div>
                                                <span style="font-size: 13px; text-align: center; line-height: 1.2;">Bắt
                                                    Trend<br>Giá Sốc</span>
                                            </a>
                                            <a href="#"
                                                style="display: flex; flex-direction: column; align-items: center; width: 100px; text-decoration: none; color: #333;">
                                                <div
                                                    style="width: 50px; height: 50px; border-radius: 20px; background-image: url('https://cf.shopee.vn/file/c7a2e1ae720f9704f92f72c9ef1a494a_xhdpi'); background-size: cover; margin-bottom: 15px; border: 1px solid #f2f2f2; box-shadow: 0 1px 1px 0 rgba(0,0,0,.05);">
                                                </div>
                                                <span
                                                    style="font-size: 13px; text-align: center; line-height: 1.2;">Miễn
                                                    Phí<br>Trả Hàng</span>
                                            </a>
                                        </div>

                                        <!-- MAIN CATEGORIES (DANH MỤC) -->
                                        <div class="shopee-categories-section"
                                            style="background: #fff; border-radius: 2px; overflow: hidden; margin-bottom: 20px; box-shadow: 0 1px 2px 0 rgba(0,0,0,.05); position: relative;">
                                            <div class="category-header"
                                                style="color: rgba(0,0,0,.54); font-size: 16px; padding: 18px 20px; border-bottom: 1px solid rgba(0,0,0,.05);">
                                                DANH MỤC
                                            </div>
                                            <button class="nav-arrow-btn nav-arrow-btn--left" id="btnCategoryLeft"
                                                style="position: absolute; left: 0; top: 55%; transform: translateY(-50%); width: 25px; height: 50px; background: rgba(0,0,0,0.2); color: white; border: none; font-size: 16px; cursor: pointer; display: none; z-index: 10;">
                                                <i class="fas fa-chevron-left"></i>
                                            </button>
                                            <button class="nav-arrow-btn nav-arrow-btn--right" id="btnCategoryRight"
                                                style="position: absolute; right: 0; top: 55%; transform: translateY(-50%); width: 25px; height: 50px; background: rgba(0,0,0,0.2); color: white; border: none; font-size: 16px; cursor: pointer; display: flex; align-items: center; justify-content: center; z-index: 10;">
                                                <i class="fas fa-chevron-right"></i>
                                            </button>
                                            <div class="category-grid" id="categoryGrid"
                                                style="display: grid; grid-template-rows: repeat(2, 1fr); grid-template-columns: repeat(10, calc(100% / 10)); overflow-x: auto; scrollbar-width: none; scroll-behavior: smooth; border-right: 1px solid rgba(0,0,0,.05); border-bottom: 1px solid rgba(0,0,0,.05);">

                                                <c:forEach var="category" items="${categories}">
                                                    <a href="search?cateId=${category.id}"
                                                        style="display: flex; flex-direction: column; align-items: center; justify-content: flex-start; padding: 20px 10px; border-right: 1px solid rgba(0,0,0,.05); border-bottom: 1px solid rgba(0,0,0,.05); text-decoration: none; color: rgba(0,0,0,.8); transition: transform 0.1s;">
                                                        <img src="${category.imageUrl}"
                                                            loading="eager" decoding="async"
                                                            style="width: 80px; height: 80px; object-fit: contain; margin-bottom: 10px;"
                                                            alt="">
                                                        <span
                                                            style="font-size: 14px; text-align: center;">${category.name}</span>
                                                    </a>
                                                </c:forEach>
                                            </div>
                                        </div>

                                        <!-- Flash Sale Banner -->
                                        <div class="flash-sale-section"
                                            style="margin-bottom: 20px; box-shadow: 0 1px 2px 0 rgba(0,0,0,.05); background: #fff; position: relative;">
                                            <div class="flash-sale-header"
                                                style="padding: 15px 20px; border-bottom: 1px solid rgba(0,0,0,.05); display:flex; justify-content:space-between; align-items:center;">
                                                <div class="flash-sale-time">
                                                    <span
                                                        style="color:#ee4d2d; font-size:20px; margin-right: 15px; font-weight: bold; font-style: italic;"><i
                                                            class="fas fa-bolt"></i> FLASH SALE</span>
                                                </div>
                                                <a href="flash_sale"
                                                    style="color:#ee4d2d; text-decoration:none; font-size:14px;">Xem
                                                    tất cả ></a>
                                            </div>
                                            <button class="nav-arrow-btn nav-arrow-btn--left" id="btnFlashSaleLeft"
                                                style="position: absolute; left: 0; top: 55%; transform: translateY(-50%); width: 25px; height: 50px; background: rgba(0,0,0,0.2); color: white; border: none; font-size: 16px; cursor: pointer; display: none; z-index: 10;">
                                                <i class="fas fa-chevron-left"></i>
                                            </button>
                                            <button class="nav-arrow-btn nav-arrow-btn--right" id="btnFlashSaleRight"
                                                style="position: absolute; right: 0; top: 55%; transform: translateY(-50%); width: 25px; height: 50px; background: rgba(0,0,0,0.2); color: white; border: none; font-size: 16px; cursor: pointer; display: flex; align-items: center; justify-content: center; z-index: 10;">
                                                <i class="fas fa-chevron-right"></i>
                                            </button>
                                            <div class="flash-sale-body" id="flashSaleGrid"
                                                style="display: flex; gap: 15px; padding: 20px; overflow-x: auto; scrollbar-width: none; scroll-behavior: smooth;">

                                                <c:forEach var="p" items="${products}" begin="0" end="5">
                                                    <a href="flash_sale"
                                                        style="text-decoration: none; flex: 0 0 170px; display: flex; flex-direction: column; align-items: center;">
                                                        <div style="width: 100%; position: relative;">
                                                            <img src="${p.imageUrl}"
                                                                loading="lazy" decoding="async"
                                                                style="width: 100%; height: 170px; object-fit: contain;">
                                                            <div
                                                                style="position: absolute; top: 0; right: 0; background: rgba(255,212,36,.9); color: #ee4d2d; font-size: 12px; font-weight: bold; padding: 2px 4px;">
                                                                -25%</div>
                                                        </div>
                                                        <div
                                                            style="color: #ee4d2d; font-size: 18px; margin-top: 15px; font-weight: 500;">
                                                            ₫${String.format("%,.0f", p.minPrice)}</div>
                                                        <div
                                                            style="position:relative; width:100%; height:16px; background:#ffbda6; border-radius:8px; margin-top:10px; overflow:hidden;">
                                                            <div
                                                                style="position:absolute; top:0; left:0; height:100%; width: 85%; background:linear-gradient(to right, #ee4d2d, #ff3b3b); border-radius:8px;">
                                                            </div>
                                                            <div
                                                                style="position:absolute; top:0; left:0; width:100%; height:100%; display:flex; align-items:center; justify-content:center; color:#fff; font-size:10px; text-transform:uppercase; z-index:2; text-shadow: 0 0 2px rgba(0,0,0,.3);">
                                                                Đang bán chạy</div>
                                                        </div>
                                                    </a>
                                                </c:forEach>
                                            </div>
                                        </div>

                                        <!-- SHOPEE MALL -->
                                        <div class="shopee-mall-section"
                                            style="background: #fff; border-radius: 2px; overflow: hidden; margin-bottom: 20px; box-shadow: 0 1px 2px 0 rgba(0,0,0,.05);">
                                            <div class="shopee-mall-header"
                                                style="display: flex; justify-content: space-between; align-items: center; padding: 18px 20px; border-bottom: 1px solid rgba(0,0,0,.05);">
                                                <div style="display: flex; align-items: center; gap: 20px;">
                                                    <div style="color: #d0011b; font-size: 16px; font-weight: 500;">
                                                        SHOPEE
                                                        MALL <span
                                                            style="font-weight: 300; margin: 0 5px; color: #ccc;">|</span>
                                                    </div>
                                                    <div
                                                        style="color: #333; font-size: 14px; display: flex; align-items: center; gap: 15px;">
                                                        <span><i class="fas fa-undo"
                                                                style="color: #d0011b; margin-right: 5px;"></i> Trả Hàng
                                                            Miễn Phí 15 Ngày</span>
                                                        <span><i class="fas fa-shield-alt"
                                                                style="color: #d0011b; margin-right: 5px;"></i> Hàng
                                                            Chính
                                                            Hãng 100%</span>
                                                        <span><i class="fas fa-truck"
                                                                style="color: #d0011b; margin-right: 5px;"></i> Miễn Phí
                                                            Vận
                                                            Chuyển</span>
                                                    </div>
                                                </div>
                                                <a href="#"
                                                    style="color: #d0011b; font-size: 14px; text-decoration: none; display: flex; align-items: center;">Xem
                                                    Tất Cả <i class="fas fa-chevron-right"
                                                        style="margin-left:5px; background: #d0011b; color: #fff; border-radius: 50%; padding: 2px 5px; font-size: 10px;"></i></a>
                                            </div>

                                            <div class="shopee-mall-body"
                                                style="display: flex; gap: 15px; padding: 15px;">
                                                <!-- Banner Left -->
                                                <div class="shopee-mall-banner" style="width: 390px; flex-shrink: 0;">
                                                    <a href="#">
                                                        <img src="images/vn-11134258-820l4-mizahu53m7sx0c.jpg"
                                                            loading="lazy" decoding="async"
                                                            style="width: 100%; height: 100%; object-fit: cover; border-radius: 2px;"
                                                            alt="Shopee Mall Banner">
                                                    </a>
                                                </div>

                                                <!-- Products Grid -->
                                                <div style="flex: 1; position: relative;">

                                                    <div class="shopee-mall-grid" id="shopeeMallGrid"
                                                        style="display: grid; grid-template-rows: repeat(2, 1fr); grid-auto-flow: column; grid-auto-columns: calc((100% - 30px) / 4); gap: 10px; overflow-x: auto; scroll-behavior: smooth; scrollbar-width: none;">
                                                        <!-- Product 1 -->
                                                        <a href="#"
                                                            style="text-decoration: none; display: flex; flex-direction: column; align-items: center; justify-content: space-between;">
                                                            <div style="width: 100%; position: relative;">
                                                                <img src="images/mall_prod_1.png"
                                                                    style="width: 100%; object-fit: contain;"
                                                                    alt="L'Oreal">
                                                            </div>
                                                            <div
                                                                style="font-size: 16px; color: #d0011b; text-align: center; margin-top: auto; padding-top: 15px;">
                                                                Ưu đãi đến 50%</div>
                                                        </a>
                                                        <!-- Product 2 -->
                                                        <a href="#"
                                                            style="text-decoration: none; display: flex; flex-direction: column; align-items: center; justify-content: space-between;">
                                                            <div style="width: 100%; position: relative;">
                                                                <img src="images/mall_prod_2.png"
                                                                    style="width: 100%; object-fit: contain;"
                                                                    alt="Unilever">
                                                            </div>
                                                            <div
                                                                style="font-size: 16px; color: #d0011b; text-align: center; margin-top: auto; padding-top: 15px;">
                                                                Mua 1 được 2</div>
                                                        </a>
                                                        <!-- Product 3 -->
                                                        <a href="#"
                                                            style="text-decoration: none; display: flex; flex-direction: column; align-items: center; justify-content: space-between;">
                                                            <div style="width: 100%; position: relative;">
                                                                <img src="images/mall_prod_3.png"
                                                                    style="width: 100%; object-fit: contain;"
                                                                    alt="Unilever">
                                                            </div>
                                                            <div
                                                                style="font-size: 16px; color: #d0011b; text-align: center; margin-top: auto; padding-top: 15px;">
                                                                Mua 1 tặng 1</div>
                                                        </a>
                                                        <!-- Product 4 -->
                                                        <a href="#"
                                                            style="text-decoration: none; display: flex; flex-direction: column; align-items: center; justify-content: space-between;">
                                                            <div style="width: 100%; position: relative;">
                                                                <img src="images/mall_prod_4.png"
                                                                    style="width: 100%; object-fit: contain;"
                                                                    alt="Garnier">
                                                            </div>
                                                            <div
                                                                style="font-size: 16px; color: #d0011b; text-align: center; margin-top: auto; padding-top: 15px;">
                                                                Mua là có quà</div>
                                                        </a>

                                                        <!-- Row 2 Products -->
                                                        <!-- Product 5 -->
                                                        <a href="#"
                                                            style="text-decoration: none; display: flex; flex-direction: column; align-items: center; justify-content: space-between;">
                                                            <div style="width: 100%; position: relative;">
                                                                <img src="images/mall_prod_5.png"
                                                                    style="width: 100%; object-fit: contain;"
                                                                    alt="Cocoon">
                                                            </div>
                                                            <div
                                                                style="font-size: 16px; color: #d0011b; text-align: center; margin-top: auto; padding-top: 15px;">
                                                                Mua 1 tặng 1</div>
                                                        </a>
                                                        <!-- Product 6 -->
                                                        <a href="#"
                                                            style="text-decoration: none; display: flex; flex-direction: column; align-items: center; justify-content: space-between;">
                                                            <div style="width: 100%; position: relative;">
                                                                <img src="images/vn-11134258-7ra0g-m6glb2udrprs42@resize_w402_nl.webp"
                                                                    style="width: 100%; object-fit: contain;"
                                                                    alt="Unilever">
                                                            </div>
                                                            <div
                                                                style="font-size: 16px; color: #d0011b; text-align: center; margin-top: auto; padding-top: 15px;">
                                                                Mua 1 tặng 1</div>
                                                        </a>
                                                        <!-- Product 7 -->
                                                        <a href="#"
                                                            style="text-decoration: none; display: flex; flex-direction: column; align-items: center; justify-content: space-between;">
                                                            <div style="width: 100%; position: relative;">
                                                                <img src="images/vn-50009109-7ce7d5800afb2b6c80a7242236ec7409@resize_w402_nl.webp"
                                                                    style="width: 100%; object-fit: contain;"
                                                                    alt="Watsons">
                                                            </div>
                                                            <div
                                                                style="font-size: 16px; color: #d0011b; text-align: center; margin-top: auto; padding-top: 15px;">
                                                                Mua là có quà</div>
                                                        </a>
                                                        <!-- Product 8 -->
                                                        <a href="#"
                                                            style="text-decoration: none; display: flex; flex-direction: column; align-items: center; justify-content: space-between;">
                                                            <div style="width: 100%; position: relative;">
                                                                <img src="images/vn-50009109-b44bb96f2e16efe70badc41661365c8a@resize_w402_nl.webp"
                                                                    style="width: 100%; object-fit: contain;"
                                                                    alt="CoolMate">
                                                            </div>
                                                            <div
                                                                style="font-size: 16px; color: #d0011b; text-align: center; margin-top: auto; padding-top: 15px;">
                                                                Mua 1 tặng 1</div>
                                                        </a>
                                                        <!-- Extra Products for scrolling -->
                                                        <a href="#"
                                                            style="text-decoration: none; display: flex; flex-direction: column; align-items: center; justify-content: space-between;">
                                                            <div style="width: 100%; position: relative;"><img
                                                                    src="images/mall_prod_1.png"
                                                                    style="width: 100%; object-fit: contain;"></div>
                                                            <div
                                                                style="font-size: 16px; color: #d0011b; text-align: center; margin-top: auto; padding-top: 15px;">
                                                                Ưu đãi đến 50%</div>
                                                        </a>
                                                        <a href="#"
                                                            style="text-decoration: none; display: flex; flex-direction: column; align-items: center; justify-content: space-between;">
                                                            <div style="width: 100%; position: relative;"><img
                                                                    src="images/mall_prod_2.png"
                                                                    style="width: 100%; object-fit: contain;"></div>
                                                            <div
                                                                style="font-size: 16px; color: #d0011b; text-align: center; margin-top: auto; padding-top: 15px;">
                                                                Mua 1 được 2</div>
                                                        </a>
                                                        <a href="#"
                                                            style="text-decoration: none; display: flex; flex-direction: column; align-items: center; justify-content: space-between;">
                                                            <div style="width: 100%; position: relative;"><img
                                                                    src="images/mall_prod_3.png"
                                                                    style="width: 100%; object-fit: contain;"></div>
                                                            <div
                                                                style="font-size: 16px; color: #d0011b; text-align: center; margin-top: auto; padding-top: 15px;">
                                                                Mua 1 tặng 1</div>
                                                        </a>
                                                        <a href="#"
                                                            style="text-decoration: none; display: flex; flex-direction: column; align-items: center; justify-content: space-between;">
                                                            <div style="width: 100%; position: relative;"><img
                                                                    src="images/mall_prod_4.png"
                                                                    style="width: 100%; object-fit: contain;"></div>
                                                            <div
                                                                style="font-size: 16px; color: #d0011b; text-align: center; margin-top: auto; padding-top: 15px;">
                                                                Mua là có quà</div>
                                                        </a>
                                                    </div>
                                                    <!-- Nút điều hướng -->
                                                    <button class="nav-arrow-btn nav-arrow-btn--left" id="btnMallLeft"
                                                        style="position: absolute; left: -12.5px; top: 50%; transform: translateY(-50%); width: 25px; height: 50px; background: rgba(0,0,0,0.2); color: white; border: none; font-size: 16px; cursor: pointer; display: none; z-index: 10;"><i
                                                            class="fas fa-chevron-left"></i></button>
                                                    <button class="nav-arrow-btn nav-arrow-btn--right" id="btnMallRight"
                                                        style="position: absolute; right: -12.5px; top: 50%; transform: translateY(-50%); width: 25px; height: 50px; background: rgba(0,0,0,0.2); color: white; border: none; font-size: 16px; cursor: pointer; display: flex; align-items: center; justify-content: center; z-index: 10;"><i
                                                            class="fas fa-chevron-right"></i></button>
                                                </div>
                                            </div>
                                        </div>

                                        <!-- TÌM KIẾM HÀNG ĐẦU -->
                                        <div class="top-search-section"
                                            style="background: #fff; border-radius: 2px; overflow: hidden; margin-bottom: 20px; box-shadow: 0 1px 2px 0 rgba(0,0,0,.05); position: relative;">
                                            <div class="top-search-header"
                                                style="color: #ee4d2d; font-size: 16px; padding: 18px 20px; border-bottom: 1px solid rgba(0,0,0,.05); text-transform: uppercase;">
                                                Tìm Kiếm Hàng Đầu <span
                                                    style="float: right; color: #ee4d2d; font-size: 14px; text-transform: none; cursor: pointer;">Xem
                                                    Tất Cả ></span>
                                            </div>
                                            <button class="nav-arrow-btn nav-arrow-btn--left" id="btnTopSearchLeft"
                                                style="position: absolute; left: 0; top: 55%; transform: translateY(-50%); width: 25px; height: 50px; background: rgba(0,0,0,0.2); color: white; border: none; font-size: 16px; cursor: pointer; display: none; z-index: 10;">
                                                <i class="fas fa-chevron-left"></i>
                                            </button>
                                            <button class="nav-arrow-btn nav-arrow-btn--right" id="btnTopSearchRight"
                                                style="position: absolute; right: 0; top: 55%; transform: translateY(-50%); width: 25px; height: 50px; background: rgba(0,0,0,0.2); color: white; border: none; font-size: 16px; cursor: pointer; display: flex; align-items: center; justify-content: center; z-index: 10;">
                                                <i class="fas fa-chevron-right"></i>
                                            </button>
                                            <div class="top-search-list" id="topSearchGrid"
                                                style="display: flex; gap: 15px; padding: 20px; overflow-x: auto; scrollbar-width: none; scroll-behavior: smooth;">

                                                <c:forEach var="p" items="${products}" begin="6" end="11">
                                                    <a href="san-pham-i.686868.${p.id}"
                                                        style="flex: 1; position: relative; text-decoration: none; color: inherit; display: block; min-width: 170px;">
                                                        <div
                                                            style="position: absolute; top:0; left: 0; background: #ee4d2d; color: white; padding: 4px 8px; font-size: 12px; font-weight: bold; border-radius: 2px; z-index: 2;">
                                                            TOP</div>
                                                        <img src="${p.imageUrl}"
                                                            loading="lazy" decoding="async"
                                                            style="width: 100%; height: 170px; object-fit: contain; display: block;"
                                                            alt="Sản Phẩm">
                                                        <div
                                                            style="background: rgba(0,0,0,.26); color: white; text-align: center; padding: 5px; font-size: 13px;">
                                                            Bán ${(p.id * 10) + 5}k+ / tháng</div>
                                                        <div
                                                            style="text-align: center; font-size: 16px; color: #555; margin-top: 15px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;">
                                                            ${p.name}</div>
                                                    </a>
                                                </c:forEach>
                                            </div>
                                        </div>

                                        <!-- GỢI Ý HÔM NAY -->
                                        <div class="suggest-today-header"
                                            style="background:#fff; padding: 15px; margin-bottom: 5px; text-align: center; color: #ee4d2d; font-size: 16px; text-transform: uppercase; border-bottom: 4px solid #ee4d2d; position: sticky; top: 119px; z-index: 10; box-shadow: 0 1px 2px 0 rgba(0,0,0,.05);">
                                            Gợi Ý Hôm Nay
                                        </div>

                                        <!-- Product Grid -->
                                        <div class="home-product">
                                            <div class="row" id="product-list">

                                                <% List<ProductDTO> list = (List<ProductDTO>)
                                                        request.getAttribute("products");
                                                        if (list != null && !list.isEmpty()) {
                                                        for (ProductDTO p : list) {
                                                        %>
                                                        <div class="col">
                                                            <% String slug="san-pham" ; if (p.getName() !=null) {
                                                                slug=p.getName().trim() .replaceAll("[\\s/]+", "-" )
                                                                .replaceAll("[^\\p{L}\\p{N}\\-]", "" )
                                                                .replaceAll("-{2,}", "-" ) .replaceAll("^-|-$", "" ); }
                                                                %>
                                                                <a class="home-product-item"
                                                                    href="<%= slug %>-i.686868.<%= p.getId() %>">
                                                                    <div class="home-product-item__img"
                                                                        style="background-image: url('<%= p.getImageUrl() %>')">
                                                                    </div>
                                                                    <h4 class="home-product-item__name">
                                                                        <%= p.getName() %>
                                                                    </h4>

                                                                    <div class="home-product-item__price">
                                                                        <span class="home-product-item__price-current">₫
                                                                            <%= String.format("%,.0f", p.getMinPrice())
                                                                                %>
                                                                        </span>
                                                                    </div>

                                                                    <div class="home-product-item__action">
                                                                        <span class="home-product-item__rating">
                                                                            <%
                                                                                int starRating = (int) Math.round(p.getRating());
                                                                                for (int si = 1; si <= 5; si++) {
                                                                                    if (si <= starRating) {
                                                                            %>
                                                                            <i class="home-product-item__star--gold fas fa-star"></i>
                                                                            <%      } else { %>
                                                                            <i class="far fa-star" style="color: #ccc;"></i>
                                                                            <%      }
                                                                                }
                                                                            %>
                                                                        </span>
                                                                        <span class="home-product-item__sold">Đã bán
                                                                            <%
                                                                                int sc = p.getSoldCount();
                                                                                if (sc >= 1000000) {
                                                                                    out.print(String.format("%.1ftr", sc / 1000000.0));
                                                                                } else if (sc >= 1000) {
                                                                                    out.print(String.format("%.1fk", sc / 1000.0));
                                                                                } else {
                                                                                    out.print(sc);
                                                                                }
                                                                            %></span>
                                                                    </div>
                                                                    <div class="home-product-item__origin">
                                                                        <span><%= p.getLocation() != null ? p.getLocation() : "Hà Nội" %></span>
                                                                    </div>

                                                                    <div class="home-product-item__favourite">
                                                                        <i class="fas fa-check"></i>
                                                                        <span>Yêu thích</span>
                                                                    </div>

                                                                    <div class="home-product-item__sale-off">
                                                                        <span
                                                                            class="home-product-item__sale-off-percent">10%</span>
                                                                        <span
                                                                            class="home-product-item__sale-off-label">GIẢM</span>
                                                                    </div>

                                                                    <% if (acc !=null && "admin"
                                                                        .equalsIgnoreCase(acc.getRole())) { %>
                                                                        <div
                                                                            style="text-align:center; padding: 5px; border-top: 1px dashed #ddd; background:#fff;">
                                                                            <object><a
                                                                                    href="product-manage?action=delete&id=<%= p.getId() %>"
                                                                                    style="color:#d0011b; font-size:12px; font-weight:bold; text-decoration:none;"
                                                                                    onclick="return confirm('Xóa thật hả?')">Xóa
                                                                                    SP</a></object>
                                                                        </div>
                                                                        <% } %>
                                                                </a>
                                                        </div>
                                                        <% } } else { %>
                                                            <div
                                                                style="width:100%; text-align:center; padding: 50px 0; color:#555;">
                                                                <i class="fas fa-box-open fa-3x mb-3 text-muted"></i>
                                                                <p>Chưa có sản phẩm. Vui lòng thêm từ Admin!</p>
                                                            </div>
                                                            <% } %>

                                            </div>
                                        </div>

                                    </div>
                                </div>

                                <!-- FOOTER -->
                                <footer class="footer">
                                    <div class="grid">
                                        <div class="row" style="padding:0 20px;">
                                            <div class="col" style="width: 25%">
                                                <h3 class="footer__heading">Chăm sóc khách hàng</h3>
                                                <ul class="footer-list">
                                                    <li><a href="#" class="footer-item__link">Trung tâm trợ giúp</a>
                                                    </li>
                                                    <li><a href="#" class="footer-item__link">Shopee Blog</a></li>
                                                    <li><a href="#" class="footer-item__link">Shopee Mall</a></li>
                                                    <li><a href="#" class="footer-item__link">Hướng dẫn mua hàng</a>
                                                    </li>
                                                </ul>
                                            </div>
                                            <div class="col" style="width: 25%">
                                                <h3 class="footer__heading">Về Shopee</h3>
                                                <ul class="footer-list">
                                                    <li><a href="#" class="footer-item__link">Giới thiệu</a></li>
                                                    <li><a href="#" class="footer-item__link">Tuyển dụng</a></li>
                                                    <li><a href="#" class="footer-item__link">Điều khoản</a></li>
                                                </ul>
                                            </div>
                                            <div class="col" style="width: 25%">
                                                <h3 class="footer__heading">Theo dõi</h3>
                                                <ul class="footer-list">
                                                    <li><a href="#" class="footer-item__link"><i class="fab fa-facebook"
                                                                style="font-size: 1.2rem; margin-right: 8px;"></i>
                                                            Facebook</a></li>
                                                    <li><a href="#" class="footer-item__link"><i
                                                                class="fab fa-instagram"
                                                                style="font-size: 1.2rem; margin-right: 8px;"></i>
                                                            Instagram</a></li>
                                                </ul>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="footer__bottom">
                                        <div class="grid">
                                            <p class="footer__text">© 2026 Shopee Clone. Trình tự môn Hệ Thống Web.
                                            </p>
                                        </div>
                                    </div>
                                </footer>

                                <!-- Shopee AI Chat Widget -->
                                <div class="shopee-chat-btn" id="shopeeChatBtn">
                                    <i class="fas fa-comment-dots"></i>
                                </div>
                                <div class="shopee-chat-window" id="shopeeChatWindow">
                                    <div class="shopee-chat-header">
                                        <span><i class="fas fa-robot" style="margin-right: 5px;"></i> Trợ lý Shopee
                                            AI</span>
                                        <i class="fas fa-times shopee-chat-close" id="shopeeChatClose"></i>
                                    </div>
                                    <div class="shopee-chat-messages" id="shopeeChatMessages">
                                        <div class="chat-msg-wrapper bot">
                                            <div class="chat-avatar"><i class="fas fa-robot"></i></div>
                                            <div class="chat-msg bot">Xin chào! Tôi là trợ lý AI ảo của Shopee. Tôi có thể giúp gì cho bạn hôm nay? 😊</div>
                                        </div>
                                    </div>
                                    <div class="shopee-chat-preview" id="chatPreview" style="display:none"></div>
                                    <div class="shopee-chat-input-area">
                                        <input type="file" id="chatImageInput" accept="image/*" style="display:none">
                                        <input type="file" id="chatFileInput" accept=".pdf,.doc,.docx,.txt,.xls,.xlsx,.csv,.zip,.rar" style="display:none">
                                        <button class="shopee-chat-attach-btn" id="chatImageBtn" title="Gửi ảnh">
                                            <i class="fas fa-image"></i>
                                        </button>
                                        <button class="shopee-chat-attach-btn" id="chatFileBtn" title="Đính kèm file">
                                            <i class="fas fa-paperclip"></i>
                                        </button>
                                        <input type="text" class="shopee-chat-input" id="shopeeChatInput"
                                            placeholder="Nhập tin nhắn..." autocomplete="off">
                                        <button class="shopee-chat-send" id="shopeeChatSend"><i
                                                class="fas fa-paper-plane"></i></button>
                                    </div>
                                </div>

                            </div>
                            <script src="js/home.js?v=1.0" defer></script>

                            <!-- Shopee VIP Promo Modal -->
                            <div id="vipPromoModal" class="shopee-vip-modal">
                                <div class="shopee-vip-modal-content">
                                    <span class="shopee-vip-close-btn">&times;</span>
                                    <a href="#">
                                        <img src="images/shopee_vip_modal.webp" alt="Shopee VIP Promotion"
                                            loading="lazy" decoding="async"
                                            style="width: 100%; height: auto; border-radius: 8px; box-shadow: 0 10px 30px rgba(0,0,0,0.3);">
                                    </a>
                                </div>
                            </div>

                        </body>

                        </html>
