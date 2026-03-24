<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@page import="java.util.List" %>
<%@page import="java.util.Map" %>
<%@page import="model.SystemSetting" %>
<%
    Map<String, String> settings = (Map<String, String>) request.getAttribute("settings");
    if (settings == null) {
        settings = new java.util.HashMap<>();
    }
%>
<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <title>Cấu Hình Hệ Thống | Admin Panel</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
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
            height: 100vh;
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
            margin-bottom: 30px;
        }

        .btn-shopee {
            background-color: var(--shopee-primary);
            color: white;
            border: none;
            font-weight: 500;
            padding: 10px 24px;
            transition: all 0.2s;
        }

        .btn-shopee:hover {
            background-color: var(--shopee-hover);
            color: white;
            transform: translateY(-1px);
        }

        /* Nav Tabs Style */
        .nav-tabs .nav-link {
            color: #555;
            font-weight: 500;
            border: none;
            border-bottom: 3px solid transparent;
            padding: 15px 20px;
            margin-bottom: -1px;
            transition: all 0.2s;
        }

        .nav-tabs .nav-link:hover {
            color: var(--shopee-primary);
            border-color: transparent;
        }

        .nav-tabs .nav-link.active {
            color: var(--shopee-primary);
            background: transparent;
            border-color: var(--shopee-primary);
        }
        
        .form-label {
            font-weight: 500;
            color: #444;
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
                <h4 class="m-0 fw-bold text-dark">Dynamic System Settings</h4>
                <small class="text-muted">Trung tâm quản lý các tham số và cấu hình Website.</small>
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
                    <img src="https://ui-avatars.com/api/?name=Admin&background=ee4d2d&color=fff&rounded=true" width="45">
                    <div class="d-flex flex-column">
                        <span class="fw-bold" style="font-size: 14px;">Super Admin</span>
                        <span class="text-muted" style="font-size: 12px;">Quản trị viên</span>
                    </div>
                </div>
            </div>
        </div>

        <% String successMessage = (String) session.getAttribute("successMessage");
           if (successMessage != null) { %>
            <div class="alert alert-success alert-dismissible fade show shadow-sm border-0" role="alert">
                <i class="fas fa-check-circle me-2"></i><strong>Thành công!</strong> <%= successMessage %>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        <% session.removeAttribute("successMessage"); } %>

        <div class="content-box p-0">
            <!-- Tabs Navigation -->
            <ul class="nav nav-tabs px-4 pt-3 border-bottom" id="settingsTabs" role="tablist">
                <li class="nav-item" role="presentation">
                    <button class="nav-link active" id="general-tab" data-bs-toggle="tab" data-bs-target="#general" type="button" role="tab" aria-selected="true">
                        <i class="fas fa-sliders-h me-1"></i> Thông Tin Chung
                    </button>
                </li>
                <li class="nav-item" role="presentation">
                    <button class="nav-link" id="smtp-tab" data-bs-toggle="tab" data-bs-target="#smtp" type="button" role="tab" aria-selected="false">
                        <i class="fas fa-envelope me-1"></i> Cấu Hình SMTP (Gửi Mail)
                    </button>
                </li>
            </ul>

            <!-- Tabs Content -->
            <form action="admin-settings" method="POST" class="p-4">
                <div class="tab-content" id="settingsTabsContent">
                    
                    <!-- Tab Thông Tin Chung -->
                    <div class="tab-pane fade show active" id="general" role="tabpanel" aria-labelledby="general-tab">
                        <div class="row g-4">
                            <div class="col-md-6">
                                <label class="form-label">Tên Website / Thương Hiệu (Site Name)</label>
                                <input type="text" class="form-control" name="setting_site_name" value="<%= settings.getOrDefault("site_name", "") %>" required>
                                <div class="form-text">Ví dụ: Shopee Clone, Cửa Hàng Bách Hóa...</div>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Số Điện Thoại Hỗ Trợ (Support Phone)</label>
                                <input type="text" class="form-control" name="setting_support_phone" value="<%= settings.getOrDefault("support_phone", "") %>">
                                <div class="form-text">Dùng làm Hotline hiển thị ở Header/Footer trang Home.</div>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Email Chăm Sóc Khách Hàng (Support Email)</label>
                                <input type="email" class="form-control" name="setting_support_email" value="<%= settings.getOrDefault("support_email", "") %>">
                                <div class="form-text">Email dành cho khách hàng liên hệ.</div>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Địa Chỉ Trụ Sở Công Ty (Contact Address)</label>
                                <textarea class="form-control" name="setting_contact_address" rows="2"><%= settings.getOrDefault("contact_address", "") %></textarea>
                            </div>
                        </div>
                    </div>

                    <!-- Tab Cấu Hình SMTP -->
                    <div class="tab-pane fade" id="smtp" role="tabpanel" aria-labelledby="smtp-tab">
                        <div class="alert alert-info border-0 rounded-3">
                            <i class="fas fa-info-circle me-2"></i> <strong>Cấu hình máy chủ SMTP</strong> cho phép hệ thống tự động gửi Email lấy lại mật khẩu và giao dịch cho khách hàng.
                        </div>
                        <div class="row g-4 mt-1">
                            <div class="col-md-6">
                                <label class="form-label">Máy Chủ SMTP (Host)</label>
                                <input type="text" class="form-control" name="setting_smtp_host" value="<%= settings.getOrDefault("smtp_host", "smtp.gmail.com") %>">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Cổng (Port)</label>
                                <input type="number" class="form-control" name="setting_smtp_port" value="<%= settings.getOrDefault("smtp_port", "587") %>">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Tài Khoản Gửi Thư (Username/Email)</label>
                                <input type="email" class="form-control" name="setting_smtp_user" value="<%= settings.getOrDefault("smtp_user", "") %>">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Mật Khẩu Ứng Dụng (App Password)</label>
                                <input type="password" class="form-control" name="setting_smtp_pass" value="<%= settings.getOrDefault("smtp_pass", "") %>">
                                <div class="form-text text-danger">Bảo mật cao: Nên dùng App Password thay cho mật khẩu thật.</div>
                            </div>
                        </div>
                    </div>

                </div>

                <!-- Footer Actions -->
                <div class="mt-5 pt-3 border-top d-flex justify-content-end gap-2">
                    <button type="reset" class="btn btn-light border px-4">Khôi Phục Ban Đầu</button>
                    <button type="submit" class="btn btn-shopee px-4">
                        <i class="fas fa-save me-1"></i> Lưu Tất Cả Cấu Hình
                    </button>
                </div>
            </form>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>

</html>
