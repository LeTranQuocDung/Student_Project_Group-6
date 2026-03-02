<%@page import="java.util.List" %>
    <%@page import="model.Product" %>
        <%@page contentType="text/html" pageEncoding="UTF-8" %>
            <%@ taglib prefix="c" uri="jakarta.tags.core" %>
                <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
                    <!DOCTYPE html>
                    <html lang="vi">

                    <head>
                        <meta charset="UTF-8">
                        <title>Chi tiết sản phẩm | Shopee Việt Nam</title>
                        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
                            rel="stylesheet">
                        <link rel="stylesheet"
                            href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
                        <link href="css/home.css" rel="stylesheet">

                        <style>
                            /* CSS RIÊNG CHO TRANG CHI TIẾT (CHUẨN SHOPEE) */
                            body {
                                background-color: #f5f5f5;
                            }

                            /* Breadcrumb (Đường dẫn) */
                            .shopee-breadcrumb {
                                font-size: 13px;
                                color: #0055aa;
                                margin: 20px 0;
                            }

                            .shopee-breadcrumb a {
                                text-decoration: none;
                                color: inherit;
                            }

                            .shopee-breadcrumb span {
                                color: #555;
                                margin: 0 5px;
                            }

                            .shopee-breadcrumb .current {
                                color: #333;
                                overflow: hidden;
                                text-overflow: ellipsis;
                                white-space: nowrap;
                            }

                            /* Khung chính */
                            .product-wrapper {
                                background: #fff;
                                padding: 20px;
                                border-radius: 3px;
                                box-shadow: 0 1px 1px 0 rgba(0, 0, 0, .05);
                                display: flex;
                                gap: 30px;
                            }

                            /* CỘT TRÁI: ẢNH */
                            .col-left {
                                width: 450px;
                                flex-shrink: 0;
                            }

                            .main-image-frame {
                                width: 100%;
                                position: relative;
                                cursor: pointer;
                                margin-bottom: 10px;
                            }

                            .main-image {
                                width: 100%;
                                aspect-ratio: 1/1;
                                object-fit: contain;
                            }

                            .gallery-list {
                                display: flex;
                                gap: 10px;
                                overflow-x: auto;
                                padding-bottom: 5px;
                            }

                            .gallery-item {
                                width: 82px;
                                height: 82px;
                                cursor: pointer;
                                border: 2px solid transparent;
                                opacity: 0.8;
                            }

                            .gallery-item:hover,
                            .gallery-item.active {
                                border-color: #ee4d2d;
                                opacity: 1;
                            }

                            .gallery-item img {
                                width: 100%;
                                height: 100%;
                                object-fit: cover;
                            }

                            /* Share & Like */
                            .share-like {
                                display: flex;
                                justify-content: center;
                                align-items: center;
                                gap: 30px;
                                margin-top: 15px;
                                font-size: 16px;
                                color: #222;
                            }

                            .share-like i {
                                font-size: 20px;
                            }

                            .like-heart {
                                color: #ff424f;
                            }

                            /* CỘT PHẢI: THÔNG TIN */
                            .col-right {
                                flex-grow: 1;
                            }

                            .product-title {
                                font-size: 20px;
                                font-weight: 500;
                                line-height: 1.2;
                                color: #222;
                                margin-bottom: 10px;
                                overflow-wrap: break-word;
                            }

                            /* Rating & Sold */
                            .rating-sold-row {
                                display: flex;
                                align-items: center;
                                font-size: 14px;
                                color: #222;
                                margin-bottom: 15px;
                            }

                            .rating-star {
                                color: #ee4d2d;
                                margin-right: 5px;
                                border-bottom: 1px solid #ee4d2d;
                                padding-bottom: 1px;
                                font-size: 16px;
                            }

                            .rating-text {
                                color: #ee4d2d;
                                margin-right: 5px;
                                border-bottom: 1px solid #ee4d2d;
                                padding-bottom: 1px;
                                font-size: 16px;
                            }

                            .separator {
                                margin: 0 15px;
                                color: #dbdbdb;
                            }

                            .sold-num {
                                font-size: 16px;
                                color: #222;
                                margin-right: 5px;
                            }

                            .sold-text {
                                color: #767676;
                                font-size: 14px;
                            }

                            .price-section {
                                background: #fafafa;
                                display: flex;
                                flex-direction: column;
                                margin-bottom: 20px;
                            }

                            .flash-sale-banner {
                                background: url('https://deo.shopeemobile.com/shopee/shopee-pcmall-live-sg/productdetailspage/0150d1ad3cd5e197cb3f.png') 0 100% no-repeat, url('https://deo.shopeemobile.com/shopee/shopee-pcmall-live-sg/productdetailspage/7504e7c7a31b402ba687.png') repeat-x;
                                background-size: auto 100%, auto 100%;
                                height: 36px;
                                display: flex;
                                justify-content: space-between;
                                align-items: center;
                                padding: 0 15px;
                                color: white;
                            }

                            .flash-sale-banner .label {
                                font-weight: bold;
                                font-style: italic;
                                font-size: 18px;
                                display: flex;
                                align-items: center;
                                gap: 5px;
                            }

                            .flash-sale-banner .timer {
                                display: flex;
                                align-items: center;
                                font-size: 14px;
                                gap: 5px;
                            }

                            .timer-box {
                                background: #000;
                                color: #fff;
                                padding: 1px 4px;
                                border-radius: 2px;
                                font-family: monospace;
                                font-size: 14px;
                                font-weight: bold;
                            }

                            .price-content {
                                padding: 15px 20px;
                                display: flex;
                                align-items: center;
                                gap: 15px;
                            }

                            .old-price {
                                text-decoration: line-through;
                                color: #929292;
                                font-size: 16px;
                            }

                            .current-price {
                                color: #ee4d2d;
                                font-size: 32px;
                                font-weight: 500;
                            }

                            .discount-tag {
                                font-size: 12px;
                                color: #fff;
                                background: #ee4d2d;
                                padding: 2px 4px;
                                border-radius: 2px;
                                font-weight: bold;
                                text-transform: uppercase;
                            }

                            .voucher-row {
                                display: flex;
                                align-items: flex-start;
                                margin-bottom: 20px;
                            }

                            .voucher-label {
                                width: 110px;
                                color: #757575;
                                font-size: 14px;
                                flex-shrink: 0;
                                margin-top: 3px;
                            }

                            .voucher-tags {
                                display: flex;
                                gap: 8px;
                                flex-wrap: wrap;
                                flex: 1;
                            }

                            .voucher-tag {
                                background: rgba(255, 87, 34, 0.1);
                                color: #ee4d2d;
                                border: 1px solid rgba(255, 87, 34, 0.2);
                                padding: 2px 8px;
                                border-radius: 2px;
                                font-size: 12px;
                                display: flex;
                                align-items: center;
                                cursor: pointer;
                            }

                            .voucher-tag::before {
                                content: '';
                                position: absolute;
                                left: -3px;
                                top: 50%;
                                transform: translateY(-50%);
                                width: 5px;
                                height: 5px;
                                background: #fff;
                                border-radius: 50%;
                                border-right: 1px solid rgba(255, 87, 34, 0.2);
                            }

                            /* Options (Màu/Size) */
                            .option-row {
                                display: flex;
                                align-items: flex-start;
                                margin-bottom: 25px;
                            }

                            .option-label {
                                width: 110px;
                                color: #757575;
                                font-size: 14px;
                                margin-top: 8px;
                                flex-shrink: 0;
                            }

                            .option-items {
                                display: flex;
                                flex-wrap: wrap;
                                gap: 10px;
                            }

                            .option-btn {
                                background: #fff;
                                border: 1px solid rgba(0, 0, 0, .09);
                                padding: 8px 30px;
                                cursor: pointer;
                                min-width: 80px;
                                color: rgba(0, 0, 0, .8);
                                font-size: 14px;
                                position: relative;
                                overflow: hidden;
                            }

                            .option-btn:hover {
                                border-color: #ee4d2d;
                                color: #ee4d2d;
                            }

                            .option-btn.selected {
                                border-color: #ee4d2d;
                                color: #ee4d2d;
                            }

                            /* Tick V góc dưới */
                            .option-btn.selected::after {
                                content: '';
                                width: 15px;
                                height: 15px;
                                background: #ee4d2d;
                                position: absolute;
                                bottom: 0;
                                right: 0;
                                clip-path: polygon(100% 0, 100% 100%, 0 100%);
                            }

                            .option-btn.selected::before {
                                content: '✔';
                                color: #fff;
                                font-size: 8px;
                                position: absolute;
                                bottom: 0;
                                right: 0;
                                z-index: 2;
                                font-weight: bold;
                            }

                            /* Số lượng */
                            .qty-input-group {
                                display: flex;
                                align-items: center;
                                border: 1px solid rgba(0, 0, 0, .09);
                                width: fit-content;
                            }

                            .qty-btn {
                                width: 32px;
                                height: 32px;
                                background: #fff;
                                border: none;
                                cursor: pointer;
                                font-size: 16px;
                                color: #757575;
                                border-right: 1px solid rgba(0, 0, 0, .09);
                                display: flex;
                                align-items: center;
                                justify-content: center;
                            }

                            .qty-btn:last-child {
                                border-right: none;
                                border-left: 1px solid rgba(0, 0, 0, .09);
                            }

                            .qty-value {
                                width: 50px;
                                height: 32px;
                                text-align: center;
                                border: none;
                                outline: none;
                                font-size: 16px;
                                color: #222;
                            }

                            /* Nút Mua */
                            .action-group {
                                display: flex;
                                gap: 15px;
                                margin-top: 30px;
                            }

                            .btn-add-cart {
                                background: rgba(255, 87, 34, .1);
                                border: 1px solid #ee4d2d;
                                color: #ee4d2d;
                                height: 48px;
                                padding: 0 20px;
                                font-size: 16px;
                                display: flex;
                                align-items: center;
                                gap: 10px;
                                border-radius: 2px;
                            }

                            .btn-add-cart:hover {
                                background: rgba(255, 87, 34, .15);
                            }

                            .btn-buy-now {
                                background: #ee4d2d;
                                color: #fff;
                                border: none;
                                height: 48px;
                                padding: 0 60px;
                                font-size: 16px;
                                border-radius: 2px;
                            }

                            .btn-buy-now:hover {
                                background: #f05d40;
                                opacity: 0.95;
                            }

                            /* Shop Info & Mô tả */
                            .section-box {
                                background: #fff;
                                padding: 25px;
                                margin-top: 15px;
                                border-radius: 3px;
                                box-shadow: 0 1px 1px 0 rgba(0, 0, 0, .05);
                            }

                            .section-header {
                                background: #f5f5f5;
                                padding: 14px;
                                color: rgba(0, 0, 0, .87);
                                font-size: 18px;
                                text-transform: uppercase;
                                margin-bottom: 20px;
                            }

                            .product-desc-content {
                                font-size: 14px;
                                line-height: 1.7;
                                color: rgba(0, 0, 0, .8);
                                white-space: pre-wrap;
                                overflow: hidden;
                            }

                            /* Toast Notification */
                            .shopee-toast {
                                position: fixed;
                                top: 50%;
                                left: 50%;
                                transform: translate(-50%, -50%) scale(0.8);
                                background: rgba(0, 0, 0, 0.75);
                                color: #fff;
                                padding: 25px 50px;
                                border-radius: 4px;
                                z-index: 99999;
                                text-align: center;
                                opacity: 0;
                                transition: opacity 0.3s, transform 0.3s;
                                pointer-events: none;
                                min-width: 200px;
                            }

                            .shopee-toast.show {
                                opacity: 1;
                                transform: translate(-50%, -50%) scale(1);
                            }

                            .shopee-toast .toast-icon {
                                font-size: 40px;
                                color: #00bfa5;
                                margin-bottom: 10px;
                            }

                            .shopee-toast .toast-msg {
                                font-size: 16px;
                                white-space: nowrap;
                            }

                            /* Wholesale Row */
                            .wholesale-row {
                                display: flex;
                                align-items: flex-start;
                                margin-bottom: 20px;
                                padding: 12px 0;
                                border-bottom: 1px solid rgba(0, 0, 0, .05);
                            }

                            .wholesale-label {
                                width: 110px;
                                color: #757575;
                                font-size: 14px;
                                flex-shrink: 0;
                                margin-top: 3px;
                            }

                            .wholesale-content {
                                flex: 1;
                                font-size: 14px;
                                color: rgba(0, 0, 0, .87);
                            }

                            .wholesale-link {
                                color: #ee4d2d;
                                cursor: pointer;
                                font-size: 14px;
                                margin-left: 10px;
                                text-decoration: none;
                            }

                            .wholesale-link:hover {
                                text-decoration: underline;
                            }

                            /* Like animation */
                            .like-heart.liked {
                                animation: heartPop 0.3s ease;
                            }

                            @keyframes heartPop {
                                0% {
                                    transform: scale(1);
                                }

                                50% {
                                    transform: scale(1.3);
                                }

                                100% {
                                    transform: scale(1);
                                }
                            }

                            /* Qty button disabled */
                            .qty-btn:disabled {
                                opacity: 0.4;
                                cursor: not-allowed;
                            }
                        </style>
                    </head>

                    <body>

                        <div style="background: linear-gradient(-180deg,#f53d2d,#f63); padding: 15px 0;">
                            <div class="container d-flex align-items-center gap-3">
                                <a href="home" class="text-white text-decoration-none fs-4 fw-bold">
                                    <i class="fas fa-shopping-bag"></i> Shopee
                                </a>
                                <div style="width: 1px; height: 20px; background: #fff; opacity: 0.5;"></div>
                                <span class="text-white fs-5">Chi tiết sản phẩm</span>

                                <div class="ms-auto d-flex align-items-center gap-4">
                                    <a href="cart" class="text-white text-decoration-none" style="position: relative;">
                                        <i class="fas fa-shopping-cart fs-5"></i>
                                        <span
                                            class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-white text-danger border border-danger"
                                            style="font-size: 0.6rem;">
                                            ${sessionScope.cart != null ? sessionScope.cart.totalQuantity : 0}
                                        </span>
                                    </a>
                                    <a href="home" class="text-white text-decoration-none small">
                                        <i class="fas fa-home"></i> Trở về trang chủ
                                    </a>
                                </div>
                            </div>
                        </div>

                        <% Product p=(Product) request.getAttribute("detail"); List<String> listImg = (List<String>)
                                request.getAttribute("listImg");

                                if (p != null) {
                                java.math.BigDecimal oldPrice = p.getPrice().multiply(new java.math.BigDecimal("1.35"));
                                %>

                                <div class="container">
                                    <div class="shopee-breadcrumb">
                                        <a href="home">Shopee</a> <span>&gt;</span>
                                        <a href="#">Thiết Bị Điện Tử</a> <span>&gt;</span>
                                        <span class="current">
                                            <%= p.getName()%>
                                        </span>
                                    </div>

                                    <div class="product-wrapper">
                                        <div class="col-left">
                                            <div class="main-image-frame">
                                                <img id="mainImg" src="<%= p.getImageUrl()%>" class="main-image"
                                                    alt="Product Image">
                                            </div>
                                            <div class="gallery-list">
                                                <div class="gallery-item active" onmouseover="changeImg(this)">
                                                    <img src="<%= p.getImageUrl()%>">
                                                </div>
                                                <% if (listImg !=null) { for (String img : listImg) {%>
                                                    <div class="gallery-item" onmouseover="changeImg(this)">
                                                        <img src="<%= img%>">
                                                    </div>
                                                    <% } }%>
                                            </div>

                                            <div class="share-like">
                                                <div>Chia sẻ: <i class="fab fa-facebook-messenger"
                                                        style="color:#0384ff; cursor:pointer;"></i> <i
                                                        class="fab fa-facebook"
                                                        style="color:#3b5999; cursor:pointer;"></i> <i
                                                        class="fab fa-pinterest"
                                                        style="color:#de0217; cursor:pointer;"></i> <i
                                                        class="fab fa-twitter"
                                                        style="color:#10c2ff; cursor:pointer;"></i></div>
                                                <div style="width: 1px; height: 20px; background: #dbdbdb;"></div>
                                                <div id="likeBtn" style="cursor:pointer;" onclick="toggleLike()">
                                                    <i id="likeIcon" class="far fa-heart like-heart"></i>
                                                    <span id="likeText">Đã thích (<span
                                                            id="likeCount">2.1k</span>)</span>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="col-right">
                                            <h1 class="product-title">
                                                <span class="badge bg-danger align-middle me-1"
                                                    style="font-size: 12px;">Yêu
                                                    Thích</span>
                                                <%= p.getName()%>
                                            </h1>

                                            <% java.util.List<model.Review> reviewList = (java.util.List<model.Review>)
                                                    request.getAttribute("reviews");
                                                    int reviewCount = (reviewList != null) ? reviewList.size() : 0;
                                                    double avgRat = 0;
                                                    if (reviewCount > 0) {
                                                    int sumRat = 0;
                                                    for (model.Review rv : reviewList) {
                                                    sumRat += rv.getRating();
                                                    }
                                                    avgRat = (double) sumRat / reviewCount;
                                                    }
                                                    Integer soldCountObj = (Integer) request.getAttribute("soldCount");
                                                    int soldCnt = (soldCountObj != null) ? soldCountObj : 0;

                                                    String reviewCountStr;
                                                    if (reviewCount >= 1000) {
                                                    reviewCountStr = String.format("%.1fk", reviewCount /
                                                    1000.0).replace(",", ".");
                                                    } else {
                                                    reviewCountStr = String.valueOf(reviewCount);
                                                    }
                                                    String soldCountStr;
                                                    if (soldCnt >= 1000000) {
                                                    soldCountStr = String.format("%.1ftr", soldCnt /
                                                    1000000.0).replace(",", ".");
                                                    } else if (soldCnt >= 1000) {
                                                    soldCountStr = String.format("%.1fk", soldCnt / 1000.0).replace(",",
                                                    ".");
                                                    } else {
                                                    soldCountStr = String.valueOf(soldCnt);
                                                    }
                                                    %>
                                                    <div class="rating-sold-row">
                                                        <span class="rating-text">
                                                            <%= String.format("%.1f", avgRat) %>
                                                        </span>
                                                        <span class="rating-star">
                                                            <% for (int si=1; si <=5; si++) { if (si
                                                                <=Math.floor(avgRat)) { %>
                                                                <i class="fas fa-star"></i>
                                                                <% } else if (si <=avgRat + 0.5) { %>
                                                                    <i class="fas fa-star-half-alt"></i>
                                                                    <% } else { %>
                                                                        <i class="far fa-star"></i>
                                                                        <% } } %>
                                                        </span>
                                                        <span class="separator">|</span>
                                                        <span class="sold-num">
                                                            <%= reviewCountStr %>
                                                        </span>
                                                        <span class="sold-text">Đánh Giá</span>
                                                        <span class="separator">|</span>
                                                        <span class="sold-num">
                                                            <%= soldCountStr %>
                                                        </span>
                                                        <span class="sold-text">Đã Bán</span>
                                                    </div>

                                                    <div class="price-section">
                                                        <div class="flash-sale-banner">
                                                            <div class="label">
                                                                F<i class="fas fa-bolt" style="font-size: 18px;"></i>ASH
                                                                SALE
                                                            </div>
                                                            <div class="timer">
                                                                <i class="far fa-clock"></i> KẾT THÚC TRONG
                                                                <span class="timer-box"
                                                                    style="margin-left: 5px;">01</span> :
                                                                <span class="timer-box">08</span> :
                                                                <span class="timer-box">37</span>
                                                            </div>
                                                        </div>
                                                        <div class="price-content">
                                                            <span class="old-price">₫<%= String.format("%,.0f",
                                                                    oldPrice)%>
                                                            </span>
                                                            <span class="current-price">₫<%= String.format("%,.0f",
                                                                    p.getPrice())%>
                                                            </span>
                                                            <span class="discount-tag"
                                                                style="background: transparent; color: #ee4d2d; border: 1px solid #ee4d2d;">-47%</span>
                                                        </div>
                                                    </div>

                                                    <!-- Wholesale Pricing Row -->
                                                    <div class="wholesale-row">
                                                        <span class="wholesale-label">Mua Giá Bán<br>Buôn/ Bán Sỉ</span>
                                                        <div class="wholesale-content">
                                                            Mua từ (>=2) sản phẩm chỉ với <b>
                                                                <%=String.format("%,.0f", p.getPrice().multiply(new
                                                                    java.math.BigDecimal("0.95")))%>₫
                                                            </b>
                                                            <a href="javascript:void(0)" class="wholesale-link">Xem Thêm
                                                                <i class="fas fa-chevron-right small"></i></a>
                                                        </div>
                                                    </div>

                                                    <div class="voucher-row">
                                                        <span class="voucher-label">Mã Giảm Giá<br>Của Shop</span>
                                                        <div class="voucher-tags" style="position: relative;">
                                                            <span class="voucher-tag"
                                                                style="position: relative; overflow: hidden;">Giảm
                                                                5k₫</span>
                                                            <span class="voucher-tag"
                                                                style="position: relative; overflow: hidden;">Giảm
                                                                10%</span>
                                                            <span class="voucher-tag"
                                                                style="position: relative; overflow: hidden;">Giảm
                                                                10%</span>
                                                            <span class="voucher-tag"
                                                                style="position: relative; overflow: hidden;">Giảm
                                                                10%</span>
                                                            <span
                                                                style="color: #ee4d2d; font-size: 14px; margin-left: auto; cursor: pointer;">Xem
                                                                tất cả <i class="fas fa-chevron-right small"></i></span>
                                                        </div>
                                                    </div>

                                                    <div class="option-row" style="margin-bottom: 25px;">
                                                        <span class="option-label">Vận Chuyển</span>
                                                        <div style="font-size: 14px; width: 100%;">
                                                            <div
                                                                style="display: flex; gap: 10px; align-items: flex-start;">
                                                                <img src="https://deo.shopeemobile.com/shopee/shopee-pcmall-live-sg/productdetailspage/d9e99298b53f66f1ce6d.png"
                                                                    style="width: 20px; height: 15px; margin-top: 3px;">
                                                                <div>
                                                                    <div style="color: rgba(0,0,0,.8);">Nhận từ 25 Th02
                                                                        - 1 Th03
                                                                        <i
                                                                            class="fas fa-chevron-right small text-black-50 ms-1"></i>
                                                                    </div>
                                                                    <div style="color: #00bfa5; margin-top: 5px;">Phí
                                                                        ship 0đ
                                                                    </div>
                                                                    <div
                                                                        style="color: #757575; font-size: 12px; margin-top: 5px;">
                                                                        Tặng
                                                                        Voucher 15.000đ nếu đơn giao sau thời gian trên.
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>

                                                    <div class="option-row" style="margin-bottom: 25px;">
                                                        <span class="option-label">An Tâm Mua<br>Sắm
                                                            Cùng<br>Shopee</span>
                                                        <div
                                                            style="font-size: 14px; display: flex; align-items: center; gap: 10px; color: rgba(0,0,0,.8);">
                                                            <i class="fas fa-shield-alt text-danger"></i> Trả hàng miễn
                                                            phí 15
                                                            ngày •
                                                            Bảo hiểm rơi vỡ màn hình <i
                                                                class="fas fa-chevron-right small text-black-50 ms-1"></i>
                                                        </div>
                                                    </div>

                                                    <div class="option-row">
                                                        <span class="option-label" style="align-self: center;">Nhóm
                                                            Màu</span>
                                                        <div class="option-items">
                                                            <button class="option-btn" onclick="selectOpt(this)"
                                                                style="padding: 4px 12px; display: flex; align-items: center; gap: 8px;">
                                                                <img src="<%= p.getImageUrl() %>"
                                                                    style="width: 24px; height: 24px; object-fit: cover;">
                                                                Mèo Tôm Cầm Hoa
                                                            </button>
                                                            <button class="option-btn" onclick="selectOpt(this)"
                                                                style="padding: 4px 12px; display: flex; align-items: center; gap: 8px;">
                                                                <img src="<%= p.getImageUrl() %>"
                                                                    style="width: 24px; height: 24px; object-fit: cover;">
                                                                Mèo Trắng Nơ Hồng
                                                            </button>
                                                        </div>
                                                    </div>

                                                    <div class="option-row">
                                                        <span class="option-label">Phiên Bản</span>
                                                        <div class="option-items">
                                                            <button class="option-btn"
                                                                onclick="selectOpt(this)">128GB</button>
                                                            <button class="option-btn"
                                                                onclick="selectOpt(this)">256GB</button>
                                                            <button class="option-btn"
                                                                onclick="selectOpt(this)">512GB</button>
                                                        </div>
                                                    </div>

                                                    <div id="productActionArea">
                                                        <input type="hidden" id="hiddenProductId" value="${detail.id}">
                                                        <div class="option-row" style="align-items: center;">
                                                            <span class="option-label">Số Lượng</span>
                                                            <div class="qty-input-group">
                                                                <button type="button" class="qty-btn" id="btnMinus"
                                                                    onclick="updateQty(-1)">-</button>
                                                                <input type="text" value="1" class="qty-value"
                                                                    id="qtyInput" onblur="clampQty()"
                                                                    onkeydown="if(event.key==='Enter')event.preventDefault()">
                                                                <button type="button" class="qty-btn" id="btnPlus"
                                                                    onclick="updateQty(1)">+</button>
                                                            </div>
                                                            <span class="text-secondary ms-3 small" id="stockLabel">
                                                                <% Integer stockObj = (Integer) request.getAttribute("totalStock");
                                                                   int stockVal = (stockObj != null) ? stockObj : 0;
                                                                   if (stockVal > 0) { %>
                                                                    <%= stockVal %> sản phẩm có sẵn
                                                                <% } else { %>
                                                                    <span style="color: #ee4d2d;">Hết hàng</span>
                                                                <% } %>
                                                            </span>
                                                        </div>

                                                        <div class="action-group">
                                                            <button type="button" class="btn btn-add-cart"
                                                                id="btnAddCart" onclick="addToCartAjax()">
                                                                <i class="fas fa-cart-plus"></i> Thêm Vào Giỏ Hàng
                                                            </button>
                                                            <button type="button" class="btn btn-buy-now" id="btnBuyNow"
                                                                onclick="buyNow()">Mua Ngay</button>
                                                        </div>
                                                    </div>

                                                    <!-- Hidden form for Buy Now (submitted via JS) -->
                                                    <form id="buyNowForm" action="buy_now" method="post"
                                                        style="display:none;">
                                                        <input type="hidden" name="productId" value="${detail.id}">
                                                        <input type="hidden" name="qty" id="buyNowQty" value="1">
                                                    </form>


                                                    <div class="mt-4 pt-3 border-top small text-secondary">
                                                        <span class="me-4"><i
                                                                class="fas fa-undo-alt text-danger me-1"></i> Đổi
                                                            trả miễn
                                                            phí 15 ngày</span>
                                                        <span><i class="fas fa-shield-alt text-danger me-1"></i> Hàng
                                                            chính hãng
                                                            100%</span>
                                                    </div>
                                        </div>
                                    </div>

                                    <!-- SHOP INFO SECTION -->
                                    <div class="section-box" style="padding: 20px 25px;">
                                        <div style="display: flex; align-items: center; gap: 20px;">
                                            <!-- Shop Avatar & Name -->
                                            <div
                                                style="display: flex; align-items: center; gap: 15px; min-width: 340px;">
                                                <div style="position: relative;">
                                                    <div
                                                        style="width: 78px; height: 78px; border-radius: 50%; border: 1px solid rgba(0,0,0,.09); overflow: hidden; background: #f5f5f5; display: flex; align-items: center; justify-content: center;">
                                                        <i class="fas fa-store"
                                                            style="font-size: 28px; color: #ee4d2d;"></i>
                                                    </div>
                                                    <span
                                                        style="position: absolute; bottom: -4px; left: 50%; transform: translateX(-50%); background: #ee4d2d; color: #fff; font-size: 10px; padding: 1px 5px; border-radius: 2px; white-space: nowrap;">Yêu
                                                        thích</span>
                                                </div>
                                                <div>
                                                    <div
                                                        style="font-size: 16px; color: rgba(0,0,0,.87); font-weight: 500; margin-bottom: 4px;">
                                                        Shopee Official Store
                                                    </div>
                                                    <div style="font-size: 12px; color: #26aa99; margin-bottom: 10px;">
                                                        <i class="fas fa-circle"
                                                            style="font-size: 6px; vertical-align: middle; margin-right: 3px;"></i>
                                                        Online
                                                    </div>
                                                    <div style="display: flex; gap: 10px;">
                                                        <button
                                                            style="background: rgba(238,77,45,0.1); color: #ee4d2d; border: 1px solid #ee4d2d; padding: 6px 18px; font-size: 13px; border-radius: 2px; cursor: pointer; display: flex; align-items: center; gap: 5px;">
                                                            <i class="fas fa-comment-dots"></i> Chat Ngay
                                                        </button>
                                                        <button
                                                            style="background: #fff; color: rgba(0,0,0,.87); border: 1px solid rgba(0,0,0,.09); padding: 6px 18px; font-size: 13px; border-radius: 2px; cursor: pointer; display: flex; align-items: center; gap: 5px;">
                                                            <i class="fas fa-store"></i> Xem Shop
                                                        </button>
                                                    </div>
                                                </div>
                                            </div>

                                            <!-- Divider -->
                                            <div
                                                style="width: 1px; height: 80px; background: rgba(0,0,0,.05); margin: 0 10px;">
                                            </div>

                                            <!-- Shop Stats Grid -->
                                            <div
                                                style="display: grid; grid-template-columns: 1fr 1fr 1fr; gap: 12px 40px; flex: 1; font-size: 13px;">
                                                <div style="display: flex; justify-content: space-between;">
                                                    <span style="color: rgba(0,0,0,.4);">Đánh Giá</span>
                                                    <span style="color: #ee4d2d;">6,5tr</span>
                                                </div>
                                                <div style="display: flex; justify-content: space-between;">
                                                    <span style="color: rgba(0,0,0,.4);">Tỉ Lệ Phản Hồi</span>
                                                    <span style="color: #ee4d2d;">100%</span>
                                                </div>
                                                <div style="display: flex; justify-content: space-between;">
                                                    <span style="color: rgba(0,0,0,.4);">Tham Gia</span>
                                                    <span style="color: #ee4d2d;">10 năm trước</span>
                                                </div>
                                                <div style="display: flex; justify-content: space-between;">
                                                    <span style="color: rgba(0,0,0,.4);">Sản Phẩm</span>
                                                    <span style="color: #ee4d2d;">1,6k</span>
                                                </div>
                                                <div style="display: flex; justify-content: space-between;">
                                                    <span style="color: rgba(0,0,0,.4);">Thời Gian Phản Hồi</span>
                                                    <span style="color: #ee4d2d;">trong vài giờ</span>
                                                </div>
                                                <div style="display: flex; justify-content: space-between;">
                                                    <span style="color: rgba(0,0,0,.4);">Người Theo Dõi</span>
                                                    <span style="color: #ee4d2d;">3,1tr</span>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="section-box">
                                        <div class="section-header"
                                            style="background: #fafafa; padding: 10px 15px; margin: -25px -25px 20px -25px; border-bottom: 1px solid rgba(0,0,0,.05);">
                                            MÔ TẢ SẢN PHẨM</div>
                                        <div class="product-desc-content">
                                            <%= p.getDescription() !=null ? p.getDescription() : "Đang cập nhật..." %>

                                                <br><br>
                                                ------------------------------------------------<br>
                                                🔰 CAM KẾT CỦA SHOP:<br>
                                                - Hàng chính hãng 100%<br>
                                                - Bảo hành 12 tháng tại trung tâm ủy quyền<br>
                                                - Hoàn tiền 200% nếu phát hiện hàng giả<br>
                                                - Giao hàng hỏa tốc trong 2h tại nội thành
                                        </div>
                                    </div>

                                    <!-- ĐÁNH GIÁ SẢN PHẨM SECTION -->
                                    <div class="section-box">
                                        <div class="section-header"
                                            style="background: #fafafa; padding: 10px 15px; margin: -25px -25px 20px -25px; border-bottom: 1px solid rgba(0,0,0,.05);">
                                            ĐÁNH GIÁ SẢN PHẨM
                                        </div>

                                        <!-- Tính toán thống kê đánh giá từ dữ liệu thực -->
                                        <c:set var="totalReviews" value="${not empty reviews ? reviews.size() : 0}" />
                                        <c:set var="sumRating" value="0" />
                                        <c:set var="star5" value="0" />
                                        <c:set var="star4" value="0" />
                                        <c:set var="star3" value="0" />
                                        <c:set var="star2" value="0" />
                                        <c:set var="star1" value="0" />
                                        <c:set var="hasCommentCount" value="0" />
                                        <c:set var="hasMediaCount" value="0" />
                                        <c:forEach var="rv" items="${reviews}">
                                            <c:set var="sumRating" value="${sumRating + rv.rating}" />
                                            <c:if test="${rv.rating == 5}">
                                                <c:set var="star5" value="${star5 + 1}" />
                                            </c:if>
                                            <c:if test="${rv.rating == 4}">
                                                <c:set var="star4" value="${star4 + 1}" />
                                            </c:if>
                                            <c:if test="${rv.rating == 3}">
                                                <c:set var="star3" value="${star3 + 1}" />
                                            </c:if>
                                            <c:if test="${rv.rating == 2}">
                                                <c:set var="star2" value="${star2 + 1}" />
                                            </c:if>
                                            <c:if test="${rv.rating == 1}">
                                                <c:set var="star1" value="${star1 + 1}" />
                                            </c:if>
                                            <c:if test="${not empty rv.comment}">
                                                <c:set var="hasCommentCount" value="${hasCommentCount + 1}" />
                                            </c:if>
                                            <c:if test="${rv.hasMedia}">
                                                <c:set var="hasMediaCount" value="${hasMediaCount + 1}" />
                                            </c:if>
                                        </c:forEach>
                                        <c:set var="avgRating"
                                            value="${totalReviews > 0 ? sumRating / totalReviews : 0}" />

                                        <!-- Overall Rating -->
                                        <div
                                            style="background: #fffbf8; border: 1px solid #f9ede5; padding: 25px 30px; margin-bottom: 20px; display: flex; align-items: center; gap: 30px;">
                                            <div style="text-align: center; min-width: 120px;">
                                                <div style="font-size: 28px; color: #ee4d2d;">
                                                    <span style="font-size: 28px;">
                                                        <c:choose>
                                                            <c:when test="${totalReviews > 0}">
                                                                <fmt:formatNumber value="${avgRating}"
                                                                    maxFractionDigits="1" />
                                                            </c:when>
                                                            <c:otherwise>0</c:otherwise>
                                                        </c:choose>
                                                    </span>
                                                    <span style="font-size: 16px; color: rgba(0,0,0,.54);"> trên
                                                        5</span>
                                                </div>
                                                <div style="color: #ee4d2d; font-size: 20px; margin-top: 5px;">
                                                    <c:forEach begin="1" end="5" var="s">
                                                        <c:choose>
                                                            <c:when test="${s <= avgRating}"><i class="fas fa-star"></i>
                                                            </c:when>
                                                            <c:when test="${s <= avgRating + 0.5}"><i
                                                                    class="fas fa-star-half-alt"></i></c:when>
                                                            <c:otherwise><i class="far fa-star"></i></c:otherwise>
                                                        </c:choose>
                                                    </c:forEach>
                                                </div>
                                            </div>
                                            <div style="display: flex; flex-wrap: wrap; gap: 8px;">
                                                <button onclick="filterReview(this, 'all')" data-filter="all"
                                                    style="padding: 6px 20px; border: 1px solid #ee4d2d; background: #fff; color: #ee4d2d; cursor: pointer; border-radius: 2px; font-size: 13px;"
                                                    class="review-filter-active">Tất Cả</button>
                                                <button onclick="filterReview(this, '5')" data-filter="5"
                                                    style="padding: 6px 20px; border: 1px solid rgba(0,0,0,.09); background: #fff; color: rgba(0,0,0,.87); cursor: pointer; border-radius: 2px; font-size: 13px;">5
                                                    Sao (${star5})</button>
                                                <button onclick="filterReview(this, '4')" data-filter="4"
                                                    style="padding: 6px 20px; border: 1px solid rgba(0,0,0,.09); background: #fff; color: rgba(0,0,0,.87); cursor: pointer; border-radius: 2px; font-size: 13px;">4
                                                    Sao (${star4})</button>
                                                <button onclick="filterReview(this, '3')" data-filter="3"
                                                    style="padding: 6px 20px; border: 1px solid rgba(0,0,0,.09); background: #fff; color: rgba(0,0,0,.87); cursor: pointer; border-radius: 2px; font-size: 13px;">3
                                                    Sao (${star3})</button>
                                                <button onclick="filterReview(this, '2')" data-filter="2"
                                                    style="padding: 6px 20px; border: 1px solid rgba(0,0,0,.09); background: #fff; color: rgba(0,0,0,.87); cursor: pointer; border-radius: 2px; font-size: 13px;">2
                                                    Sao (${star2})</button>
                                                <button onclick="filterReview(this, '1')" data-filter="1"
                                                    style="padding: 6px 20px; border: 1px solid rgba(0,0,0,.09); background: #fff; color: rgba(0,0,0,.87); cursor: pointer; border-radius: 2px; font-size: 13px;">1
                                                    Sao (${star1})</button>
                                                <button onclick="filterReview(this, 'comment')" data-filter="comment"
                                                    style="padding: 6px 20px; border: 1px solid rgba(0,0,0,.09); background: #fff; color: rgba(0,0,0,.87); cursor: pointer; border-radius: 2px; font-size: 13px;">Có
                                                    Bình Luận (${hasCommentCount})</button>
                                                <button onclick="filterReview(this, 'media')" data-filter="media"
                                                    style="padding: 6px 20px; border: 1px solid rgba(0,0,0,.09); background: #fff; color: rgba(0,0,0,.87); cursor: pointer; border-radius: 2px; font-size: 13px;">Có
                                                    Hình Ảnh / Video (${hasMediaCount})</button>
                                            </div>
                                        </div>

                                        <!-- Reviews Data -->
                                        <c:choose>
                                            <c:when test="${empty reviews}">
                                                <!-- Empty State for Reviews -->
                                                <div
                                                    style="display: flex; flex-direction: column; align-items: center; justify-content: center; padding: 50px 0;">
                                                    <img src="https://deo.shopeemobile.com/shopee/shopee-pcmall-live-sg/productdetailpage/18cc857e49eec2bd9215031b26829ced.png"
                                                        alt="No reviews"
                                                        style="width: 100px; height: 100px; margin-bottom: 20px;">
                                                    <div style="font-size: 16px; color: rgba(0,0,0,.87);">Chưa có đánh
                                                        giá</div>
                                                </div>
                                            </c:when>
                                            <c:otherwise>
                                                <!-- Review List -->
                                                <div class="review-list">
                                                    <c:forEach var="r" items="${reviews}">
                                                        <div class="review-item" data-rating="${r.rating}"
                                                            data-has-comment="${not empty r.comment}"
                                                            data-has-media="${r.hasMedia}"
                                                            style="display: flex; gap: 10px; padding: 15px 0; border-bottom: 1px solid rgba(0,0,0,.09);">
                                                            <div class="user-avatar"
                                                                style="width: 40px; height: 40px; border-radius: 50%; overflow: hidden; background: #f5f5f5; flex-shrink: 0; display: flex; align-items: center; justify-content: center;">
                                                                <i class="fas fa-user"
                                                                    style="color: #c6c6c6; font-size: 20px;"></i>
                                                            </div>
                                                            <div class="review-main" style="flex: 1;">
                                                                <div class="username"
                                                                    style="font-size: 12px; color: rgba(0,0,0,.87); margin-bottom: 4px;">
                                                                    ${r.username}</div>
                                                                <div class="stars"
                                                                    style="color: #ee4d2d; font-size: 10px; margin-bottom: 4px;">
                                                                    <c:forEach begin="1" end="5" var="i">
                                                                        <c:choose>
                                                                            <c:when test="${i <= r.rating}">
                                                                                <i class="fas fa-star"
                                                                                    style="margin-right: 2px;"></i>
                                                                            </c:when>
                                                                            <c:otherwise>
                                                                                <i class="far fa-star"
                                                                                    style="margin-right: 2px;"></i>
                                                                            </c:otherwise>
                                                                        </c:choose>
                                                                    </c:forEach>
                                                                </div>
                                                                <div class="time-variant"
                                                                    style="font-size: 12px; color: rgba(0,0,0,.54); margin-bottom: 12px;">
                                                                    <fmt:formatDate value="${r.createdAt}"
                                                                        pattern="yyyy-MM-dd HH:mm" /> | Phân loại hàng:
                                                                    Mặc định
                                                                </div>
                                                                <div class="review-content"
                                                                    style="font-size: 14px; color: rgba(0,0,0,.87); line-height: 1.5; white-space: pre-wrap;">
                                                                    ${r.comment}</div>

                                                                <c:if test="${r.hasMedia}">
                                                                    <div class="review-media"
                                                                        style="margin-top: 15px; display: flex; gap: 10px;">
                                                                        <div
                                                                            style="width: 72px; height: 72px; cursor: pointer;">
                                                                            <img src="${detail.imageUrl}"
                                                                                style="width: 100%; height: 100%; object-fit: cover;">
                                                                        </div>
                                                                    </div>
                                                                </c:if>

                                                                <div class="review-actions"
                                                                    style="margin-top: 15px; display: flex; gap: 20px; font-size: 14px; color: rgba(0,0,0,.4);">
                                                                    <span style="cursor: pointer;"><i
                                                                            class="far fa-thumbs-up"></i> Hữu
                                                                        ích?</span>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </c:forEach>
                                                </div>
                                                <!-- Empty state khi filter không có kết quả -->
                                                <div id="reviewFilterEmpty"
                                                    style="display:none; text-align:center; padding: 40px 0; color: rgba(0,0,0,.54);">
                                                    <i class="far fa-comment-dots"
                                                        style="font-size: 40px; margin-bottom: 10px; color: #ddd;"></i>
                                                    <div style="font-size: 14px;">Không có đánh giá nào phù hợp với bộ
                                                        lọc</div>
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>

                                </div>

                                <!-- VIẾT ĐÁNH GIÁ SECTION -->
                                <c:if test="${not empty sessionScope.account}">
                                    <div class="section-box" style="margin-top: 20px;">
                                        <div class="section-header"
                                            style="background: #fafafa; padding: 10px 15px; margin: -25px -25px 20px -25px; border-bottom: 1px solid rgba(0,0,0,.05);">
                                            VIẾT ĐÁNH GIÁ SẢN PHẨM
                                        </div>
                                        <form action="submit_review" method="post"
                                            style="display: flex; flex-direction: column; gap: 15px;">
                                            <input type="hidden" name="productId" value="${detail.id}">
                                            <div>
                                                <label
                                                    style="font-size: 14px; color: rgba(0,0,0,.87); margin-bottom: 8px; display: block;">Chọn
                                                    mức độ đánh giá:</label>
                                                <div class="rating-input"
                                                    style="color: #ee4d2d; font-size: 24px; cursor: pointer; display: flex; gap: 5px;">
                                                    <i class="fas fa-star rating-star-input" data-value="1"></i>
                                                    <i class="fas fa-star rating-star-input" data-value="2"></i>
                                                    <i class="fas fa-star rating-star-input" data-value="3"></i>
                                                    <i class="fas fa-star rating-star-input" data-value="4"></i>
                                                    <i class="fas fa-star rating-star-input" data-value="5"></i>
                                                </div>
                                                <input type="hidden" name="rating" id="ratingValue" value="5" required>
                                            </div>
                                            <div>
                                                <textarea name="comment" rows="4"
                                                    placeholder="Để lại đánh giá của bạn về sản phẩm này..."
                                                    style="width: 100%; padding: 10px; border: 1px solid rgba(0,0,0,.14); border-radius: 2px; font-size: 14px; outline: none; resize: vertical;"
                                                    required></textarea>
                                            </div>
                                            <div style="display: flex; justify-content: flex-end;">
                                                <button type="submit" class="btn btn-buy-now"
                                                    style="height: 40px; padding: 0 30px; line-height: 40px; border-radius: 2px;">Gửi
                                                    Đánh Giá</button>
                                            </div>
                                        </form>
                                    </div>
                                    <script>
                                        const starsList = document.querySelectorAll('.rating-star-input');
                                        const ratingInput = document.getElementById('ratingValue');

                                        starsList.forEach(star => {
                                            star.addEventListener('mouseover', function () {
                                                const val = parseInt(this.getAttribute('data-value'));
                                                updateStars(val);
                                            });
                                            star.addEventListener('mouseout', function () {
                                                const val = parseInt(ratingInput.value) || 0;
                                                updateStars(val);
                                            });
                                            star.addEventListener('click', function () {
                                                ratingInput.value = this.getAttribute('data-value');
                                                updateStars(parseInt(this.getAttribute('data-value')));
                                            });
                                        });

                                        function updateStars(val) {
                                            starsList.forEach((s, idx) => {
                                                if (idx < val) {
                                                    s.classList.remove('far');
                                                    s.classList.add('fas');
                                                } else {
                                                    s.classList.remove('fas');
                                                    s.classList.add('far');
                                                }
                                            });
                                        }
                                    </script>
                                </c:if>
                                <c:if test="${empty sessionScope.account}">
                                    <div class="section-box"
                                        style="margin-top: 20px; text-align: center; padding: 30px;">
                                        <div style="font-size: 16px; color: rgba(0,0,0,.87); margin-bottom: 15px;">Vui
                                            lòng đăng nhập để viết đánh giá cho sản phẩm này nhé.</div>
                                        <a href="login.jsp" class="btn btn-add-cart"
                                            style="display: inline-flex; justify-content: center; width: auto;">Đăng
                                            Nhập</a>
                                    </div>
                                </c:if>



                                <% } else { %>
                                    <div class="container text-center py-5">
                                        <h3>Sản phẩm không tồn tại!</h3>
                                        <a href="home" class="btn btn-primary mt-3">Quay lại trang chủ</a>
                                    </div>
                                    <% }%>

                                        <div class="shopee-footer"
                                            style="border-top: 4px solid #ee4d2d; background: #fff; padding: 40px 0; margin-top: 50px; font-size: 14px; color: rgba(0,0,0,.65);">
                                            <div class="container text-center">
                                                <p>© 2026 Shopee. Tất cả các quyền được bảo lưu.</p>
                                            </div>
                                        </div>

                                        <!-- Toast Notification HTML -->
                                        <div class="shopee-toast" id="shopeeToast">
                                            <div class="toast-icon"><i class="fas fa-check-circle"></i></div>
                                            <div class="toast-msg" id="toastMsg">Sản phẩm đã được thêm vào Giỏ Hàng
                                            </div>
                                        </div>

                                        <script>
                                            // ============================================================
                                            // 1. HOVER ĐỔI ẢNH
                                            // ============================================================
                                            function changeImg(el) {
                                                document.getElementById('mainImg').src = el.querySelector('img').src;
                                                document.querySelectorAll('.gallery-item').forEach(i => i.classList.remove('active'));
                                                el.classList.add('active');
                                            }

                                            // ============================================================
                                            // 2. CHỌN OPTION (Màu/Size)
                                            // ============================================================
                                            function selectOpt(btn) {
                                                let siblings = btn.parentElement.children;
                                                for (let s of siblings)
                                                    s.classList.remove('selected');
                                                btn.classList.add('selected');
                                            }

                                            // ============================================================
                                            // 3. SỐ LƯỢNG - TĂNG GIẢM + VALIDATION
                                            // ============================================================
                                            const MAX_QTY = <%= (request.getAttribute("totalStock") != null) ? request.getAttribute("totalStock") : 0 %>; // Tồn kho thực tế
                                            const MIN_QTY = 1;

                                            function updateQty(n) {
                                                let input = document.getElementById('qtyInput');
                                                let val = parseInt(input.value) || 1;
                                                val += n;
                                                if (val < MIN_QTY) val = MIN_QTY;
                                                if (val > MAX_QTY) val = MAX_QTY;
                                                input.value = val;
                                                updateQtyButtons(val);
                                            }

                                            function clampQty() {
                                                let input = document.getElementById('qtyInput');
                                                let val = parseInt(input.value);
                                                if (isNaN(val) || val < MIN_QTY) val = MIN_QTY;
                                                if (val > MAX_QTY) val = MAX_QTY;
                                                input.value = val;
                                                updateQtyButtons(val);
                                            }

                                            function updateQtyButtons(val) {
                                                let btnMinus = document.getElementById('btnMinus');
                                                let btnPlus = document.getElementById('btnPlus');
                                                if (btnMinus) btnMinus.disabled = (val <= MIN_QTY);
                                                if (btnPlus) btnPlus.disabled = (val >= MAX_QTY);
                                            }

                                            // Initialize button states
                                            updateQtyButtons(1);

                                            // ============================================================
                                            // 4. THÊM VÀO GIỎ HÀNG - AJAX
                                            // ============================================================
                                            function addToCartAjax() {
                                                let productId = document.getElementById('hiddenProductId').value;
                                                let qty = document.getElementById('qtyInput').value;
                                                let btn = document.getElementById('btnAddCart');

                                                // Disable button during request
                                                btn.disabled = true;
                                                btn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Đang thêm...';

                                                fetch('add_to_cart', {
                                                    method: 'POST',
                                                    headers: {
                                                        'Content-Type': 'application/x-www-form-urlencoded',
                                                        'X-Requested-With': 'XMLHttpRequest'
                                                    },
                                                    body: 'productId=' + productId + '&qty=' + qty
                                                })
                                                    .then(res => res.json())
                                                    .then(data => {
                                                        if (data.success) {
                                                            // Update cart badge in header
                                                            let badges = document.querySelectorAll('.badge');
                                                            badges.forEach(b => {
                                                                if (b.closest('a[href="cart"]')) {
                                                                    b.textContent = data.cartCount;
                                                                }
                                                            });

                                                            // Show success toast
                                                            showToast(data.message, true);
                                                        } else {
                                                            showToast(data.message || 'Có lỗi xảy ra', false);
                                                        }
                                                    })
                                                    .catch(err => {
                                                        console.error('Add to cart error:', err);
                                                        showToast('Có lỗi xảy ra, vui lòng thử lại', false);
                                                    })
                                                    .finally(() => {
                                                        btn.disabled = false;
                                                        btn.innerHTML = '<i class="fas fa-cart-plus"></i> Thêm Vào Giỏ Hàng';
                                                    });
                                            }

                                            // ============================================================
                                            // 5. MUA NGAY
                                            // ============================================================
                                            function buyNow() {
                                                let qty = document.getElementById('qtyInput').value;
                                                document.getElementById('buyNowQty').value = qty;
                                                document.getElementById('buyNowForm').submit();
                                            }

                                            // ============================================================
                                            // 6. TOAST NOTIFICATION
                                            // ============================================================
                                            function showToast(message, isSuccess) {
                                                let toast = document.getElementById('shopeeToast');
                                                let icon = toast.querySelector('.toast-icon i');
                                                let msg = document.getElementById('toastMsg');

                                                msg.textContent = message;

                                                if (isSuccess) {
                                                    icon.className = 'fas fa-check-circle';
                                                    icon.style.color = '#00bfa5';
                                                } else {
                                                    icon.className = 'fas fa-exclamation-circle';
                                                    icon.style.color = '#ee4d2d';
                                                }

                                                toast.classList.add('show');
                                                setTimeout(() => {
                                                    toast.classList.remove('show');
                                                }, 2000);
                                            }

                                            // ============================================================
                                            // 7. FLASH SALE COUNTDOWN TIMER
                                            // ============================================================
                                            (function () {
                                                // Set countdown for 2 hours from now
                                                let totalSeconds = 2 * 3600; // 2 hours
                                                const timerBoxes = document.querySelectorAll('.timer-box');

                                                if (timerBoxes.length >= 3) {
                                                    function updateTimer() {
                                                        if (totalSeconds <= 0) {
                                                            // Flash sale ended
                                                            let banner = document.querySelector('.flash-sale-banner');
                                                            if (banner) {
                                                                let timerDiv = banner.querySelector('.timer');
                                                                if (timerDiv) timerDiv.innerHTML = '<span style="font-size: 14px;">ĐÃ KẾT THÚC</span>';
                                                            }
                                                            return;
                                                        }

                                                        let hrs = Math.floor(totalSeconds / 3600);
                                                        let mins = Math.floor((totalSeconds % 3600) / 60);
                                                        let secs = totalSeconds % 60;

                                                        timerBoxes[0].textContent = String(hrs).padStart(2, '0');
                                                        timerBoxes[1].textContent = String(mins).padStart(2, '0');
                                                        timerBoxes[2].textContent = String(secs).padStart(2, '0');

                                                        totalSeconds--;
                                                    }

                                                    updateTimer(); // Initial display
                                                    setInterval(updateTimer, 1000);
                                                }
                                            })();

                                            // ============================================================
                                            // 8. LIKE (YÊU THÍCH) TOGGLE
                                            // ============================================================
                                            let isLiked = false;
                                            let likeCountNum = 2100; // 2.1k

                                            function toggleLike() {
                                                let icon = document.getElementById('likeIcon');
                                                let countSpan = document.getElementById('likeCount');

                                                isLiked = !isLiked;

                                                if (isLiked) {
                                                    icon.classList.remove('far');
                                                    icon.classList.add('fas');
                                                    likeCountNum++;
                                                } else {
                                                    icon.classList.remove('fas');
                                                    icon.classList.add('far');
                                                    likeCountNum--;
                                                }

                                                // Format number
                                                if (likeCountNum >= 1000) {
                                                    countSpan.textContent = (likeCountNum / 1000).toFixed(1) + 'k';
                                                } else {
                                                    countSpan.textContent = likeCountNum;
                                                }

                                                // Animation
                                                icon.classList.add('liked');
                                                setTimeout(() => icon.classList.remove('liked'), 300);
                                            }

                                            // ============================================================
                                            // 9. REVIEW FILTER
                                            // ============================================================
                                            function filterReview(btn, filterType) {
                                                // 1. Update button styling
                                                document.querySelectorAll('[data-filter]').forEach(b => {
                                                    b.style.borderColor = 'rgba(0,0,0,.09)';
                                                    b.style.color = 'rgba(0,0,0,.87)';
                                                    b.classList.remove('review-filter-active');
                                                });
                                                btn.style.borderColor = '#ee4d2d';
                                                btn.style.color = '#ee4d2d';
                                                btn.classList.add('review-filter-active');

                                                // 2. Filter review items
                                                let items = document.querySelectorAll('.review-item');
                                                let visibleCount = 0;

                                                items.forEach(item => {
                                                    let show = false;
                                                    let rating = item.getAttribute('data-rating');
                                                    let hasComment = item.getAttribute('data-has-comment') === 'true';
                                                    let hasMedia = item.getAttribute('data-has-media') === 'true';

                                                    switch (filterType) {
                                                        case 'all':
                                                            show = true;
                                                            break;
                                                        case '5': case '4': case '3': case '2': case '1':
                                                            show = (rating === filterType);
                                                            break;
                                                        case 'comment':
                                                            show = hasComment;
                                                            break;
                                                        case 'media':
                                                            show = hasMedia;
                                                            break;
                                                    }

                                                    item.style.display = show ? 'flex' : 'none';
                                                    if (show) visibleCount++;
                                                });

                                                // 3. Show/hide empty state
                                                let emptyDiv = document.getElementById('reviewFilterEmpty');
                                                if (emptyDiv) {
                                                    emptyDiv.style.display = (visibleCount === 0 && items.length > 0) ? 'block' : 'none';
                                                }
                                            }
                                        </script>
                    </body>

                    </html>