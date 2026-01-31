<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng nhập tài khoản - Mua sắm Online | Shopee Việt Nam</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <style>
        /* 1. RESET & FONT CHUẨN SHOPEE */
        body {
            font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif;
            background-color: rgb(238, 77, 45); /* Màu cam chủ đạo */
            margin: 0;
            padding: 0;
        }

        /* 2. HEADER TRẮNG */
        .shopee-header {
            background: #fff;
            height: 84px;
            box-shadow: 0 6px 6px -5px rgba(0,0,0,.05);
            display: flex;
            align-items: center;
        }
        .header-container {
            width: 1040px;
            margin: 0 auto;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .brand-wrap {
            display: flex;
            align-items: center;
            text-decoration: none;
        }
        .shopee-logo-icon {
            color: #ee4d2d;
            font-size: 40px;
            margin-right: 15px;
        }
        .header-title {
            font-size: 24px;
            color: #222;
            margin-top: 5px;
        }
        .help-link {
            color: #ee4d2d;
            font-size: 14px;
            text-decoration: none;
        }

        /* 3. BODY (PHẦN GIỮA) */
        .login-section {
            background-color: #ee4d2d;
            min-height: 600px;
            /* Ảnh nền Shopee thật */
            background-image: url('https://cf.shopee.vn/file/sg-11134004-7rd70-lvw88x093qf719'); 
            background-repeat: no-repeat;
            background-position: center;
            background-size: contain;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .login-container {
            width: 1040px;
            display: flex;
            justify-content: flex-end; /* Đẩy form sang phải */
        }

        /* 4. FORM LOGIN BOX */
        .login-box {
            background: #fff;
            width: 400px;
            border-radius: 4px;
            padding: 22px 30px;
            box-shadow: 0 3px 10px 0 rgba(0,0,0,.14);
            box-sizing: border-box;
        }
        .login-title {
            font-size: 20px;
            margin-bottom: 20px;
            color: #222;
            font-weight: 400;
        }
        .form-control {
            border-radius: 2px;
            height: 40px;
            font-size: 14px;
            border: 1px solid #dbdbdb;
            margin-bottom: 15px;
        }
        .form-control:focus {
            box-shadow: none;
            border-color: #777;
        }
        .btn-primary-shopee {
            background: #ee4d2d;
            color: #fff;
            width: 100%;
            height: 40px;
            border: none;
            border-radius: 2px;
            font-size: 14px;
            text-transform: uppercase;
            margin-top: 10px;
            cursor: pointer;
            box-shadow: 0 1px 1px rgba(0,0,0,.09);
        }
        .btn-primary-shopee:hover {
            background: #f05d40;
        }
        
        .links-row {
            display: flex;
            justify-content: space-between;
            margin-top: 10px;
            font-size: 12px;
        }
        .links-row a { text-decoration: none; color: #05a; }
        
        /* DIVIDER */
        .divider {
            display: flex;
            align-items: center;
            margin: 20px 0;
            color: #ccc;
        }
        .divider span { width: 100%; border-bottom: 1px solid #dbdbdb; }
        .divider-text { padding: 0 10px; font-size: 12px; color: #ccc; white-space: nowrap; }

        /* SOCIAL BUTTONS */
        .social-btns { display: flex; gap: 10px; }
        .btn-social {
            flex: 1; height: 36px; border: 1px solid #dbdbdb; background: #fff;
            display: flex; align-items: center; justify-content: center;
            border-radius: 2px; font-size: 14px; color: #000; text-decoration: none; cursor: pointer;
        }
        .btn-social:hover { background: #f5f5f5; }
        
        .register-link {
            text-align: center; margin-top: 25px; font-size: 14px; color: rgba(0,0,0,.26);
        }
        .register-link a { color: #ee4d2d; font-weight: 500; text-decoration: none; }

        /* 5. FOOTER */
        .footer-shopee {
            background: #f5f5f5;
            padding: 40px 0;
            color: rgba(0,0,0,.54);
            font-size: 12px;
            text-align: center;
        }
        .footer-policy span { padding: 0 20px; border-right: 1px solid rgba(0,0,0,.09); text-transform: uppercase; }
        .footer-policy span:last-child { border-right: none; }
        .company-info { margin-top: 20px; line-height: 1.6; }
    </style>
</head>
<body>

    <div class="shopee-header">
        <div class="header-container">
            <a href="home" class="brand-wrap">
                <i class="fas fa-shopping-bag shopee-logo-icon"></i>
                <span class="header-title">Đăng nhập</span>
            </a>
            <a href="#" class="help-link">Bạn cần giúp đỡ?</a>
        </div>
    </div>

    <div class="login-section">
        <div class="login-container">
            <div class="login-box">
                <div class="login-title">Đăng nhập</div>
                
                <% if(request.getAttribute("mess") != null) { %>
                    <div class="alert alert-danger py-2 mb-3" style="font-size: 12px; background-color:#fff6f7; border-color:#ff424f; color:#222;">
                        <i class="fas fa-exclamation-circle text-danger"></i> <%= request.getAttribute("mess") %>
                    </div>
                <% } %>

                <form action="login" method="post">
                    <input type="text" name="email" class="form-control" placeholder="Email/Số điện thoại/Tên đăng nhập" required>
                    <input type="password" name="password" class="form-control" placeholder="Mật khẩu" value="admin" required>
                    
                    <button type="submit" class="btn-primary-shopee">ĐĂNG NHẬP</button>
                    
                    <div class="links-row">
                        <a href="#">Quên mật khẩu</a>
                        <a href="#">Đăng nhập với SMS</a>
                    </div>

                    <div class="divider">
                        <span></span><div class="divider-text">HOẶC</div><span></span>
                    </div>

                    <div class="social-btns">
                        <button type="button" class="btn-social">
                            <i class="fab fa-facebook text-primary me-2"></i> Facebook
                        </button>
                        <button type="button" class="btn-social">
                            <i class="fab fa-google text-danger me-2"></i> Google
                        </button>
                    </div>

                    <div class="register-link">
                        Bạn mới biết đến Shopee? <a href="register">Đăng ký</a>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <div class="footer-shopee">
        <div class="container">
            <div class="footer-policy">
                <span>CHÍNH SÁCH BẢO MẬT</span>
                <span>QUY CHẾ HOẠT ĐỘNG</span>
                <span>VẬN CHUYỂN</span>
                <span>TRẢ HÀNG & HOÀN TIỀN</span>
            </div>
            <div class="company-info">
                <p>Công ty TNHH Shopee</p>
                <p>Địa chỉ: Tầng 4-5-6, Tòa nhà Capital Place, số 29 đường Liễu Giai, Phường Ngọc Khánh, Quận Ba Đình, Thành phố Hà Nội, Việt Nam.</p>
                <p>© 2026 Shopee. Tất cả các quyền được bảo lưu.</p>
            </div>
        </div>
    </div>

</body>
</html>