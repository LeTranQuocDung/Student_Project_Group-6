<%@page import="java.util.List" %>
    <%@page import="model.Product" %>
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
                        min-height: 100vh;
                        background: #ffffff;
                        width: var(--sidebar-width);
                        position: fixed;
                        box-shadow: 2px 0 10px rgba(0, 0, 0, 0.05);
                        z-index: 100;
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
                <div class="sidebar d-flex flex-column">
                    <div class="sidebar-logo">
                        <h4><i class="fas fa-shopping-bag me-1"></i> Admin Panel</h4>
                    </div>
                    <div class="mt-4 flex-grow-1">
                        <div class="nav-item">
                            <a href="admin"><i class="fas fa-chart-pie"></i> Tổng Quan</a>
                        </div>
                        <div class="nav-item">
                            <a href="admin-import"><i class="fas fa-database"></i> Quản lý Dữ Liệu</a>
                        </div>
                        <div class="nav-item">
                            <a href="admin-generate"><i class="fas fa-magic"></i> Tạo Dữ Liệu</a>
                        </div>
                        <div class="nav-item">
                            <a href="admin-products" class="active"><i class="fas fa-box-open"></i> Sản Phẩm</a>
                        </div>
                        <div class="nav-item">
                            <a href="admin-orders"><i class="fas fa-clipboard-list"></i> Đơn Hàng</a>
                        </div>
                        <div class="nav-item">
                            <a href="admin-users"><i class="fas fa-users"></i> Khách Hàng</a>
                        </div>
                        <div class="nav-item">
                            <a href="home" target="_blank"><i class="fas fa-globe"></i> Truy Cập Cửa Hàng</a>
                        </div>
                    </div>
                    <div class="nav-item mb-4 border-top pt-3">
                        <a href="logout" class="text-danger"><i class="fas fa-sign-out-alt"></i> Đăng Xuất</a>
                    </div>
                </div>

                <!-- Main Content -->
                <div class="main-content">
                    <!-- Header -->
                    <div class="top-header">
                        <div>
                            <h4 class="m-0 fw-bold text-dark">Quản lý Sản Phẩm</h4>
                            <small class="text-muted">Danh sách và thông tin chi tiết</small>
                        </div>
                        <div class="d-flex align-items-center gap-3">
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
                            <h5 class="fw-bold m-0 text-dark">Danh sách sản phẩm</h5>
                            <button class="btn btn-shopee" data-bs-toggle="modal" data-bs-target="#addModal">
                                <i class="fas fa-plus me-1"></i> Thêm Sản Phẩm Mới
                            </button>
                        </div>

                        <div class="table-responsive">
                            <table class="table table-hover table-product border">
                                <thead class="table-light">
                                    <tr>
                                        <th width="80">ID</th>
                                        <th width="100">Hình Ảnh</th>
                                        <th>Tên Sản Phẩm</th>
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
                                                <td>#<%= p.getId() %>
                                                </td>
                                                <td>
                                                    <img src="<%= p.getImageUrl() %>" alt="Product">
                                                </td>
                                                <td class="fw-medium">
                                                    <%= p.getName() %>
                                                </td>
                                                <td class="text-end text-danger fw-bold">
                                                    <%= String.format("%,.0f", p.getPrice()) %> đ
                                                </td>
                                                <td class="text-center">
                                                    <button class="btn btn-sm btn-outline-primary shadow-sm"
                                                        onclick="openEditModal(<%= p.getId() %>, '<%= p.getName().replace("'", "\\\\'") %>', '<%= p.getPrice() %>', '<%= p.getImageUrl() %>')">
                                                        <i class="fas fa-edit"></i> Sửa
                                                    </button>
                                                    <form action="admin-products" method="POST" style="display:inline;"
                                                        onsubmit="return confirm('Bạn có chắc chắn muốn xóa sản phẩm này?');">
                                                        <input type="hidden" name="action" value="delete">
                                                        <input type="hidden" name="id" value="<%= p.getId() %>">
                                                        <button type="submit"
                                                            class="btn btn-sm btn-outline-danger shadow-sm">
                                                            <i class="fas fa-trash"></i> Xóa
                                                        </button>
                                                    </form>
                                                </td>
                                            </tr>
                                            <% } } %>
                                </tbody>
                            </table>
                        </div>
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
                                        <label class="form-label fw-medium">Giá Bán (VNĐ) <span
                                                class="text-danger">*</span></label>
                                        <input type="number" class="form-control" name="price" required
                                            placeholder="Ví dụ: 150000">
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
                                        <label class="form-label fw-medium">Giá Bán (VNĐ) <span
                                                class="text-danger">*</span></label>
                                        <input type="number" class="form-control" name="price" id="edit-price" required>
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

                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
                <script>
                    function openEditModal(id, name, price, image) {
                        document.getElementById('edit-id').value = id;
                        document.getElementById('edit-name').value = name;
                        document.getElementById('edit-price').value = parseInt(price);
                        document.getElementById('edit-image').value = image;

                        var editModal = new bootstrap.Modal(document.getElementById('editModal'));
                        editModal.show();
                    }
                </script>
            </body>

            </html>