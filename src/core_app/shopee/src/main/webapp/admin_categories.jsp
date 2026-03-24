<%@page import="java.util.List" %>
<%@page import="model.Category" %>
<%@page contentType="text/html" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <title>Quản lý Danh Mục | Shopee Clone</title>
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

        .table-category img {
            width: 60px;
            height: 60px;
            object-fit: cover;
            border-radius: 4px;
            border: 1px solid #eee;
        }

        .table-category td {
            vertical-align: middle;
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
                <h4 class="m-0 fw-bold text-dark">Quản lý Danh Mục</h4>
                <small class="text-muted">Danh sách và thông tin danh mục sản phẩm</small>
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

        <!-- Content Box -->
        <div class="content-box">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h5 class="fw-bold m-0 text-dark">
                    <% if (request.getAttribute("isTrash") != null && (Boolean) request.getAttribute("isTrash")) { %>
                        Thùng Rác Danh Mục
                    <% } else { %>
                        Danh sách danh mục
                    <% } %>
                </h5>
                <div class="d-flex gap-2">
                    <% if (request.getAttribute("isTrash") != null && (Boolean) request.getAttribute("isTrash")) { %>
                        <a href="admin-categories" class="btn btn-secondary shadow-sm">
                            <i class="fas fa-arrow-left me-1"></i> Quay lại
                        </a>
                    <% } else { %>
                        <a href="admin-categories?action=view_trash" class="btn btn-warning shadow-sm">
                            <i class="fas fa-trash-alt me-1"></i> Xem Thùng Rác
                        </a>
                        <button class="btn btn-shopee shadow-sm" data-bs-toggle="modal" data-bs-target="#addModal">
                            <i class="fas fa-plus me-1"></i> Thêm Mới
                        </button>
                    <% } %>
                </div>
            </div>

            <!-- Search Box & Bulk Actions -->
            <div class="d-flex justify-content-between align-items-center mb-4">
                <!-- Left: Search Box (Có thể mở rộng sau nếu cần) -->
                <div></div>
                
                <!-- Right: Bulk Actions -->
                <div class="bulk-actions" style="display: none;" id="bulk-action-bar">
                    <span class="me-2 text-muted fw-medium"><span id="selected-count">0</span> danh mục đã chọn</span>
                    <% if (request.getAttribute("isTrash") != null && (Boolean) request.getAttribute("isTrash")) { %>
                        <button type="button" class="btn btn-outline-success shadow-sm" onclick="submitBulkAction('bulk_restore')">
                            <i class="fas fa-undo me-1"></i> Khôi phục mục chọn
                        </button>
                        <button type="button" class="btn btn-danger shadow-sm ms-2" onclick="submitBulkAction('bulk_delete_permanent')">
                            <i class="fas fa-trash-alt me-1"></i> Xóa vĩnh viễn mục chọn
                        </button>
                    <% } else { %>
                        <button type="button" class="btn btn-outline-danger shadow-sm" onclick="submitBulkAction('bulk_delete')">
                            <i class="fas fa-trash me-1"></i> Xóa mục chọn
                        </button>
                    <% } %>
                </div>
            </div>

            <!-- Main Table Form -->
            <form id="bulkForm" action="admin-categories" method="POST">
                <input type="hidden" name="action" id="bulk-action-input" value="">
                <div class="table-responsive">
                <table class="table table-hover table-category border">
                    <thead class="table-light">
                        <tr>
                            <th width="40" class="text-center">
                                <input class="form-check-input" type="checkbox" id="selectAll">
                            </th>
                            <th width="80">ID</th>
                            <th width="100">Hình Ảnh</th>
                            <th>Tên Danh Mục</th>
                            <th width="200" class="text-center">Hành Động</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% List<Category> categories = (List<Category>) request.getAttribute("categories");
                                if(categories != null) {
                                for(Category c : categories) {
                                %>
                                <tr>
                                    <td class="text-center">
                                        <input class="form-check-input row-checkbox" type="checkbox" name="selectedIds" value="<%= c.getId() %>">
                                    </td>
                                    <td>#<%= c.getId() %>
                                    </td>
                                    <td>
                                        <img src="<%= c.getImageUrl() %>" alt="Category">
                                    </td>
                                    <td class="fw-medium">
                                        <%= c.getName() %>
                                    </td>
                                    <td class="text-center">
                                        <% if (request.getAttribute("isTrash") != null && (Boolean) request.getAttribute("isTrash")) { %>
                                            <form action="admin-categories" method="POST" style="display:inline;">
                                                <input type="hidden" name="action" value="restore">
                                                <input type="hidden" name="id" value="<%= c.getId() %>">
                                                <button type="submit" class="btn btn-sm btn-outline-success shadow-sm">
                                                    <i class="fas fa-undo"></i> Khôi phục
                                                </button>
                                            </form>
                                        <% } else { %>
                                            <button class="btn btn-sm btn-outline-primary shadow-sm"
                                                onclick="openEditModal(<%= c.getId() %>, '<%= c.getName().replace("'", "\\\\'") %>', '<%= c.getImageUrl() %>')">
                                                <i class="fas fa-edit"></i> Sửa
                                            </button>
                                            <form action="admin-categories" method="POST" style="display:inline;"
                                                onsubmit="return confirm('Bạn có chắc chắn muốn xóa danh mục này?');">
                                                <input type="hidden" name="action" value="delete">
                                                <input type="hidden" name="id" value="<%= c.getId() %>">
                                                <button type="submit" class="btn btn-sm btn-outline-danger shadow-sm">
                                                    <i class="fas fa-trash"></i> Xóa
                                                </button>
                                            </form>
                                        <% } %>
                                    </td>
                                </tr>
                                <% } } %>
                    </tbody>
                </table>
                <% if(categories == null || categories.isEmpty()) { %>
                    <div class="text-center py-4 text-muted">
                        <i class="fas fa-tags fa-2x mb-2"></i>
                        <p class="mb-0">Chưa có danh mục nào.</p>
                    </div>
                <% } %>
            </div>
            </form>
        </div>
    </div>

    <!-- Add Modal -->
    <div class="modal fade" id="addModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title fw-bold">Thêm Danh Mục Mới</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form action="admin-categories" method="POST">
                    <div class="modal-body">
                        <input type="hidden" name="action" value="add">
                        <div class="mb-3">
                            <label class="form-label fw-medium">Tên Danh Mục <span class="text-danger">*</span></label>
                            <input type="text" class="form-control" name="name" required placeholder="Nhập tên danh mục...">
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-medium">Link Hình Ảnh</label>
                            <input type="url" class="form-control" name="image_url" placeholder="https://... / images/...">
                            <small class="text-muted">Để trống sẽ dùng ảnh mặc định.</small>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-light border" data-bs-dismiss="modal">Hủy</button>
                        <button type="submit" class="btn btn-shopee">Lưu Danh Mục</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Edit Modal -->
    <div class="modal fade" id="editModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title fw-bold">Cập Nhật Danh Mục</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form action="admin-categories" method="POST">
                    <div class="modal-body">
                        <input type="hidden" name="action" value="edit">
                        <input type="hidden" name="id" id="edit-id">
                        <div class="mb-3">
                            <label class="form-label fw-medium">Tên Danh Mục <span class="text-danger">*</span></label>
                            <input type="text" class="form-control" name="name" id="edit-name" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-medium">Link Hình Ảnh</label>
                            <input type="url" class="form-control" name="image_url" id="edit-image">
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-light border" data-bs-dismiss="modal">Hủy</button>
                        <button type="submit" class="btn btn-shopee">Cập Nhật</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function openEditModal(id, name, image) {
            document.getElementById('edit-id').value = id;
            document.getElementById('edit-name').value = name;
            document.getElementById('edit-image').value = image;

            var editModal = new bootstrap.Modal(document.getElementById('editModal'));
            editModal.show();
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
            if(actionName === 'bulk_delete') msg = "Bạn có chắc chắn muốn xóa " + count + " danh mục đã chọn vào thùng rác không?";
            else if(actionName === 'bulk_delete_permanent') msg = "⚠️ CẢNH BÁO: Rất nhiều sản phẩm phụ thuộc vào Danh Mục. Việc XÓA VĨNH VIỄN " + count + " danh mục này có thể gây lỗi. Phê duyệt?";
            else if(actionName === 'bulk_restore') msg = "Khôi phục " + count + " danh mục đã chọn?";

            if (confirm(msg)) {
                document.getElementById('bulk-action-input').value = actionName;
                document.getElementById('bulkForm').submit();
            }
        }
    </script>
</body>

</html>
