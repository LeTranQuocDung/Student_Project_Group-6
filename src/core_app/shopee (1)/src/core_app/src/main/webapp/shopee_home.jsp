<%@page import="model.ProductDTO" %>
    <%@page import="model.Admin" %>
        <%@page import="model.User" %>
            <%@page import="java.util.List" %>
                <%@page contentType="text/html" pageEncoding="UTF-8" %>
                    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
                        <!DOCTYPE html>
                        <html lang="vi">

                        <head>
                            <meta charset="UTF-8">
                            <meta name="viewport" content="width=device-width, initial-scale=1.0">
                            <meta name="referrer" content="no-referrer">
                            <title>Shopee Việt Nam | Mua và Bán Trên Ứng Dụng Di Động Hoặc Website</title>
                            <link rel="stylesheet"
                                href="https://cdnjs.cloudflare.com/ajax/libs/normalize/8.0.1/normalize.min.css">
                            <link rel="stylesheet" href="css/style.css?v=2.0">
                            <link rel="stylesheet"
                                href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
                            <style>
                                /* Tinh chỉnh Fix lỗi Banner đè Menu do Header Fixed của Shopee */
                                .app__container {
                                    padding-top: 20px;
                                }

                                .grid {
                                    width: 1200px;
                                    max-width: 100%;
                                    margin: 0 auto;
                                }

                                .row {
                                    display: flex;
                                    flex-wrap: wrap;
                                    margin-left: -5px;
                                    margin-right: -5px;
                                }

                                .col {
                                    padding-left: 5px;
                                    padding-right: 5px;
                                    margin-bottom: 10px;
                                    width: 16.66667%;
                                }

                                /* 6 items/row */
                                .header__navbar-item-link {
                                    text-decoration: none;
                                    color: white;
                                }

                                /* Nút điều hướng Shopee Mall */
                                .nav-arrow-btn {
                                    position: absolute;
                                    top: 50%;
                                    transform: translateY(-50%);
                                    width: 25px;
                                    height: 25px;
                                    background-color: #fff;
                                    border-radius: 50%;
                                    border: none;
                                    display: flex;
                                    justify-content: center;
                                    align-items: center;
                                    box-shadow: 0 1px 12px 0 rgba(0, 0, 0, .12);
                                    cursor: pointer;
                                    z-index: 10;
                                    transition: transform 0.2s cubic-bezier(0.4, 0, 0.2, 1), box-shadow 0.2s;
                                    color: rgba(0, 0, 0, .54);
                                    font-size: 10px;
                                }

                                .nav-arrow-btn:hover {
                                    transform: translateY(-50%) scale(1.6);
                                    box-shadow: 0 1px 12px 0 rgba(0, 0, 0, .2);
                                    color: rgba(0, 0, 0, .8);
                                }

                                .nav-arrow-btn--left {
                                    left: -12.5px;
                                }

                                .nav-arrow-btn--right {
                                    right: -12.5px;
                                }

                                #topSearchGrid::-webkit-scrollbar {
                                    display: none;
                                }

                                #topSearchGrid>a {
                                    flex: 0 0 calc((100% - 75px) / 6);
                                }

                                /* Giao diện Chat AI Shopee */
                                .shopee-chat-btn {
                                    position: fixed;
                                    bottom: 20px;
                                    right: 20px;
                                    width: 60px;
                                    height: 60px;
                                    background-color: #ee4d2d;
                                    color: white;
                                    border-radius: 50%;
                                    display: flex;
                                    justify-content: center;
                                    align-items: center;
                                    font-size: 24px;
                                    box-shadow: 0 4px 10px rgba(0, 0, 0, 0.2);
                                    cursor: pointer;
                                    z-index: 1000;
                                    transition: transform 0.3s;
                                }

                                .shopee-chat-btn:hover {
                                    transform: scale(1.1);
                                }

                                .shopee-chat-window {
                                    position: fixed;
                                    bottom: 90px;
                                    right: 20px;
                                    width: 350px;
                                    height: 480px;
                                    background: white;
                                    box-shadow: 0 5px 20px rgba(0, 0, 0, 0.15);
                                    border-radius: 8px;
                                    display: none;
                                    flex-direction: column;
                                    z-index: 1000;
                                    overflow: hidden;
                                    border: 1px solid rgba(0, 0, 0, 0.05);
                                }

                                .shopee-chat-header {
                                    background: linear-gradient(-180deg, #f53d2d, #f63);
                                    color: white;
                                    padding: 15px;
                                    font-size: 16px;
                                    font-weight: 500;
                                    display: flex;
                                    justify-content: space-between;
                                    align-items: center;
                                }

                                .shopee-chat-close {
                                    cursor: pointer;
                                    font-size: 18px;
                                }

                                .shopee-chat-messages {
                                    flex: 1;
                                    padding: 15px;
                                    overflow-y: auto;
                                    display: flex;
                                    flex-direction: column;
                                    gap: 10px;
                                    background: #f9f9f9;
                                }

                                .shopee-chat-messages::-webkit-scrollbar {
                                    width: 6px;
                                }

                                .shopee-chat-messages::-webkit-scrollbar-thumb {
                                    background: #ccc;
                                    border-radius: 4px;
                                }

                                /* Wrapper chứa avatar + bubble */
                                .chat-msg-wrapper {
                                    display: flex;
                                    align-items: flex-end;
                                    gap: 8px;
                                    max-width: 90%;
                                }

                                .chat-msg-wrapper.user {
                                    align-self: flex-end;
                                    flex-direction: row-reverse;
                                }

                                .chat-msg-wrapper.bot {
                                    align-self: flex-start;
                                }

                                .chat-avatar {
                                    width: 28px;
                                    height: 28px;
                                    border-radius: 50%;
                                    display: flex;
                                    align-items: center;
                                    justify-content: center;
                                    font-size: 14px;
                                    flex-shrink: 0;
                                }

                                .chat-msg-wrapper.bot .chat-avatar {
                                    background: linear-gradient(-180deg, #f53d2d, #f63);
                                    color: #fff;
                                }

                                .chat-msg-wrapper.user .chat-avatar {
                                    background: #ddd;
                                    color: #666;
                                }

                                .chat-msg {
                                    padding: 10px 15px;
                                    border-radius: 18px;
                                    font-size: 14px;
                                    line-height: 1.4;
                                    word-wrap: break-word;
                                    min-width: 0;
                                }

                                .chat-msg.user {
                                    background: #ee4d2d;
                                    color: white;
                                    border-bottom-right-radius: 4px;
                                }

                                .chat-msg.bot {
                                    background: #fff;
                                    color: #333;
                                    border: 1px solid #e1e1e1;
                                    border-bottom-left-radius: 4px;
                                }

                                .shopee-chat-input-area {
                                    display: flex;
                                    padding: 10px;
                                    border-top: 1px solid #efefef;
                                    background: white;
                                }

                                .shopee-chat-input {
                                    flex: 1;
                                    border: 1px solid #ddd;
                                    border-radius: 20px;
                                    padding: 8px 15px;
                                    outline: none;
                                    font-size: 14px;
                                }

                                .shopee-chat-input:focus {
                                    border-color: #ee4d2d;
                                }

                                .shopee-chat-send {
                                    background: none;
                                    border: none;
                                    color: #ee4d2d;
                                    font-size: 20px;
                                    margin-left: 10px;
                                    cursor: pointer;
                                    transition: color 0.2s;
                                }

                                .shopee-chat-send:hover {
                                    color: #d0011b;
                                }

                                /* Nút đính kèm ảnh / file */
                                .shopee-chat-attach-btn {
                                    background: none;
                                    border: none;
                                    color: #888;
                                    font-size: 18px;
                                    cursor: pointer;
                                    padding: 4px 6px;
                                    transition: color 0.2s;
                                    display: flex;
                                    align-items: center;
                                }

                                .shopee-chat-attach-btn:hover {
                                    color: #ee4d2d;
                                }

                                /* Vùng preview ảnh/file trước khi gửi */
                                .shopee-chat-preview {
                                    display: flex;
                                    align-items: center;
                                    padding: 8px 10px;
                                    border-top: 1px solid #efefef;
                                    background: #fafafa;
                                    gap: 8px;
                                    position: relative;
                                }

                                .shopee-chat-preview img {
                                    max-width: 80px;
                                    max-height: 60px;
                                    border-radius: 6px;
                                    border: 1px solid #ddd;
                                    object-fit: cover;
                                }

                                .shopee-chat-preview .preview-file-info {
                                    display: flex;
                                    align-items: center;
                                    gap: 6px;
                                    background: #fff;
                                    border: 1px solid #ddd;
                                    border-radius: 8px;
                                    padding: 6px 10px;
                                    font-size: 12px;
                                    color: #555;
                                }

                                .shopee-chat-preview .preview-file-info i {
                                    color: #ee4d2d;
                                    font-size: 16px;
                                }

                                .shopee-chat-preview .preview-remove {
                                    background: rgba(0,0,0,0.5);
                                    color: #fff;
                                    border: none;
                                    border-radius: 50%;
                                    width: 20px;
                                    height: 20px;
                                    font-size: 12px;
                                    cursor: pointer;
                                    display: flex;
                                    align-items: center;
                                    justify-content: center;
                                    margin-left: auto;
                                    flex-shrink: 0;
                                }

                                .shopee-chat-preview .preview-remove:hover {
                                    background: rgba(0,0,0,0.7);
                                }

                                /* Ảnh trong tin nhắn chat */
                                .chat-msg img.chat-image {
                                    max-width: 100%;
                                    max-height: 200px;
                                    border-radius: 8px;
                                    margin-top: 5px;
                                    display: block;
                                    cursor: pointer;
                                }

                                .chat-msg .chat-file-badge {
                                    display: inline-flex;
                                    align-items: center;
                                    gap: 5px;
                                    background: rgba(255,255,255,0.2);
                                    padding: 4px 8px;
                                    border-radius: 6px;
                                    font-size: 12px;
                                    margin-top: 4px;
                                }

                                .chat-msg.bot .chat-file-badge {
                                    background: #f0f0f0;
                                }

                                .typing-indicator {
                                    display: inline-block;
                                    width: 4px;
                                    height: 4px;
                                    border-radius: 50%;
                                    background-color: #999;
                                    animation: typing 1s infinite alternate;
                                    margin: 0 2px;
                                }

                                .typing-indicator:nth-child(2) {
                                    animation-delay: 0.2s;
                                }

                                .typing-indicator:nth-child(3) {
                                    animation-delay: 0.4s;
                                }

                                @keyframes typing {
                                    0% {
                                        transform: translateY(0);
                                    }

                                    100% {
                                        transform: translateY(-4px);
                                    }
                                }

                                /* Modal quảng cáo Shopee VIP */
                                .shopee-vip-modal {
                                    position: fixed;
                                    top: 0;
                                    left: 0;
                                    width: 100%;
                                    height: 100%;
                                    background: rgba(0, 0, 0, 0.6);
                                    z-index: 9999;
                                    display: flex;
                                    justify-content: center;
                                    align-items: center;
                                    opacity: 0;
                                    visibility: hidden;
                                    transition: opacity 0.3s ease, visibility 0.3s ease;
                                }

                                .shopee-vip-modal.show {
                                    opacity: 1;
                                    visibility: visible;
                                }

                                .shopee-vip-modal-content {
                                    position: relative;
                                    max-width: 500px;
                                    width: 90%;
                                    transform: scale(0.8);
                                    transition: transform 0.3s cubic-bezier(0.175, 0.885, 0.32, 1.275);
                                }

                                .shopee-vip-modal.show .shopee-vip-modal-content {
                                    transform: scale(1);
                                }

                                .shopee-vip-close-btn {
                                    position: absolute;
                                    top: -15px;
                                    right: -15px;
                                    width: 30px;
                                    height: 30px;
                                    background: #fff;
                                    color: #666;
                                    border-radius: 50%;
                                    display: flex;
                                    justify-content: center;
                                    align-items: center;
                                    font-size: 20px;
                                    font-weight: bold;
                                    cursor: pointer;
                                    box-shadow: 0 2px 5px rgba(0, 0, 0, 0.2);
                                    z-index: 10;
                                }

                                .shopee-vip-close-btn:hover {
                                    background: #f1f1f1;
                                    color: #333;
                                }
                            </style>
                        </head>

                        <body>
                            <div class="app">
                                <!-- HEADER -->
                                <header class="header">
                                    <!-- Navbar -->
                                    <nav class="header__navbar">
                                        <ul class="header__navbar-list">
                                            <li class="header__navbar-item header__navbar-item--separate"><a href="#"
                                                    class="header__navbar-item-link">Kênh Người Bán</a></li>
                                            <li class="header__navbar-item header__navbar-item--separate"><a href="#"
                                                    class="header__navbar-item-link">Trở thành Người bán Shopee</a>
                                            </li>
                                            <li class="header__navbar-item header__navbar-item--separate"><a href="#"
                                                    class="header__navbar-item-link">Tải ứng dụng</a></li>
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
                                                        class="far fa-question-circle"></i> Hỗ trợ</a></li>
                                            <% User acc=(User) session.getAttribute("account"); if (acc !=null) { %>
                                                <li class="header__navbar-item header__navbar-item--separate" style="font-weight: 500;">
                                                    <div class="user-dropdown-wrapper">
                                                        <div class="user-dropdown-trigger" id="userDropdownTrigger">
                                                            <span class="user-avatar-small"><i class="fas fa-user-circle"></i></span>
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
                                                            style="width: 100%; height: 100%; object-fit: cover; display: block;">
                                                    </a>
                                                    <a href="#" style="flex: 0 0 100%; scroll-snap-align: start;">
                                                        <img src="images/main_banner_2.webp" alt="Shopee Banner 2"
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
                                                            style="width: 100%; height: 100%; object-fit: cover; display: block;"></a>
                                                </div>
                                                <div
                                                    style="flex: 1; border-radius: 2px; overflow: hidden; box-shadow: var(--box-shadow);">
                                                    <a href="#"><img src="images/sub_banner_2.webp" alt="Banner Nhỏ 2"
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
                                                    style="width: 50px; height: 50px; border-radius: 20px; background-image: url('https://cf.shopee.vn/file/vn-50009109-8a387d78a7ad954ec489d3ef9abd60b4_xhdpi'); background-size: cover; margin-bottom: 15px; border: 1px solid #f2f2f2; box-shadow: var(--box-shadow);">
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
                                                    <a href="#"
                                                        style="display: flex; flex-direction: column; align-items: center; justify-content: flex-start; padding: 20px 10px; border-right: 1px solid rgba(0,0,0,.05); border-bottom: 1px solid rgba(0,0,0,.05); text-decoration: none; color: rgba(0,0,0,.8); transition: transform 0.1s;">
                                                        <img src="${category.imageUrl}"
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
                                                <a href="#"
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
                                                    <a href="san-pham-i.686868.${p.id}"
                                                        style="text-decoration: none; flex: 0 0 170px; display: flex; flex-direction: column; align-items: center;">
                                                        <div style="width: 100%; position: relative;">
                                                            <img src="${p.imageUrl}"
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
                                                        <img src="images/shopee_mall_banner.png"
                                                            style="width: 100%; height: 100%; object-fit: cover; border-radius: 2px;"
                                                            alt="Shopee Mall Banner">
                                                    </a>
                                                </div>

                                                <!-- Products Grid -->
                                                <div style="flex: 1; position: relative;">
                                                    <style>
                                                        #shopeeMallGrid::-webkit-scrollbar {
                                                            display: none;
                                                        }
                                                    </style>
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
                                                                <img src="https://down-vn.img.susercontent.com/file/vn-11134201-7r98o-lsusnux18z046d"
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
                                                                <img src="https://down-vn.img.susercontent.com/file/vn-11134201-7r98o-lt2mzhz9k2cndv"
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
                                                                <img src="https://down-vn.img.susercontent.com/file/vn-11134201-7r98o-lt0aeyx5k3z486"
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
                                                                            <i
                                                                                class="home-product-item__star--gold fas fa-star"></i>
                                                                            <i
                                                                                class="home-product-item__star--gold fas fa-star"></i>
                                                                            <i
                                                                                class="home-product-item__star--gold fas fa-star"></i>
                                                                            <i
                                                                                class="home-product-item__star--gold fas fa-star"></i>
                                                                            <i
                                                                                class="home-product-item__star--gold fas fa-star"></i>
                                                                        </span>
                                                                        <span class="home-product-item__sold">Đã bán
                                                                            13,2k</span>
                                                                    </div>

                                                                    <div class="home-product-item__origin">
                                                                        <span>Hà Nội</span>
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
                            <script>
                                document.addEventListener("DOMContentLoaded", function () {
                                    // Hàm khởi tạo Carousel dùng chung cho các section
                                    function initCarousel(gridId, btnLeftId, btnRightId, displayStyle = "block") {
                                        const grid = document.getElementById(gridId);
                                        const btnLeft = document.getElementById(btnLeftId);
                                        const btnRight = document.getElementById(btnRightId);

                                        if (grid && btnLeft && btnRight) {
                                            function updateNavButtons() {
                                                const maxScroll = grid.scrollWidth - grid.clientWidth;
                                                const currentScroll = grid.scrollLeft;

                                                // 1. Khi nội dung quá ngắn, không có cuộn (maxScroll <= 1), ẩn cả 2 nút
                                                if (maxScroll <= 1) {
                                                    btnLeft.style.display = "none";
                                                    btnRight.style.display = "none";
                                                } else {
                                                    // 2. Nội dung có cuộn, logic hiển thị:
                                                    // Thêm dung sai 50px phòng tránh lỗi pixel fraction hoặc margin gap trong CSS Grid 
                                                    // khiến scrollLeft không bao giờ chạm tới maxScroll
                                                    btnLeft.style.display = currentScroll <= 50 ? "none" : displayStyle;
                                                    btnRight.style.display = currentScroll >= maxScroll - 50 ? "none" : displayStyle;
                                                    if (gridId === 'shopeeMallGrid') {
                                                        console.log("ShopeeMallGrid - scrollLeft:", currentScroll, "maxScroll:", maxScroll, "clientWidth:", grid.clientWidth, "scrollWidth:", grid.scrollWidth);
                                                    }
                                                }
                                            }

                                            // Gọi ngay lần đầu
                                            updateNavButtons();

                                            // Gán sự kiện Event listener
                                            grid.addEventListener("scroll", updateNavButtons);
                                            window.addEventListener("resize", updateNavButtons);

                                            btnLeft.addEventListener("click", () => {
                                                const currentScroll = grid.scrollLeft;
                                                const scrollAmount = currentScroll <= grid.clientWidth * 1.5 ? currentScroll : grid.clientWidth;
                                                grid.scrollBy({ left: -scrollAmount, behavior: "smooth" });
                                            });
                                            btnRight.addEventListener("click", () => {
                                                const maxScroll = grid.scrollWidth - grid.clientWidth;
                                                const currentScroll = grid.scrollLeft;
                                                const remainingScroll = maxScroll - currentScroll;
                                                const scrollAmount = remainingScroll <= grid.clientWidth * 1.5 ? remainingScroll : grid.clientWidth;
                                                grid.scrollBy({ left: scrollAmount, behavior: "smooth" });
                                            });
                                            // Thêm ResizeObserver để tự cập nhật khi layout hoặc ảnh thay đổi kích thước
                                            const observer = new ResizeObserver(() => {
                                                updateNavButtons();
                                            });
                                            observer.observe(grid);

                                            // Chạy lại khi trang đã load hết tất cả resource (ảnh)
                                            window.addEventListener('load', updateNavButtons);
                                        }
                                    }

                                    // Áp dụng vòng lặp Navigation Scroll cho toàn bộ các danh sách grid
                                    initCarousel("categoryGrid", "btnCategoryLeft", "btnCategoryRight", "flex");
                                    initCarousel("flashSaleGrid", "btnFlashSaleLeft", "btnFlashSaleRight", "flex");
                                    initCarousel("shopeeMallGrid", "btnMallLeft", "btnMallRight", "flex");
                                    initCarousel("topSearchGrid", "btnTopSearchLeft", "btnTopSearchRight", "flex");

                                    // --- Main Banner Carousel Logic ---
                                    const mainBannerCarousel = document.getElementById("mainBannerCarousel");
                                    const mainBannerWrapper = document.getElementById("mainBannerWrapper");
                                    const mainBannerLeftBtn = document.getElementById("mainBannerLeftBtn");
                                    const mainBannerRightBtn = document.getElementById("mainBannerRightBtn");
                                    const dots = document.querySelectorAll(".banner-dot");
                                    let currentIndex = 0;
                                    const totalBanners = 2; // Tạm thời để 2 ảnh
                                    let autoPlayInterval;

                                    if (mainBannerCarousel) {
                                        // Ẩn hiện navigation buttons popup on hover wrapper
                                        mainBannerWrapper.addEventListener("mouseenter", () => {
                                            mainBannerLeftBtn.style.display = "block";
                                            mainBannerRightBtn.style.display = "block";
                                        });
                                        mainBannerWrapper.addEventListener("mouseleave", () => {
                                            mainBannerLeftBtn.style.display = "none";
                                            mainBannerRightBtn.style.display = "none";
                                        });

                                        function updateDots(index) {
                                            dots.forEach(dot => {
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

                                        mainBannerLeftBtn.addEventListener("click", () => {
                                            scrollToBanner(currentIndex - 1);
                                            resetAutoPlay();
                                        });

                                        mainBannerRightBtn.addEventListener("click", () => {
                                            scrollToBanner(currentIndex + 1);
                                            resetAutoPlay();
                                        });

                                        dots.forEach(dot => {
                                            dot.addEventListener("click", (e) => {
                                                const idx = parseInt(e.target.getAttribute("data-index"));
                                                scrollToBanner(idx);
                                                resetAutoPlay();
                                            });
                                        });

                                        // Auto play every 3 seconds
                                        function startAutoPlay() {
                                            autoPlayInterval = setInterval(() => {
                                                scrollToBanner(currentIndex + 1);
                                            }, 3000);
                                        }

                                        function resetAutoPlay() {
                                            clearInterval(autoPlayInterval);
                                            startAutoPlay();
                                        }

                                        mainBannerCarousel.addEventListener("scrollend", () => {
                                            // Handle manual swipe updates
                                            const scrollPortion = mainBannerCarousel.scrollLeft / mainBannerCarousel.clientWidth;
                                            const idx = Math.round(scrollPortion);
                                            if (idx !== currentIndex) {
                                                currentIndex = idx;
                                                updateDots(currentIndex);
                                                resetAutoPlay();
                                            }
                                        });

                                        startAutoPlay();
                                    }

                                    // --- Shopee AI Chat Logic ---
                                    const chatBtn = document.getElementById("shopeeChatBtn");
                                    const chatWindow = document.getElementById("shopeeChatWindow");
                                    const chatClose = document.getElementById("shopeeChatClose");
                                    const chatInput = document.getElementById("shopeeChatInput");
                                    const chatSend = document.getElementById("shopeeChatSend");
                                    const chatMessages = document.getElementById("shopeeChatMessages");
                                    const chatImageInput = document.getElementById("chatImageInput");
                                    const chatFileInput = document.getElementById("chatFileInput");
                                    const chatImageBtn = document.getElementById("chatImageBtn");
                                    const chatFileBtn = document.getElementById("chatFileBtn");
                                    const chatPreview = document.getElementById("chatPreview");

                                    // API Proxypal qua Ngrok (public URL)
                                    const apiKey = "proxypal-local";
                                    const apiUrl = "https://chopfallen-will-steamily.ngrok-free.dev/v1/chat/completions";
                                    let chatHistory = []; // Lưu lại lịch sử hội thoại

                                    // Trạng thái đính kèm hiện tại
                                    let pendingAttachment = null; // { type: 'image'|'file', base64, name, mimeType, dataUrl }

                                    // Lời nhắc hệ thống (System Prompt)
                                    const systemInstruction = {
                                        role: "system",
                                        content: "Bạn là trợ lý ảo thân thiện của Shopee. Tư vấn khách hàng ngắn gọn, lịch sự, chuyên nghiệp và hữu ích. Dùng emoji sinh động. Khi người dùng gửi ảnh, hãy phân tích và mô tả nội dung ảnh. Khi người dùng gửi file, hãy phân tích nội dung file."
                                    };

                                    if (chatBtn && chatWindow) {
                                        chatBtn.addEventListener("click", () => {
                                            const isHidden = chatWindow.style.display === "none" || chatWindow.style.display === "";
                                            chatWindow.style.display = isHidden ? "flex" : "none";
                                            if (isHidden) {
                                                chatInput.focus();
                                            }
                                        });

                                        chatClose.addEventListener("click", () => {
                                            chatWindow.style.display = "none";
                                        });

                                        // === Xử lý chọn ảnh ===
                                        chatImageBtn.addEventListener("click", () => chatImageInput.click());
                                        chatImageInput.addEventListener("change", function () {
                                            const file = this.files[0];
                                            if (!file) return;
                                            if (file.size > 10 * 1024 * 1024) {
                                                alert("Ảnh quá lớn! Vui lòng chọn ảnh dưới 10MB.");
                                                this.value = '';
                                                return;
                                            }
                                            const reader = new FileReader();
                                            reader.onload = function (e) {
                                                const dataUrl = e.target.result;
                                                pendingAttachment = {
                                                    type: 'image',
                                                    dataUrl: dataUrl,
                                                    name: file.name,
                                                    mimeType: file.type
                                                };
                                                showPreview();
                                            };
                                            reader.readAsDataURL(file);
                                            this.value = ''; // Reset để có thể chọn lại cùng file
                                        });

                                        // === Xử lý chọn file ===
                                        chatFileBtn.addEventListener("click", () => chatFileInput.click());
                                        chatFileInput.addEventListener("change", function () {
                                            const file = this.files[0];
                                            if (!file) return;
                                            if (file.size > 10 * 1024 * 1024) {
                                                alert("File quá lớn! Vui lòng chọn file dưới 10MB.");
                                                this.value = '';
                                                return;
                                            }
                                            const reader = new FileReader();
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

                                        // === Hiển thị preview (dùng DOM thay vì innerHTML tránh xung đột JSP EL) ===
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

                                        // === Hiển thị tin nhắn (dùng DOM createElement tránh JSP EL xung đột) ===
                                        function addMessage(text, sender, attachment) {
                                            // Wrapper chứa avatar + bubble
                                            var wrapper = document.createElement('div');
                                            wrapper.className = 'chat-msg-wrapper ' + sender;

                                            // Avatar
                                            var avatar = document.createElement('div');
                                            avatar.className = 'chat-avatar';
                                            var avatarIcon = document.createElement('i');
                                            avatarIcon.className = sender === 'bot' ? 'fas fa-robot' : 'fas fa-user';
                                            avatar.appendChild(avatarIcon);
                                            wrapper.appendChild(avatar);

                                            // Bubble tin nhắn
                                            var msgDiv = document.createElement('div');
                                            msgDiv.className = 'chat-msg ' + sender;

                                            // Nếu có ảnh đính kèm → dùng createElement (không dùng innerHTML)
                                            if (attachment && attachment.type === 'image') {
                                                var img = document.createElement('img');
                                                img.src = attachment.dataUrl;
                                                img.className = 'chat-image';
                                                img.alt = 'Ảnh';
                                                img.addEventListener('click', function() { window.open(this.src, '_blank'); });
                                                msgDiv.appendChild(img);
                                            }

                                            // Nếu có file đính kèm
                                            if (attachment && attachment.type === 'file') {
                                                var badge = document.createElement('div');
                                                badge.className = 'chat-file-badge';
                                                var fIcon = document.createElement('i');
                                                fIcon.className = 'fas fa-file-alt';
                                                badge.appendChild(fIcon);
                                                badge.appendChild(document.createTextNode(' ' + attachment.name));
                                                msgDiv.appendChild(badge);
                                            }

                                            // Text content
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
                                            // Format lịch sử hội thoại cho OpenAI API
                                            const messages = [systemInstruction, ...chatHistory];

                                            try {
                                                const response = await fetch(apiUrl, {
                                                    method: 'POST',
                                                    headers: {
                                                        'Content-Type': 'application/json',
                                                        'Authorization': 'Bearer ' + apiKey,
                                                        'ngrok-skip-browser-warning': 'true'
                                                    },
                                                    body: JSON.stringify({
                                                        model: "gpt-5", // Sử dụng model gpt-5 qua ProxyPal
                                                        messages: messages,
                                                        temperature: 0.7
                                                    })
                                                });

                                                if (!response.ok) {
                                                    const errData = await response.json().catch(() => ({}));
                                                    console.error("API Error details:", errData);
                                                    const errMsg = (errData.error && errData.error.message) ? errData.error.message : 'Unknown';
                                                    throw new Error("HTTP Error " + response.status + ": " + errMsg);
                                                }

                                                const data = await response.json();
                                                if (data && data.choices && data.choices.length > 0 && data.choices[0].message) {
                                                    const replyText = data.choices[0].message.content;
                                                    chatHistory.push({ role: "assistant", content: replyText });
                                                    return replyText;
                                                }
                                                return "Xin lỗi, tôi không thể hiểu yêu cầu này, bạn có thể hỏi câu khác không?";
                                            } catch (error) {
                                                console.error("[Shopee AI] Lỗi hệ thống:", error);

                                                // Nếu là lỗi mạng (Failed to fetch)
                                                if (error instanceof TypeError && error.message === "Failed to fetch") {
                                                    return "Xin lỗi, hệ thống AI không thể kết nối tới máy chủ. Vui lòng thử lại sau.";
                                                }
                                                // Nếu lỗi khác, in ra chi tiết
                                                return "Xin lỗi, hệ thống AI đang gặp sự cố: " + error.message;
                                            }
                                        }

                                        async function handleSend() {
                                            const text = chatInput.value.trim();
                                            const attachment = pendingAttachment;

                                            // Phải có text hoặc attachment
                                            if (!text && !attachment) return;

                                            // Hiển thị tin nhắn user (có ảnh/file nếu có)
                                            addMessage(text, "user", attachment);
                                            chatInput.value = "";
                                            clearAttachment();
                                            addTypingIndicator();

                                            // Tạo message cho API
                                            let userMessage;

                                            if (attachment && attachment.type === 'image') {
                                                // Format OpenAI Vision API: multimodal content
                                                const contentParts = [];
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
                                                // Đính kèm nội dung file dưới dạng text
                                                const fileContext = `[File đính kèm: ${attachment.name}]\n\nNội dung file:\n${attachment.textContent}`;
                                                const fullText = text ? `${text}\n\n${fileContext}` : fileContext;
                                                userMessage = { role: "user", content: fullText };
                                            } else {
                                                userMessage = { role: "user", content: text };
                                            }

                                            chatHistory.push(userMessage);

                                            const reply = await fetchFromAI();

                                            removeTypingIndicator();

                                            // Trường hợp network error, không lưu lịch sử tin nhắn fail
                                            if (reply.startsWith("Xin lỗi, hệ thống AI")) {
                                                addMessage(reply, "bot");
                                                chatHistory.pop(); // Revert user message
                                                return;
                                            }

                                            addMessage(reply, "bot");
                                        }

                                        chatSend.addEventListener("click", handleSend);
                                        chatInput.addEventListener("keypress", (e) => {
                                            if (e.key === "Enter") handleSend();
                                        });
                                    }
                                });
                            </script>

                            <!-- Shopee VIP Promo Modal -->
                            <div id="vipPromoModal" class="shopee-vip-modal">
                                <div class="shopee-vip-modal-content">
                                    <span class="shopee-vip-close-btn">&times;</span>
                                    <a href="#">
                                        <!-- Thay src bằng ảnh thật của Modal -->
                                        <img src="images/shopee_vip_modal.png" alt="Shopee VIP Promotion"
                                            onerror="this.src='https://cf.shopee.vn/file/vn-50009109-8a387d78a7ad954ec489d3ef9abd60b4_xhdpi'"
                                            style="width: 100%; height: auto; border-radius: 8px; box-shadow: 0 10px 30px rgba(0,0,0,0.3);">
                                    </a>
                                </div>
                            </div>

                            <script>
                                document.addEventListener("DOMContentLoaded", function () {
                                    // Kiểm tra xem người dùng đã thấy modal chưa trong session này
                                    if (!sessionStorage.getItem('shopeeVipPromoShown')) {
                                        const modal = document.getElementById('vipPromoModal');
                                        const closeBtn = document.querySelector('.shopee-vip-close-btn');

                                        // Hiển thị modal sau một khoảng trễ nhỏ (vd 1 giây)
                                        setTimeout(() => {
                                            modal.classList.add('show');
                                        }, 1000);

                                        // Đóng modal 
                                        const closeModal = () => {
                                            modal.classList.remove('show');
                                            // Đánh dấu là đã hiển thị trong session này
                                            sessionStorage.setItem('shopeeVipPromoShown', 'true');
                                        };

                                        closeBtn.addEventListener('click', closeModal);

                                        // Đóng modal khi click ra ngoài hình ảnh
                                        modal.addEventListener('click', function (e) {
                                            if (e.target === modal) {
                                                closeModal();
                                            }
                                        });
                                    }
                                });
                            </script>

                        </body>

                        </html>