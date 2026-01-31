<%@page import="model.Admin"%>
<%@page import="model.User"%>
<%@page import="java.text.NumberFormat"%>
<%@page import="java.util.Locale"%>
<%@page import="java.util.List"%>
<%@page import="model.ProductDTO"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Shopee Fake - Demo Migration</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        <style>
            body { background-color: #f5f5f5; font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif; }

            /* HEADER MÀU CAM SHOPEE */
            .shopee-header {
                background: linear-gradient(-180deg,#f53d2d,#f63);
                color: white; padding: 10px 0; margin-bottom: 20px;
            }

            /* CARD SẢN PHẨM */
            .product-card {
                background: white; border: 1px solid transparent; transition: transform 0.1s;
                cursor: pointer; position: relative; margin-bottom: 10px; height: 100%;
            }
            .product-card:hover {
                transform: translateY(-1px); border: 1px solid #ee4d2d; z-index: 1;
                box-shadow: 0 2px 4px rgba(0,0,0,.1);
            }
            .p-img { width: 100%; aspect-ratio: 1/1; object-fit: cover; background: #fafafa; }
            .p-body { padding: 8px; }
            .p-name { 
                font-size: 12px; color: #333; line-height: 14px; height: 28px; 
                overflow: hidden; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical;
                margin-bottom: 5px;
            }
            .p-price { color: #ee4d2d; font-size: 16px; font-weight: bold; }
            .currency { font-size: 10px; vertical-align: top; text-decoration: underline; }
            .p-shop { font-size: 10px; color: #888; margin-top: 10px; text-align: right; }
            .mall-badge { background: #d0011b; color: white; padding: 1px 3px; font-size: 9px; border-radius: 2px; margin-right: 4px; font-weight: bold; }

            /* Link style cho giỏ hàng */
            .cart-icon-link { color: white; text-decoration: none; position: relative; font-size: 24px;}
            .cart-icon-link:hover { color: #f0f0f0; }
            .cart-badge {
                position: absolute; top: -5px; right: -10px;
                background: white; color: #ee4d2d;
                font-size: 10px; padding: 2px 6px; border-radius: 10px; border: 1px solid #ee4d2d;
            }
        </style>
    </head>
    <body>

        <div class="shopee-header sticky-top">
            <div class="container">
                <div class="row align-items-center">
                    <div class="col-md-3">
                        <a href="home" class="text-white text-decoration-none">
                            <h3 class="fw-bold m-0"><i class="fas fa-shopping-bag"></i> Shopee Fake</h3>
                        </a>
                    </div>

                    <div class="col-md-6">
                        <form action="home" method="get">
                            <div class="input-group">
                                <input type="text" name="txt" class="form-control border-0" 
                                       placeholder="Tìm kiếm trong 12.000 sản phẩm..."
                                       value="<%= request.getAttribute("txtS") != null ? request.getAttribute("txtS") : ""%>">
                                <button type="submit" class="btn btn-light text-danger"><i class="fas fa-search"></i></button>
                            </div>
                        </form>
                    </div>

                    <div class="col-md-3 d-flex align-items-center justify-content-end gap-3">
                        
                        <a href="#" class="cart-icon-link" onclick="alert('Chức năng Giỏ hàng đang phát triển!')">
                            <i class="fas fa-shopping-cart"></i>
                            <span class="cart-badge">99+</span> 
                        </a>

                        <% 
                            // Lấy user từ session (Key là "account" như đã lưu trong Servlet)
                            User acc = (User) session.getAttribute("account");
                            
                            if (acc == null) { 
                        %>
                            <a href="login" class="text-white text-decoration-none fw-bold small">Đăng nhập</a>
                        <% } else { %>
                            <div class="dropdown">
                                <button class="btn btn-sm btn-outline-light dropdown-toggle border-0" type="button" data-bs-toggle="dropdown">
                                    Hi, <%= acc.getFullName() %>
                                </button>
                                <ul class="dropdown-menu dropdown-menu-end">
                                    <% 
                                        // KIỂM TRA: Nếu là Admin mới hiện nút Thêm
                                        if (acc instanceof Admin) { 
                                    %>
                                        <li><a class="dropdown-item fw-bold text-danger" href="#" data-bs-toggle="modal" data-bs-target="#addModal">
                                            <i class="fas fa-plus"></i> Thêm Sản Phẩm
                                        </a></li>
                                        <li><hr class="dropdown-divider"></li>
                                    <% } %>
                                    <li><a class="dropdown-item" href="logout">Đăng xuất</a></li>
                                </ul>
                            </div>
                        <% } %>

                    </div>
                </div>

                <div class="row mt-2" style="font-size: 12px;">
                    <div class="col text-white opacity-75">Gợi ý: Áo thun, Dép nam, iPhone 15 Pro Max, Váy xinh, Giày Sneaker...</div>
                </div>
            </div>
        </div>

        <div class="container pb-5">
            <div class="row mb-3">
                <div class="col-12">
                    <div class="bg-white p-3 rounded shadow-sm d-flex justify-content-between align-items-center">
                        <h6 class="text-danger fw-bold m-0">🔥 GỢI Ý HÔM NAY</h6>
                        <% if (request.getAttribute("txtS") != null && !request.getAttribute("txtS").toString().isEmpty()) {%>
                        <span class="text-muted small">Kết quả tìm kiếm cho: "<b><%= request.getAttribute("txtS")%></b>"</span>
                        <% } %>
                    </div>
                </div>
            </div>

            <div class="row g-2">
                <%
                    List<ProductDTO> products = (List<ProductDTO>) request.getAttribute("products");
                    NumberFormat formatter = NumberFormat.getInstance(new Locale("vi", "VN"));

                    if (products != null && !products.isEmpty()) {
                        for (ProductDTO p : products) {
                %>
                <div class="col-6 col-md-4 col-lg-2">
                    <div class="product-card position-relative">
                        
                        <% if (acc != null && acc instanceof Admin) { %>
                            <a href="product-manage?action=delete&id=<%= p.getId() %>" 
                               class="btn btn-danger btn-sm position-absolute top-0 end-0 m-1 rounded-circle" 
                               style="z-index: 10; width: 24px; height: 24px; line-height: 12px; padding: 0; font-size: 12px;" 
                               onclick="return confirm('Bạn chắc chắn muốn xóa sản phẩm <%= p.getName() %>?')"
                               title="Xóa sản phẩm">X</a>
                        <% } %>

                        <img src="<%= p.getImage()%>" class="p-img" alt="<%= p.getName()%>">
                        <div class="p-body">
                            <div class="p-name">
                                <span class="mall-badge">Mall</span><%= p.getName()%>
                            </div>
                            <div class="d-flex justify-content-between align-items-end">
                                <div class="p-price">
                                    <span class="currency">₫</span><%= formatter.format(p.getMinPrice())%>
                                </div>
                                <div class="p-shop">
                                    <i class="fas fa-store-alt"></i> <%= p.getShopName()%>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <%
                    }
                } else {
                %>
                <div class="col-12 text-center py-5">
                    <h3 class="text-muted">Không tìm thấy sản phẩm nào!</h3>
                    <p>Thử tìm từ khóa khác xem sao...</p>
                    <a href="home" class="btn btn-primary">Về trang chủ</a>
                </div>
                <% }%>
            </div>

            <div class="text-center mt-4">
                <button class="btn btn-outline-secondary px-5" onclick="alert('Đã load hết sản phẩm!')">
                    Xem thêm
                </button>
            </div>
        </div>

        <div class="modal fade" id="addModal" tabindex="-1">
            <div class="modal-dialog">
                <form action="product-manage" method="post" class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title fw-bold">Thêm Sản Phẩm Mới</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <div class="mb-3">
                            <label class="form-label">Tên sản phẩm</label>
                            <input type="text" name="name" class="form-control" required placeholder="Nhập tên sản phẩm...">
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Mô tả</label>
                            <textarea name="desc" class="form-control" rows="3" placeholder="Mô tả chi tiết..."></textarea>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Giá bán dự kiến (VNĐ)</label>
                             <input type="number" class="form-control" placeholder="100000">
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                        <button type="submit" class="btn btn-danger">Lưu sản phẩm</button>
                    </div>
                </form>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>