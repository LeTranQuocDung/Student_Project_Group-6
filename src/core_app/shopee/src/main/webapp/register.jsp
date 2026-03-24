<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Đăng ký ngay | Shopee Việt Nam</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body { background-color: rgb(238, 77, 45); font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif; }
        .shopee-header { background: white; padding: 24px 0; margin-bottom: 0; box-shadow: 0 6px 6px -5px rgba(0,0,0,0.05); }
        .header-container { width: 1040px; margin: 0 auto; display: flex; align-items: center; justify-content: space-between; }
        .shopee-logo { color: #ee4d2d; font-size: 34px; font-weight: 500; text-decoration: none; display: flex; align-items: flex-end; gap: 15px; }
        .shopee-logo i { font-size: 40px; }
        .page-title { color: #222; font-size: 24px; margin-bottom: 2px; }
        
        .register-body { background: #ee4d2d; min-height: 600px; display: flex; align-items: center; justify-content: center; }
        .register-wrapper { width: 1040px; display: flex; align-items: center; justify-content: space-between; }
        
        .branding-image { flex: 1; text-align: center; color: white; display: flex; flex-direction: column; align-items: center; }
        .branding-image i { font-size: 180px; opacity: 0.9; margin-bottom: 20px;}
        .branding-text { font-size: 26px; font-weight: 500; }

        .register-card { background: white; width: 400px; padding: 30px; border-radius: 4px; box-shadow: 0 3px 10px rgba(0,0,0,0.14); }
        .form-control { border-radius: 2px; padding: 12px; font-size: 14px; margin-bottom: 15px; border: 1px solid #dbdbdb; }
        .btn-shopee { background-color: #ee4d2d; color: white; width: 100%; border: none; padding: 12px; text-transform: uppercase; font-size: 14px; border-radius: 2px; box-shadow: 0 1px 1px rgba(0,0,0,.09); }
        .btn-shopee:hover { background-color: #d73211; color: white; }

        .footer { background: #f5f5f5; padding: 40px 0; text-align: center; color: #757575; font-size: 12px; }
    </style>
</head>
<body>

    <div class="shopee-header">
        <div class="header-container">
            <a href="home" class="shopee-logo">
                <i class="fas fa-shopping-bag"></i>
                <span class="page-title">Đăng ký</span>
            </a>
            <a href="#" class="text-danger text-decoration-none small">Bạn cần giúp đỡ?</a>
        </div>
    </div>

    <div class="register-body">
        <div class="register-wrapper">
            <div class="branding-image d-none d-lg-flex">
                <i class="fas fa-shopping-basket"></i>
                <div class="branding-text">Nền tảng thương mại điện tử<br>yêu thích ở Đông Nam Á</div>
            </div>

            <div class="register-card">
                <div style="font-size: 20px; margin-bottom: 25px;">Đăng ký</div>
                
                <% if(request.getAttribute("mess") != null) { %>
                    <div class="alert alert-danger py-2 small text-center"><%= request.getAttribute("mess") %></div>
                <% } %>

                <form action="register" method="post">
                    <input type="text" name="email" class="form-control" required placeholder="Email (Tên đăng nhập)">
                    <input type="text" name="fullname" class="form-control" required placeholder="Họ và Tên">
                    <input type="text" name="phone" class="form-control" required placeholder="Số điện thoại">
                    <input type="password" name="password" class="form-control" required placeholder="Mật khẩu">
                    <input type="password" name="re-password" class="form-control" required placeholder="Nhập lại mật khẩu">
                    
                    <button type="submit" class="btn btn-shopee mb-3">TIẾP THEO</button>
                    
                    <div class="text-center small text-muted">
                        Bằng việc đăng kí, bạn đồng ý với <a href="#" class="text-danger text-decoration-none">Điều khoản Shopee</a>
                    </div>
                    
                    <div class="text-center small mt-4">
                        Bạn đã có tài khoản? <a href="login" class="text-danger fw-bold text-decoration-none">Đăng nhập</a>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <div class="footer">
        <div class="container">
            <div style="margin-bottom: 20px;">
                <span style="margin: 0 10px;">CHÍNH SÁCH BẢO MẬT</span> |
                <span style="margin: 0 10px;">QUY CHẾ HOẠT ĐỘNG</span> |
                <span style="margin: 0 10px;">VẬN CHUYỂN</span>
            </div>
            <div>© 2026 Shopee. Tất cả các quyền được bảo lưu.</div>
        </div>
    </div>
</body>
</html>
