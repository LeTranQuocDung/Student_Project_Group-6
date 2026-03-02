<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="vi">

    <head>
        <meta charset="UTF-8">
        <title>Import Dữ Liệu | Shopee Admin</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
        <style>
            :root {
                --shopee-primary: #ee4d2d;
                --sidebar-width: 260px;
                --bg-color: #f5f5f5;
                --card-shadow: 0 1px 3px rgba(0, 0, 0, 0.12), 0 1px 2px rgba(0, 0, 0, 0.24);
            }

            body {
                background: var(--bg-color);
                font-family: 'Inter', sans-serif;
                overflow-x: hidden;
            }

            /* Sidebar */
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

            /* Main Content */
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

            .card-custom {
                border: none;
                border-radius: 12px;
                background: #fff;
                box-shadow: var(--card-shadow);
                overflow: hidden;
            }

            .btn-shopee {
                background: linear-gradient(90deg, #ff7b54, #ee4d2d);
                color: #fff;
                font-weight: 600;
                border: none;
                box-shadow: 0 4px 6px rgba(238, 77, 45, 0.3);
                transition: transform 0.2s ease;
            }

            .btn-shopee:hover {
                background: linear-gradient(90deg, #ee4d2d, #ff7b54);
                color: #fff;
                transform: translateY(-2px);
            }

            .log-box {
                background: #212529;
                color: #0dcf45;
                font-family: 'Consolas', monospace;
                height: 350px;
                overflow-y: scroll;
                padding: 20px;
                border-radius: 0 0 12px 12px;
                font-size: 14px;
                line-height: 1.6;
            }

            .log-box::-webkit-scrollbar {
                width: 8px;
            }

            .log-box::-webkit-scrollbar-thumb {
                background: #495057;
                border-radius: 4px;
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
                    <a href="admin-import" class="active"><i class="fas fa-database"></i> Quản lý Dữ Liệu</a>
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
                    <h4 class="m-0 fw-bold text-dark">Quản Lý Dữ Liệu Hệ Thống</h4>
                    <small class="text-muted">Import File CSV và Khôi Phục CSDL</small>
                </div>
                <div class="d-flex align-items-center gap-3">
                    <div class="d-flex align-items-center gap-2">
                        <img src="https://ui-avatars.com/api/?name=Admin&background=ee4d2d&color=fff&rounded=true"
                            width="45">
                        <div class="d-flex flex-column">
                            <span class="fw-bold" style="font-size: 14px;">Super Admin</span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Action Card -->
            <div class="card card-custom mb-4">
                <div class="card-header bg-danger text-white fw-bold py-3"><i
                        class="fas fa-exclamation-triangle me-2"></i> RESET DATABASE (MIGRATION)</div>
                <div class="card-body text-center py-5">
                    <div class="mb-4">
                        <i class="fas fa-cloud-upload-alt text-muted mb-3" style="font-size: 50px;"></i>
                        <h5 class="fw-bold">Khôi phục Dữ liệu Mẫu (10.000+ Rows)</h5>
                        <p class="text-muted mx-auto" style="max-width: 600px;">
                            Hệ thống sẽ <strong>xóa toàn bộ</strong> thông tin cũ trong Database và đọc lại thư mục Data
                            để nhúng bản ghi CSV.
                            <br><span class="text-danger fw-bold">Lưu ý: Hành động này KHÔNG THỂ HOÀN TÁC!</span>
                        </p>
                    </div>

                    <form action="admin-import" method="post" id="importForm">
                        <button type="button" id="btn" class="btn btn-shopee btn-lg px-5 py-2 rounded-pill"
                            onclick="loading()">
                            <i class="fas fa-sync-alt me-2"></i> BẮT ĐẦU IMPORT NGAY
                        </button>
                    </form>

                    <div id="load" class="d-none mt-4">
                        <div class="spinner-border text-danger" role="status" style="width: 3rem; height: 3rem;"></div>
                        <h5 class="mt-3 fw-bold text-danger">Đang xử lý dữ liệu lớn... Cấm đóng trình duyệt!</h5>
                        <small class="text-muted">Việc này có thể tốn từ 1 đến 5 phút tùy hiệu năng server.</small>
                    </div>
                </div>
            </div>

            <!-- Log Card -->
            <div class="card card-custom">
                <div
                    class="card-header bg-dark text-white fw-bold py-3 d-flex justify-content-between align-items-center">
                    <span><i class="fas fa-terminal me-2"></i> SYSTEM LOGS (CONSOLE)</span>
                    <span class="badge bg-success">LIVE</span>
                </div>
                <div class="card-body p-0">
                    <div class="log-box">
                        <% if(request.getAttribute("logs") !=null) { %>
                            <%= request.getAttribute("logs").toString().replace("\n", "<br>" ) %>
                                <% } else { %>
                                    <span class="text-muted">> System loaded. Ready to receive commands...</span><br>
                                    <span class="text-muted">> Please execute Action [IMPORT] to view logs.</span>
                                    <% } %>
                    </div>
                </div>
            </div>

            <div class="text-center mt-4 text-muted">
                <small>&copy; 2026 Designed for Shopee Clone Administrators.</small>
            </div>
        </div>

        <script>
            function loading() {
                var btn = document.getElementById('btn');
                var load = document.getElementById('load');
                var form = document.getElementById('importForm');

                if (confirm("Bạn có chắc chắn muốn XÓA SẠCH dữ liệu cũ và MIGRATION toàn bộ dữ liệu mẫu không? Hành động này nguy hiểm!")) {
                    btn.classList.add('d-none');
                    load.classList.remove('d-none');
                    form.submit(); // Bấm Yes mới nộp
                }
            }
        </script>
    </body>

    </html>