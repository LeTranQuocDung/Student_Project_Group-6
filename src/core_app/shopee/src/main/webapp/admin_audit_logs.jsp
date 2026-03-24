<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@page import="java.util.List" %>
        <%@page import="model.AuditLog" %>
            <%@page import="java.text.SimpleDateFormat" %>
                <!DOCTYPE html>
                <html lang="vi">

                <head>
                    <meta charset="UTF-8">
                    <title>Nhật Ký Hoạt Động | Shopee Admin</title>
                    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
                    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
                    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap"
                        rel="stylesheet">
                    <style>
                        :root {
                            --shopee-primary: #ee4d2d;
                            --shopee-hover: #f05d40;
                            --sidebar-width: 260px;
                            --bg-color: #f5f5f5;
                            --card-shadow: 0 1px 3px rgba(0, 0, 0, 0.12), 0 1px 2px rgba(0, 0, 0, 0.24);
                        }

                        body {
                            background: var(--bg-color);
                            font-family: 'Inter', sans-serif;
                            overflow-x: hidden;
                        }

                        .sidebar {
                            height: 100vh;
                            background: #fff;
                            width: var(--sidebar-width);
                            position: fixed;
                            box-shadow: 2px 0 10px rgba(0, 0, 0, 0.05);
                            z-index: 100;
                    overflow-y: auto;
                        }

                        .sidebar-logo {
                            display: flex;
                            align-items: center;
                            justify-content: center;
                            padding: 20px 0;
                            border-bottom: 1px solid #eee;
                        }

                        .sidebar-logo h4 {
                            color: var(--shopee-primary);
                            font-weight: 700;
                            margin: 0;
                            font-size: 22px;
                        }

                        .nav-item {
                            padding: 5px 15px;
                        }

                        .sidebar a {
                            color: #555;
                            text-decoration: none;
                            padding: 12px 20px;
                            display: flex;
                            align-items: center;
                            border-radius: 8px;
                            font-weight: 500;
                            transition: all 0.2s ease;
                            margin-bottom: 5px;
                        }

                        .sidebar a i {
                            width: 30px;
                            font-size: 18px;
                        }

                        .sidebar a:hover {
                            background-color: #fef0ee;
                            color: var(--shopee-primary);
                        }

                        .sidebar a.active {
                            background-color: var(--shopee-primary);
                            color: #fff;
                            box-shadow: 0 4px 6px rgba(238, 77, 45, 0.2);
                        }

                        .main-content {
                            margin-left: var(--sidebar-width);
                            padding: 30px 40px;
                        }

                        .top-header {
                            display: flex;
                            justify-content: space-between;
                            align-items: center;
                            background: #fff;
                            padding: 15px 30px;
                            border-radius: 12px;
                            box-shadow: var(--card-shadow);
                            margin-bottom: 30px;
                        }

                        .content-box {
                            background: #fff;
                            padding: 25px;
                            border-radius: 12px;
                            box-shadow: var(--card-shadow);
                        }

                        .badge-create {
                            background: #d4edda;
                            color: #155724;
                        }

                        .badge-update {
                            background: #cce5ff;
                            color: #004085;
                        }

                        .badge-delete {
                            background: #f8d7da;
                            color: #721c24;
                        }

                        .badge-restore {
                            background: #e2e3f1;
                            color: #383d6e;
                        }
                    </style>
                </head>

                <body>
                    <!-- Sidebar -->

                    <%@ include file="admin_sidebar.jsp" %>

                    <!-- Main Content -->
                    <div class="main-content">
                        <!-- Header -->
                        <div class="top-header">
                            <div>
                                <h4 class="m-0 fw-bold text-dark">Nhật Ký Hoạt Động</h4>
                                <small class="text-muted">Theo dõi và truy xuát các thao tác của hệ thống</small>
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
                                    <img src="https://ui-avatars.com/api/?name=Admin&background=ee4d2d&color=fff&rounded=true"
                                        width="45">
                                    <div class="d-flex flex-column">
                                        <span class="fw-bold" style="font-size: 14px;">Super Admin</span>
                                        <span class="text-muted" style="font-size: 12px;">Quản trị viên</span>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Content Box -->
                        <div class="content-box">
                            <div class="d-flex justify-content-between align-items-center mb-4">
                                <h5 class="fw-bold m-0 text-dark"><i class="fas fa-history me-2 text-muted"></i>Lịch sử truy vết</h5>
                            </div>

                            <div class="table-responsive">
                                <table class="table table-hover border align-middle">
                                    <thead class="table-light">
                                        <tr>
                                            <th width="80">ID</th>
                                            <th width="150">Thời Gian</th>
                                            <th width="150">Admin</th>
                                            <th width="120" class="text-center">Hành Động</th>
                                            <th width="120" class="text-center">Bảng</th>
                                            <th width="80" class="text-center">Ref ID</th>
                                            <th>Chi Tiết</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <% List<AuditLog> logs=(List<AuditLog>) request.getAttribute("logs");
                                            SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
                                            if(logs !=null) { for(AuditLog log : logs) { 
                                                String actionClass="badge-secondary";
                                                String icon = "fa-circle";
                                                switch(log.getAction().toUpperCase()) {
                                                    case "CREATE": actionClass="badge-create"; icon="fa-plus"; break;
                                                    case "UPDATE": actionClass="badge-update"; icon="fa-edit"; break;
                                                    case "DELETE": actionClass="badge-delete"; icon="fa-trash"; break;
                                                    case "RESTORE": actionClass="badge-restore"; icon="fa-undo"; break;
                                                }
                                                %>
                                            <tr>
                                                <td class="text-muted">#<%= log.getId() %></td>
                                                <td class="text-muted" style="font-size: 13px;">
                                                    <i class="fas fa-clock me-1"></i> <%= log.getCreatedAt() != null ? sdf.format(log.getCreatedAt()) : "" %>
                                                </td>
                                                <td class="fw-bold"><i class="fas fa-user-shield me-1 text-primary"></i> <%= log.getAdminName() != null ? log.getAdminName() : "Unknown (" + log.getAdminId() + ")" %></td>
                                                <td class="text-center">
                                                    <span class="badge rounded-pill px-3 py-2 w-100 <%= actionClass %>">
                                                        <i class="fas <%= icon %> me-1"></i> <%= log.getAction() %>
                                                    </span>
                                                </td>
                                                <td class="text-center fw-medium text-secondary"><%= log.getTargetTable() %></td>
                                                <td class="text-center fw-bold">#<%= log.getTargetId() %></td>
                                                <td><%= log.getDetails() %></td>
                                            </tr>
                                            <% } } %>
                                    </tbody>
                                </table>
                            </div>

                            <% if(logs==null || logs.isEmpty()) { %>
                                <div class="text-center py-5 text-muted">
                                    <i class="fas fa-inbox fa-3x mb-3"></i>
                                    <h5>Ch&#432;a c&#243; nh&#7853;t k&#253; n&#224;o</h5>
                                    <p>C&#225;c thao t&#225;c c&#7911;a Admin s&#7869; &#273;&#432;&#7907;c ghi l&#7841;i t&#7841;i &#273;&#226;y.</p>
                                </div>
                            <% } %>

                            <!-- Pagination -->
                            <% 
                                Integer currentPageAttr = (Integer) request.getAttribute("currentPage");
                                Integer totalPagesAttr = (Integer) request.getAttribute("totalPages");
                                int pgNum = (currentPageAttr != null) ? currentPageAttr : 1;
                                int pgTotal = (totalPagesAttr != null) ? totalPagesAttr : 1;
                                if (pgTotal > 1) { 
                            %>
                            <nav aria-label="Page navigation" class="mt-4">
                                <ul class="pagination justify-content-center">
                                    <li class="page-item <%= (pgNum == 1) ? "disabled" : "" %>">
                                        <a class="page-link" href="?page=<%= pgNum - 1 %>" aria-label="Previous">
                                            <span aria-hidden="true">&laquo;</span>
                                        </a>
                                    </li>
                                    <% for (int i = 1; i <= pgTotal; i++) { %>
                                        <li class="page-item <%= (pgNum == i) ? "active" : "" %>">
                                            <a class="page-link" href="?page=<%= i %>"><%= i %></a>
                                        </li>
                                    <% } %>
                                    <li class="page-item <%= (pgNum == pgTotal) ? "disabled" : "" %>">
                                        <a class="page-link" href="?page=<%= pgNum + 1 %>" aria-label="Next">
                                            <span aria-hidden="true">&raquo;</span>
                                        </a>
                                    </li>
                                </ul>
                            </nav>
                            <% } %>
                        </div>
                    </div>

                    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
                </body>

                </html>
