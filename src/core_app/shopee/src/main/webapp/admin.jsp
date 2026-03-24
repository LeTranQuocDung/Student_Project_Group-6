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
            <%@ include file="admin_sidebar.jsp" %>

            <!-- Main Content -->
            <div class="main-content">
                <!-- Header -->
                <div class="top-header">
                    <div>
                        <h4 class="m-0 fw-bold text-dark">Dashboard Thống Kê</h4>
                        <small class="text-muted">Cập nhật số liệu theo thời gian thực</small>
                    </div>
                    <div class="d-flex align-items-center gap-3">
                        <!-- Global Search Button -->
                        <button class="btn btn-light rounded-circle shadow-sm" type="button" onclick="openGlobalSearch()" title="Tìm kiếm toàn cục (Ctrl+K)">
                            <i class="fas fa-search"></i>
                        </button>
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

                <!-- Recent Orders & Top Products -->
                <div class="row g-4 mb-4">
                    <div class="col-xl-8 col-lg-7">
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
                                                if(recentOrders != null && !recentOrders.isEmpty()) {
                                                for(String[] o : recentOrders) {
                                                String statusClass = "badge-pending";
                                                String statusText = "Xử lý";
                                                if("COMPLETED".equals(o[3])) { statusClass = "badge-completed"; statusText = "Hoàn thành"; }
                                                else if("CANCELLED".equals(o[3])) { statusClass = "badge-cancelled"; statusText = "Đã hủy"; }
                                                else if("PAID".equals(o[3])) { statusClass = "badge-paid"; statusText = "Đã thanh toán"; }
                                                else if("SHIPPED".equals(o[3])) { statusClass = "badge-shipped"; statusText = "Đang giao"; }
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
                                                            <%= statusText %>
                                                        </span>
                                                    </td>
                                                    <td class="text-muted" style="font-size: 13px;"><i
                                                            class="fas fa-clock me-1"></i>
                                                        <%= o[4] != null && o[4].length() >= 19 ? o[4].substring(0, 19) : o[4] %>
                                                    </td>
                                                </tr>
                                                <% } } else { %>
                                                <tr><td colspan="5" class="text-center text-muted py-4"><i class="fas fa-inbox fa-2x mb-2 d-block"></i> Chưa có đơn hàng nào.</td></tr>
                                                <% } %>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                    
                    <div class="col-xl-4 col-lg-5">
                        <div class="chart-box">
                            <h5 class="chart-title">Top Sản Phẩm Bán Chạy</h5>
                            <div class="table-responsive">
                                <table class="table table-hover border align-middle mb-0">
                                    <thead class="table-light">
                                        <tr>
                                            <th>Tên Sản Phẩm</th>
                                            <th width="80" class="text-end">Đã Bán</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <% List<String[]> topProducts = (List<String[]>) request.getAttribute("topProducts");
                                           if (topProducts != null && !topProducts.isEmpty()) {
                                               for (String[] tp : topProducts) { %>
                                        <tr>
                                            <td class="text-truncate" style="max-width: 150px;" title="<%= tp[0] %>"><%= tp[0] %></td>
                                            <td class="text-end fw-bold text-success"><%= tp[1] %></td>
                                        </tr>
                                        <% } } else { %>
                                        <tr><td colspan="2" class="text-center text-muted">Chưa có dữ liệu</td></tr>
                                        <% } %>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Recent Logs -->
                <div class="row g-4 mb-4">
                    <div class="col-12">
                        <div class="chart-box">
                            <div class="d-flex justify-content-between align-items-center mb-3">
                                <h5 class="chart-title m-0">Nhật Ký Hoạt Động (Gần Đây)</h5>
                                <a href="admin-logs" class="btn btn-sm btn-outline-primary">Xem tất cả <i class="fas fa-arrow-right ms-1"></i></a>
                            </div>
                            <div class="table-responsive">
                                <table class="table table-hover border align-middle mb-0">
                                    <thead class="table-light">
                                        <tr>
                                            <th>Người Thực Hiện</th>
                                            <th>Hành Động</th>
                                            <th>Mục Tiêu</th>
                                            <th>Chi Tiết</th>
                                            <th width="180">Thời Gian</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <% java.util.List<model.AuditLog> recentLogs = (java.util.List<model.AuditLog>) request.getAttribute("recentLogs");
                                           if (recentLogs != null && !recentLogs.isEmpty()) {
                                               for (model.AuditLog log : recentLogs) {
                                                   String actionClass = "bg-secondary";
                                                   if ("CREATE".equals(log.getAction())) actionClass = "bg-success";
                                                   else if ("UPDATE".equals(log.getAction())) actionClass = "bg-warning text-dark";
                                                   else if ("DELETE".equals(log.getAction())) actionClass = "bg-danger";
                                                   else if ("RESTORE".equals(log.getAction())) actionClass = "bg-info text-dark";
                                        %>
                                        <tr>
                                            <td class="fw-medium"><i class="fas fa-user-shield text-muted me-1"></i> <%= log.getAdminName() != null ? log.getAdminName() : "Admin" %></td>
                                            <td><span class="badge <%= actionClass %>"><%= log.getAction() %></span></td>
                                            <td><span class="badge bg-light text-dark border"><%= log.getTargetTable() %></span> (ID: <%= log.getTargetId() %>)</td>
                                            <td class="text-muted"><%= log.getDetails() %></td>
                                            <td class="text-muted" style="font-size: 13px;"><i class="fas fa-clock me-1"></i> <%= new java.text.SimpleDateFormat("dd/MM/yyyy HH:mm").format(log.getCreatedAt()) %></td>
                                        </tr>
                                        <% } } else { %>
                                        <tr><td colspan="5" class="text-center text-muted">Chưa có hoạt động nào</td></tr>
                                        <% } %>
                                    </tbody>
                                </table>
                            </div>
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

            <!-- ============== GLOBAL SEARCH MODAL ============== -->
            <div id="globalSearchOverlay" style="display:none; position:fixed; top:0; left:0; width:100vw; height:100vh; background:rgba(0,0,0,0.5); z-index:9999; backdrop-filter:blur(4px);" onclick="closeGlobalSearch()">
                <div style="max-width:680px; margin:80px auto; background:#fff; border-radius:16px; box-shadow:0 20px 60px rgba(0,0,0,0.3); overflow:hidden;" onclick="event.stopPropagation()">
                    <!-- Search Input -->
                    <div style="padding:20px 24px; border-bottom:1px solid #eee; display:flex; align-items:center; gap:12px;">
                        <i class="fas fa-search" style="color:#aaa; font-size:18px;"></i>
                        <input id="globalSearchInput" type="text" placeholder="Tìm kiếm sản phẩm, người dùng, đơn hàng, danh mục..."
                            style="border:none; outline:none; width:100%; font-size:16px; background:transparent;"
                            oninput="debounceSearch(this.value)" autocomplete="off">
                        <kbd style="background:#f1f1f1; padding:2px 8px; border-radius:4px; font-size:12px; color:#888; border:1px solid #ddd;">ESC</kbd>
                    </div>
                    <!-- Results Container -->
                    <div id="globalSearchResults" style="max-height:460px; overflow-y:auto; padding:8px 0;">
                        <div style="text-align:center; padding:40px 20px; color:#aaa;">
                            <i class="fas fa-search" style="font-size:40px; margin-bottom:12px; opacity:0.3;"></i>
                            <p style="margin:0;">Nhập từ khóa để bắt đầu tìm kiếm...</p>
                            <p style="margin:4px 0 0; font-size:13px; color:#ccc;">Tìm theo tên, email, mã đơn hàng, ID...</p>
                        </div>
                    </div>
                    <!-- Footer -->
                    <div style="padding:10px 24px; border-top:1px solid #eee; display:flex; justify-content:space-between; align-items:center; background:#fafafa;">
                        <div style="display:flex; gap:16px; font-size:12px; color:#999;">
                            <span><kbd style="background:#eee; padding:1px 5px; border-radius:3px; border:1px solid #ddd;">↑↓</kbd> Chọn</span>
                            <span><kbd style="background:#eee; padding:1px 5px; border-radius:3px; border:1px solid #ddd;">Enter</kbd> Mở</span>
                            <span><kbd style="background:#eee; padding:1px 5px; border-radius:3px; border:1px solid #ddd;">Esc</kbd> Đóng</span>
                        </div>
                        <span style="font-size:12px; color:#ccc;" id="globalSearchCount"></span>
                    </div>
                </div>
            </div>

            <script>
            // ===== GLOBAL SEARCH LOGIC =====
            let searchTimer = null;

            function openGlobalSearch() {
                document.getElementById('globalSearchOverlay').style.display = 'block';
                setTimeout(() => document.getElementById('globalSearchInput').focus(), 100);
            }

            function closeGlobalSearch() {
                document.getElementById('globalSearchOverlay').style.display = 'none';
                document.getElementById('globalSearchInput').value = '';
                document.getElementById('globalSearchResults').innerHTML =
                    '<div style="text-align:center; padding:40px 20px; color:#aaa;">' +
                    '<i class="fas fa-search" style="font-size:40px; margin-bottom:12px; opacity:0.3;"></i>' +
                    '<p style="margin:0;">Nhập từ khóa để bắt đầu tìm kiếm...</p></div>';
                document.getElementById('globalSearchCount').textContent = '';
            }

            function debounceSearch(query) {
                clearTimeout(searchTimer);
                if (query.trim().length < 2) {
                    document.getElementById('globalSearchResults').innerHTML =
                        '<div style="text-align:center; padding:40px 20px; color:#aaa;">' +
                        '<i class="fas fa-search" style="font-size:40px; margin-bottom:12px; opacity:0.3;"></i>' +
                        '<p style="margin:0;">Nhập ít nhất 2 ký tự...</p></div>';
                    document.getElementById('globalSearchCount').textContent = '';
                    return;
                }
                // Loading state
                document.getElementById('globalSearchResults').innerHTML =
                    '<div style="text-align:center; padding:40px 20px; color:#aaa;">' +
                    '<i class="fas fa-spinner fa-spin" style="font-size:24px;"></i>' +
                    '<p style="margin:8px 0 0;">Đang tìm kiếm...</p></div>';

                searchTimer = setTimeout(() => performSearch(query), 300);
            }

            function performSearch(query) {
                fetch('admin-search?q=' + encodeURIComponent(query))
                    .then(r => r.json())
                    .then(data => renderResults(data))
                    .catch(err => {
                        document.getElementById('globalSearchResults').innerHTML =
                            '<div style="text-align:center; padding:40px 20px; color:#f44336;">' +
                            '<i class="fas fa-exclamation-triangle" style="font-size:24px;"></i>' +
                            '<p style="margin:8px 0 0;">Lỗi kết nối. Thử lại sau.</p></div>';
                    });
            }

            function renderResults(data) {
                const r = data.results;
                let html = '';
                const icons = {products:'fa-box',users:'fa-users',orders:'fa-receipt',categories:'fa-tags'};
                const labels = {products:'Sản Phẩm',users:'Người Dùng',orders:'Đơn Hàng',categories:'Danh Mục'};
                const colors = {products:'#ee4d2d',users:'#2196f3',orders:'#4caf50',categories:'#ff9800'};

                for (const [type, items] of Object.entries(r)) {
                    if (items.length === 0) continue;
                    html += '<div style="padding:8px 24px 4px;"><span style="font-size:11px; font-weight:700; color:' + colors[type] + '; text-transform:uppercase; letter-spacing:1px;">' +
                        '<i class="fas ' + icons[type] + '"></i> ' + labels[type] + ' (' + items.length + ')</span></div>';

                    items.forEach(item => {
                        let subtitle = '';
                        let title = item.name || item.customer || '#' + item.id;
                        let icon = icons[type];

                        if (type === 'products') {
                            subtitle = 'ID: ' + item.id + ' • Giá: ' + (item.price || 'N/A') + 'đ';
                        } else if (type === 'users') {
                            subtitle = (item.email || '') + (item.phone ? ' • ' + item.phone : '') + ' • ' + item.role;
                        } else if (type === 'orders') {
                            title = 'Đơn #' + item.id + ' — ' + item.customer;
                            subtitle = item.total + 'đ • ' + item.status + ' • ' + item.date;
                        } else if (type === 'categories') {
                            subtitle = 'ID: ' + item.id;
                        }

                        html += '<a href="' + item.link + '" style="display:flex; align-items:center; gap:12px; padding:10px 24px; cursor:pointer; text-decoration:none; color:inherit; transition:background 0.15s;" ' +
                            'onmouseover="this.style.background=\'#f5f5f5\'" onmouseout="this.style.background=\'transparent\'">' +
                            '<div style="width:36px; height:36px; border-radius:8px; background:' + colors[type] + '15; display:flex; align-items:center; justify-content:center;">' +
                            '<i class="fas ' + icon + '" style="color:' + colors[type] + '; font-size:14px;"></i></div>' +
                            '<div style="flex:1; min-width:0;"><div style="font-size:14px; font-weight:500; white-space:nowrap; overflow:hidden; text-overflow:ellipsis;">' + title + '</div>' +
                            '<div style="font-size:12px; color:#999; white-space:nowrap; overflow:hidden; text-overflow:ellipsis;">' + subtitle + '</div></div>' +
                            '<i class="fas fa-arrow-right" style="color:#ddd; font-size:12px;"></i></a>';
                    });
                }

                if (data.total === 0) {
                    html = '<div style="text-align:center; padding:40px 20px; color:#aaa;">' +
                        '<i class="fas fa-search" style="font-size:40px; margin-bottom:12px; opacity:0.3;"></i>' +
                        '<p style="margin:0;">Không tìm thấy kết quả cho "' + data.keyword + '"</p></div>';
                }

                document.getElementById('globalSearchResults').innerHTML = html;
                document.getElementById('globalSearchCount').textContent = data.total + ' kết quả';
            }

            // Keyboard shortcut: Ctrl+K to open
            document.addEventListener('keydown', function(e) {
                if ((e.ctrlKey || e.metaKey) && e.key === 'k') {
                    e.preventDefault();
                    openGlobalSearch();
                }
                if (e.key === 'Escape') {
                    closeGlobalSearch();
                }
            });
            </script>
        </body>

        </html>