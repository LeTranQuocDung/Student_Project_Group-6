<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@page import="java.util.List" %>
        <%@page import="model.User" %>
            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <title>Quản lý Khách Hàng | Shopee Admin</title>
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

                    .btn-shopee {
                        background-color: var(--shopee-primary);
                        color: white;
                        border: none;
                    }

                    .btn-shopee:hover {
                        background-color: var(--shopee-hover);
                        color: white;
                    }

                    .user-avatar {
                        width: 40px;
                        height: 40px;
                        border-radius: 50%;
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        font-weight: 700;
                        font-size: 16px;
                        color: #fff;
                    }

                    .wallet-badge {
                        background: #e8f5e9;
                        color: #2e7d32;
                        font-weight: 600;
                        border-radius: 20px;
                        padding: 4px 12px;
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
                            <h4 class="m-0 fw-bold text-dark">Quản Lý Khách Hàng</h4>
                            <small class="text-muted">Danh sách và thông tin người dùng</small>
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
                            <h5 class="fw-bold m-0 text-dark"><i class="fas fa-users me-2 text-muted"></i>
                                <% if (request.getAttribute("isTrash") != null && (Boolean) request.getAttribute("isTrash")) { %>
                                    Thùng rác khách hàng
                                <% } else { %>
                                    Danh sách khách hàng
                                <% } %>
                            </h5>
                            <div class="d-flex gap-2 align-items-center">
                                <span class="badge bg-secondary fs-6">
                                    <% List<User> users = (List<User>) request.getAttribute("users");
                                            out.print(users != null ? users.size() : 0);
                                            %> người dùng
                                </span>
                                <% if (request.getAttribute("isTrash") != null && (Boolean) request.getAttribute("isTrash")) { %>
                                    <a href="admin-users" class="btn btn-secondary btn-sm shadow-sm ms-2">
                                        <i class="fas fa-arrow-left me-1"></i> Quay lại
                                    </a>
                                <% } else { %>
                                    <a href="admin-users?action=view_trash" class="btn btn-warning btn-sm shadow-sm ms-2">
                                        <i class="fas fa-trash-alt me-1"></i> Xem Thùng Rác
                                    </a>
                                <% } %>
                            </div>
                        </div>

                        <!-- Bulk Actions -->
                        <div class="bulk-actions mb-4" style="display: none;" id="bulk-action-bar">
                            <span class="me-2 text-muted fw-medium"><span id="selected-count">0</span> khách hàng đã chọn</span>
                            <% if (request.getAttribute("isTrash") != null && (Boolean) request.getAttribute("isTrash")) { %>
                                <button type="button" class="btn btn-outline-success shadow-sm" onclick="submitBulkAction('bulk_restore')">
                                    <i class="fas fa-undo me-1"></i> Khôi phục mục chọn
                                </button>
                                <button type="button" class="btn btn-danger shadow-sm ms-2" onclick="submitBulkAction('bulk_delete_permanent')">
                                    <i class="fas fa-trash-alt me-1"></i> Xóa vĩnh viễn mục chọn
                                </button>
                            <% } else { %>
                                <button type="button" class="btn btn-outline-danger shadow-sm" onclick="submitBulkAction('bulk_delete')">
                                    <i class="fas fa-user-times me-1"></i> Cấm mục chọn
                                </button>
                            <% } %>
                        </div>

                        <!-- Main Table Form -->
                        <form id="bulkForm" action="admin-users" method="POST">
                            <input type="hidden" name="action" id="bulk-action-input" value="">
                        <div class="table-responsive">
                            <table class="table table-hover border align-middle">
                                <thead class="table-light">
                                    <tr>
                                        <th width="40" class="text-center">
                                            <input class="form-check-input" type="checkbox" id="selectAll">
                                        </th>
                                        <th width="60">ID</th>
                                        <th>Tên Khách Hàng</th>
                                        <th>Email</th>
                                        <th>Số Điện Thoại</th>
                                        <th width="140" class="text-end">Số Dư Ví</th>
                                        <th width="100" class="text-center">Vai Trò</th>
                                        <th width="120" class="text-center">Hành Động</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% String[]
                                        colors={"#ee4d2d","#007bff","#28a745","#6f42c1","#fd7e14","#20c997","#e83e8c"};
                                        if(users !=null) { int idx=0; for(User u : users) { String color=colors[idx %
                                        colors.length]; String initials="" ; if(u.getFullName() !=null &&
                                        !u.getFullName().isEmpty()) { String[]
                                        parts=u.getFullName().trim().split("\\s+"); initials=parts.length> 1
                                        ? ("" + parts[0].charAt(0) + parts[parts.length-1].charAt(0)).toUpperCase()
                                        : ("" + parts[0].charAt(0)).toUpperCase();
                                        }
                                        idx++;
                                        %>
                                        <tr>
                                            <td class="text-center">
                                                <input class="form-check-input row-checkbox" type="checkbox" name="selectedIds" value="<%= u.getId() %>">
                                            </td>
                                            <td class="fw-bold text-muted">#<%= u.getId() %>
                                            </td>
                                            <td>
                                                <div class="d-flex align-items-center gap-2">
                                                    <div class="user-avatar" style="background: <%= color %>;">
                                                        <%= initials %>
                                                    </div>
                                                    <span class="fw-medium">
                                                        <%= u.getFullName() !=null ? u.getFullName() : "N/A" %>
                                                    </span>
                                                </div>
                                            </td>
                                            <td class="text-muted">
                                                <%= u.getEmail() !=null ? u.getEmail() : "N/A" %>
                                            </td>
                                            <td>
                                                <%= u.getPhone() !=null ? u.getPhone() : "N/A" %>
                                            </td>
                                            <td class="text-end">
                                                <span class="wallet-badge">
                                                    <%= String.format("%,.0f", u.getWallet()) %> đ
                                                </span>
                                            </td>
                                            <td class="text-center">
                                                <span class="badge bg-info text-dark px-3 py-2">
                                                    <%= u.getRole() !=null ? u.getRole().toUpperCase() : "USER" %>
                                                </span>
                                            </td>
                                            <td class="text-center">
                                                <% if (request.getAttribute("isTrash") != null && (Boolean) request.getAttribute("isTrash")) { %>
                                                    <form action="admin-users" method="POST" style="display:inline;">
                                                        <input type="hidden" name="action" value="restore">
                                                        <input type="hidden" name="id" value="<%= u.getId() %>">
                                                        <button type="submit" class="btn btn-sm btn-outline-success shadow-sm mb-1">
                                                            <i class="fas fa-undo"></i> Khôi phục
                                                        </button>
                                                    </form>
                                                <% } else { %>
                                                    <button type="button" class="btn btn-sm btn-outline-primary shadow-sm mb-1"
                                                            onclick="openAssignRoleModal(<%= u.getId() %>, '<%= u.getFullName().replace("'", "\\\\'") %>', <%= u.getAdminRoleId() != null ? u.getAdminRoleId() : "0" %>, '<%= u.getRole() %>')">
                                                        <i class="fas fa-exchange-alt"></i> Cấp/Thu Quyền
                                                    </button>
                                                    <form action="admin-users" method="POST" style="display:inline;"
                                                        onsubmit="return confirm('Bạn có chắc chắn muốn xóa người dùng này?');">
                                                        <input type="hidden" name="action" value="delete">
                                                        <input type="hidden" name="id" value="<%= u.getId() %>">
                                                        <button type="submit" class="btn btn-sm btn-outline-danger shadow-sm mb-1">
                                                            <i class="fas fa-trash"></i> Xóa
                                                        </button>
                                                    </form>
                                                <% } %>
                                            </td>
                                        </tr>
                                        <% } } %>
                                </tbody>
                            </table>
                        </div>
                        </form>

                        <% if(users==null || users.isEmpty()) { %>
                            <div class="text-center py-5 text-muted">
                                <i class="fas fa-users fa-3x mb-3"></i>
                                <h5>Chưa có khách hàng nào</h5>
                                <p>Người dùng đăng ký sẽ hiển thị ở đây.</p>
                            </div>
                            <% } %>
                    </div>
                </div>

                <!-- Assign Role Modal -->
                <div class="modal fade" id="assignRoleModal" tabindex="-1" aria-hidden="true">
                    <div class="modal-dialog">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title fw-bold">Cấp/Thu Quyền <span id="assign-role-username" class="text-primary"></span></h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                            </div>
                            <form action="admin-users" method="POST">
                                <div class="modal-body">
                                    <input type="hidden" name="action" value="assign_role">
                                    <input type="hidden" name="id" id="assign-role-id">
                                    
                                    <div class="mb-3">
                                        <label class="form-label fw-medium">Chọn Vai Trò (Nhóm Quyền)</label>
                                        <select class="form-select" name="admin_role_id" id="assign-role-select">
                                            <option value="0">-- Khách Hàng (Tước quyền Admin) --</option>
                                            <% 
                                            List<model.Role> adminRoles = (List<model.Role>) request.getAttribute("adminRoles");
                                            if (adminRoles != null) {
                                                for (model.Role r : adminRoles) {
                                            %>
                                            <option value="<%= r.getId() %>"><%= r.getName() %> - <%= r.getDescription() %></option>
                                            <%  }
                                            } %>
                                        </select>
                                        <div class="form-text mt-2 text-danger">Lưu ý: Nếu chọn "Khách Hàng", người dùng sẽ bị tước mọi quyền quản trị hệ thống.</div>
                                    </div>
                                </div>
                                <div class="modal-footer bg-light">
                                    <button type="button" class="btn btn-light border" data-bs-dismiss="modal">Hủy</button>
                                    <button type="submit" class="btn btn-shopee">Áp dụng</button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>

                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
                <script>
                    function openAssignRoleModal(id, name, roleId, currentRole) {
                        document.getElementById('assign-role-id').value = id;
                        document.getElementById('assign-role-username').innerText = name;
                        
                        let select = document.getElementById('assign-role-select');
                        if (currentRole.toLowerCase() === 'admin' && roleId > 0) {
                            select.value = roleId;
                        } else {
                            select.value = '0';
                        }
                        
                        var assignRoleModal = new bootstrap.Modal(document.getElementById('assignRoleModal'));
                        assignRoleModal.show();
                    }

                    // --- Bulk Actions Script ---
                    document.addEventListener("DOMContentLoaded", function () {
                        const selectAllCheckbox = document.getElementById('selectAll');
                        const rowCheckboxes = document.querySelectorAll('.row-checkbox');
                        const bulkActionBar = document.getElementById('bulk-action-bar');
                        const selectedCountSpan = document.getElementById('selected-count');

                        function updateBulkActionVisibility() {
                            const checkedCount = document.querySelectorAll('.row-checkbox:checked').length;
                            selectedCountSpan.textContent = checkedCount;
                            if (checkedCount > 0) {
                                bulkActionBar.style.display = 'block';
                            } else {
                                bulkActionBar.style.display = 'none';
                                selectAllCheckbox.checked = false;
                            }
                        }

                        if (selectAllCheckbox) {
                            selectAllCheckbox.addEventListener('change', function () {
                                rowCheckboxes.forEach(cb => {
                                    cb.checked = selectAllCheckbox.checked;
                                });
                                updateBulkActionVisibility();
                            });
                        }

                        rowCheckboxes.forEach(cb => {
                            cb.addEventListener('change', function () {
                                const allChecked = document.querySelectorAll('.row-checkbox:checked').length === rowCheckboxes.length;
                                selectAllCheckbox.checked = allChecked;
                                updateBulkActionVisibility();
                            });
                        });
                    });

                    function submitBulkAction(actionName) {
                        const count = document.querySelectorAll('.row-checkbox:checked').length;
                        if (count === 0) return;
                        
                        let msg = "";
                        if(actionName === 'bulk_delete') msg = "Bạn có chắc chắn muốn cấm (Ban) " + count + " người dùng đã chọn vào thùng rác không?";
                        else if(actionName === 'bulk_delete_permanent') msg = "⚠️ CẢNH BÁO: Rất nhiều đơn hàng phụ thuộc vào User ID. Việc XÓA VĨNH VIỄN " + count + " tài khoản này có thể gây lỗi. Phê duyệt?";
                        else if(actionName === 'bulk_restore') msg = "Khôi phục " + count + " người dùng đã chọn?";

                        if (confirm(msg)) {
                            document.getElementById('bulk-action-input').value = actionName;
                            document.getElementById('bulkForm').submit();
                        }
                    }
                </script>
            </body>

            </html>