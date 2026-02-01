<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Đăng nhập | Shopee Việt Nam</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

        <style>
            body {
                background: #f5f5f5;
                font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif;
                overflow-x: hidden;
            }

            /* HEADER */
            .login-header {
                background: #fff;
                padding: 20px 0;
                box-shadow: 0 4px 10px rgba(0,0,0,.05);
            }
            .shopee-logo {
                color: #ee4d2d;
                font-size: 30px;
                text-decoration: none;
                display: flex;
                align-items: center;
                gap: 10px;
            }
            .page-title {
                color: #222;
                font-size: 22px;
                margin-top: 5px;
            }

            /* BODY */
            .login-body {
                background-color: #ee4d2d;
                min-height: 550px;
                display: flex;
                align-items: center;
            }
            .banner-img {
                width: 100%;
                max-width: 550px;
            }

            /* CARD LOGIN */
            .login-card {
                background: #fff;
                width: 400px;
                padding: 30px;
                border-radius: 4px;
                box-shadow: 0 3px 10px 0 rgba(0,0,0,.14);
                margin-left: auto;
                position: relative;
            }
            .login-title {
                font-size: 20px;
                color: #222;
                margin-bottom: 25px;
                font-weight: 500;
            }

            .form-control {
                height: 42px;
                font-size: 14px;
                border-radius: 2px;
            }
            .form-control:focus {
                box-shadow: none;
                border-color: #777;
            }

            .btn-login {
                background: #ee4d2d;
                color: #fff;
                width: 100%;
                height: 42px;
                border: none;
                border-radius: 2px;
                font-size: 14px;
                text-transform: uppercase;
                margin-top: 15px;
            }
            .btn-login:hover {
                background: #d73211;
            }

            .separator {
                display: flex;
                align-items: center;
                margin: 20px 0;
                color: #dbdbdb;
                font-size: 12px;
            }
            .separator::before, .separator::after {
                content: "";
                flex: 1;
                height: 1px;
                background: #dbdbdb;
            }
            .separator span {
                padding: 0 10px;
                color: #ccc;
            }

            .social-btns {
                display: flex;
                gap: 10px;
                justify-content: space-between;
            }
            .btn-social {
                flex: 1;
                height: 40px;
                border: 1px solid rgba(0,0,0,.26);
                background: #fff;
                display: flex;
                align-items: center;
                justify-content: center;
                gap: 8px;
                font-size: 14px;
                text-decoration: none;
                color: #000;
                border-radius: 2px;
            }
            .btn-social:hover {
                background: #f5f5f5;
            }

            /* QR CODE CORNER (Giả lập giống Shopee) */
            .qr-corner {
                position: absolute;
                top: 0;
                right: 0;
                cursor: pointer;
                width: 70px;
                height: 70px;
                background: url('https://deo.shopeemobile.com/shopee/shopee-pcmall-live-sg/assets/32a93b426038421c.png') no-repeat;
                background-size: cover;
                /* Cắt góc tam giác */
                clip-path: polygon(0 0, 100% 0, 100% 100%);
            }
            .qr-tooltip {
                position: absolute;
                top: 15px;
                right: 80px;
                background: rgba(255, 239, 235, 0.9);
                border: 2px solid #ffbfb5;
                color: #ee4d2d;
                padding: 10px 15px;
                font-size: 13px;
                font-weight: bold;
                border-radius: 2px;
                width: 180px;
                text-align: center;
            }
            .qr-tooltip::after {
                content: '';
                position: absolute;
                top: 50%;
                right: -6px;
                transform: translateY(-50%);
                border-width: 6px;
                border-style: solid;
                border-color: transparent transparent transparent #ffbfb5;
            }

            /* Màn hình QR (Ẩn mặc định) */
            #qr-view {
                display: none;
                text-align: center;
                padding-top: 20px;
            }
            .qr-img {
                width: 180px;
                height: 180px;
                margin-bottom: 20px;
                border: 1px solid #eee;
                padding: 10px;
            }

        </style>
    </head>
    <body>

        <div class="login-header">
            <div class="container d-flex align-items-center justify-content-between">
                <a href="home" class="shopee-logo">
                    <i class="fas fa-shopping-bag"></i> 
                    <span class="fw-bold">Shopee</span>
                    <span class="page-title">Đăng nhập</span>
                </a>
                <a href="#" class="text-danger text-decoration-none small" onclick="alert('Liên hệ tổng đài 19001221')">Bạn cần giúp đỡ?</a>
            </div>
        </div>

        <div class="login-body">
            <div class="container d-flex justify-content-between align-items-center">

                <div class="d-none d-lg-block text-center text-white">
                    <img src="https://down-vn.img.susercontent.com/file/sg-11134004-7rd70-luj041g6f4r46c" class="banner-img" alt="Shopee Mall">
                    <div class="mt-3 fw-bold fs-5">Yêu thích nhất Đông Nam Á</div>
                </div>

                <div class="login-card">
                    <div class="qr-corner" onclick="toggleQR()"></div>
                    <div class="qr-tooltip" id="qr-tooltip">Đăng nhập với mã QR</div>

                    <div id="form-view">
                        <div class="login-title">Đăng nhập</div>

                        <% String err = (String) request.getAttribute("error");
                        if (err != null) {%>
                        <div class="alert alert-danger py-2 small"><i class="fas fa-exclamation-circle"></i> <%= err%></div>
                        <% }%>

                        <form action="login" method="post">
                            <div class="mb-3">
                                <input type="text" name="user" class="form-control" placeholder="Email / Số điện thoại / Tên đăng nhập" required>
                            </div>
                            <div class="mb-3">
                                <input type="password" name="pass" class="form-control" placeholder="Mật khẩu" required>
                            </div>

                            <button type="submit" class="btn-login">Đăng nhập</button>
                        </form>

                        <div class="d-flex justify-content-between mt-3 small">
                            <a href="javascript:void(0)" class="text-primary text-decoration-none" onclick="alert('Chức năng Quên mật khẩu đang bảo trì!')">Quên mật khẩu</a>
                            <a href="javascript:void(0)" class="text-secondary text-decoration-none" onclick="alert('Hệ thống SMS đang hết tiền!')">Đăng nhập với SMS</a>
                        </div>

                        <div class="separator"><span>HOẶC</span></div>

                        <div class="social-btns">
                            <a href="javascript:void(0)" class="btn-social" onclick="alert('Cần có API Key Facebook để chạy chức năng này!')">
                                <i class="fab fa-facebook text-primary"></i> Facebook
                            </a>
                            <a href="javascript:void(0)" class="btn-social" onclick="alert('Cần có API Key Google để chạy chức năng này!')">
                                <i class="fab fa-google text-danger"></i> Google
                            </a>
                        </div>

                        <div class="text-center mt-4 small">
                            <span class="text-muted">Bạn mới biết đến Shopee?</span> 
                            <a href="register" class="text-danger fw-bold text-decoration-none">Đăng ký</a>
                        </div>
                    </div>

                    <div id="qr-view">
                        <div class="login-title">Đăng nhập với mã QR</div>
                        <img src="https://upload.wikimedia.org/wikipedia/commons/d/d0/QR_code_for_mobile_English_Wikipedia.svg" class="qr-img">
                        <p class="small text-muted">Quét mã QR bằng ứng dụng Shopee</p>
                        <a href="javascript:void(0)" class="text-primary text-decoration-none small" onclick="alert('Làm sao mà quét thật được ông ơi :))')">Làm sao để quét mã?</a>
                    </div>
                </div>
            </div>
        </div>

        <div class="container py-5 text-center small text-secondary">
            <div class="row">
                <div class="col-12 mb-3">
                    <span class="mx-3">CHÍNH SÁCH BẢO MẬT</span>
                    <span class="mx-3">QUY CHẾ HOẠT ĐỘNG</span>
                    <span class="mx-3">CHÍNH SÁCH VẬN CHUYỂN</span>
                </div>
                <div class="col-12">
                    <img src="https://down-vn.img.susercontent.com/file/d4bbea4570b93bfd5fc652ca82a262a8" width="100">
                    <p class="mt-2">© 2026 Shopee. Tất cả các quyền được bảo lưu.</p>
                </div>
            </div>
        </div>

        <script>
            let isQR = false;
            function toggleQR() {
                isQR = !isQR;
                let formView = document.getElementById('form-view');
                let qrView = document.getElementById('qr-view');
                let tooltip = document.getElementById('qr-tooltip');

                if (isQR) {
                    // Chuyển sang QR
                    formView.style.display = 'none';
                    qrView.style.display = 'block';
                    tooltip.style.display = 'none'; // Ẩn tooltip khi đang ở chế độ QR
                } else {
                    // Chuyển về Form
                    formView.style.display = 'block';
                    qrView.style.display = 'none';
                    tooltip.style.display = 'block';
                }
            }
        </script>
    </body>
</html>