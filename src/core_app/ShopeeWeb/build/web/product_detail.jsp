<%@page import="java.util.List"%>
<%@page import="model.Product"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Chi tiết sản phẩm | Shopee Fake</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <link href="css/home.css" rel="stylesheet"> <style>
            /* CSS RIÊNG CHO TRANG DETAIL */
            body {
                background-color: #f5f5f5;
            }
            .product-container {
                background: #fff;
                padding: 20px;
                border-radius: 3px;
                box-shadow: 0 1px 1px 0 rgba(0,0,0,.05);
                margin-top: 20px;
            }

            /* CỘT ẢNH */
            .main-image {
                width: 100%;
                object-fit: cover;
                border: 1px solid #f2f2f2;
                cursor: pointer;
            }
            .sub-img-list {
                display: flex;
                gap: 10px;
                margin-top: 10px;
                overflow-x: auto;
            }
            .sub-img {
                width: 80px;
                height: 80px;
                object-fit: cover;
                border: 2px solid transparent;
                cursor: pointer;
            }
            .sub-img:hover, .sub-img.active {
                border-color: #ee4d2d;
            }

            /* CỘT THÔNG TIN */
            .product-title {
                font-size: 20px;
                font-weight: 500;
                line-height: 24px;
                color: #222;
                margin-bottom: 10px;
            }
            .rating-row {
                color: #ee4d2d;
                font-size: 14px;
                margin-bottom: 15px;
                border-bottom: 1px solid #f2f2f2;
                padding-bottom: 15px;
                display: flex;
                gap: 20px;
            }
            .rating-row span {
                color: #222;
                margin-left: 5px;
            }

            .price-section {
                background: #fafafa;
                padding: 15px;
                margin-bottom: 25px;
            }
            .price-original {
                text-decoration: line-through;
                color: #929292;
                font-size: 16px;
                margin-right: 10px;
            }
            .price-current {
                color: #ee4d2d;
                font-size: 30px;
                font-weight: 500;
            }
            .discount-badge {
                font-size: 12px;
                background: #ee4d2d;
                color: #fff;
                padding: 2px 4px;
                border-radius: 2px;
                font-weight: bold;
            }

            /* CHỌN MÀU/SIZE */
            .option-group {
                display: flex;
                align-items: center;
                margin-bottom: 25px;
            }
            .option-label {
                color: #757575;
                width: 110px;
                font-size: 14px;
            }
            .option-btn {
                border: 1px solid rgba(0,0,0,.09);
                background: #fff;
                padding: 8px 25px;
                margin-right: 10px;
                cursor: pointer;
                min-width: 80px;
            }
            .option-btn:hover {
                border-color: #ee4d2d;
                color: #ee4d2d;
            }
            .option-btn.selected {
                border-color: #ee4d2d;
                color: #ee4d2d;
                position: relative;
            }
            .option-btn.selected::after {
                content: '✓';
                position: absolute;
                bottom: 0;
                right: 0;
                background: #ee4d2d;
                color: #fff;
                font-size: 10px;
                padding: 0 4px;
            }

            /* SỐ LƯỢNG */
            .quantity-input {
                width: 50px;
                text-align: center;
                border: 1px solid rgba(0,0,0,.09);
                height: 32px;
                border-left: none;
                border-right: none;
            }
            .quantity-btn {
                width: 32px;
                height: 32px;
                border: 1px solid rgba(0,0,0,.09);
                background: #fff;
                cursor: pointer;
            }

            /* NÚT MUA */
            .action-btns {
                margin-top: 30px;
                display: flex;
                gap: 15px;
            }
            .btn-add-cart {
                background: rgba(255,87,34,.1);
                border: 1px solid #ee4d2d;
                color: #ee4d2d;
                height: 48px;
                padding: 0 20px;
                display: flex;
                align-items: center;
                gap: 10px;
            }
            .btn-add-cart:hover {
                background: rgba(255,87,34,.15);
            }
            .btn-buy-now {
                background: #ee4d2d;
                color: #fff;
                border: none;
                height: 48px;
                padding: 0 40px;
            }
            .btn-buy-now:hover {
                background: #d73211;
            }
        </style>
    </head>
    <body>

        <div style="background: #ee4d2d; padding: 10px;">
            <div class="container">
                <a href="home" class="text-white text-decoration-none"><i class="fas fa-arrow-left"></i> Quay lại trang chủ</a>
            </div>
        </div>

        <%
            Product p = (Product) request.getAttribute("detail");
            List<String> images = (List<String>) request.getAttribute("images");
            if (p != null) {
        %>
        <div class="container product-container">
            <div class="row">

                <div class="col-md-5">
                    <img id="mainImg" src="<%= p.getImage()%>" class="main-image">
                    <div class="sub-img-list">
                        <img src="<%= p.getImage()%>" class="sub-img active" onclick="changeImage(this)">
                        <% if (images != null)
                            for (String img : images) {%>
                        <img src="<%= img%>" class="sub-img" onclick="changeImage(this)">
                        <% }%>
                    </div>
                </div>

                <div class="col-md-7 ps-md-4">
                    <h1 class="product-title">[Mã giảm 50k] <%= p.getName()%> - Hàng chính hãng</h1>

                    <div class="rating-row">
                        <div>4.9 <i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i></div>
                        <div style="border-left: 1px solid #dbdbdb; padding-left: 20px;">1.2k <span>Đánh giá</span></div>
                        <div style="border-left: 1px solid #dbdbdb; padding-left: 20px;">5.6k <span>Đã bán</span></div>
                    </div>

                    <div class="price-section">
                        <span class="price-original">₫<%= String.format("%,.0f", p.getPrice() * 1.5)%></span>
                        <span class="price-current">₫<%= String.format("%,.0f", p.getPrice())%></span>
                        <span class="discount-badge">GIẢM 35%</span>
                    </div>

                    <div class="option-group">
                        <span class="option-label">Màu Sắc</span>
                        <button class="option-btn" onclick="selectOption(this, 'color')">Đen Nhám</button>
                        <button class="option-btn" onclick="selectOption(this, 'color')">Trắng Ngọc</button>
                        <button class="option-btn" onclick="selectOption(this, 'color')">Xanh Titan</button>
                    </div>

                    <div class="option-group">
                        <span class="option-label">Dung Lượng</span>
                        <button class="option-btn" onclick="selectOption(this, 'size')">128GB</button>
                        <button class="option-btn" onclick="selectOption(this, 'size')">256GB</button>
                        <button class="option-btn" onclick="selectOption(this, 'size')">512GB</button>
                    </div>

                    <div class="option-group">
                        <span class="option-label">Số Lượng</span>
                        <div class="d-flex">
                            <button class="quantity-btn" onclick="updateQty(-1)">-</button>
                            <input id="qtyInput" class="quantity-input" value="1">
                            <button class="quantity-btn" onclick="updateQty(1)">+</button>
                        </div>
                        <span class="ms-3 text-secondary small">1200 sản phẩm có sẵn</span>
                    </div>

                    <div class="action-btns">
                        <button class="btn btn-add-cart" onclick="addToCart()">
                            <i class="fas fa-cart-plus"></i> Thêm Vào Giỏ Hàng
                        </button>
                        <button class="btn btn-buy-now">Mua Ngay</button>
                    </div>
                </div>
            </div>

            <div class="row mt-4">
                <div class="col-12">
                    <div style="background: #fafafa; padding: 15px; font-weight: 500; font-size: 18px;">MÔ TẢ SẢN PHẨM</div>
                    <div class="p-3" style="white-space: pre-line; font-size: 14px; line-height: 1.8;">
                        <%= p.getDescription()%>

                        ✅ Cam kết hàng chính hãng 100%
                        ✅ Bảo hành 12 tháng tại trung tâm ủy quyền
                        ✅ Đổi trả trong vòng 7 ngày nếu lỗi nhà sản xuất
                    </div>
                </div>
            </div>
        </div>
        <% } else { %>
        <div class="container text-center py-5">
            <h3>Sản phẩm không tồn tại!</h3>
            <a href="home">Về trang chủ</a>
        </div>
        <% }%>

        <script>
            // 1. Script đổi ảnh Gallery
            function changeImage(element) {
                document.getElementById('mainImg').src = element.src;
                // Xóa class active cũ
                document.querySelectorAll('.sub-img').forEach(el => el.classList.remove('active'));
                // Thêm active cho ảnh đang chọn
                element.classList.add('active');
            }

            // 2. Script chọn Màu/Size
            function selectOption(btn, type) {
                // Tìm các nút cùng dòng (anh em)
                let siblings = btn.parentElement.querySelectorAll('.option-btn');
                siblings.forEach(el => el.classList.remove('selected'));
                btn.classList.add('selected');
            }

            // 3. Script tăng giảm số lượng
            function updateQty(change) {
                let input = document.getElementById('qtyInput');
                let newVal = parseInt(input.value) + change;
                if (newVal >= 1)
                    input.value = newVal;
            }

            // 4. Script Thêm giỏ hàng (Fake alert)
            function addToCart() {
                alert('Đã thêm sản phẩm vào giỏ hàng thành công!');
                // Sau này ông sẽ gọi CartServlet ở đây
            }
        </script>

    </body>
</html>