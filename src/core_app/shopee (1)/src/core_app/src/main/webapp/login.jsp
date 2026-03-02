<%@page contentType="text/html" pageEncoding="UTF-8" %>
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
                box-shadow: 0 4px 10px rgba(0, 0, 0, .05);
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
                box-shadow: 0 3px 10px 0 rgba(0, 0, 0, .14);
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

            .separator::before,
            .separator::after {
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
                border: 1px solid rgba(0, 0, 0, .26);
                background: #fff;
                display: flex;
                align-items: center;
                justify-content: center;
                gap: 8px;
                font-size: 14px;
                text-decoration: none;
                color: #000;
                border-radius: 2px;
                cursor: pointer;
                transition: all .2s;
            }

            .btn-social:hover {
                background: #f5f5f5;
                border-color: rgba(0,0,0,.4);
            }

            .btn-social.fb:hover { border-color: #1877f2; color: #1877f2; }
            .btn-social.gg:hover { border-color: #ea4335; color: #ea4335; }

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
                clip-path: polygon(0 0, 100% 0, 100% 100%);
                z-index: 10;
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
                z-index: 10;
                cursor: pointer;
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

            /* Màn hình QR */
            #qr-view {
                display: none;
                text-align: center;
                padding-top: 10px;
            }

            .qr-container {
                width: 200px;
                height: 200px;
                margin: 0 auto 15px;
                border: 1px solid #eee;
                padding: 10px;
                display: flex;
                align-items: center;
                justify-content: center;
                position: relative;
                border-radius: 4px;
            }

            .qr-container canvas { max-width: 100%; max-height: 100%; }

            .qr-status {
                font-size: 13px;
                margin: 10px 0;
                padding: 8px 12px;
                border-radius: 4px;
            }
            .qr-status.pending { background: #fff3cd; color: #856404; }
            .qr-status.success { background: #d4edda; color: #155724; }
            .qr-status.error { background: #f8d7da; color: #721c24; }

            .btn-confirm-qr {
                background: #ee4d2d;
                color: #fff;
                border: none;
                padding: 10px 24px;
                border-radius: 4px;
                font-size: 14px;
                cursor: pointer;
                margin-top: 10px;
                transition: background .2s;
            }
            .btn-confirm-qr:hover { background: #d73211; }

            .btn-refresh-qr {
                background: #f5f5f5;
                color: #333;
                border: 1px solid #ddd;
                padding: 8px 16px;
                border-radius: 4px;
                font-size: 13px;
                cursor: pointer;
                margin-top: 8px;
                transition: all .2s;
            }
            .btn-refresh-qr:hover { background: #eee; }

            /* Loading spinner cho QR */
            .qr-loading {
                width: 40px;
                height: 40px;
                border: 3px solid #f0f0f0;
                border-top-color: #ee4d2d;
                border-radius: 50%;
                animation: spin .8s linear infinite;
            }
            @keyframes spin { to { transform: rotate(360deg); }}

            /* Pulse animation */
            @keyframes pulse {
                0% { transform: scale(1); }
                50% { transform: scale(1.02); }
                100% { transform: scale(1); }
            }
            .qr-scanning .qr-container {
                border-color: #ee4d2d;
                animation: pulse 2s ease-in-out infinite;
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
                <a href="#" class="text-danger text-decoration-none small"
                    onclick="alert('Liên hệ tổng đài 19001221')">Bạn cần giúp đỡ?</a>
            </div>
        </div>

        <div class="login-body">
            <div class="container d-flex justify-content-between align-items-center">

                <div class="d-none d-lg-block text-center text-white">
                    <img src="https://down-vn.img.susercontent.com/file/sg-11134004-7rd70-luj041g6f4r46c"
                        class="banner-img" alt="Shopee Mall">
                    <div class="mt-3 fw-bold fs-5">Yêu thích nhất Đông Nam Á</div>
                </div>

                <div class="login-card">
                    <div class="qr-corner" onclick="toggleQR()"></div>
                    <div class="qr-tooltip" id="qr-tooltip" onclick="toggleQR()">Đăng nhập với mã QR</div>

                    <!-- ========== FORM VIEW ========== -->
                    <div id="form-view">
                        <div class="login-title">Đăng nhập</div>

                        <% String err=(String) request.getAttribute("error"); if (err !=null) {%>
                            <div class="alert alert-danger py-2 small"><i class="fas fa-exclamation-circle"></i>
                                <%= err%>
                            </div>
                        <% }%>

                        <% String mess=(String) request.getAttribute("mess"); if (mess !=null) {%>
                            <div class="alert alert-success py-2 small"><i class="fas fa-check-circle"></i>
                                <%= mess%>
                            </div>
                        <% }%>

                        <form action="login" method="post">
                            <div class="mb-3">
                                <input type="text" name="user" class="form-control"
                                    placeholder="Email / Số điện thoại / Tên đăng nhập" required>
                            </div>
                            <div class="mb-3">
                                <input type="password" name="pass" class="form-control"
                                    placeholder="Mật khẩu" required>
                            </div>

                            <button type="submit" class="btn-login">Đăng nhập</button>
                        </form>

                        <div class="d-flex justify-content-between mt-3 small">
                            <a href="javascript:void(0)" class="text-primary text-decoration-none"
                                onclick="alert('Chức năng Quên mật khẩu đang bảo trì!')">Quên mật
                                khẩu</a>
                            <a href="javascript:void(0)" class="text-secondary text-decoration-none"
                                onclick="alert('Hệ thống SMS đang hết tiền!')">Đăng nhập với SMS</a>
                        </div>

                        <div class="separator"><span>HOẶC</span></div>

                        <!-- ===== SOCIAL LOGIN BUTTONS ===== -->
                        <div class="social-btns">
                            <a href="facebook-login" class="btn-social fb">
                                <i class="fab fa-facebook text-primary"></i> Facebook
                            </a>
                            <a href="google-login" class="btn-social gg">
                                <i class="fab fa-google text-danger"></i> Google
                            </a>
                        </div>

                        <div class="text-center mt-4 small">
                            <span class="text-muted">Bạn mới biết đến Shopee?</span>
                            <a href="register" class="text-danger fw-bold text-decoration-none">Đăng
                                ký</a>
                        </div>
                    </div>

                    <!-- ========== QR VIEW ========== -->
                    <div id="qr-view">
                        <div class="login-title">Đăng nhập với mã QR</div>

                        <div class="qr-container" id="qrContainer">
                            <div class="qr-loading" id="qrLoading"></div>
                        </div>

                        <div class="qr-status pending" id="qrStatus">
                            <i class="fas fa-spinner fa-spin"></i> Đang tạo mã QR...
                        </div>

                        <p class="small text-muted mb-1">Quét mã QR bằng ứng dụng Shopee</p>

                        <button class="btn-confirm-qr" id="btnConfirmQr" style="display:none"
                                onclick="confirmQrScan()">
                            <i class="fas fa-mobile-alt"></i> Giả lập quét QR (Demo)
                        </button>

                        <button class="btn-refresh-qr" id="btnRefreshQr" style="display:none"
                                onclick="generateQrCode()">
                            <i class="fas fa-redo"></i> Tạo mã QR mới
                        </button>
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

        <!-- QR Code Generator Library -->
        <script src="https://cdn.jsdelivr.net/npm/qrcodejs@1.0.0/qrcode.min.js"></script>

        <script>
            // ==========================================
            // 1. TOGGLE QR / FORM VIEW
            // ==========================================
            let isQR = false;
            let qrToken = null;
            let pollingInterval = null;

            function toggleQR() {
                isQR = !isQR;
                let formView = document.getElementById('form-view');
                let qrView = document.getElementById('qr-view');
                let tooltip = document.getElementById('qr-tooltip');

                if (isQR) {
                    formView.style.display = 'none';
                    qrView.style.display = 'block';
                    tooltip.innerHTML = 'Đăng nhập với tài khoản';
                    // Tạo QR code khi chuyển sang qr-view
                    generateQrCode();
                } else {
                    formView.style.display = 'block';
                    qrView.style.display = 'none';
                    tooltip.innerHTML = 'Đăng nhập với mã QR';
                    // Dừng polling khi quay lại form
                    stopPolling();
                }
            }

            // ==========================================
            // 2. GOOGLE: Direct redirect (href="google-login")
            // 3. FACEBOOK: Direct redirect (href="facebook-login")
            // ==========================================

            // ==========================================
            // 3. QR CODE LOGIN
            // ==========================================
            function generateQrCode() {
                stopPolling();

                let container = document.getElementById('qrContainer');
                let status = document.getElementById('qrStatus');
                let btnConfirm = document.getElementById('btnConfirmQr');
                let btnRefresh = document.getElementById('btnRefreshQr');

                // Reset UI
                container.innerHTML = '<div class="qr-loading"></div>';
                status.className = 'qr-status pending';
                status.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Đang tạo mã QR...';
                btnConfirm.style.display = 'none';
                btnRefresh.style.display = 'none';

                // Gọi API tạo token
                fetch('qr-login?action=generate')
                    .then(r => r.json())
                    .then(data => {
                        if (data.token) {
                            qrToken = data.token;
                            container.innerHTML = '';

                            // Tạo QR Code bằng thư viện qrcodejs
                            new QRCode(container, {
                                text: 'shopee://qr-login?token=' + qrToken,
                                width: 170,
                                height: 170,
                                colorDark: '#000000',
                                colorLight: '#ffffff',
                                correctLevel: QRCode.CorrectLevel.H
                            });

                            status.className = 'qr-status pending';
                            status.innerHTML = '<i class="fas fa-qrcode"></i> Quét mã để đăng nhập';
                            btnConfirm.style.display = 'inline-block';
                            btnRefresh.style.display = 'none';

                            // Bắt đầu polling
                            startPolling();
                        }
                    })
                    .catch(err => {
                        container.innerHTML = '<i class="fas fa-exclamation-triangle text-danger" style="font-size:40px"></i>';
                        status.className = 'qr-status error';
                        status.innerHTML = '<i class="fas fa-times-circle"></i> Lỗi tạo mã QR!';
                        btnRefresh.style.display = 'inline-block';
                    });
            }

            function startPolling() {
                pollingInterval = setInterval(() => {
                    if (!qrToken) return;

                    fetch('qr-login?action=check&token=' + qrToken)
                        .then(r => r.json())
                        .then(data => {
                            let status = document.getElementById('qrStatus');

                            if (data.status === 'CONFIRMED') {
                                stopPolling();
                                status.className = 'qr-status success';
                                status.innerHTML = '<i class="fas fa-check-circle"></i> Đăng nhập thành công! Đang chuyển trang...';
                                document.getElementById('btnConfirmQr').style.display = 'none';

                                // Chuyển trang
                                setTimeout(() => {
                                    window.location.href = data.redirect || 'home';
                                }, 1000);
                            } else if (data.status === 'EXPIRED') {
                                stopPolling();
                                status.className = 'qr-status error';
                                status.innerHTML = '<i class="fas fa-clock"></i> Mã QR đã hết hạn!';
                                document.getElementById('btnConfirmQr').style.display = 'none';
                                document.getElementById('btnRefreshQr').style.display = 'inline-block';
                            }
                        });
                }, 2000); // Polling mỗi 2 giây
            }

            function stopPolling() {
                if (pollingInterval) {
                    clearInterval(pollingInterval);
                    pollingInterval = null;
                }
            }

            function confirmQrScan() {
                if (!qrToken) return;

                let btn = document.getElementById('btnConfirmQr');
                btn.disabled = true;
                btn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Đang xác nhận...';

                // Giả lập quét QR
                fetch('qr-login?action=confirm&token=' + qrToken, {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                    body: 'token=' + qrToken + '&action=confirm'
                })
                .then(r => r.json())
                .then(data => {
                    if (data.success) {
                        let status = document.getElementById('qrStatus');
                        status.className = 'qr-status success';
                        status.innerHTML = '<i class="fas fa-mobile-alt"></i> Quét QR thành công! Đang xác nhận...';
                    } else {
                        btn.disabled = false;
                        btn.innerHTML = '<i class="fas fa-mobile-alt"></i> Giả lập quét QR (Demo)';
                        alert('Lỗi xác nhận: ' + (data.error || 'Unknown'));
                    }
                });
            }
        </script>
    </body>

    </html>
