<%@page contentType="text/html" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Đăng nhập bằng Facebook</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }

        body {
            background: #f0f2f5;
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .fb-login-container {
            width: 400px;
            background: #fff;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,.1), 0 8px 16px rgba(0,0,0,.1);
            overflow: hidden;
        }

        .fb-header {
            background: #1877f2;
            padding: 20px 16px;
            text-align: center;
        }

        .fb-header i {
            color: #fff;
            font-size: 48px;
        }

        .fb-header h2 {
            color: #fff;
            font-size: 20px;
            margin-top: 8px;
            font-weight: 600;
        }

        .fb-header p {
            color: rgba(255,255,255,.85);
            font-size: 13px;
            margin-top: 4px;
        }

        .fb-body {
            padding: 20px 16px;
        }

        .fb-input {
            width: 100%;
            padding: 14px 16px;
            border: 1px solid #dddfe2;
            border-radius: 6px;
            font-size: 15px;
            margin-bottom: 12px;
            outline: none;
            transition: border-color .2s;
        }

        .fb-input:focus {
            border-color: #1877f2;
            box-shadow: 0 0 0 2px rgba(24,119,242,.2);
        }

        .fb-btn {
            width: 100%;
            padding: 12px;
            background: #1877f2;
            color: #fff;
            border: none;
            border-radius: 6px;
            font-size: 17px;
            font-weight: 700;
            cursor: pointer;
            transition: background .2s;
        }

        .fb-btn:hover {
            background: #166fe5;
        }

        .fb-divider {
            text-align: center;
            margin: 16px 0;
            position: relative;
        }

        .fb-divider::before {
            content: '';
            position: absolute;
            top: 50%;
            left: 0;
            right: 0;
            height: 1px;
            background: #dadde1;
        }

        .fb-divider span {
            background: #fff;
            padding: 0 10px;
            color: #65676b;
            font-size: 13px;
            position: relative;
        }

        .fb-footer {
            text-align: center;
            padding: 16px;
            border-top: 1px solid #dadde1;
        }

        .fb-footer a {
            color: #1877f2;
            text-decoration: none;
            font-size: 14px;
        }

        .fb-note {
            text-align: center;
            padding: 12px;
            background: #fff3cd;
            border-radius: 6px;
            margin-bottom: 12px;
            font-size: 12px;
            color: #856404;
        }

        .error-msg {
            background: #ffebe9;
            color: #d1242f;
            padding: 10px;
            border-radius: 6px;
            font-size: 13px;
            margin-bottom: 12px;
            text-align: center;
        }

        .loading-overlay {
            display: none;
            position: fixed;
            top: 0; left: 0; right: 0; bottom: 0;
            background: rgba(255,255,255,.8);
            z-index: 999;
            align-items: center;
            justify-content: center;
        }

        .spinner {
            width: 40px;
            height: 40px;
            border: 4px solid #e4e6eb;
            border-top-color: #1877f2;
            border-radius: 50%;
            animation: spin .8s linear infinite;
        }

        @keyframes spin { to { transform: rotate(360deg); } }
    </style>
</head>
<body>

    <div class="loading-overlay" id="loadingOverlay">
        <div class="spinner"></div>
    </div>

    <div class="fb-login-container">
        <div class="fb-header">
            <i class="fab fa-facebook"></i>
            <h2>Đăng nhập bằng Facebook</h2>
            <p>Tiếp tục đến Shopee Việt Nam</p>
        </div>

        <div class="fb-body">
            <div class="fb-note">
                <i class="fas fa-info-circle"></i>
                Đây là giao diện giả lập Facebook Login cho mục đích demo.
                Nhập email và tên để đăng nhập.
            </div>

            <% String err = (String) request.getAttribute("error");
               if (err != null) { %>
                <div class="error-msg"><i class="fas fa-exclamation-circle"></i> <%= err %></div>
            <% } %>

            <form action="facebook-login" method="post" id="fbForm" onsubmit="showLoading()">
                <input type="email" name="email" class="fb-input" placeholder="Email" required
                       value="user@facebook.com">
                <input type="text" name="name" class="fb-input" placeholder="Tên hiển thị" required
                       value="Facebook User">
                <button type="submit" class="fb-btn">
                    <i class="fas fa-sign-in-alt"></i> Đăng nhập
                </button>
            </form>

            <div class="fb-divider"><span>hoặc</span></div>

            <div class="fb-footer">
                <a href="javascript:void(0)" onclick="window.close()">
                    <i class="fas fa-times"></i> Hủy bỏ
                </a>
            </div>
        </div>
    </div>

    <script>
        function showLoading() {
            document.getElementById('loadingOverlay').style.display = 'flex';
        }
    </script>
</body>
</html>
