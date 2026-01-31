<%@page import="model.ProductDTO"%>
<%@page import="model.Admin"%>
<%@page import="model.User"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Shopee Việt Nam | Mua và Bán Trên Ứng Dụng Di Động Hoặc Website</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <style>
        /* 1. CẤU HÌNH CHUNG */
        body { background-color: #f5f5f5; font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif; color: rgba(0,0,0,.87); margin: 0; padding: 0; }
        a { text-decoration: none; color: inherit; }
        ul { list-style: none; padding: 0; margin: 0; }

        /* 2. HEADER */
        .shopee-top-nav { background: #ee4d2d; color: #fff; font-size: 13px; padding: 5px 0; }
        .shopee-top-nav a { color: #fff; margin: 0 10px; text-decoration: none; }
        .shopee-top-nav a:hover { opacity: 0.8; }

        .shopee-header-main { background: linear-gradient(-180deg,#f53d2d,#f63); padding: 15px 0 10px; position: sticky; top: 0; z-index: 100; }
        .shopee-logo { color: #fff; font-size: 28px; display: flex; align-items: center; gap: 10px; text-decoration: none; }
        .shopee-logo i { font-size: 38px; }

        .shopee-search-bar { background: #fff; border-radius: 2px; padding: 3px; display: flex; width: 100%; box-shadow: 0 0.125rem 0.25rem rgba(0,0,0,.09); }
        .shopee-search-input { border: none; flex: 1; padding: 0 10px; outline: none; }
        .shopee-search-btn { background: #fb5533; border: none; color: #fff; width: 60px; border-radius: 2px; }
        .shopee-search-btn:hover { background: #ec4625; }

        .shopee-cart-icon { color: #fff; font-size: 26px; margin-top: 5px; cursor: pointer; position: relative; margin-left: 20px;}
        .cart-badge { position: absolute; top: -5px; right: -8px; background: #fff; color: #ee4d2d; border-radius: 40px; padding: 0 6px; font-size: 12px; border: 1px solid #ee4d2d; }

        /* 3. SIDEBAR DANH MỤC */
        .category-sidebar { background: #fff; border-radius: 2px; margin-top: 20px; }
        .category-header { font-weight: 700; padding: 15px; border-bottom: 1px solid rgba(0,0,0,.05); display: flex; align-items: center; gap: 10px; font-size: 16px; color: rgba(0,0,0,.8); }
        .category-list li { padding: 10px 15px; font-size: 14px; cursor: pointer; transition: 0.1s; display: block; color: rgba(0,0,0,.87); }
        .category-list li:hover { color: #ee4d2d; font-weight: 500; background: #fafafa; }
        .active-cate { color: #ee4d2d !important; font-weight: bold; }

        /* 4. BANNER & CARD */
        .shopee-banner { border-radius: 3px; overflow: hidden; margin-top: 20px; margin-bottom: 20px; box-shadow: 0 1px 1px 0 rgba(0,0,0,.05); }

        .shopee-card { 
            background: #fff; border: 1px solid transparent; border-radius: 2px; 
            transition: transform .1s, box-shadow .1s; position: relative; height: 100%;
            display: flex; flex-direction: column; text-decoration: none;
        }
        .shopee-card:hover { transform: translateY(-1px); box-shadow: 0 1px 20px 0 rgba(0,0,0,.05); border-color: #ee4d2d; z-index: 2; }
        .card-img-top { width: 100%; aspect-ratio: 1/1; object-fit: cover; }
        .card-body { padding: 8px; display: flex; flex-direction: column; justify-content: space-between; flex: 1; }
        .card-title { font-size: 12px; line-height: 14px; height: 28px; overflow: hidden; display: -webkit-box; -webkit-box-orient: vertical; -webkit-line-clamp: 2; margin-bottom: 5px; color: #222; }
        .card-price { color: #ee4d2d; font-size: 16px; }
        .sold-count { font-size: 10px; color: rgba(0,0,0,.54); }

        /* BADGES */
        .badge-mall { position: absolute; top: 0; left: 0; background: #d0011b; color: #fff; font-size: 10px; padding: 0 4px; border-bottom-right-radius: 3px; font-weight: 500; }
        .badge-sale { position: absolute; top: 0; right: 0; background: rgba(255,212,36,.9); width: 36px; height: 32px; text-align: center; font-size: 10px; padding-top: 2px; }
        .sale-percent { color: #ee4d2d; font-weight: 700; display: block; }
        .sale-text { color: #fff; text-transform: uppercase; font-weight: 700; }

        /* 5. FOOTER */
        .shopee-footer { border-top: 4px solid #ee4d2d; background: #fff; padding: 40px 0; margin-top: 50px; font-size: 14px; color: rgba(0,0,0,.65); }
    </style>
</head>
<body>

    <header>
        <div class="shopee-top-nav d-none d-md-block">
            <div class="container d-flex justify-content-between">
                <div>
                    <a href="#">Kênh Người Bán</a> <span class="mx-1">|</span>
                    <a href="#">Tải ứng dụng</a> <span class="mx-1">|</span>
                    <a href="#">Kết nối <i class="fab fa-facebook"></i></a>
                </div>
                <div>
                    <a href="#"><i class="far fa-bell"></i> Thông báo</a>
                    <a href="#"><i class="far fa-question-circle"></i> Hỗ trợ</a>
                    <% User acc = (User) session.getAttribute("account");
                       if (acc != null) { %>
                        <span class="text-white ms-3 fw-bold"><%= acc.getFullName() %></span>
                        <% if ("admin".equalsIgnoreCase(acc.getRole())) { %> <span class="badge bg-warning text-dark ms-1">ADMIN</span> <% } %>
                        <a href="logout" class="ms-3 fw-bold">Đăng xuất</a>
                    <% } else { %>
                        <a href="register" class="fw-bold ms-3">Đăng Ký</a>
                        <a href="login" class="fw-bold ms-3 border-start ps-3 border-white">Đăng Nhập</a>
                    <% } %>
                </div>
            </div>
        </div>

        <div class="shopee-header-main">
            <div class="container d-flex align-items-center gap-4">
                <a href="home" class="shopee-logo"><i class="fas fa-shopping-bag"></i> Shopee</a>
                <div class="flex-grow-1">
                    <form action="search" method="get" class="shopee-search-bar">
                        <input type="text" name="txt" class="shopee-search-input" 
                               placeholder="Săn voucher 50k đơn đầu tiên!" 
                               value="<%= request.getAttribute("txtS") == null ? "" : request.getAttribute("txtS") %>">
                        <button type="submit" class="shopee-search-btn"><i class="fas fa-search"></i></button>
                    </form>
                    <div class="d-flex gap-3 text-white mt-1 small ps-2 opacity-75">
                        <span>Váy Đầm</span> <span>Áo Thun</span> <span>iPhone 15</span> <span>Túi Xách</span>
                    </div>
                </div>
                <div class="shopee-cart-icon"><i class="fas fa-shopping-cart"></i><span class="cart-badge">0</span></div>
            </div>
        </div>
    </header>

    <div class="container">
        <div class="row">
            <div class="col-lg-2 d-none d-lg-block">
                <div class="category-sidebar">
                    <div class="category-header"><i class="fas fa-list"></i> Danh Mục</div>
                    <ul class="category-list">
                        <li class="active-cate"><i class="fas fa-caret-right me-2"></i>Tất Cả</li>
                        <li>Thời Trang Nam</li>
                        <li>Điện Thoại & Phụ Kiện</li>
                        <li>Thiết Bị Điện Tử</li>
                        <li>Máy Tính & Laptop</li>
                        <li>Đồng Hồ</li>
                        <li>Nhà Cửa & Đời Sống</li>
                    </ul>
                </div>
            </div>

            <div class="col-lg-10">
                <div id="bannerCarousel" class="carousel slide shopee-banner" data-bs-ride="carousel">
                    <div class="carousel-inner">
                        <div class="carousel-item active"><img src="https://cf.shopee.vn/file/vn-50009109-b6c86a23730e7930906296a84d008906_xxhdpi" class="d-block w-100"></div>
                        <div class="carousel-item"><img src="https://cf.shopee.vn/file/vn-50009109-ec8f121287042a969f6e520970a24080_xxhdpi" class="d-block w-100"></div>
                    </div>
                    <button class="carousel-control-prev" type="button" data-bs-target="#bannerCarousel" data-bs-slide="prev"><span class="carousel-control-prev-icon"></span></button>
                    <button class="carousel-control-next" type="button" data-bs-target="#bannerCarousel" data-bs-slide="next"><span class="carousel-control-next-icon"></span></button>
                </div>

                <div class="row row-cols-2 row-cols-md-4 row-cols-lg-5 g-2">
                    <% 
                       List<ProductDTO> list = (List<ProductDTO>) request.getAttribute("products");
                       if (list != null && !list.isEmpty()) {
                            for (ProductDTO p : list) { 
                    %>
                    <div class="col">
                        <a href="product-detail?id=<%= p.getId() %>" class="text-decoration-none">
                            <div class="shopee-card">
                                <div class="badge-mall">Yêu thích</div>
                                <div class="badge-sale"><span class="sale-percent">50%</span><span class="sale-text">GIẢM</span></div>
                                
                                <img src="<%= p.getImage() %>" class="card-img-top" alt="<%= p.getName() %>">
                                
                                <div class="card-body">
                                    <div class="card-title"><%= p.getName() %></div>
                                    <div class="d-flex justify-content-between align-items-baseline mt-auto">
                                        <div class="card-price">₫<%= String.format("%,.0f", p.getMinPrice()) %></div>
                                        <div class="sold-count">Đã bán 1k</div>
                                    </div>
                                    
                                    <% if (acc != null && "admin".equalsIgnoreCase(acc.getRole())) { %>
                                        <div class="mt-2 pt-2 border-top text-center">
                                            <a href="product-manage?action=delete&id=<%= p.getId() %>" 
                                               class="text-danger small fw-bold"
                                               onclick="return confirm('Xóa thật hả?')">Xóa</a>
                                        </div>
                                    <% } %>
                                </div>
                            </div>
                        </a>
                    </div>
                    <%      } 
                       } else { 
                    %>
                        <div class="col-12 text-center py-5">
                            <i class="fas fa-box-open fa-3x text-muted mb-3"></i><p class="text-muted">Chưa có sản phẩm!</p>
                            <a href="admin-import" class="btn btn-danger btn-sm">Admin Import</a>
                        </div>
                    <% } %>
                </div>
            </div>
        </div>
    </div>

    <footer class="shopee-footer">
        <div class="container text-center">
            <p>© 2026 Shopee. Tất cả các quyền được bảo lưu.</p>
        </div>
    </footer>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>