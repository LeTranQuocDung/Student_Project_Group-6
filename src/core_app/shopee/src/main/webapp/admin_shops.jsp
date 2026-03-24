<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@page import="java.util.List" %>
<%@page import="model.Shop" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản Lý Shop | Shopee Admin</title>
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
        body { background: var(--bg-color); font-family: 'Inter', sans-serif; overflow-x: hidden; }
        .sidebar { height: 100vh; background: #fff; width: var(--sidebar-width); position: fixed; box-shadow: 2px 0 10px rgba(0,0,0,0.05); z-index: 100; overflow-y: auto; }
        .sidebar-logo { display: flex; align-items: center; justify-content: center; padding: 20px 0; border-bottom: 1px solid #eee; }
        .sidebar-logo h4 { color: var(--shopee-primary); font-weight: 700; margin: 0; font-size: 22px; }
        .nav-item { padding: 5px 15px; }
        .sidebar a { color: #555; text-decoration: none; padding: 12px 20px; display: flex; align-items: center; border-radius: 8px; font-weight: 500; transition: all 0.2s ease; margin-bottom: 5px; }
        .sidebar a i { width: 30px; font-size: 18px; }
        .sidebar a:hover { background-color: #fef0ee; color: var(--shopee-primary); }
        .sidebar a.active { background-color: var(--shopee-primary); color: #fff; box-shadow: 0 4px 6px rgba(238,77,45,0.2); }
        .main-content { margin-left: var(--sidebar-width); padding: 30px 40px; }
        .top-header { display: flex; justify-content: space-between; align-items: center; background: #fff; padding: 15px 30px; border-radius: 12px; box-shadow: var(--card-shadow); margin-bottom: 30px; }
        .content-box { background: #fff; padding: 25px; border-radius: 12px; box-shadow: var(--card-shadow); }
        .btn-shopee { background-color: var(--shopee-primary); color: white; border: none; }
        .btn-shopee:hover { background-color: var(--shopee-hover); color: white; }
        .shop-avatar {
            width: 45px; height: 45px; border-radius: 50%;
            display: flex; align-items: center; justify-content: center;
            font-weight: 700; font-size: 16px; color: #fff;
            background: linear-gradient(135deg, #ee4d2d, #f7a072);
            flex-shrink: 0;
        }
        .shop-avatar img { width: 45px; height: 45px; border-radius: 50%; object-fit: cover; }
        .revenue-badge {
            background: #e8f5e9; color: #2e7d32; font-weight: 600;
            border-radius: 20px; padding: 4px 12px; font-size: 13px;
        }
        .rating-stars { color: #ffc107; font-size: 13px; }
        .stat-card {
            background: linear-gradient(135deg, #fff0ed, #fff);
            border: 1px solid #ffe0d6;
            border-radius: 12px;
            padding: 20px;
            text-align: center;
        }
        .stat-card .stat-value { font-size: 28px; font-weight: 700; color: var(--shopee-primary); }
        .stat-card .stat-label { font-size: 13px; color: #888; margin-top: 5px; }
    </style>
</head>
<body>
    <%@ include file="admin_sidebar.jsp" %>

    <div class="main-content">
        <!-- Header -->
        <div class="top-header">
            <div>
                <h4 class="m-0 fw-bold text-dark">Quản Lý Shop</h4>
                <small class="text-muted">Danh sách và thông tin các cửa hàng</small>
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

        <%
            List<Shop> shops = (List<Shop>) request.getAttribute("shops");
            double grandTotalRevenue = 0;
            int grandTotalProducts = 0;
            int grandTotalOrders = 0;
            if (shops != null) {
                for (Shop ss : shops) {
                    grandTotalRevenue += ss.getTotalRevenue();
                    grandTotalProducts += ss.getProductCount();
                    grandTotalOrders += ss.getFollowerCount(); // followerCount reused as orderCount
                }
            }
        %>

        <!-- Summary Stats -->
        <div class="row mb-4 g-3">
            <div class="col-md-3">
                <div class="stat-card">
                    <div class="stat-value"><%= shops != null ? shops.size() : 0 %></div>
                    <div class="stat-label"><i class="fas fa-store me-1"></i> Tổng Số Shop</div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="stat-card">
                    <div class="stat-value"><%= String.format("%,d", grandTotalProducts) %></div>
                    <div class="stat-label"><i class="fas fa-box me-1"></i> Tổng Sản Phẩm</div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="stat-card">
                    <div class="stat-value"><%= String.format("%,d", grandTotalOrders) %></div>
                    <div class="stat-label"><i class="fas fa-shopping-cart me-1"></i> Tổng Đơn Hàng</div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="stat-card">
                    <div class="stat-value" style="font-size: 22px;"><%= String.format("%,.0f", grandTotalRevenue) %>đ</div>
                    <div class="stat-label"><i class="fas fa-coins me-1"></i> Tổng Doanh Thu</div>
                </div>
            </div>
        </div>

        <!-- Content Box -->
        <div class="content-box">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h5 class="fw-bold m-0 text-dark"><i class="fas fa-store me-2 text-muted"></i> Danh sách cửa hàng</h5>
                <div class="d-flex gap-2 align-items-center">
                    <span class="badge bg-secondary fs-6"><%= shops != null ? shops.size() : 0 %> shop</span>
                    <button class="btn btn-shopee shadow-sm" data-bs-toggle="modal" data-bs-target="#createShopModal">
                        <i class="fas fa-plus me-1"></i> Tạo Shop Mới
                    </button>
                </div>
            </div>

            <div class="table-responsive">
                <table class="table table-hover border align-middle">
                    <thead class="table-light">
                        <tr>
                            <th width="60">ID</th>
                            <th>Tên Shop</th>
                            <th>Chủ Shop</th>
                            <th width="100" class="text-center">Sản Phẩm</th>
                            <th width="100" class="text-center">Đơn Hàng</th>
                            <th width="160" class="text-end">Doanh Thu</th>
                            <th width="110" class="text-center">Rating</th>
                            <th width="120" class="text-center">Hành Động</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% String[] colors = {"#ee4d2d","#007bff","#28a745","#6f42c1","#fd7e14","#20c997","#e83e8c","#17a2b8"};
                        if (shops != null) { int idx = 0; for (Shop s : shops) {
                            String color = colors[idx % colors.length];
                            String initial = s.getShopName() != null && !s.getShopName().isEmpty()
                                    ? String.valueOf(s.getShopName().charAt(0)).toUpperCase() : "S";
                            idx++;
                        %>
                        <tr>
                            <td class="fw-bold text-muted">#<%= s.getId() %></td>
                            <td>
                                <div class="d-flex align-items-center gap-2">
                                    <div class="shop-avatar" style="background: <%= color %>;">
                                        <% if (s.getOwnerAvatar() != null && !s.getOwnerAvatar().isEmpty()) { %>
                                            <img src="<%= s.getOwnerAvatar() %>" alt="">
                                        <% } else { %>
                                            <%= initial %>
                                        <% } %>
                                    </div>
                                    <div>
                                        <span class="fw-medium"><%= s.getShopName() %></span>
                                        <% if (s.getLocation() != null && !s.getLocation().isEmpty()) { %>
                                            <br><small class="text-muted"><i class="fas fa-map-marker-alt me-1"></i><%= s.getLocation() %></small>
                                        <% } %>
                                    </div>
                                </div>
                            </td>
                            <td>
                                <span class="text-muted"><%= s.getOwnerName() != null ? s.getOwnerName() : "N/A" %></span>
                            </td>
                            <td class="text-center">
                                <span class="badge bg-light text-dark border px-3 py-2"><%= String.format("%,d", s.getProductCount()) %></span>
                            </td>
                            <td class="text-center">
                                <span class="badge bg-light text-dark border px-3 py-2"><%= String.format("%,d", s.getFollowerCount()) %></span>
                            </td>
                            <td class="text-end">
                                <span class="revenue-badge"><%= String.format("%,.0f", s.getTotalRevenue()) %> đ</span>
                            </td>
                            <td class="text-center">
                                <span class="rating-stars">
                                    <% for (int i = 1; i <= 5; i++) { %>
                                        <i class="fas fa-star<%= i <= Math.round(s.getRating()) ? "" : " text-muted" %>" style="<%= i <= Math.round(s.getRating()) ? "" : "opacity:0.3" %>"></i>
                                    <% } %>
                                </span>
                                <br><small class="text-muted"><%= String.format("%.1f", s.getRating()) %></small>
                            </td>
                            <td class="text-center">
                                <a href="admin-shops?action=detail&id=<%= s.getId() %>"
                                   class="btn btn-sm btn-outline-primary shadow-sm">
                                    <i class="fas fa-eye me-1"></i> Chi tiết
                                </a>
                            </td>
                        </tr>
                        <% } } %>
                    </tbody>
                </table>
            </div>

            <% if (shops == null || shops.isEmpty()) { %>
                <div class="text-center py-5 text-muted">
                    <i class="fas fa-store-slash fa-3x mb-3"></i>
                    <h5>Chưa có shop nào</h5>
                    <p>Các shop sẽ hiển thị ở đây khi được tạo.</p>
                </div>
            <% } %>
        </div>
    </div>

    <!-- Create Shop Modal -->
    <div class="modal fade" id="createShopModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title fw-bold"><i class="fas fa-store me-2"></i>Tạo Shop Mới</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form action="admin-shops" method="POST">
                    <div class="modal-body">
                        <input type="hidden" name="action" value="create">
                        <div class="mb-3">
                            <label class="form-label fw-medium">Tên Shop <span class="text-danger">*</span></label>
                            <input type="text" class="form-control" name="shop_name" required placeholder="VD: Thời Trang ABC">
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-medium">Rating (0 - 5)</label>
                            <input type="number" class="form-control" name="rating" value="4.5" min="0" max="5" step="0.1">
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-medium">Vị trí / Địa chỉ</label>
                            <input type="text" class="form-control" name="location" placeholder="VD: TP. Hồ Chí Minh">
                        </div>
                    </div>
                    <div class="modal-footer bg-light">
                        <button type="button" class="btn btn-light border" data-bs-dismiss="modal">Hủy</button>
                        <button type="submit" class="btn btn-shopee">Tạo Shop</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
