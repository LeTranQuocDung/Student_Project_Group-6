<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Admin Dashboard | Shopee Clone</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

        <style>
            body {
                background: #f8f9fa;
                overflow-x: hidden;
            }
            .sidebar {
                min-height: 100vh;
                background: #343a40;
                color: #fff;
                width: 250px;
                position: fixed;
            }
            .sidebar a {
                color: #adb5bd;
                text-decoration: none;
                padding: 15px 20px;
                display: block;
                font-weight: 500;
            }
            .sidebar a:hover, .sidebar a.active {
                color: #fff;
                background: #ee4d2d;
            }
            .sidebar i {
                width: 25px;
            }
            .main-content {
                margin-left: 250px;
                padding: 20px;
            }

            /* Card thống kê */
            .stat-card {
                border: none;
                border-radius: 10px;
                box-shadow: 0 4px 6px rgba(0,0,0,0.1);
                transition: 0.3s;
            }
            .stat-card:hover {
                transform: translateY(-5px);
            }
            .icon-box {
                font-size: 40px;
                opacity: 0.8;
            }

            /* Chart container */
            .chart-container {
                background: #fff;
                padding: 20px;
                border-radius: 10px;
                box-shadow: 0 4px 6px rgba(0,0,0,0.05);
            }
        </style>
    </head>
    <body>

        <div class="sidebar">
            <div class="d-flex align-items-center justify-content-center py-4 border-bottom border-secondary">
                <h4 class="m-0 text-white"><i class="fas fa-shopping-bag text-danger"></i> Shopee Admin</h4>
            </div>
            <div class="mt-3">
                <a href="admin" class="active"><i class="fas fa-tachometer-alt"></i> Dashboard</a>
                <a href="home"><i class="fas fa-home"></i> Xem Trang Chủ</a>
                <a href="admin-import"><i class="fas fa-database"></i> Quản lý Data</a>
                <a href="#"><i class="fas fa-box"></i> Sản phẩm</a>
                <a href="#"><i class="fas fa-file-invoice-dollar"></i> Đơn hàng</a>
                <a href="#"><i class="fas fa-users"></i> Khách hàng</a>
                <a href="login.jsp" class="mt-5 border-top border-secondary"><i class="fas fa-sign-out-alt"></i> Đăng xuất</a>
            </div>
        </div>

        <div class="main-content">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h3>Tổng Quan Báo Cáo</h3>
                <div class="d-flex align-items-center gap-2">
                    <img src="https://ui-avatars.com/api/?name=Admin&background=ee4d2d&color=fff" class="rounded-circle" width="40">
                    <span class="fw-bold">Xin chào, Admin</span>
                </div>
            </div>

            <div class="row g-4 mb-4">
                <div class="col-md-4">
                    <div class="card stat-card bg-primary text-white h-100">
                        <div class="card-body d-flex justify-content-between align-items-center">
                            <div>
                                <h6 class="text-uppercase mb-2 opacity-75">Tổng Doanh Thu</h6>
                                <h3 class="fw-bold">₫<%= String.format("%,.0f", request.getAttribute("totalRevenue"))%></h3>
                            </div>
                            <div class="icon-box"><i class="fas fa-dollar-sign"></i></div>
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="card stat-card bg-success text-white h-100">
                        <div class="card-body d-flex justify-content-between align-items-center">
                            <div>
                                <h6 class="text-uppercase mb-2 opacity-75">Tổng Đơn Hàng</h6>
                                <h3 class="fw-bold"><%= request.getAttribute("totalOrders")%></h3>
                            </div>
                            <div class="icon-box"><i class="fas fa-shopping-cart"></i></div>
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="card stat-card bg-warning text-dark h-100">
                        <div class="card-body d-flex justify-content-between align-items-center">
                            <div>
                                <h6 class="text-uppercase mb-2 opacity-75">Tổng Khách Hàng</h6>
                                <h3 class="fw-bold"><%= request.getAttribute("totalUsers")%></h3>
                            </div>
                            <div class="icon-box"><i class="fas fa-user-friends"></i></div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="row">
                <div class="col-md-8">
                    <div class="chart-container">
                        <h5 class="mb-4 text-secondary">Biểu đồ Doanh Thu Tuần Qua</h5>
                        <canvas id="revenueChart" height="150"></canvas>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="chart-container h-100">
                        <h5 class="mb-4 text-secondary">Trạng Thái Đơn</h5>
                        <canvas id="statusChart"></canvas>
                    </div>
                </div>
            </div>
        </div>

        <script>
            // 1. Biểu đồ Cột (Doanh thu)
            const ctx = document.getElementById('revenueChart').getContext('2d');
            new Chart(ctx, {
                type: 'bar', // Dạng cột
                data: {
                    labels: <%= request.getAttribute("chartLabels")%>, // Dữ liệu từ Servlet
                    datasets: [{
                            label: 'Doanh thu (VNĐ)',
                            data: <%= request.getAttribute("chartData")%>, // Dữ liệu từ Servlet
                            backgroundColor: 'rgba(238, 77, 45, 0.8)', // Màu cam Shopee
                            borderColor: 'rgba(238, 77, 45, 1)',
                            borderWidth: 1,
                            borderRadius: 5
                        }]
                },
                options: {
                    scales: {y: {beginAtZero: true}}
                }
            });

            // 2. Biểu đồ Tròn (Trạng thái)
            const ctx2 = document.getElementById('statusChart').getContext('2d');
            new Chart(ctx2, {
                type: 'doughnut', // Dạng bánh donut
                data: {
                    labels: ['Thành công', 'Đang xử lý', 'Đã hủy'],
                    datasets: [{
                            data: [<%= request.getAttribute("totalOrders")%>, 15, 5], // Fake tỉ lệ 1 chút
                            backgroundColor: ['#198754', '#ffc107', '#dc3545']
                        }]
                }
            });
        </script>
    </body>
</html>