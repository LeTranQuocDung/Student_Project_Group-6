<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng nhập — Shopee Kênh Người Bán</title>
    <meta name="description" content="Đăng nhập Kênh Người Bán Shopee — Quản lý shop và bán hàng chuyên nghiệp">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/normalize/8.0.1/normalize.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link rel="stylesheet" href="css/seller_auth.css">
</head>
<body>
<div class="sa-page">

    <!-- HEADER -->
    <header class="sa-header">
        <div class="sa-header__left">
            <a href="home" class="sa-header__logo">
                <i class="fa-solid fa-bag-shopping"></i> Shopee
            </a>
            <span class="sa-header__title">Kênh Người Bán</span>
        </div>
        <a href="#" class="sa-header__help" onclick="alert('Liên hệ tổng đài 19001221')">Bạn cần giúp đỡ?</a>
    </header>

    <!-- MAIN -->
    <main class="sa-main">
        <div class="sa-container">

            <!-- LEFT — Illustration -->
            <div class="sa-left">
                <h1 class="sa-left__title" style="font-style:italic;color:var(--sa-text)">Bán hàng chuyên nghiệp</h1>
                <p class="sa-left__desc">
                    Quản lý shop của bạn một cách hiệu quả hơn trên Shopee với Shopee - Kênh Người Bán
                </p>
                <div class="sa-illustration">
                    <div style="position:relative;width:100%;height:100%;display:flex;align-items:center;justify-content:center">
                        <!-- Cloud -->
                        <i class="fas fa-cloud" style="position:absolute;top:20px;left:40px;font-size:50px;color:rgba(255,255,255,.06)"></i>
                        <i class="fas fa-cloud" style="position:absolute;top:60px;left:0;font-size:30px;color:rgba(255,255,255,.04)"></i>
                        <!-- Main shop -->
                        <div style="display:flex;flex-direction:column;align-items:center;position:relative;z-index:2">
                            <i class="fas fa-store" style="font-size:80px;color:var(--sa-orange);opacity:.8"></i>
                            <div style="width:160px;height:8px;background:rgba(255,255,255,.05);border-radius:50%;margin-top:8px"></div>
                        </div>
                        <!-- Side elements -->
                        <i class="fas fa-laptop" style="position:absolute;bottom:40px;left:20px;font-size:48px;color:rgba(255,255,255,.1)"></i>
                        <i class="fas fa-mobile-alt" style="position:absolute;bottom:50px;right:40px;font-size:36px;color:rgba(255,255,255,.08)"></i>
                        <i class="fas fa-chart-line" style="position:absolute;top:30px;right:20px;font-size:32px;color:rgba(255,255,255,.06)"></i>
                        <!-- Ground line -->
                        <div style="position:absolute;bottom:28px;left:0;right:0;height:2px;background:linear-gradient(90deg,transparent,rgba(255,255,255,.06),transparent)"></div>
                    </div>
                </div>
            </div>

            <!-- RIGHT — Login Card -->
            <div class="sa-card">
                <!-- QR Corner -->
                <div class="sa-qr-corner" onclick="alert('Tính năng QR đang phát triển')" title="Đăng nhập với mã QR">
                    <i class="fas fa-qrcode"></i>
                </div>
                <div class="sa-qr-tooltip" onclick="alert('Tính năng QR đang phát triển')">Đăng nhập với mã QR</div>

                <h2 class="sa-card__title">Đăng nhập</h2>

                <!-- Error/Success messages -->
                <% String err = (String) request.getAttribute("error");
                   if (err != null) { %>
                    <div class="sa-alert sa-alert--error">
                        <i class="fas fa-exclamation-circle"></i> <%= err %>
                    </div>
                <% } %>
                <% String mess = (String) request.getAttribute("mess");
                   if (mess != null) { %>
                    <div class="sa-alert sa-alert--success">
                        <i class="fas fa-check-circle"></i> <%= mess %>
                    </div>
                <% } %>

                <form action="seller-login" method="post" id="sellerLoginForm">
                    <div class="sa-form-group">
                        <input type="text" name="user" class="sa-input" id="loginUser"
                               placeholder="Email/Số điện thoại/Tên đăng nhập" required autocomplete="username">
                    </div>
                    <div class="sa-form-group">
                        <div class="sa-input-wrap">
                            <input type="password" name="pass" class="sa-input" id="loginPass"
                                   placeholder="Mật khẩu" required autocomplete="current-password">
                            <button type="button" class="sa-input-toggle" onclick="togglePassword()" title="Hiện/Ẩn mật khẩu">
                                <i class="fas fa-eye-slash" id="toggleIcon"></i>
                            </button>
                        </div>
                    </div>

                    <button type="submit" class="sa-btn sa-btn--primary" id="loginBtn">ĐĂNG NHẬP</button>
                </form>

                <a href="#" class="sa-forgot" onclick="alert('Chức năng Quên mật khẩu đang bảo trì!')">Quên mật khẩu</a>

                <div class="sa-separator"><span>HOẶC</span></div>

                <div class="sa-social-btns">
                    <a href="facebook-login" class="sa-social-btn">
                        <i class="fab fa-facebook"></i> Facebook
                    </a>
                    <a href="google-login" class="sa-social-btn">
                        <svg class="sa-google-icon" viewBox="0 0 24 24"><path fill="#4285F4" d="M22.56 12.25c0-.78-.07-1.53-.2-2.25H12v4.26h5.92a5.06 5.06 0 0 1-2.2 3.32v2.77h3.57c2.08-1.92 3.28-4.74 3.28-8.1z"/><path fill="#34A853" d="M12 23c2.97 0 5.46-.98 7.28-2.66l-3.57-2.77c-.98.66-2.23 1.06-3.71 1.06-2.86 0-5.29-1.93-6.16-4.53H2.18v2.84C3.99 20.53 7.7 23 12 23z"/><path fill="#FBBC05" d="M5.84 14.09c-.22-.66-.35-1.36-.35-2.09s.13-1.43.35-2.09V7.07H2.18C1.43 8.55 1 10.22 1 12s.43 3.45 1.18 4.93l2.85-2.22.81-.62z"/><path fill="#EA4335" d="M12 5.38c1.62 0 3.06.56 4.21 1.64l3.15-3.15C17.45 2.09 14.97 1 12 1 7.7 1 3.99 3.47 2.18 7.07l3.66 2.84c.87-2.6 3.3-4.53 6.16-4.53z"/></svg>
                        Google
                    </a>
                </div>

                <div class="sa-switch">
                    Bạn mới biết đến Shopee? <a href="seller-register">Đăng ký</a>
                </div>

                <a href="login" class="sa-account-type">
                    Đăng nhập với tài khoản Chính/ Phụ <i class="fas fa-chevron-right"></i>
                </a>
            </div>
        </div>
    </main>

    <!-- FOOTER -->
    <footer class="sa-footer">
        © 2026 Shopee. Tất cả các quyền được bảo lưu.
    </footer>

</div>

<script>
function togglePassword() {
    var input = document.getElementById('loginPass');
    var icon = document.getElementById('toggleIcon');
    if (input.type === 'password') {
        input.type = 'text';
        icon.className = 'fas fa-eye';
    } else {
        input.type = 'password';
        icon.className = 'fas fa-eye-slash';
    }
}

document.getElementById('sellerLoginForm').addEventListener('submit', function() {
    var btn = document.getElementById('loginBtn');
    btn.disabled = true;
    btn.innerHTML = '<span class="sa-spinner"></span> Đang đăng nhập...';
});
</script>
</body>
</html>
