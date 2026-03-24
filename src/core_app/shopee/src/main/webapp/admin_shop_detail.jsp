<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@page import="java.util.List" %>
<%@page import="model.Shop" %>
<%@page import="model.Product" %>
<%@page import="model.Category" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Chi Tiết Shop | Shopee Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --shopee-primary: #ee4d2d;
            --shopee-hover: #f05d40;
            --sidebar-width: 260px;
            --bg-color: #f5f5f5;
            --card-shadow: 0 1px 3px rgba(0, 0, 0, 0.12), 0 1px 2px rgba(0, 0, 0, 0.24);
        }
        html { overflow-x: hidden; }
        body { background: var(--bg-color); font-family: 'Inter', sans-serif; overflow-x: hidden; margin: 0; }
        .sidebar { height: 100vh; background: #fff; width: var(--sidebar-width); position: fixed; box-shadow: 2px 0 10px rgba(0,0,0,0.05); z-index: 100; overflow-y: auto; }
        .sidebar-logo { display: flex; align-items: center; justify-content: center; padding: 20px 0; border-bottom: 1px solid #eee; }
        .sidebar-logo h4 { color: var(--shopee-primary); font-weight: 700; margin: 0; font-size: 22px; }
        .nav-item { padding: 5px 15px; }
        .sidebar a { color: #555; text-decoration: none; padding: 12px 20px; display: flex; align-items: center; border-radius: 8px; font-weight: 500; transition: all 0.2s ease; margin-bottom: 5px; }
        .sidebar a i { width: 30px; font-size: 18px; }
        .sidebar a:hover { background-color: #fef0ee; color: var(--shopee-primary); }
        .sidebar a.active { background-color: var(--shopee-primary); color: #fff; box-shadow: 0 4px 6px rgba(238,77,45,0.2); }
        .main-content { margin-left: var(--sidebar-width); padding: 30px 40px; max-width: calc(100vw - var(--sidebar-width)); box-sizing: border-box; overflow: hidden; }
        .top-header { display: flex; justify-content: space-between; align-items: center; background: #fff; padding: 15px 30px; border-radius: 12px; box-shadow: var(--card-shadow); margin-bottom: 30px; }
        .content-box { background: #fff; padding: 25px; border-radius: 12px; box-shadow: var(--card-shadow); margin-bottom: 25px; overflow: hidden; }
        .btn-shopee { background-color: var(--shopee-primary); color: white; border: none; }
        .btn-shopee:hover { background-color: var(--shopee-hover); color: white; }

        .shop-profile {
            display: flex; align-items: center; gap: 20px;
            padding: 25px; border-radius: 16px;
            background: linear-gradient(135deg, #fff0ed 0%, #fff8f6 100%);
            border: 1px solid #ffe0d6;
        }
        .shop-profile-avatar {
            width: 80px; height: 80px; border-radius: 50%;
            display: flex; align-items: center; justify-content: center;
            font-weight: 700; font-size: 28px; color: #fff;
            background: linear-gradient(135deg, #ee4d2d, #f7a072);
            flex-shrink: 0;
        }
        .shop-profile-avatar img { width: 80px; height: 80px; border-radius: 50%; object-fit: cover; }
        .stat-card {
            border-radius: 12px; padding: 20px; text-align: center;
            border: 1px solid #eee;
        }
        .stat-card .stat-value { font-size: 26px; font-weight: 700; }
        .stat-card .stat-label { font-size: 13px; color: #888; margin-top: 5px; }
        .stat-revenue { background: #e8f5e9; }
        .stat-revenue .stat-value { color: #2e7d32; }
        .stat-orders { background: #e3f2fd; }
        .stat-orders .stat-value { color: #1565c0; }
        .stat-products { background: #fff3e0; }
        .stat-products .stat-value { color: #e65100; }

        .badge-pending { background: #fff3cd; color: #856404; font-weight: 600; }
        .badge-completed { background: #d4edda; color: #155724; font-weight: 600; }
        .badge-cancelled { background: #f8d7da; color: #721c24; font-weight: 600; }
        .badge-paid { background: #cce5ff; color: #004085; font-weight: 600; }
        .badge-shipped { background: #e2e3f1; color: #383d6e; font-weight: 600; }

        .info-row { display: flex; gap: 10px; margin-bottom: 8px; }
        .info-label { min-width: 130px; color: #888; font-weight: 500; font-size: 14px; }
        .info-value { font-weight: 600; color: #333; font-size: 14px; }
        .rating-stars { color: #ffc107; }

        .table-responsive { overflow-x: auto; max-width: 100%; }
        .products-table { table-layout: fixed; width: 100%; }
        .products-table td, .products-table th { overflow: hidden; text-overflow: ellipsis; white-space: nowrap; vertical-align: middle; }
        .products-table td:nth-child(3) { white-space: normal; word-break: break-word; overflow: hidden; }
    </style>
</head>
<body>
    <%@ include file="admin_sidebar.jsp" %>

    <%
        Shop shop = (Shop) request.getAttribute("shop");
        double totalRevenue = request.getAttribute("totalRevenue") != null ? (Double) request.getAttribute("totalRevenue") : 0;
        int orderCount = request.getAttribute("orderCount") != null ? (Integer) request.getAttribute("orderCount") : 0;
        int productCount = request.getAttribute("productCount") != null ? (Integer) request.getAttribute("productCount") : 0;
        String currentStatus = (String) request.getAttribute("currentStatus");
    %>

    <div class="main-content">
        <!-- Header -->
        <div class="top-header">
            <div class="d-flex align-items-center gap-3">
                <a href="admin-shops" class="btn btn-outline-secondary btn-sm">
                    <i class="fas fa-arrow-left me-1"></i> Quay lại
                </a>
                <div>
                    <h4 class="m-0 fw-bold text-dark">Chi Tiết Shop #<%= shop.getId() %></h4>
                    <small class="text-muted">Thông tin và đơn hàng của shop</small>
                </div>
            </div>
            <div class="d-flex align-items-center gap-3">
                <div class="dropdown">
                    <button class="btn btn-light rounded-circle shadow-sm position-relative" type="button" data-bs-toggle="dropdown" aria-expanded="false">
                        <i class="fas fa-bell"></i>
                        <span class="position-absolute top-0 start-100 translate-middle p-1 bg-danger rounded-circle"></span>
                    </button>
                    <ul class="dropdown-menu dropdown-menu-end shadow border-0 mt-2" style="width: 300px;">
                        <li><h6 class="dropdown-header fw-bold text-dark">Thông Báo</h6></li>
                        <li><hr class="dropdown-divider"></li>
                        <li><a class="dropdown-item text-center text-muted py-3" href="#">Chưa có thông báo mới nào</a></li>
                        <li><hr class="dropdown-divider"></li>
                        <li><a class="dropdown-item text-center fw-medium text-primary" href="#">Xem tất cả</a></li>
                    </ul>
                </div>
                <div class="d-flex align-items-center gap-2 border-start ps-3">
                    <img src="https://ui-avatars.com/api/?name=Admin&background=ee4d2d&color=fff&rounded=true" width="45">
                    <div class="d-flex flex-column">
                        <span class="fw-bold" style="font-size: 14px;">Super Admin</span>
                        <span class="text-muted" style="font-size: 12px;">Quản trị viên</span>
                    </div>
                </div>
            </div>
        </div>

        <% if (session.getAttribute("successMessage") != null) { %>
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <i class="fas fa-check-circle me-2"></i> <%= session.getAttribute("successMessage") %>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
            <% session.removeAttribute("successMessage"); %>
        <% } %>
        <% if (session.getAttribute("errorMessage") != null) { %>
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="fas fa-exclamation-triangle me-2"></i> <%= session.getAttribute("errorMessage") %>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
            <% session.removeAttribute("errorMessage"); %>
        <% } %>

        <!-- Shop Profile -->
        <div class="content-box">
            <div class="d-flex justify-content-between align-items-start mb-3">
                <h5 class="fw-bold m-0"><i class="fas fa-store me-2 text-muted"></i> Thông Tin Shop</h5>
                <button class="btn btn-shopee btn-sm" data-bs-toggle="modal" data-bs-target="#editShopModal">
                    <i class="fas fa-edit me-1"></i> Chỉnh Sửa
                </button>
            </div>

            <div class="shop-profile">
                <div class="shop-profile-avatar">
                    <% if (shop.getOwnerAvatar() != null && !shop.getOwnerAvatar().isEmpty()) { %>
                        <img src="<%= shop.getOwnerAvatar() %>" alt="">
                    <% } else { %>
                        <%= shop.getShopName() != null && !shop.getShopName().isEmpty() ? String.valueOf(shop.getShopName().charAt(0)).toUpperCase() : "S" %>
                    <% } %>
                </div>
                <div class="flex-grow-1">
                    <h4 class="fw-bold mb-2" style="color: var(--shopee-primary);"><%= shop.getShopName() %></h4>
                    <div class="info-row">
                        <span class="info-label"><i class="fas fa-user me-1"></i> Chủ shop:</span>
                        <span class="info-value"><%= shop.getOwnerName() != null ? shop.getOwnerName() : "N/A" %> (ID: <%= shop.getOwnerId() %>)</span>
                    </div>
                    <div class="info-row">
                        <span class="info-label"><i class="fas fa-star me-1"></i> Rating:</span>
                        <span class="info-value">
                            <span class="rating-stars">
                                <% for (int i = 1; i <= 5; i++) { %>
                                    <i class="fas fa-star<%= i <= Math.round(shop.getRating()) ? "" : " text-muted" %>" style="<%= i <= Math.round(shop.getRating()) ? "" : "opacity:0.3" %>"></i>
                                <% } %>
                            </span>
                            <%= String.format("%.1f", shop.getRating()) %>/5.0
                        </span>
                    </div>
                    <div class="info-row">
                        <span class="info-label"><i class="fas fa-map-marker-alt me-1"></i> Vị trí:</span>
                        <span class="info-value"><%= shop.getLocation() != null && !shop.getLocation().isEmpty() ? shop.getLocation() : "Chưa cập nhật" %></span>
                    </div>
                    <div class="info-row">
                        <span class="info-label"><i class="fas fa-calendar me-1"></i> Tham gia:</span>
                        <span class="info-value"><%= shop.getJoinDuration() %></span>
                    </div>
                    <div class="info-row">
                        <span class="info-label"><i class="fas fa-reply me-1"></i> Tỉ lệ phản hồi:</span>
                        <span class="info-value"><%= shop.getResponseRate() != null ? shop.getResponseRate() : "N/A" %></span>
                    </div>
                    <div class="info-row">
                        <span class="info-label"><i class="fas fa-clock me-1"></i> Thời gian PH:</span>
                        <span class="info-value"><%= shop.getResponseTime() != null ? shop.getResponseTime() : "N/A" %></span>
                    </div>
                </div>
            </div>
        </div>

        <!-- Stats Cards -->
        <div class="row mb-4 g-3">
            <div class="col-md-4">
                <div class="stat-card stat-revenue">
                    <div class="stat-value"><%= String.format("%,.0f", totalRevenue) %>đ</div>
                    <div class="stat-label"><i class="fas fa-coins me-1"></i> Tổng Doanh Thu</div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="stat-card stat-orders">
                    <div class="stat-value"><%= String.format("%,d", orderCount) %></div>
                    <div class="stat-label"><i class="fas fa-shopping-cart me-1"></i> Tổng Đơn Hàng</div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="stat-card stat-products">
                    <div class="stat-value"><%= String.format("%,d", productCount) %></div>
                    <div class="stat-label"><i class="fas fa-box me-1"></i> Tổng Sản Phẩm</div>
                </div>
            </div>
        </div>

        <!-- Orders Table -->
        <div class="content-box">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h5 class="fw-bold m-0 text-dark"><i class="fas fa-clipboard-list me-2 text-muted"></i> Đơn Hàng Liên Quan</h5>
                <div class="d-flex align-items-center gap-3">
                    <select class="form-select form-select-sm" style="width: 160px;"
                            onchange="location.href='admin-shops?action=detail&id=<%= shop.getId() %>&status=' + this.value">
                        <option value="ALL" <%= "ALL".equals(currentStatus) || currentStatus == null ? "selected" : "" %>>Tất cả trạng thái</option>
                        <option value="PENDING" <%= "PENDING".equals(currentStatus) ? "selected" : "" %>>Chờ xử lý</option>
                        <option value="PAID" <%= "PAID".equals(currentStatus) ? "selected" : "" %>>Đã thanh toán</option>
                        <option value="SHIPPED" <%= "SHIPPED".equals(currentStatus) ? "selected" : "" %>>Đang giao</option>
                        <option value="COMPLETED" <%= "COMPLETED".equals(currentStatus) ? "selected" : "" %>>Hoàn thành</option>
                        <option value="CANCELLED" <%= "CANCELLED".equals(currentStatus) ? "selected" : "" %>>Đã hủy</option>
                    </select>
                    <% List<String[]> orders = (List<String[]>) request.getAttribute("orders"); %>
                    <span class="badge bg-secondary fs-6"><%= orders != null ? orders.size() : 0 %> đơn</span>
                </div>
            </div>

            <div class="table-responsive">
                <table class="table table-hover border align-middle">
                    <thead class="table-light">
                        <tr>
                            <th width="80">Mã ĐH</th>
                            <th>Khách Hàng</th>
                            <th>Email</th>
                            <th width="150" class="text-end">Tổng Tiền</th>
                            <th width="150" class="text-center">Trạng Thái</th>
                            <th width="180">Ngày Tạo</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (orders != null) { for (String[] o : orders) {
                            String statusClass = "badge-pending";
                            String statusText = "Xử lý";
                            if ("COMPLETED".equals(o[4])) { statusClass = "badge-completed"; statusText = "Hoàn thành"; }
                            else if ("CANCELLED".equals(o[4])) { statusClass = "badge-cancelled"; statusText = "Đã hủy"; }
                            else if ("PAID".equals(o[4])) { statusClass = "badge-paid"; statusText = "Đã thanh toán"; }
                            else if ("SHIPPED".equals(o[4])) { statusClass = "badge-shipped"; statusText = "Đang giao"; }
                        %>
                        <tr>
                            <td class="fw-bold">#<%= o[0] %></td>
                            <td><i class="fas fa-user-circle text-muted me-1"></i> <%= o[1] %></td>
                            <td class="text-muted"><%= o[2] %></td>
                            <td class="text-end text-danger fw-bold"><%= String.format("%,.0f", Double.parseDouble(o[3])) %> đ</td>
                            <td class="text-center">
                                <span class="badge rounded-pill px-3 py-2 <%= statusClass %>"><%= statusText %></span>
                            </td>
                            <td class="text-muted" style="font-size: 13px;"><i class="fas fa-clock me-1"></i> <%= o[5] != null && o[5].length() >= 19 ? o[5].substring(0, 19) : o[5] %></td>
                        </tr>
                        <% } } %>
                    </tbody>
                </table>
            </div>

            <% if (orders == null || orders.isEmpty()) { %>
                <div class="text-center py-5 text-muted">
                    <i class="fas fa-inbox fa-3x mb-3"></i>
                    <h5>Chưa có đơn hàng nào</h5>
                    <p>Đơn hàng liên quan đến shop này sẽ hiển thị ở đây.</p>
                </div>
            <% } %>
        </div>

    <!-- ======== PRODUCTS SECTION ======== -->
    <%
        List<Product> shopProducts = (List<Product>) request.getAttribute("shopProducts");
        List<Category> categories = (List<Category>) request.getAttribute("categories");
        int productPage = request.getAttribute("productPage") != null ? (Integer) request.getAttribute("productPage") : 1;
        int productTotalPages = request.getAttribute("productTotalPages") != null ? (Integer) request.getAttribute("productTotalPages") : 1;
        String productSearch = (String) request.getAttribute("productSearch");
    %>
    <div class="content-box">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h5 class="fw-bold m-0 text-dark"><i class="fas fa-box me-2 text-muted"></i> S&#7843;n Ph&#7849;m C&#7911;a Shop</h5>
            <div class="d-flex align-items-center gap-2">
                <form action="admin-shops" method="GET" class="d-flex gap-2">
                    <input type="hidden" name="action" value="detail">
                    <input type="hidden" name="id" value="<%= shop.getId() %>">
                    <input type="text" name="psearch" class="form-control form-control-sm" style="width:200px;"
                           placeholder="T&#236;m s&#7843;n ph&#7849;m..." value="<%= productSearch != null ? productSearch : "" %>">
                    <button class="btn btn-outline-secondary btn-sm"><i class="fas fa-search"></i></button>
                </form>
                <span class="badge bg-secondary fs-6"><%= shopProducts != null ? productCount : 0 %> SP</span>
                <button class="btn btn-shopee btn-sm shadow-sm" data-bs-toggle="modal" data-bs-target="#addProductModal">
                    <i class="fas fa-plus me-1"></i> Th&#234;m SP
                </button>
            </div>
        </div>

        <div class="table-responsive">
            <table class="table table-hover border align-middle products-table">
                <thead class="table-light">
                    <tr>
                        <th width="60">ID</th>
                        <th width="70">&#7842;nh</th>
                        <th>T&#234;n S&#7843;n Ph&#7849;m</th>
                        <th width="140" class="text-end">Gi&#225;</th>
                        <th width="160" class="text-center">H&#224;nh &#272;&#7897;ng</th>
                    </tr>
                </thead>
                <tbody>
                    <% if (shopProducts != null) { for (Product sp : shopProducts) { %>
                    <tr>
                        <td class="fw-bold text-muted">#<%= sp.getId() %></td>
                        <td>
                            <img src="<%= sp.getImageUrl() %>" width="45" height="45"
                                 style="object-fit:cover; border-radius:8px; border:1px solid #eee;"
                                 onerror="this.src='https://via.placeholder.com/45'">
                        </td>
                        <td>
                            <a href="product_detail?id=<%= sp.getId() %>" class="text-decoration-none text-dark fw-medium" target="_blank">
                                <%= sp.getName() %>
                            </a>
                        </td>
                        <td class="text-end text-danger fw-bold"><%= String.format("%,.0f", sp.getPrice()) %>&#273;</td>
                        <td class="text-center">
                            <button class="btn btn-sm btn-outline-primary"
                                onclick="openEditProductModal(<%= sp.getId() %>, '<%= sp.getName().replace("'", "\\\\'") %>', '<%= sp.getPrice() %>', '<%= sp.getImageUrl() %>', <%= sp.getCategoryId() %>)">
                                <i class="fas fa-edit"></i>
                            </button>
                            <form action="admin-shops" method="POST" style="display:inline;"
                                  onsubmit="return confirm('X&#225;c nh&#7853;n x&#243;a s&#7843;n ph&#7849;m #<%= sp.getId() %>?')">
                                <input type="hidden" name="action" value="delete_product">
                                <input type="hidden" name="shop_id" value="<%= shop.getId() %>">
                                <input type="hidden" name="product_id" value="<%= sp.getId() %>">
                                <button type="submit" class="btn btn-sm btn-outline-danger"><i class="fas fa-trash"></i></button>
                            </form>
                        </td>
                    </tr>
                    <% } } %>
                </tbody>
            </table>
        </div>

        <% if (shopProducts == null || shopProducts.isEmpty()) { %>
            <div class="text-center py-4 text-muted">
                <i class="fas fa-box-open fa-2x mb-2"></i>
                <p>Ch&#432;a c&#243; s&#7843;n ph&#7849;m n&#224;o trong shop n&#224;y.</p>
            </div>
        <% } %>

        <!-- Pagination -->
        <% if (productTotalPages > 1) { %>
        <nav class="mt-3">
            <ul class="pagination justify-content-center mb-0">
                <li class="page-item <%= productPage <= 1 ? "disabled" : "" %>">
                    <a class="page-link" href="admin-shops?action=detail&id=<%= shop.getId() %>&ppage=<%= productPage - 1 %>&psearch=<%= productSearch != null ? productSearch : "" %>">&#171;</a>
                </li>
                <% for (int i = 1; i <= productTotalPages; i++) { %>
                <li class="page-item <%= i == productPage ? "active" : "" %>">
                    <a class="page-link" href="admin-shops?action=detail&id=<%= shop.getId() %>&ppage=<%= i %>&psearch=<%= productSearch != null ? productSearch : "" %>"><%= i %></a>
                </li>
                <% } %>
                <li class="page-item <%= productPage >= productTotalPages ? "disabled" : "" %>">
                    <a class="page-link" href="admin-shops?action=detail&id=<%= shop.getId() %>&ppage=<%= productPage + 1 %>&psearch=<%= productSearch != null ? productSearch : "" %>">&#187;</a>
                </li>
            </ul>
        </nav>
        <% } %>
    </div>
    </div>

    <!-- Add Product Modal -->
    <div class="modal fade" id="addProductModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title fw-bold"><i class="fas fa-plus-circle me-2"></i>Th&#234;m S&#7843;n Ph&#7849;m</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form action="admin-shops" method="POST">
                    <div class="modal-body">
                        <input type="hidden" name="action" value="add_product">
                        <input type="hidden" name="shop_id" value="<%= shop.getId() %>">
                        <div class="mb-3">
                            <label class="form-label fw-medium">T&#234;n S&#7843;n Ph&#7849;m <span class="text-danger">*</span></label>
                            <input type="text" class="form-control" name="name" required placeholder="Nh&#7853;p t&#234;n s&#7843;n ph&#7849;m...">
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-medium">Danh M&#7909;c <span class="text-danger">*</span></label>
                            <select class="form-select" name="category_id" required>
                                <% if (categories != null) { for (Category c : categories) { %>
                                    <option value="<%= c.getId() %>"><%= c.getName() %></option>
                                <% } } %>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-medium">Gi&#225; B&#225;n (VN&#272;) <span class="text-danger">*</span></label>
                            <input type="number" class="form-control" name="price" required min="0" step="1" placeholder="150000">
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-medium">Link H&#236;nh &#7842;nh</label>
                            <input type="url" class="form-control" name="image_url" placeholder="https://...">
                        </div>
                    </div>
                    <div class="modal-footer bg-light">
                        <button type="button" class="btn btn-light border" data-bs-dismiss="modal">H&#7911;y</button>
                        <button type="submit" class="btn btn-shopee">Th&#234;m SP</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Edit Product Modal -->
    <div class="modal fade" id="editProductModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title fw-bold"><i class="fas fa-edit me-2"></i>S&#7917;a S&#7843;n Ph&#7849;m</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form action="admin-shops" method="POST">
                    <div class="modal-body">
                        <input type="hidden" name="action" value="edit_product">
                        <input type="hidden" name="shop_id" value="<%= shop.getId() %>">
                        <input type="hidden" name="product_id" id="ep-id">
                        <div class="mb-3">
                            <label class="form-label fw-medium">T&#234;n S&#7843;n Ph&#7849;m <span class="text-danger">*</span></label>
                            <input type="text" class="form-control" name="name" id="ep-name" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-medium">Danh M&#7909;c <span class="text-danger">*</span></label>
                            <select class="form-select" name="category_id" id="ep-category" required>
                                <% if (categories != null) { for (Category c : categories) { %>
                                    <option value="<%= c.getId() %>"><%= c.getName() %></option>
                                <% } } %>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-medium">Gi&#225; B&#225;n (VN&#272;) <span class="text-danger">*</span></label>
                            <input type="number" class="form-control" name="price" id="ep-price" required min="0" step="1">
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-medium">Link H&#236;nh &#7842;nh</label>
                            <input type="url" class="form-control" name="image_url" id="ep-image">
                        </div>
                    </div>
                    <div class="modal-footer bg-light">
                        <button type="button" class="btn btn-light border" data-bs-dismiss="modal">H&#7911;y</button>
                        <button type="submit" class="btn btn-shopee">L&#432;u Thay &#272;&#7893;i</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    <div class="modal fade" id="editShopModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title fw-bold"><i class="fas fa-edit me-2"></i>Chỉnh Sửa Shop #<%= shop.getId() %></h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form action="admin-shops" method="POST">
                    <div class="modal-body">
                        <input type="hidden" name="action" value="edit">
                        <input type="hidden" name="id" value="<%= shop.getId() %>">

                        <div class="mb-3">
                            <label class="form-label fw-medium">Tên Shop</label>
                            <input type="text" class="form-control" name="shop_name" value="<%= shop.getShopName() %>" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-medium">Rating (0 - 5)</label>
                            <input type="number" class="form-control" name="rating" value="<%= String.format("%.1f", shop.getRating()) %>"
                                   min="0" max="5" step="0.1" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-medium">Vị trí / Địa chỉ</label>
                            <input type="text" class="form-control" name="location"
                                   value="<%= shop.getLocation() != null ? shop.getLocation() : "" %>"
                                   placeholder="VD: TP. Hồ Chí Minh">
                        </div>
                    </div>
                    <div class="modal-footer bg-light">
                        <button type="button" class="btn btn-light border" data-bs-dismiss="modal">Hủy</button>
                        <button type="submit" class="btn btn-shopee">Lưu Thay Đổi</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function openEditProductModal(id, name, price, image, categoryId) {
            document.getElementById('ep-id').value = id;
            document.getElementById('ep-name').value = name;
            document.getElementById('ep-price').value = parseInt(price);
            document.getElementById('ep-image').value = image;
            document.getElementById('ep-category').value = categoryId;
            var modal = new bootstrap.Modal(document.getElementById('editProductModal'));
            modal.show();
        }
    </script>
</body>
</html>
