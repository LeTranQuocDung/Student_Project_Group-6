<%@page import="java.util.List"%>
<%@page import="model.Product"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Chi tiết sản phẩm | Shopee Việt Nam</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
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
                box-shadow: 0 1px 1px 0 rgba(0,0,0,.05);
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
            .gallery-item:hover, .gallery-item.active {
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

            /* Giá tiền */
            .price-section {
                background: #fafafa;
                padding: 15px 20px;
                display: flex;
                align-items: center;
                gap: 15px;
                margin-bottom: 25px;
            }
            .old-price {
                text-decoration: line-through;
                color: #929292;
                font-size: 16px;
            }
            .current-price {
                color: #ee4d2d;
                font-size: 30px;
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
                border: 1px solid rgba(0,0,0,.09);
                padding: 8px 30px;
                cursor: pointer;
                min-width: 80px;
                color: rgba(0,0,0,.8);
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
                border: 1px solid rgba(0,0,0,.09);
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
                border-right: 1px solid rgba(0,0,0,.09);
                display: flex;
                align-items: center;
                justify-content: center;
            }
            .qty-btn:last-child {
                border-right: none;
                border-left: 1px solid rgba(0,0,0,.09);
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
                background: rgba(255,87,34,.1);
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
                background: rgba(255,87,34,.15);
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
                box-shadow: 0 1px 1px 0 rgba(0,0,0,.05);
            }
            .section-header {
                background: #f5f5f5;
                padding: 14px;
                color: rgba(0,0,0,.87);
                font-size: 18px;
                text-transform: uppercase;
                margin-bottom: 20px;
            }
            .product-desc-content {
                font-size: 14px;
                line-height: 1.7;
                color: rgba(0,0,0,.8);
                white-space: pre-wrap;
                overflow: hidden;
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

                <a href="home" class="ms-auto text-white text-decoration-none small">
                    <i class="fas fa-home"></i> Trở về trang chủ
                </a>
            </div>
        </div>

        <%
            Product p = (Product) request.getAttribute("detail");
            List<String> listImg = (List<String>) request.getAttribute("listImg");

            if (p != null) {
                double oldPrice = p.getPrice() * 1.35; // Giả lập giá cũ cao hơn giá bán
        %>

        <div class="container">
            <div class="shopee-breadcrumb">
                <a href="home">Shopee</a> <span>&gt;</span>
                <a href="#">Thiết Bị Điện Tử</a> <span>&gt;</span>
                <span class="current"><%= p.getName()%></span>
            </div>

            <div class="product-wrapper">
                <div class="col-left">
                    <div class="main-image-frame">
                        <img id="mainImg" src="<%= p.getImage()%>" class="main-image" alt="Product Image">
                    </div>
                    <div class="gallery-list">
                        <div class="gallery-item active" onmouseover="changeImg(this)">
                            <img src="<%= p.getImage()%>">
                        </div>
                        <% if (listImg != null) {
                                for (String img : listImg) {%>
                        <div class="gallery-item" onmouseover="changeImg(this)">
                            <img src="<%= img%>">
                        </div>
                        <% }
                            }%>
                    </div>

                    <div class="share-like">
                        <div>Chia sẻ: <i class="fab fa-facebook-messenger" style="color:#0384ff"></i> <i class="fab fa-facebook" style="color:#3b5999"></i> <i class="fab fa-pinterest" style="color:#de0217"></i> <i class="fab fa-twitter" style="color:#10c2ff"></i></div>
                        <div style="width: 1px; height: 20px; background: #dbdbdb;"></div>
                        <div><i class="far fa-heart like-heart"></i> Đã thích (2,1k)</div>
                    </div>
                </div>

                <div class="col-right">
                    <h1 class="product-title">
                        <span class="badge bg-danger align-middle me-1" style="font-size: 12px;">Yêu Thích</span>
                        <%= p.getName()%>
                    </h1>

                    <div class="rating-sold-row">
                        <span class="rating-text">4.9</span>
                        <span class="rating-star"><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i></span>
                        <span class="separator">|</span>
                        <span class="sold-num">1.2k</span>
                        <span class="sold-text">Đánh Giá</span>
                        <span class="separator">|</span>
                        <span class="sold-num">5.6k</span>
                        <span class="sold-text">Đã Bán</span>
                    </div>

                    <div class="price-section">
                        <span class="old-price">₫<%= String.format("%,.0f", oldPrice)%></span>
                        <span class="current-price">₫<%= String.format("%,.0f", p.getPrice())%></span>
                        <span class="discount-tag">GIẢM 35%</span>
                    </div>

                    <div class="option-row" style="margin-bottom: 15px;">
                        <span class="option-label">Vận Chuyển</span>
                        <div style="font-size: 14px;">
                            <div style="margin-bottom: 5px;"><i class="fas fa-truck-free text-success"></i> <span class="text-secondary">Miễn phí vận chuyển</span></div>
                            <div class="text-secondary"><i class="fas fa-truck"></i> Vận chuyển tới: <strong>Hà Nội</strong> <i class="fas fa-chevron-down small"></i></div>
                        </div>
                    </div>

                    <div class="option-row">
                        <span class="option-label">Màu Sắc</span>
                        <div class="option-items">
                            <button class="option-btn" onclick="selectOpt(this)">Đen Nhám</button>
                            <button class="option-btn" onclick="selectOpt(this)">Trắng Ngọc</button>
                            <button class="option-btn" onclick="selectOpt(this)">Xanh Titan</button>
                        </div>
                    </div>

                    <div class="option-row">
                        <span class="option-label">Phiên Bản</span>
                        <div class="option-items">
                            <button class="option-btn" onclick="selectOpt(this)">128GB</button>
                            <button class="option-btn" onclick="selectOpt(this)">256GB</button>
                            <button class="option-btn" onclick="selectOpt(this)">512GB</button>
                        </div>
                    </div>

                    <div class="option-row" style="align-items: center;">
                        <span class="option-label">Số Lượng</span>
                        <div class="qty-input-group">
                            <button class="qty-btn" onclick="updateQty(-1)">-</button>
                            <input type="text" value="1" class="qty-value" id="qty">
                            <button class="qty-btn" onclick="updateQty(1)">+</button>
                        </div>
                        <span class="text-secondary ms-3 small">4532 sản phẩm có sẵn</span>
                    </div>

                    <div class="action-group">
                        <button class="btn btn-add-cart" onclick="alert('Đã thêm vào giỏ hàng!')">
                            <i class="fas fa-cart-plus"></i> Thêm Vào Giỏ Hàng
                        </button>
                        <button class="btn btn-buy-now">Mua Ngay</button>
                    </div>

                    <div class="mt-4 pt-3 border-top small text-secondary">
                        <span class="me-4"><i class="fas fa-undo-alt text-danger me-1"></i> Đổi trả miễn phí 15 ngày</span>
                        <span><i class="fas fa-shield-alt text-danger me-1"></i> Hàng chính hãng 100%</span>
                    </div>
                </div>
            </div>

            <div class="section-box">
                <div class="section-header" style="background: #fafafa; padding: 10px 15px; margin: -25px -25px 20px -25px; border-bottom: 1px solid rgba(0,0,0,.05);">MÔ TẢ SẢN PHẨM</div>
                <div class="product-desc-content">
                    <%= p.getDescription() != null ? p.getDescription() : "Đang cập nhật..."%>

                    <br><br>
                    ------------------------------------------------<br>
                    🔰 CAM KẾT CỦA SHOP:<br>
                    - Hàng chính hãng 100%<br>
                    - Bảo hành 12 tháng tại trung tâm ủy quyền<br>
                    - Hoàn tiền 200% nếu phát hiện hàng giả<br>
                    - Giao hàng hỏa tốc trong 2h tại nội thành
                </div>
            </div>
        </div>

        <% } else { %>
        <div class="container text-center py-5">
            <h3>Sản phẩm không tồn tại!</h3>
            <a href="home" class="btn btn-primary mt-3">Quay lại trang chủ</a>
        </div>
        <% }%>

        <div class="shopee-footer" style="border-top: 4px solid #ee4d2d; background: #fff; padding: 40px 0; margin-top: 50px; font-size: 14px; color: rgba(0,0,0,.65);">
            <div class="container text-center">
                <p>© 2026 Shopee. Tất cả các quyền được bảo lưu.</p>
            </div>
        </div>

        <script>
            // 1. Hover đổi ảnh
            function changeImg(el) {
                document.getElementById('mainImg').src = el.querySelector('img').src;
                document.querySelectorAll('.gallery-item').forEach(i => i.classList.remove('active'));
                el.classList.add('active');
            }

            // 2. Chọn Option (Màu/Size)
            function selectOpt(btn) {
                let siblings = btn.parentElement.children;
                for (let s of siblings)
                    s.classList.remove('selected');
                btn.classList.add('selected');
            }

            // 3. Tăng giảm số lượng (SỬA LẠI ĐOẠN NÀY CHO KHỚP ID)
            function updateQty(n) {
                // Lưu ý: ID ở đây phải là 'qtyInput' trùng với id trong thẻ <input> ở trên
                let input = document.getElementById('qtyInput');
                let val = parseInt(input.value) + n;
                if (val >= 1)
                    input.value = val;
            }
        </script>
    </body>
</html>