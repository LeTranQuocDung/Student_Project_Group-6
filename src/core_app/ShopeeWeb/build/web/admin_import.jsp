<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Import Data | Shopee Admin</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <style>
            body {
                background: #f8f9fa;
                overflow-x: hidden;
            }
            /* Sidebar giống Dashboard */
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

            .log-box {
                background: #000;
                color: #0f0;
                font-family: monospace;
                height: 400px;
                overflow-y: scroll;
                padding: 15px;
                border-radius: 5px;
            }
        </style>
    </head>
    <body>

        <div class="sidebar">
            <div class="d-flex align-items-center justify-content-center py-4 border-bottom border-secondary">
                <h4 class="m-0 text-white"><i class="fas fa-shopping-bag text-danger"></i> Shopee Admin</h4>
            </div>
            <div class="mt-3">
                <a href="admin"><i class="fas fa-tachometer-alt"></i> Dashboard</a>
                <a href="home"><i class="fas fa-home"></i> Xem Trang Chủ</a>
                <a href="admin-import" class="active"><i class="fas fa-database"></i> Quản lý Data</a>
                <a href="#"><i class="fas fa-box"></i> Sản phẩm</a>
                <a href="#"><i class="fas fa-file-invoice-dollar"></i> Đơn hàng</a>
                <a href="#"><i class="fas fa-users"></i> Khách hàng</a>
                <a href="login.jsp" class="mt-5 border-top border-secondary"><i class="fas fa-sign-out-alt"></i> Đăng xuất</a>
            </div>
        </div>

        <div class="main-content">
            <h3 class="mb-4">Quản Lý Dữ Liệu Hệ Thống</h3>

            <div class="card shadow mb-4">
                <div class="card-header bg-danger text-white fw-bold"><i class="fas fa-exclamation-triangle"></i> RESET DATABASE (MIGRATION)</div>
                <div class="card-body text-center py-5">
                    <p class="mb-4">Hệ thống sẽ xóa toàn bộ dữ liệu cũ và nạp lại dữ liệu mẫu (10k Rows) từ file CSV.<br>
                        <b>Lưu ý: Hành động này không thể hoàn tác!</b></p>

                    <form action="admin-import" method="post">
                        <button type="submit" id="btn" class="btn btn-danger btn-lg px-5" onclick="loading()">
                            <i class="fas fa-sync-alt"></i> BẮT ĐẦU IMPORT NGAY
                        </button>
                    </form>

                    <div id="load" class="d-none mt-3">
                        <div class="spinner-border text-danger"></div>
                        <span class="ms-2 fw-bold text-danger">Đang xử lý dữ liệu lớn, vui lòng chờ...</span>
                    </div>
                </div>
            </div>

            <div class="card shadow">
                <div class="card-header fw-bold bg-dark text-white"><i class="fas fa-terminal"></i> SYSTEM LOGS</div>
                <div class="card-body p-0">
                    <div class="log-box">
                        <%= (request.getAttribute("logs") != null ? request.getAttribute("logs") : "> Waiting for command... Ready to import CSV.")%>
                    </div>
                </div>
            </div>
        </div>

        <script>
            function loading() {
                document.getElementById('btn').classList.add('d-none');
                document.getElementById('load').classList.remove('d-none');
            }
        </script>
    </body>
</html>