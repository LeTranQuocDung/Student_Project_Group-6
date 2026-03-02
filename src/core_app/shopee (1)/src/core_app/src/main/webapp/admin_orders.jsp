<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@page import="java.util.List" %>
        <!DOCTYPE html>
        <html lang="vi">

        <head>
            <meta charset="UTF-8">
            <title>Quản lý Đơn Hàng | Shopee Admin</title>
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

                .badge-pending {
                    background: #fff3cd;
                    color: #856404;
                    font-weight: 600;
                }

                .badge-completed {
                    background: #d4edda;
                    color: #155724;
                    font-weight: 600;
                }

                .badge-cancelled {
                    background: #f8d7da;
                    color: #721c24;
                    font-weight: 600;
                }

                .badge-paid {
                    background: #cce5ff;
                    color: #004085;
                    font-weight: 600;
                }

                .badge-shipped {
                    background: #e2e3f1;
                    color: #383d6e;
                    font-weight: 600;
                }

                .status-select {
                    border: 2px solid #dee2e6;
                    border-radius: 8px;
                    padding: 5px 10px;
                    font-size: 13px;
                    font-weight: 500;
                    cursor: pointer;
                    transition: border-color 0.2s;
                }

                .status-select:focus {
                    border-color: var(--shopee-primary);
                    outline: none;
                    box-shadow: 0 0 0 3px rgba(238, 77, 45, 0.15);
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
                    <div class="nav-item"><a href="admin-products"><i class="fas fa-box-open"></i> Sản Phẩm</a></div>
                    <div class="nav-item"><a href="admin-orders" class="active"><i class="fas fa-clipboard-list"></i>
                            Đơn Hàng</a></div>
                    <div class="nav-item"><a href="admin-users"><i class="fas fa-users"></i> Khách Hàng</a></div>
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
                        <h4 class="m-0 fw-bold text-dark">Quản Lý Đơn Hàng</h4>
                        <small class="text-muted">Theo dõi và cập nhật trạng thái đơn hàng</small>
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
                        <h5 class="fw-bold m-0 text-dark"><i class="fas fa-clipboard-list me-2 text-muted"></i>Danh sách
                            đơn hàng</h5>
                        <span class="badge bg-secondary fs-6">
                            <% List<String[]> orders = (List<String[]>) request.getAttribute("orders");
                                    out.print(orders != null ? orders.size() : 0);
                                    %> đơn
                        </span>
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
                                    <th width="180" class="text-center">Cập Nhật</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% if(orders !=null) { for(String[] o : orders) { String statusClass="badge-pending" ;
                                    String statusText=o[4]; if("COMPLETED".equals(o[4])) statusClass="badge-completed" ;
                                    else if("CANCELLED".equals(o[4])) statusClass="badge-cancelled" ; else
                                    if("PAID".equals(o[4])) statusClass="badge-paid" ; else if("SHIPPED".equals(o[4]))
                                    statusClass="badge-shipped" ; %>
                                    <tr>
                                        <td class="fw-bold">#<%= o[0] %>
                                        </td>
                                        <td><i class="fas fa-user-circle text-muted me-1"></i>
                                            <%= o[1] %>
                                        </td>
                                        <td class="text-muted">
                                            <%= o[2] %>
                                        </td>
                                        <td class="text-end text-danger fw-bold">
                                            <%= String.format("%,.0f", Double.parseDouble(o[3])) %> đ
                                        </td>
                                        <td class="text-center">
                                            <span class="badge rounded-pill px-3 py-2 <%= statusClass %>">
                                                <%= statusText %>
                                            </span>
                                        </td>
                                        <td class="text-muted" style="font-size: 13px;"><i
                                                class="fas fa-clock me-1"></i>
                                            <%= o[5] %>
                                        </td>
                                        <td class="text-center">
                                            <form action="admin-orders" method="POST"
                                                class="d-flex gap-1 justify-content-center">
                                                <input type="hidden" name="action" value="updateStatus">
                                                <input type="hidden" name="orderId" value="<%= o[0] %>">
                                                <select name="status" class="status-select">
                                                    <option value="PENDING" <%="PENDING" .equals(o[4]) ? "selected" : ""
                                                        %>>Chờ xử lý</option>
                                                    <option value="PAID" <%="PAID" .equals(o[4]) ? "selected" : "" %>>Đã
                                                        thanh toán</option>
                                                    <option value="SHIPPED" <%="SHIPPED" .equals(o[4]) ? "selected" : ""
                                                        %>>Đang giao</option>
                                                    <option value="COMPLETED" <%="COMPLETED" .equals(o[4]) ? "selected"
                                                        : "" %>>Hoàn thành</option>
                                                    <option value="CANCELLED" <%="CANCELLED" .equals(o[4]) ? "selected"
                                                        : "" %>>Đã hủy</option>
                                                </select>
                                                <button type="submit" class="btn btn-sm btn-shopee"><i
                                                        class="fas fa-save"></i></button>
                                            </form>
                                        </td>
                                    </tr>
                                    <% } } %>
                            </tbody>
                        </table>
                    </div>

                    <% if(orders==null || orders.isEmpty()) { %>
                        <div class="text-center py-5 text-muted">
                            <i class="fas fa-inbox fa-3x mb-3"></i>
                            <h5>Chưa có đơn hàng nào</h5>
                            <p>Đơn hàng sẽ hiển thị ở đây khi khách hàng đặt mua.</p>
                        </div>
                        <% } %>
                </div>
            </div>

            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        </body>

        </html>