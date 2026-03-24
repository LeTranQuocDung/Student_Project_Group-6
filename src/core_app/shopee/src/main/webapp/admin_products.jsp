<%@page import="java.util.List" %>
    <%@page import="model.Product" %>
    <%@page import="model.Category" %>
    <%@page import="model.Shop" %>
        <%@page contentType="text/html" pageEncoding="UTF-8" %>
            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <title>Quản lý Sản Phẩm | Shopee Clone</title>
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

                    .table-product img {
                        width: 60px;
                        height: 60px;
                        object-fit: cover;
                        border-radius: 4px;
                        border: 1px solid #eee;
                    }

                    .table-product td {
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
                            <h4 class="m-0 fw-bold text-dark">Quản lý Sản Phẩm</h4>
                            <small class="text-muted">Danh sách và thông tin chi tiết</small>
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
                            <h5 class="fw-bold m-0 text-dark">
                                <% if (request.getAttribute("isTrash") != null && (Boolean) request.getAttribute("isTrash")) { %>
                                    Thùng Rác Sản Phẩm
                                <% } else { %>
                                    Danh sách sản phẩm
                                <% } %>
                            </h5>
                            <div class="d-flex gap-2">
                                <% if (request.getAttribute("isTrash") != null && (Boolean) request.getAttribute("isTrash")) { %>
                                    <a href="admin-products" class="btn btn-secondary shadow-sm">
                                        <i class="fas fa-arrow-left me-1"></i> Quay lại
                                    </a>
                                <% } else { %>
                                    <a href="admin-products?action=view_trash" class="btn btn-warning shadow-sm">
                                        <i class="fas fa-trash-alt me-1"></i> Xem Thùng Rác
                                    </a>
                                    <button class="btn btn-shopee shadow-sm" data-bs-toggle="modal" data-bs-target="#addModal">
                                        <i class="fas fa-plus me-1"></i> Thêm Sản Phẩm Mới
                                    </button>
                                <% } %>
                            </div>
                        </div>

                        <!-- Search Box & Bulk Actions -->
                        <div class="d-flex justify-content-between align-items-center mb-4">
                            <!-- Left: Search Box -->
                            <form action="admin-products" method="GET" class="m-0">
                                <% if (request.getAttribute("isTrash") != null && (Boolean) request.getAttribute("isTrash")) { %>
                                    <input type="hidden" name="action" value="view_trash">
                                <% } %>
                                <div class="input-group" style="width: 300px;">
                                    <input type="text" class="form-control" name="search" placeholder="Tìm kiếm sản phẩm..." value="${search}">
                                    <button class="btn btn-outline-secondary" type="submit"><i class="fas fa-search"></i></button>
                                </div>
                            </form>
                            
                            <!-- Right: Bulk Actions -->
                            <div class="bulk-actions" style="display: none;" id="bulk-action-bar">
                                <span class="me-2 text-muted fw-medium"><span id="selected-count">0</span> sản phẩm đã chọn</span>
                                <% if (request.getAttribute("isTrash") != null && (Boolean) request.getAttribute("isTrash")) { %>
                                    <button type="button" class="btn btn-outline-success shadow-sm shadow-sm" onclick="submitBulkAction('bulk_restore')">
                                        <i class="fas fa-undo me-1"></i> Khôi phục mục chọn
                                    </button>
                                    <button type="button" class="btn btn-danger shadow-sm ms-2 shadow-sm" onclick="submitBulkAction('bulk_delete_permanent')">
                                        <i class="fas fa-trash-alt me-1"></i> Xóa vĩnh viễn mục chọn
                                    </button>
                                <% } else { %>
                                    <button type="button" class="btn btn-outline-danger shadow-sm shadow-sm" onclick="submitBulkAction('bulk_delete')">
                                        <i class="fas fa-trash me-1"></i> Xóa mục chọn
                                    </button>
                                <% } %>
                            </div>
                        </div>

                        <!-- Main Table Form -->
                        <form id="bulkForm" action="admin-products" method="POST">
                            <input type="hidden" name="action" id="bulk-action-input" value="">
                            <div class="table-responsive">
                            <table class="table table-hover table-product border">
                                <thead class="table-light">
                                    <tr>
                                        <th width="40" class="text-center">
                                            <input class="form-check-input" type="checkbox" id="selectAll">
                                        </th>
                                        <th width="80">ID</th>
                                        <th width="100">Hình Ảnh</th>
                                        <th>Tên Sản Phẩm</th>
                                        <th width="160">Shop</th>
                                        <th width="150" class="text-end">Giá (VNĐ)</th>
                                        <th width="200" class="text-center">Hành Động</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% List<Product> products = (List<Product>) request.getAttribute("products");
                                            if(products != null) {
                                            for(Product p : products) {
                                            %>
                                            <tr>
                                                <td class="text-center">
                                                    <input class="form-check-input row-checkbox" type="checkbox" name="selectedIds" value="<%= p.getId() %>">
                                                </td>
                                                <td>#<%= p.getId() %>
                                                </td>
                                                <td>
                                                    <img src="<%= p.getImageUrl() %>" alt="Product">
                                                </td>
                                                <td class="fw-medium">
                                                    <%= p.getName() %>
                                                </td>
                                                <td>
                                                    <a href="admin-shops?action=detail&id=<%= p.getShopId() %>" class="text-decoration-none">
                                                        <i class="fas fa-store text-muted me-1" style="font-size:12px;"></i>
                                                        <span class="text-primary fw-medium" style="font-size:13px;"><%= p.getShopName() != null ? p.getShopName() : "N/A" %></span>
                                                    </a>
                                                </td>
                                                <td class="text-end text-danger fw-bold">
                                                    <%= String.format("%,.0f", p.getPrice()) %> đ
                                                </td>
                                                <td class="text-center">
                                                    <% if (request.getAttribute("isTrash") != null && (Boolean) request.getAttribute("isTrash")) { %>
                                                        <button type="button" class="btn btn-sm btn-outline-success shadow-sm"
                                                            onclick="submitSingleAction('restore', <%= p.getId() %>)">
                                                            <i class="fas fa-undo"></i> Khôi phục
                                                        </button>
                                                    <% } else { %>
                                                        <button type="button" class="btn btn-sm btn-outline-primary shadow-sm"
                                                            onclick="openEditModal(<%= p.getId() %>, '<%= p.getName().replace("'", "\\\\'") %>', '<%= p.getPrice() %>', '<%= p.getImageUrl() %>', <%= p.getCategoryId() %>, <%= p.getShopId() %>)">
                                                            <i class="fas fa-edit"></i> Sửa
                                                        </button>
                                                        <button type="button" class="btn btn-sm btn-outline-danger shadow-sm"
                                                            onclick="submitSingleAction('delete', <%= p.getId() %>)">
                                                            <i class="fas fa-trash"></i> Xóa
                                                        </button>
                                                    <% } %>
                                                </td>
                                            </tr>
                                            <% } } %>
                                </tbody>
                            </table>
                        </div>
                        </form>

                        <!-- Pagination -->
                        <% 
                            Integer cpObj = (Integer) request.getAttribute("currentPage");
                            Integer tpObj = (Integer) request.getAttribute("totalPages");
                            if (cpObj != null && tpObj != null) {
                                int pgNum = cpObj;
                                int pgTotal = tpObj;
                                String searchParam = (String) request.getAttribute("search");
                                String searchUrl = "";
                                if (searchParam != null && !searchParam.isEmpty()) {
                                    searchUrl += "&search=" + searchParam;
                                }
                                if (request.getAttribute("isTrash") != null && (Boolean) request.getAttribute("isTrash")) {
                                    searchUrl += "&action=view_trash";
                                }
                                if (pgTotal > 1) { 
                        %>
                        <nav aria-label="Page navigation" class="mt-4">
                            <ul class="pagination justify-content-center flex-wrap">
                                <li class="page-item <%= (pgNum == 1) ? "disabled" : "" %>">
                                    <a class="page-link" href="?page=<%= pgNum - 1 %><%= searchUrl %>" aria-label="Previous">
                                        <span aria-hidden="true">&laquo;</span>
                                    </a>
                                </li>
                                <% 
                                    int maxPagesToShow = 5;
                                    int startPage = Math.max(1, pgNum - 2);
                                    int endPage = Math.min(pgTotal, startPage + maxPagesToShow - 1);
                                    if (endPage - startPage + 1 < maxPagesToShow) {
                                        startPage = Math.max(1, endPage - maxPagesToShow + 1);
                                    }
                                    if (startPage > 1) { 
                                %>
                                    <li class="page-item"><a class="page-link" href="?page=1<%= searchUrl %>">1</a></li>
                                    <% if (startPage > 2) { %>
                                        <li class="page-item disabled"><span class="page-link">...</span></li>
                                    <% } %>
                                <% } %>
                                <% for (int i = startPage; i <= endPage; i++) { %>
                                    <li class="page-item <%= (pgNum == i) ? "active" : "" %>">
                                        <a class="page-link" href="?page=<%= i %><%= searchUrl %>"><%= i %></a>
                                    </li>
                                <% } %>
                                <% if (endPage < pgTotal) { %>
                                    <% if (endPage < pgTotal - 1) { %>
                                        <li class="page-item disabled"><span class="page-link">...</span></li>
                                    <% } %>
                                    <li class="page-item"><a class="page-link" href="?page=<%= pgTotal %><%= searchUrl %>"><%= pgTotal %></a></li>
                                <% } %>
                                <li class="page-item <%= (pgNum == pgTotal) ? "disabled" : "" %>">
                                    <a class="page-link" href="?page=<%= pgNum + 1 %><%= searchUrl %>" aria-label="Next">
                                        <span aria-hidden="true">&raquo;</span>
                                    </a>
                                </li>
                            </ul>
                        </nav>
                        <%      } 
                            } 
                        %>
                    </div>
                </div>

                <!-- Add Modal -->
                <div class="modal fade" id="addModal" tabindex="-1" aria-hidden="true">
                    <div class="modal-dialog">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title fw-bold">Thêm Sản Phẩm Mới</h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal"
                                    aria-label="Close"></button>
                            </div>
                            <form action="admin-products" method="POST">
                                <div class="modal-body">
                                    <input type="hidden" name="action" value="add">
                                    <div class="mb-3">
                                        <label class="form-label fw-medium">Tên Sản Phẩm <span
                                                class="text-danger">*</span></label>
                                        <input type="text" class="form-control" name="name" required
                                            placeholder="Nhập tên sản phẩm...">
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label fw-medium">Danh Mục <span class="text-danger">*</span></label>
                                        <select class="form-select" name="category_id" required>
                                            <% List<Category> cats = (List<Category>) request.getAttribute("categories");
                                                if(cats != null) {
                                                    for(Category c : cats) { %>
                                                        <option value="<%= c.getId() %>"><%= c.getName() %></option>
                                            <% } } %>
                                        </select>
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label fw-medium">Shop <span class="text-danger">*</span></label>
                                        <select class="form-select" name="shop_id" required>
                                            <% List<Shop> shopList = (List<Shop>) request.getAttribute("shops");
                                                if(shopList != null) {
                                                    for(Shop sh : shopList) { %>
                                                        <option value="<%= sh.getId() %>"><%= sh.getShopName() %></option>
                                            <% } } %>
                                        </select>
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label fw-medium">Giá Bán (VNĐ) <span
                                                class="text-danger">*</span></label>
                                        <input type="number" class="form-control" name="price" required
                                            min="0" step="1" placeholder="Ví dụ: 150000">
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label fw-medium">Link Hình Ảnh</label>
                                        <input type="url" class="form-control" name="image_url"
                                            placeholder="https://...">
                                        <small class="text-muted">Để trống sẽ dùng ảnh mặc định.</small>
                                    </div>
                                </div>
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-light border"
                                        data-bs-dismiss="modal">Hủy</button>
                                    <button type="submit" class="btn btn-shopee">Lưu Sản Phẩm</button>
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
                                <h5 class="modal-title fw-bold">Cập Nhật Sản Phẩm</h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal"
                                    aria-label="Close"></button>
                            </div>
                            <form action="admin-products" method="POST">
                                <div class="modal-body">
                                    <input type="hidden" name="action" value="edit">
                                    <input type="hidden" name="id" id="edit-id">
                                    <div class="mb-3">
                                        <label class="form-label fw-medium">Tên Sản Phẩm <span
                                                class="text-danger">*</span></label>
                                        <input type="text" class="form-control" name="name" id="edit-name" required>
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label fw-medium">Danh Mục <span class="text-danger">*</span></label>
                                        <select class="form-select" name="category_id" id="edit-category" required>
                                            <% if(cats != null) {
                                                for(Category c : cats) { %>
                                                    <option value="<%= c.getId() %>"><%= c.getName() %></option>
                                            <% } } %>
                                        </select>
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label fw-medium">Shop <span class="text-danger">*</span></label>
                                        <select class="form-select" name="shop_id" id="edit-shop" required>
                                            <% if(shopList != null) {
                                                for(Shop sh : shopList) { %>
                                                    <option value="<%= sh.getId() %>"><%= sh.getShopName() %></option>
                                            <% } } %>
                                        </select>
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label fw-medium">Giá Bán (VNĐ) <span
                                                class="text-danger">*</span></label>
                                        <input type="number" class="form-control" name="price" id="edit-price" required
                                            min="0" step="1">
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label fw-medium">Link Hình Ảnh</label>
                                        <input type="url" class="form-control" name="image_url" id="edit-image">
                                    </div>
                                </div>
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-light border"
                                        data-bs-dismiss="modal">Hủy</button>
                                    <button type="submit" class="btn btn-shopee">Cập Nhật</button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>

                <!-- Hidden form for single actions (delete/restore) - outside bulkForm to avoid nested forms -->
                <form id="singleActionForm" action="admin-products" method="POST" style="display:none;">
                    <input type="hidden" name="action" id="single-action-input">
                    <input type="hidden" name="id" id="single-id-input">
                </form>

                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
                <script>
                    // Chặn giá âm khi submit form
                    document.querySelectorAll('form[action="admin-products"]').forEach(function(form) {
                        form.addEventListener('submit', function(e) {
                            var priceInput = form.querySelector('input[name="price"]');
                            if (priceInput && parseFloat(priceInput.value) < 0) {
                                e.preventDefault();
                                alert('Giá sản phẩm không được âm! Vui lòng nhập giá >= 0.');
                                priceInput.focus();
                                return false;
                            }
                        });
                    });
                    function openEditModal(id, name, price, image, categoryId, shopId) {
                        document.getElementById('edit-id').value = id;
                        document.getElementById('edit-name').value = name;
                        document.getElementById('edit-price').value = parseInt(price);
                        document.getElementById('edit-image').value = image;
                        document.getElementById('edit-category').value = categoryId;
                        document.getElementById('edit-shop').value = shopId;

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

                        // Toggle tất cả
                        if (selectAllCheckbox) {
                            selectAllCheckbox.addEventListener('change', function () {
                                rowCheckboxes.forEach(cb => {
                                    cb.checked = selectAllCheckbox.checked;
                                });
                                updateBulkActionVisibility();
                            });
                        }

                        // Toggle từng dòng
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
                        if(actionName === 'bulk_delete') msg = "Bạn có chắc chắn muốn xóa " + count + " sản phẩm đã chọn vào thùng rác không?";
                        else if(actionName === 'bulk_delete_permanent') msg = "⚠️ CẢNH BÁO: Bạn chuẩn bị XÓA VĨNH VIỄN " + count + " sản phẩm. Việc này KHÔNG THỂ KHÔI PHỤC. Phê duyệt?";
                        else if(actionName === 'bulk_restore') msg = "Khôi phục " + count + " sản phẩm đã chọn?";

                        if (confirm(msg)) {
                            document.getElementById('bulk-action-input').value = actionName;
                            document.getElementById('bulkForm').submit();
                        }
                    }
                    function submitSingleAction(actionName, productId) {
                        let msg = '';
                        if (actionName === 'delete') msg = 'Bạn có chắc chắn muốn xóa sản phẩm này?';
                        else if (actionName === 'restore') msg = 'Khôi phục sản phẩm này?';
                        if (msg && !confirm(msg)) return;
                        document.getElementById('single-action-input').value = actionName;
                        document.getElementById('single-id-input').value = productId;
                        document.getElementById('singleActionForm').submit();
                    }
                </script>
            </body>
            </html>