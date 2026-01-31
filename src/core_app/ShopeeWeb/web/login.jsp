<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Đăng nhập - Shopee Fake</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body {
            background-color: rgb(238, 77, 45); /* Màu cam Shopee */
            font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif;
        }
        
        /* HEADER TRẮNG */
        .shopee-login-header {
            background: white;
            padding: 20px 0;
            box-shadow: 0 4px 6px rgba(0,0,0,0.05);
            margin-bottom: 0;
        }
        .header-container {
            width: 1040px;
            margin: 0 auto;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }
        .shopee-logo {
            color: #ee4d2d;
            font-size: 30px;
            font-weight: bold;
            text-decoration: none;
            display: flex;
            align-items: center;
            gap: 15px;
        }
        .page-title {
            color: #222;
            font-size: 20px;
            margin-top: 5px;
        }
        .help-link {
            color: #ee4d2d;
            text-decoration: none;
            font-size: 14px;
            font-weight: 500;
        }

        /* PHẦN THÂN (MÀU CAM) */
        .login-body {
            background: #ee4d2d; /* Cam Shopee */
            min-height: 600px;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .login-wrapper {
            width: 1040px;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }
        
        /* ẢNH BÊN TRÁI (Trang trí) */
        .branding-image {
            text-align: center;
            color: white;
            flex: 1;
        }
        .branding-image i {
            font-size: 200px;
            opacity: 0.3;
        }
        .branding-text {
            font-size: 24px;
            font-weight: bold;
            margin-top: 20px;
        }

        /* FORM BÊN PHẢI */
        .login-form-card {
            background: white;
            width: 400px;
            padding: 30px;
            border-radius: 4px;
            box-shadow: 0 3px 10px rgba(0,0,0,0.14);
        }
        .form-title {
            font-size: 20px;
            margin-bottom: 25px;
            color: #222;
        }
        .form-control {
            border-radius: 2px;
            padding: 10px;
            font-size: 14px;
        }
        .btn-shopee {
            background-color: #ee4d2d;
            color: white;
            width: 100%;
            padding: 10px;
            border: none;
            border-radius: 2px;
            text-transform: uppercase;
            font-size: 14px;
            letter-spacing: 0.5px;
        }
        .btn-shopee:hover {
            background-color: #d73211;
            color: white;
        }
        .social-login {
            display: flex;
            gap: 10px;
            margin-top: 20px;
        }
        .btn-social {
            flex: 1;
            border: 1px solid #ccc;
            font-size: 12px;
            padding: 8px;
            background: white;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 5px;
        }

        /* FOOTER */
        .footer {
            background: #f5f5f5;
            padding: 30px 0;
            text-align: center;
            color: #888;
            font-size: 12px;
        }
    </style>
</head>
<body>

    <div class="shopee-login-header">
        <div class="header-container">
            <a href="home" class="shopee-logo">
                <i class="fas fa-shopping-bag"></i> Shopee Fake
                <span class="page-title">Đăng nhập</span>
            </a>
            <a href="#" class="help-link">Bạn cần giúp đỡ?</a>
        </div>
    </div>

    <div class="login-body">
        <div class="login-wrapper">
            
            <div class="branding-image d-none d-lg-block">
                <i class="fas fa-shopping-basket"></i>
                <div class="branding-text">Nền tảng thương mại điện tử<br>yêu thích ở Đông Nam Á</div>
            </div>

            <div class="login-form-card">
                <div class="form-title">Đăng nhập</div>

                <% if(request.getAttribute("mess") != null) { %>
                    <div class="alert alert-danger py-2 small">
                        <i class="fas fa-exclamation-circle"></i> <%= request.getAttribute("mess") %>
                    </div>
                <% } %>

                <form action="login" method="post">
                    <div class="mb-3">
                        <input type="text" name="email" class="form-control" required placeholder="Email/Số điện thoại/Tên đăng nhập">
                    </div>
                    <div class="mb-3">
                        <input type="password" name="password" class="form-control" required placeholder="Mật khẩu" value="123">
                    </div>
                    
                    <button type="submit" class="btn btn-shopee mb-3">Đăng nhập</button>
                    
                    <div class="d-flex justify-content-between small text-primary mb-3">
                        <a href="#" class="text-decoration-none">Quên mật khẩu</a>
                        <a href="#" class="text-decoration-none">Đăng nhập với SMS</a>
                    </div>

                    <div class="text-center small text-muted my-2">HOẶC</div>

                    <div class="social-login">
                        <button type="button" class="btn btn-social"><i class="fab fa-facebook text-primary"></i> Facebook</button>
                        <button type="button" class="btn btn-social"><i class="fab fa-google text-danger"></i> Google</button>
                    </div>

                    <div class="text-center mt-4 small">
                        Bạn mới biết đến Shopee? <a href="#" class="text-danger fw-bold text-decoration-none">Đăng ký</a>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <div class="footer">
        <div class="container">
            <div class="row">
                <div class="col-12">
                    <span>CHÍNH SÁCH BẢO MẬT</span> &nbsp;|&nbsp; 
                    <span>QUY CHẾ HOẠT ĐỘNG</span> &nbsp;|&nbsp; 
                    <span>VẬN CHUYỂN</span> &nbsp;|&nbsp; 
                    <span>CHÍNH SÁCH TRẢ HÀNG VÀ HOÀN TIỀN</span>
                </div>
                <div class="col-12 mt-3">
                    Công ty Shopee Fake - Do ông chủ tịch lớp quản lý.<br>
                    Địa chỉ: Đại học FPT - Môn Web Java Servlet.<br>
                    © 2024 Shopee Fake. Tất cả các quyền được bảo lưu.
                </div>
            </div>
        </div>
    </div>

</body>
</html>