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
                        min-height: 100vh;
                        background: #fff;
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
                <div class="sidebar d-flex flex-column">
                    <div class="sidebar-logo">
                        <h4><i class="fas fa-shopping-bag me-1"></i> Admin Panel</h4>
                    </div>
                    <div class="mt-4 flex-grow-1">
                        <div class="nav-item"><a href="admin"><i class="fas fa-chart-pie"></i> Tổng Quan</a></div>
                        <div class="nav-item"><a href="admin-import"><i class="fas fa-database"></i> Quản lý Dữ Liệu</a>
                        </div>
                        <div class="nav-item"><a href="admin-generate"><i class="fas fa-magic"></i> Tạo Dữ Liệu</a></div>
                        <div class="nav-item"><a href="admin-products"><i class="fas fa-box-open"></i> Sản Phẩm</a>
                        </div>
                        <div class="nav-item"><a href="admin-orders"><i class="fas fa-clipboard-list"></i> Đơn Hàng</a>
                        </div>
                        <div class="nav-item"><a href="admin-users" class="active"><i class="fas fa-users"></i> Khách
                                Hàng</a></div>
                        <div class="nav-item"><a href="home" target="_blank"><i class="fas fa-globe"></i> Truy Cập Cửa
                                Hàng</a></div>
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
                            <h4 class="m-0 fw-bold text-dark">Quản Lý Khách Hàng</h4>
                            <small class="text-muted">Danh sách và thông tin người dùng</small>
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

                    <!-- Content Box -->
                    <div class="content-box">
                        <div class="d-flex justify-content-between align-items-center mb-4">
                            <h5 class="fw-bold m-0 text-dark"><i class="fas fa-users me-2 text-muted"></i>Danh sách
                                khách hàng</h5>
                            <span class="badge bg-secondary fs-6">
                                <% List<User> users = (List<User>) request.getAttribute("users");
                                        out.print(users != null ? users.size() : 0);
                                        %> người dùng
                            </span>
                        </div>

                        <div class="table-responsive">
                            <table class="table table-hover border align-middle">
                                <thead class="table-light">
                                    <tr>
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
                                                <form action="admin-users" method="POST" style="display:inline;"
                                                    onsubmit="return confirm('Bạn có chắc chắn muốn xóa người dùng này?');">
                                                    <input type="hidden" name="action" value="delete">
                                                    <input type="hidden" name="id" value="<%= u.getId() %>">
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

                        <% if(users==null || users.isEmpty()) { %>
                            <div class="text-center py-5 text-muted">
                                <i class="fas fa-users fa-3x mb-3"></i>
                                <h5>Chưa có khách hàng nào</h5>
                                <p>Người dùng đăng ký sẽ hiển thị ở đây.</p>
                            </div>
                            <% } %>
                    </div>
                </div>

                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
            </body>

            </html>