<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="vi">

    <head>
        <meta charset="UTF-8">
        <title>Tạo Dữ Liệu Tự Động | Shopee Admin</title>
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

            /* Input styling */
            .input-count {
                max-width: 250px;
                margin: 0 auto;
                font-size: 24px;
                text-align: center;
                font-weight: 700;
                border: 2px solid #dee2e6;
                border-radius: 12px;
                padding: 12px 20px;
                transition: border-color 0.3s;
            }

            .input-count:focus {
                border-color: var(--shopee-primary);
                box-shadow: 0 0 0 0.2rem rgba(238, 77, 45, 0.15);
            }

            /* Quick buttons */
            .quick-btn {
                border: 2px solid #dee2e6;
                background: #fff;
                color: #333;
                font-weight: 600;
                border-radius: 8px;
                padding: 8px 20px;
                transition: all 0.2s;
                cursor: pointer;
            }

            .quick-btn:hover {
                border-color: var(--shopee-primary);
                color: var(--shopee-primary);
                background: #fef0ee;
            }

            /* Info cards */
            .info-card {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                border-radius: 12px;
                padding: 20px;
                color: white;
                text-align: center;
            }

            .info-card i {
                font-size: 30px;
                margin-bottom: 10px;
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
                    <a href="admin-generate" class="active"><i class="fas fa-magic"></i> Tạo Dữ Liệu</a>
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
                    <h4 class="m-0 fw-bold text-dark">Tạo Dữ Liệu Tự Động</h4>
                    <small class="text-muted">Sinh sản phẩm & biến thể số lượng lớn cho hệ thống</small>
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

            <!-- Info Cards -->
            <div class="row g-3 mb-4">
                <div class="col-md-4">
                    <div class="info-card">
                        <i class="fas fa-box-open"></i>
                        <h6 class="fw-bold mb-1">Sản Phẩm</h6>
                        <small>Mỗi sản phẩm có tên, giá, mô tả, hình ảnh ngẫu nhiên</small>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="info-card" style="background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);">
                        <i class="fas fa-layer-group"></i>
                        <h6 class="fw-bold mb-1">2 Biến Thể / SP</h6>
                        <small>Mỗi SP kèm 2 variants (màu, size, stock, giá riêng)</small>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="info-card" style="background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);">
                        <i class="fas fa-bolt"></i>
                        <h6 class="fw-bold mb-1">Batch Insert</h6>
                        <small>Tối ưu hiệu suất, hỗ trợ đến 10.000 sản phẩm</small>
                    </div>
                </div>
            </div>

            <!-- Action Card -->
            <div class="card card-custom mb-4">
                <div class="card-header bg-white fw-bold py-3 border-bottom">
                    <i class="fas fa-wand-magic-sparkles me-2 text-danger"></i> CÔNG CỤ TẠO DỮ LIỆU TỰ ĐỘNG
                </div>
                <div class="card-body text-center py-5">
                    <div class="mb-4">
                        <i class="fas fa-cubes text-muted mb-3" style="font-size: 50px;"></i>
                        <h5 class="fw-bold">Nhập số lượng sản phẩm cần tạo</h5>
                        <p class="text-muted mx-auto" style="max-width: 500px;">
                            Hệ thống sẽ tự động tạo sản phẩm với dữ liệu ngẫu nhiên (tên, giá, mô tả, hình ảnh) 
                            kèm 2 biến thể cho mỗi sản phẩm.
                        </p>
                    </div>

                    <form action="admin-generate" method="post" id="generateForm">
                        <!-- Input số lượng -->
                        <input type="number" name="count" id="countInput" class="form-control input-count mb-3"
                            value="100" min="1" max="10000" placeholder="Nhập số lượng...">

                        <!-- Quick select buttons -->
                        <div class="d-flex justify-content-center gap-2 mb-4">
                            <button type="button" class="quick-btn" onclick="setCount(10)">10</button>
                            <button type="button" class="quick-btn" onclick="setCount(50)">50</button>
                            <button type="button" class="quick-btn" onclick="setCount(100)">100</button>
                            <button type="button" class="quick-btn" onclick="setCount(500)">500</button>
                            <button type="button" class="quick-btn" onclick="setCount(1000)">1,000</button>
                            <button type="button" class="quick-btn" onclick="setCount(5000)">5,000</button>
                        </div>

                        <button type="button" id="btnGenerate" class="btn btn-shopee btn-lg px-5 py-2 rounded-pill"
                            onclick="startGenerate()">
                            <i class="fas fa-magic me-2"></i> BẮT ĐẦU TẠO DỮ LIỆU
                        </button>
                    </form>

                    <div id="loadingArea" class="d-none mt-4">
                        <div class="spinner-border text-danger" role="status" style="width: 3rem; height: 3rem;"></div>
                        <h5 class="mt-3 fw-bold text-danger">Đang tạo dữ liệu... Vui lòng chờ!</h5>
                        <small class="text-muted">Thời gian phụ thuộc vào số lượng. 1000 SP ~ vài giây.</small>
                    </div>
                </div>
            </div>

            <!-- Log Card -->
            <div class="card card-custom">
                <div
                    class="card-header bg-dark text-white fw-bold py-3 d-flex justify-content-between align-items-center">
                    <span><i class="fas fa-terminal me-2"></i> KẾT QUẢ (CONSOLE LOG)</span>
                    <span class="badge bg-success">OUTPUT</span>
                </div>
                <div class="card-body p-0">
                    <div class="log-box">
                        <% if(request.getAttribute("logs") != null) { %>
                            <%= request.getAttribute("logs").toString() %>
                        <% } else { %>
                            <span class="text-muted">> System loaded. Ready to generate data...</span><br>
                            <span class="text-muted">> Nhập số lượng và bấm nút để bắt đầu.</span>
                        <% } %>
                    </div>
                </div>
            </div>

            <div class="text-center mt-4 text-muted">
                <small>&copy; 2026 Designed for Shopee Clone Administrators.</small>
            </div>
        </div>

        <script>
            function setCount(val) {
                document.getElementById('countInput').value = val;
            }

            function startGenerate() {
                var count = document.getElementById('countInput').value;
                if (!count || count < 1) {
                    alert('Vui lòng nhập số lượng hợp lệ (1 - 10.000)');
                    return;
                }

                var msg = 'Bạn có chắc muốn tạo ' + Number(count).toLocaleString() + ' sản phẩm?\n\n';
                msg += '• ' + count + ' sản phẩm\n';
                msg += '• ' + (count * 2) + ' biến thể\n\n';
                msg += 'Dữ liệu sẽ được THÊM VÀO (không xóa dữ liệu cũ).';

                if (confirm(msg)) {
                    document.getElementById('btnGenerate').classList.add('d-none');
                    document.getElementById('loadingArea').classList.remove('d-none');
                    document.getElementById('generateForm').submit();
                }
            }
        </script>
    </body>

    </html>
