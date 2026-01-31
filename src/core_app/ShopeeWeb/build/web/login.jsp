<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Đăng nhập tài khoản - Mua sắm Online | Shopee Việt Nam</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body {
            background-color: rgb(238, 77, 45);
            font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif;
        }
        
        /* HEADER */
        .shopee-login-header {
            background: white;
            padding: 24px 0;
            box-shadow: 0 6px 6px -5px rgba(0,0,0,0.05);
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
            font-size: 34px;
            font-weight: 500;
            text-decoration: none;
            display: flex;
            align-items: flex-end;
            gap: 15px;
        }
        .shopee-logo i { font-size: 40px; }
        .page-title {
            color: #222;
            font-size: 24px;
            margin-bottom: 2px;
        }
        .help-link {
            color: #ee4d2d;
            text-decoration: none;
            font-size: 14px;
        }

        /* BODY */
        .login-body {
            background-color: rgb(238, 77, 45);
            min-height: 600px;
            display: flex;
            align-items: center;
            justify-content: center;
            background-image: url('https://cf.shopee.vn/file/sg-11134004-7rd70-lvw88x093qf719'); /* Background Shopee thật nếu có */
            background-size: contain;
            background-repeat: no-repeat;
            background-position: center;
        }
        .login-wrapper {
            width: 1040px;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }
        
        /* BRANDING LEFT */
        .branding-image {
            flex: 1;
            text-align: center;
            color: white;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
        }
        .branding-image i { font-size: 180px; opacity: 0.9; margin-bottom: 20px;}
        .branding-text { font-size: 26px; font-weight: 500; }

        /* FORM RIGHT */
        .login-form-card {
            background: white;
            width: 400px;
            padding: 30px;
            border-radius: 4px;
            box-shadow: 0 3px 10px rgba(0,0,0,0.14);
        }
        .form-title { font-size: 20px; margin-bottom: 25px; color: #222; font-weight: 400; }
        .form-control { border-radius: 2px; padding: 12px; font-size: 14px; border: 1px solid #dbdbdb; }
        .form-control:focus { border-color: #777; box-shadow: none; }
        
        .btn-shopee {
            background-color: #ee4d2d;
            color: white;
            width: 100%;
            padding: 12px;
            border: none;
            border-radius: 2px;
            text-transform: uppercase;
            font-size: 14px;
            box-shadow: 0 1px 1px rgba(0,0,0,.09);
        }
        .btn-shopee:hover { background-color: #d73211; color: white; }
        
        .social-login { display: flex; gap: 10px; margin-top: 25px; }
        .btn-social {
            flex: 1; border: 1px solid #dbdbdb; font-size: 14px; padding: 10px;
            background: white; display: flex; align-items: center; justify-content: center; gap: 8px; color: #555;
        }

        /* FOOTER */
        .footer { background: #f5f5f5; padding: 40px 0; text-align: center; color: #757575; font-size: 12px; }
        .footer-links span { margin: 0 15px; text-transform: uppercase; }
        .footer-info { margin-top: 15px; line-height: 1.6; }
    </style>
</head>
<body>

    <div class="shopee-login-header">
        <div class="header-container">
            <a href="home" class="shopee-logo">
                <i class="fas fa-shopping-bag"></i>
                <span class="page-title">Đăng nhập</span>
            </a>
            <a href="#" class="help-link">Bạn cần giúp đỡ?</a>
        </div>
    </div>

    <div class="login-body">
        <div class="login-wrapper">
            <div class="branding-image d-none d-lg-flex">
                <i class="fas fa-shopping-basket"></i>
                <div class="branding-text">Nền tảng thương mại điện tử<br>yêu thích ở Đông Nam Á</div>
            </div>

            <div class="login-form-card">
                <div class="form-title">Đăng nhập</div>

                <% if(request.getAttribute("mess") != null) { %>
                    <div class="alert alert-danger py-2 small d-flex align-items-center gap-2">
                        <i class="fas fa-exclamation-circle"></i> <%= request.getAttribute("mess") %>
                    </div>
                <% } %>

                <form action="login" method="post">
                    <div class="mb-3">
                        <input type="text" name="email" class="form-control" required placeholder="Email/Số điện thoại/Tên đăng nhập">
                    </div>
                    <div class="mb-3">
                        <input type="password" name="password" class="form-control" required placeholder="Mật khẩu" value="admin">
                    </div>
                    
                    <button type="submit" class="btn btn-shopee mb-2">ĐĂNG NHẬP</button>
                    
                    <div class="d-flex justify-content-between small text-primary mb-4">
                        <a href="#" class="text-decoration-none text-primary">Quên mật khẩu</a>
                        <a href="#" class="text-decoration-none text-primary">Đăng nhập với SMS</a>
                    </div>

                    <div class="text-center small text-muted my-2" style="position: relative;">
                        <span style="background: white; padding: 0 10px; position: relative; z-index: 1;">HOẶC</span>
                        <div style="border-top: 1px solid #dbdbdb; position: absolute; top: 50%; width: 100%; left: 0;"></div>
                    </div>

                    <div class="social-login">
                        <button type="button" class="btn btn-social"><i class="fab fa-facebook text-primary"></i> Facebook</button>
                        <button type="button" class="btn btn-social"><i class="fab fa-google text-danger"></i> Google</button>
                    </div>

                    <div class="text-center mt-4 small text-muted">
                        Bạn mới biết đến Shopee? <a href="register" class="text-danger fw-bold text-decoration-none">Đăng ký</a>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <div class="footer">
        <div class="container">
            <div class="footer-links">
                <span>CHÍNH SÁCH BẢO MẬT</span>
                <span>QUY CHẾ HOẠT ĐỘNG</span>
                <span>CHÍNH SÁCH VẬN CHUYỂN</span>
                <span>CHÍNH SÁCH TRẢ HÀNG VÀ HOÀN TIỀN</span>
            </div>
            <div class="footer-info">
                <i class="fas fa-check-circle"></i> Công ty Shopee Việt Nam - Trụ sở chính: Tầng 4-5-6, Tòa nhà Capital Place, số 29 đường Liễu Giai, Phường Ngọc Khánh, Quận Ba Đình, Thành phố Hà Nội, Việt Nam.<br>
                © 2026 Shopee. Tất cả các quyền được bảo lưu.
            </div>
        </div>
    </div>
</body>
</html>