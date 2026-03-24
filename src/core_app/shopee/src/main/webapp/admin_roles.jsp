<%@page import="java.util.List" %>
<%@page import="model.Role" %>
<%@page import="model.Permission" %>
<%@page contentType="text/html" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <title>Phân Quyền Hệ Thống | Shopee Clone</title>
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

        body {
            background: var(--bg-color);
            font-family: 'Inter', sans-serif;
            overflow-x: hidden;
        }

        .sidebar {
            height: 100vh;
            background: #ffffff;
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
            color: #ffffff;
            box-shadow: 0 4px 6px rgba(238, 77, 45, 0.2);
        }

        .main-content {
            margin-left: var(--sidebar-width);
            padding: 30px 40px;
        }

        /* Header */
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

        .btn-shopee {
            background-color: var(--shopee-primary);
            color: white;
            border: none;
        }

        .btn-shopee:hover {
            background-color: var(--shopee-hover);
            color: white;
        }
        
        .perm-badge {
            background-color: #fef0ee;
            color: var(--shopee-primary);
            border: 1px solid #ffdec9;
            font-size: 12px;
            padding: 4px 8px;
            margin: 2px;
            border-radius: 4px;
            display: inline-block;
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
                <h4 class="m-0 fw-bold text-dark">Quản lý Phân Quyền (RBAC)</h4>
                <small class="text-muted">Tạo mới, sửa đổi vai trò và phân quyền trên hệ thống</small>
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

        <!-- Content Box -->
        <div class="content-box">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h5 class="fw-bold m-0 text-dark">Danh sách Nhóm Quyền</h5>
                <button class="btn btn-shopee shadow-sm" data-bs-toggle="modal" data-bs-target="#addModal">
                    <i class="fas fa-plus me-1"></i> Tạo Nhóm Quyền Mới
                </button>
            </div>

            <div class="table-responsive">
                <table class="table table-hover border">
                    <thead class="table-light">
                        <tr>
                            <th width="80">ID</th>
                            <th width="200">Tên Nhóm</th>
                            <th>Mô tả</th>
                            <th>Các Quyền (Permissions)</th>
                            <th width="150" class="text-center">Hành Động</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% 
                        List<Role> roles = (List<Role>) request.getAttribute("roles");
                        List<Permission> allPermissions = (List<Permission>) request.getAttribute("allPermissions");
                        if(roles != null) {
                            for(Role r : roles) {
                        %>
                                <tr>
                                    <td>#<%= r.getId() %></td>
                                    <td class="fw-bold text-primary"><%= r.getName() %></td>
                                    <td class="text-muted"><%= r.getDescription() != null ? r.getDescription() : "" %></td>
                                    <td>
                                        <% if(r.getId() == 1) { %>
                                            <span class="badge bg-danger shadow-sm"><i class="fas fa-star text-warning"></i> Full Quyền Hệ Thống</span>
                                        <% } else {
                                            List<Permission> rPerms = r.getPermissions();
                                            if (rPerms != null && !rPerms.isEmpty()) {
                                                for(Permission p : rPerms) { %>
                                                    <span class="perm-badge"><%= p.getDescription() %></span>
                                                <% }
                                            } else { %>
                                                <span class="text-muted fst-italic">Chưa cấp quyền</span>
                                            <% }
                                        } %>
                                    </td>
                                    <td class="text-center">
                                        <% if (r.getId() != 1) { %>
                                            <button class="btn btn-sm btn-outline-primary shadow-sm"
                                                onclick='openEditModal(<%= r.getId() %>, "<%= r.getName() %>", "<%= r.getDescription() %>", <%= 
                                                // Generate JSON array of permission IDs
                                                "[" + r.getPermissions().stream().map(p -> "\"" + p.getId() + "\"").reduce((a, b) -> a + "," + b).orElse("") + "]" 
                                                %>)'>
                                                <i class="fas fa-edit"></i>
                                            </button>
                                            <form action="admin-roles" method="POST" style="display:inline;"
                                                onsubmit="return confirm('Xóa nhóm quyền có thể tước quyền truy cập của nhiều Admin liên quan. Bạn chắc chứ?');">
                                                <input type="hidden" name="action" value="delete">
                                                <input type="hidden" name="id" value="<%= r.getId() %>">
                                                <button type="submit" class="btn btn-sm btn-outline-danger shadow-sm">
                                                    <i class="fas fa-trash"></i>
                                                </button>
                                            </form>
                                        <% } else { %>
                                            <span class="badge bg-secondary">Mặc định</span>
                                        <% } %>
                                    </td>
                                </tr>
                        <%  } 
                        } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <!-- Add Modal -->
    <div class="modal fade" id="addModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title fw-bold">Tạo Nhóm Quyền Mới</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form action="admin-roles" method="POST">
                    <div class="modal-body">
                        <input type="hidden" name="action" value="create">
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label class="form-label fw-medium">Tên Nhóm <span class="text-danger">*</span></label>
                                <input type="text" class="form-control" name="name" required placeholder="VD: Quản lý Kho...">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label fw-medium">Mô tả</label>
                                <input type="text" class="form-control" name="description" placeholder="Nhân sự duyệt kho và quản lý mã vận đơn">
                            </div>
                        </div>
                        <hr>
                        <h6 class="fw-bold mb-3 text-dark">Gán quyền hạn hệ thống</h6>
                        <div class="row">
                            <% if (allPermissions != null) {
                                for (Permission p : allPermissions) { %>
                            <div class="col-md-6 mb-2">
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" name="permissions" value="<%= p.getId() %>" id="add_perm_<%= p.getId() %>">
                                    <label class="form-check-label" for="add_perm_<%= p.getId() %>">
                                        <%= p.getDescription() %> <br><small class="text-muted">(<%= p.getId() %>)</small>
                                    </label>
                                </div>
                            </div>
                            <%  }
                               } %>
                        </div>
                    </div>
                    <div class="modal-footer bg-light">
                        <button type="button" class="btn btn-light border" data-bs-dismiss="modal">Hủy</button>
                        <button type="submit" class="btn btn-shopee">Lưu Nhóm Quyền</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Edit Modal -->
    <div class="modal fade" id="editModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title fw-bold">Cập Nhật Nhóm Quyền</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form action="admin-roles" method="POST">
                    <div class="modal-body">
                        <input type="hidden" name="action" value="update">
                        <input type="hidden" name="id" id="edit-id">
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label class="form-label fw-medium">Tên Nhóm <span class="text-danger">*</span></label>
                                <input type="text" class="form-control" name="name" id="edit-name" required>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label fw-medium">Mô tả</label>
                                <input type="text" class="form-control" name="description" id="edit-desc">
                            </div>
                        </div>
                        <hr>
                        <h6 class="fw-bold mb-3 text-dark">Gán quyền hạn hệ thống</h6>
                        <div class="row">
                            <% if (allPermissions != null) {
                                for (Permission p : allPermissions) { %>
                            <div class="col-md-6 mb-2">
                                <div class="form-check">
                                    <input class="form-check-input edit-perm-checkbox" type="checkbox" name="permissions" value="<%= p.getId() %>" id="edit_perm_<%= p.getId() %>">
                                    <label class="form-check-label" for="edit_perm_<%= p.getId() %>">
                                        <%= p.getDescription() %> <br><small class="text-muted">(<%= p.getId() %>)</small>
                                    </label>
                                </div>
                            </div>
                            <%  }
                               } %>
                        </div>
                    </div>
                    <div class="modal-footer bg-light">
                        <button type="button" class="btn btn-light border" data-bs-dismiss="modal">Hủy</button>
                        <button type="submit" class="btn btn-shopee">Cập Nhật</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function openEditModal(id, name, desc, permissions) {
            document.getElementById('edit-id').value = id;
            document.getElementById('edit-name').value = name;
            document.getElementById('edit-desc').value = desc !== "null" ? desc : "";

            // Reset checkboxes
            document.querySelectorAll('.edit-perm-checkbox').forEach(cb => cb.checked = false);

            // Tick active permissions
            permissions.forEach(pId => {
                let cb = document.getElementById('edit_perm_' + pId);
                if (cb) cb.checked = true;
            });

            var editModal = new bootstrap.Modal(document.getElementById('editModal'));
            editModal.show();
        }
    </script>
</body>

</html>
