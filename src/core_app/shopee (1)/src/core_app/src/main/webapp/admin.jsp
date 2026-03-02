<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@page import="java.util.List" %>
        <!DOCTYPE html>
        <html lang="vi">

        <head>
            <meta charset="UTF-8">
            <title>Admin Dashboard | Shopee Clone</title>
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
            <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
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

                /* Stats Cards */
                .stat-card {
                    border: none;
                    border-radius: 12px;
                    background: #fff;
                    box-shadow: var(--card-shadow);
                    transition: transform 0.3s ease;
                    overflow: hidden;
                    position: relative;
                }

                .stat-card:hover {
                    transform: translateY(-5px);
                }

                .stat-icon {
                    position: absolute;
                    right: -20px;
                    bottom: -20px;
                    font-size: 100px;
                    opacity: 0.1;
                }

                .card-revenue {
                    background: linear-gradient(135deg, #ee4d2d, #ff7b54);
                    color: white;
                }

                .card-orders {
                    background: linear-gradient(135deg, #28a745, #4cd137);
                    color: white;
                }

                .card-users {
                    background: linear-gradient(135deg, #007bff, #00a8ff);
                    color: white;
                }

                .card-products {
                    background: linear-gradient(135deg, #6f42c1, #a855f7);
                    color: white;
                }

                /* Chart Box */
                .chart-box {
                    background: #fff;
                    padding: 25px;
                    border-radius: 12px;
                    box-shadow: var(--card-shadow);
                    height: 100%;
                }

                .chart-title {
                    font-weight: 600;
                    color: #333;
                    margin-bottom: 20px;
                    font-size: 17px;
                    border-left: 4px solid var(--shopee-primary);
                    padding-left: 10px;
                }

                /* Recent orders table */
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
                        <a href="admin" class="active"><i class="fas fa-chart-pie"></i> Tổng Quan</a>
                    </div>
                    <div class="nav-item">
                        <a href="admin-import"><i class="fas fa-database"></i> Quản lý Dữ Liệu</a>
                    </div>
                    <div class="nav-item">
                        <a href="admin-generate"><i class="fas fa-magic"></i> Tạo Dữ Liệu</a>
                    </div>
                    <div class="nav-item">
                        <a href="admin-products"><i class="fas fa-box-open"></i> Sản Phẩm</a>
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
                        <h4 class="m-0 fw-bold text-dark">Dashboard Thống Kê</h4>
                        <small class="text-muted">Cập nhật số liệu theo thời gian thực</small>
                    </div>
                    <div class="d-flex align-items-center gap-3">
                        <button class="btn btn-light rounded-circle shadow-sm position-relative">
                            <i class="fas fa-bell"></i>
                            <span
                                class="position-absolute top-0 start-100 translate-middle p-1 bg-danger rounded-circle"></span>
                        </button>
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

                <!-- Dashboard Stats: 4 cards -->
                <div class="row g-4 mb-4">
                    <div class="col-xl-3 col-md-6">
                        <div class="stat-card card-revenue p-4">
                            <div class="d-flex flex-column">
                                <span class="text-uppercase fw-bold mb-1 opacity-75"
                                    style="letter-spacing: 1px; font-size: 13px;">Tổng Doanh Thu</span>
                                <h2 class="fw-bold m-0 mt-2">₫<%= String.format("%,.0f",
                                        request.getAttribute("totalRevenue"))%>
                                </h2>
                            </div>
                            <i class="fas fa-wallet stat-icon"></i>
                        </div>
                    </div>
                    <div class="col-xl-3 col-md-6">
                        <div class="stat-card card-orders p-4">
                            <div class="d-flex flex-column">
                                <span class="text-uppercase fw-bold mb-1 opacity-75"
                                    style="letter-spacing: 1px; font-size: 13px;">Tổng Đơn Hàng</span>
                                <h2 class="fw-bold m-0 mt-2">
                                    <%= request.getAttribute("totalOrders")%> <small
                                            class="fs-6 fw-normal opacity-75">đơn</small>
                                </h2>
                            </div>
                            <i class="fas fa-shopping-bag stat-icon"></i>
                        </div>
                    </div>
                    <div class="col-xl-3 col-md-6">
                        <div class="stat-card card-users p-4">
                            <div class="d-flex flex-column">
                                <span class="text-uppercase fw-bold mb-1 opacity-75"
                                    style="letter-spacing: 1px; font-size: 13px;">Người Dùng</span>
                                <h2 class="fw-bold m-0 mt-2">
                                    <%= request.getAttribute("totalUsers")%> <small
                                            class="fs-6 fw-normal opacity-75">user</small>
                                </h2>
                            </div>
                            <i class="fas fa-users stat-icon"></i>
                        </div>
                    </div>
                    <div class="col-xl-3 col-md-6">
                        <div class="stat-card card-products p-4">
                            <div class="d-flex flex-column">
                                <span class="text-uppercase fw-bold mb-1 opacity-75"
                                    style="letter-spacing: 1px; font-size: 13px;">Sản Phẩm</span>
                                <h2 class="fw-bold m-0 mt-2">
                                    <%= request.getAttribute("totalProducts")%> <small
                                            class="fs-6 fw-normal opacity-75">SP</small>
                                </h2>
                            </div>
                            <i class="fas fa-box-open stat-icon"></i>
                        </div>
                    </div>
                </div>

                <!-- Charts -->
                <div class="row g-4 mb-4">
                    <div class="col-xl-8 col-lg-7">
                        <div class="chart-box">
                            <h5 class="chart-title">Doanh Thu 7 Ngày Gần Nhất</h5>
                            <canvas id="revenueChart" height="120"></canvas>
                        </div>
                    </div>
                    <div class="col-xl-4 col-lg-5">
                        <div class="chart-box">
                            <h5 class="chart-title">Tỷ Lệ Đơn Hàng</h5>
                            <div class="d-flex justify-content-center align-items-center" style="height: 250px;">
                                <canvas id="statusChart"></canvas>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Recent Orders -->
                <div class="row g-4 mb-4">
                    <div class="col-12">
                        <div class="chart-box">
                            <div class="d-flex justify-content-between align-items-center mb-3">
                                <h5 class="chart-title m-0">Đơn Hàng Gần Đây</h5>
                                <a href="admin-orders" class="btn btn-sm btn-outline-danger">Xem tất cả <i
                                        class="fas fa-arrow-right ms-1"></i></a>
                            </div>
                            <div class="table-responsive">
                                <table class="table table-hover border align-middle mb-0">
                                    <thead class="table-light">
                                        <tr>
                                            <th width="80">Mã ĐH</th>
                                            <th>Khách Hàng</th>
                                            <th width="150" class="text-end">Tổng Tiền</th>
                                            <th width="140" class="text-center">Trạng Thái</th>
                                            <th width="180">Ngày Tạo</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <% List<String[]> recentOrders = (List<String[]>)
                                                request.getAttribute("recentOrders");
                                                if(recentOrders != null) {
                                                for(String[] o : recentOrders) {
                                                String statusClass = "badge-pending";
                                                if("COMPLETED".equals(o[3])) statusClass = "badge-completed";
                                                else if("CANCELLED".equals(o[3])) statusClass = "badge-cancelled";
                                                else if("PAID".equals(o[3])) statusClass = "badge-paid";
                                                else if("SHIPPED".equals(o[3])) statusClass = "badge-shipped";
                                                %>
                                                <tr>
                                                    <td class="fw-bold">#<%= o[0] %>
                                                    </td>
                                                    <td><i class="fas fa-user-circle text-muted me-1"></i>
                                                        <%= o[1] %>
                                                    </td>
                                                    <td class="text-end text-danger fw-bold">
                                                        <%= String.format("%,.0f", Double.parseDouble(o[2])) %> đ
                                                    </td>
                                                    <td class="text-center">
                                                        <span class="badge rounded-pill px-3 py-2 <%= statusClass %>">
                                                            <%= o[3] %>
                                                        </span>
                                                    </td>
                                                    <td class="text-muted" style="font-size: 13px;"><i
                                                            class="fas fa-clock me-1"></i>
                                                        <%= o[4] %>
                                                    </td>
                                                </tr>
                                                <% } } %>
                                    </tbody>
                                </table>
                            </div>
                            <% if(recentOrders==null || recentOrders.isEmpty()) { %>
                                <div class="text-center py-4 text-muted">
                                    <i class="fas fa-inbox fa-2x mb-2"></i>
                                    <p class="mb-0">Chưa có đơn hàng nào.</p>
                                </div>
                                <% } %>
                        </div>
                    </div>
                </div>

                <!-- Footer -->
                <div class="row g-4">
                    <div class="col-12">
                        <div class="chart-box p-3 text-center text-muted">
                            &copy; 2026 Shopee Clone Admin System. Designed for Enterprise Management.
                        </div>
                    </div>
                </div>
            </div>

            <script>
                // Biểu đồ Doanh Thu Dạng Area (Đổ bóng mượt mà)
                const ctxRev = document.getElementById('revenueChart').getContext('2d');

                let gradient = ctxRev.createLinearGradient(0, 0, 0, 400);
                gradient.addColorStop(0, 'rgba(238, 77, 45, 0.4)');
                gradient.addColorStop(1, 'rgba(238, 77, 45, 0.0)');

                new Chart(ctxRev, {
                    type: 'line',
                    data: {
                        labels: <%= request.getAttribute("chartLabels") %>, // Dữ liệu Server
                        datasets: [{
                            label: 'Doanh thu (VNĐ)',
                            data: <%= request.getAttribute("chartData") %>, // Dữ liệu Server
                            fill: true,
                            backgroundColor: gradient,
                            borderColor: '#ee4d2d',
                            tension: 0.4, // Tạo đường cong mượt
                            borderWidth: 3,
                            pointBackgroundColor: '#fff',
                            pointBorderColor: '#ee4d2d',
                            pointBorderWidth: 2,
                            pointRadius: 4,
                            pointHoverRadius: 6
                        }]
                    },
                    options: {
                        responsive: true,
                        plugins: {
                            legend: { display: false } // Ẩn legend không cần thiết
                        },
                        scales: {
                            y: {
                                beginAtZero: true,
                                grid: { borderDash: [5, 5] }
                            },
                            x: {
                                grid: { display: false }
                            }
                        }
                    }
                });

                // Biểu đồ Doughnut cho Trạng thái đơn (Dữ liệu thực)
                const ctxStatus = document.getElementById('statusChart').getContext('2d');
                new Chart(ctxStatus, {
                    type: 'doughnut',
                    data: {
                        labels: ['Hoàn thành', 'Chờ xử lý', 'Đã hủy'],
                        datasets: [{
                            data: [<%= request.getAttribute("ordersCompleted") %>, <%= request.getAttribute("ordersPending") %>, <%= request.getAttribute("ordersCancelled") %>],
                            backgroundColor: ['#28a745', '#ffc107', '#dc3545'],
                            borderWidth: 0,
                            hoverOffset: 4
                        }]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        plugins: {
                            legend: { position: 'bottom' }
                        },
                        cutout: '70%'
                    }
                });
            </script>
        </body>

        </html>