<%@page import="model.Cart"%>
<%@page import="model.CartItem"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Giỏ Hàng | Shopee Clone</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <link href="css/home.css" rel="stylesheet">

        <style>
            /* CSS riêng cho Cart một chút */
            body {
                background: #f5f5f5;
            }
            .cart-header {
                background: #fff;
                border-bottom: 1px solid rgba(0,0,0,.09);
                height: 100px;
                display: flex;
                align-items: center;
            }
            .cart-logo {
                color: #ee4d2d;
                font-size: 24px;
                text-decoration: none;
                display: flex;
                align-items: center;
                gap: 15px;
            }
            .cart-logo:hover {
                color: #ee4d2d;
            }
            .page-title {
                color: #222;
                font-size: 20px;
                border-left: 1px solid #ee4d2d;
                padding-left: 15px;
                margin-left: 15px;
                line-height: 28px;
            }
            .cart-section {
                background: #fff;
                box-shadow: 0 1px 1px 0 rgba(0,0,0,.05);
                border-radius: 3px;
                margin-bottom: 20px;
            }
            .btn-checkout {
                background: #ee4d2d;
                color: #fff;
                border: none;
                width: 200px;
                height: 40px;
                border-radius: 2px;
            }
            .btn-checkout:hover {
                background: #d73211;
            }
            .item-link {
                text-decoration: none;
                color: rgba(0,0,0,.87);
            }
            .item-link:hover {
                color: #ee4d2d;
            }
        </style>
    </head>
    <body>

        <div class="cart-header">
            <div class="container d-flex justify-content-between align-items-center">
                <a href="home" class="cart-logo">
                    <i class="fas fa-shopping-bag" style="font-size: 30px;"></i> 
                    <span style="font-weight: bold;">Shopee</span>
                    <span class="page-title">Giỏ Hàng</span>
                </a>
                <div class="input-group" style="width: 400px;">
                    <input type="text" class="form-control border-danger" placeholder="Tìm kiếm sản phẩm...">
                    <button class="btn btn-danger"><i class="fas fa-search"></i></button>
                </div>
            </div>
        </div>

        <div class="container mt-4 mb-5">
            <%
                // Lấy giỏ hàng từ Session
                Cart cart = (Cart) session.getAttribute("cart");

                // Kiểm tra giỏ hàng trống
                if (cart == null || cart.getItems().isEmpty()) {
            %>
            <div class="text-center py-5 bg-white shadow-sm" style="min-height: 300px;">
                <img src="https://deo.shopeemobile.com/shopee/shopee-pcmall-live-sg/cart/9bdd8040b334d31946f49e36beaf32db.png" width="100" class="mt-4">
                <p class="text-muted fw-bold mt-3">Giỏ hàng của bạn còn trống</p>
                <a href="home" class="btn btn-danger px-5 text-uppercase">Mua Ngay</a>
            </div>
            <% } else { %>

            <div class="cart-section py-3 px-4">
                <div class="row text-secondary small text-center">
                    <div class="col-5 text-start">Sản Phẩm</div>
                    <div class="col-2">Đơn Giá</div>
                    <div class="col-2">Số Lượng</div>
                    <div class="col-2">Số Tiền</div>
                    <div class="col-1">Thao Tác</div>
                </div>
            </div>

            <div class="cart-section px-4 pb-1">
                <% for (CartItem i : cart.getItems()) {%>
                <div class="row align-items-center border-bottom py-4 text-center">
                    <div class="col-5 text-start d-flex gap-3 align-items-center">
                        <a href="product_detail?id=<%= i.getProduct().getId()%>">
                            <img src="<%= i.getProduct().getImage()%>" width="80" height="80" style="object-fit: cover; border: 1px solid #e8e8e8;">
                        </a>
                        <div style="overflow: hidden;">
                            <a href="product_detail?id=<%= i.getProduct().getId()%>" class="item-link">
                                <div style="white-space: nowrap; overflow: hidden; text-overflow: ellipsis; max-width: 300px;">
                                    <%= i.getProduct().getName()%>
                                </div>
                            </a>
                            <div class="text-success small mt-1"><i class="fas fa-truck-free"></i> Miễn phí vận chuyển</div>
                            <img src="https://down-vn.img.susercontent.com/file/vn-50009109-c7a2e1ae720f9704f92f72c9ef1a494a" height="15" class="mt-1">
                        </div>
                    </div>

                    <div class="col-2">
                        <span class="text-secondary text-decoration-line-through small">₫<%= String.format("%,.0f", i.getPrice() * 1.2)%></span><br>
                        <span>₫<%= String.format("%,.0f", i.getPrice())%></span>
                    </div>

                    <div class="col-2 d-flex justify-content-center">
                        <input type="text" value="<%= i.getQuantity()%>" class="form-control text-center" style="width: 50px; height: 30px; font-size: 14px;" readonly>
                    </div>

                    <div class="col-2 text-danger fw-bold">
                        ₫<%= String.format("%,.0f", i.getTotalPrice())%>
                    </div>

                    <div class="col-1">
                        <a href="cart?action=delete&id=<%= i.getProduct().getId()%>" class="text-dark small text-decoration-none hover-red">Xóa</a>
                    </div>
                </div>
                <% }%>
            </div>

            <div class="cart-section p-4 sticky-bottom d-flex align-items-center justify-content-end gap-5" style="bottom: 0; border-top: 1px dotted rgba(0,0,0,.09);">
                <div class="d-flex align-items-center gap-2">
                    <input type="checkbox" class="form-check-input" checked> 
                    <span class="small">Chọn tất cả (<%= cart.getItems().size()%>)</span>
                </div>

                <div class="d-flex align-items-center gap-3">
                    <div>Tổng thanh toán (<%= cart.getTotalQuantity()%> sản phẩm):</div> 
                    <div class="text-danger fs-3 fw-bold">₫<%= String.format("%,.0f", cart.getTotalMoney())%></div>
                </div>

                <form action="checkout" method="post" class="d-inline">
                    <button type="submit" class="btn-checkout text-uppercase fw-bold">Mua Hàng</button>
                </form>
            </div>

            <% }%>
        </div>

        <div class="text-center py-4 border-top text-secondary small">
            <p>© 2026 Shopee Clone. Design by You.</p>
        </div>

        <style>.hover-red:hover {
            color: #ee4d2d !important;
            cursor: pointer;
        }</style>
    </body>
</html>