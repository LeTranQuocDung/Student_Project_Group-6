<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng ký — Shopee Kênh Người Bán</title>
    <meta name="description" content="Trở thành Người bán trên Shopee — Nền tảng thương mại điện tử hàng đầu Đông Nam Á">
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
            <span class="sa-header__title">Đăng ký</span>
        </div>
        <a href="#" class="sa-header__help" onclick="alert('Liên hệ tổng đài 19001221')">Bạn cần giúp đỡ?</a>
    </header>

    <!-- MAIN -->
    <main class="sa-main">
        <div class="sa-container">

            <!-- LEFT — Features -->
            <div class="sa-left">
                <p class="sa-left__subtitle">Shopee Việt Nam</p>
                <h1 class="sa-left__title">Trở thành Người bán<br>ngay hôm nay</h1>

                <ul class="sa-features">
                    <li>
                        <i class="fas fa-store"></i>
                        <span>Nền tảng thương mại điện tử hàng đầu Đông Nam Á và Đài Loan</span>
                    </li>
                    <li>
                        <i class="fas fa-globe-asia"></i>
                        <span>Phát triển trở thành thương hiệu toàn cầu</span>
                    </li>
                    <li>
                        <i class="fas fa-users"></i>
                        <span>Dẫn đầu lượng người dùng trên ứng dụng mua sắm tại Việt Nam</span>
                    </li>
                </ul>

                <!-- Skyline decoration -->
                <div style="width:100%;height:80px;position:relative;overflow:hidden;opacity:.1;margin-top:16px">
                    <div style="position:absolute;bottom:0;left:0;right:0;display:flex;align-items:flex-end;justify-content:center;gap:3px">
                        <div style="width:12px;height:35px;background:var(--sa-text);border-radius:1px 1px 0 0"></div>
                        <div style="width:8px;height:50px;background:var(--sa-text);border-radius:1px 1px 0 0"></div>
                        <div style="width:15px;height:30px;background:var(--sa-text);border-radius:1px 1px 0 0"></div>
                        <div style="width:10px;height:65px;background:var(--sa-text);border-radius:1px 1px 0 0"></div>
                        <div style="width:6px;height:40px;background:var(--sa-text);border-radius:1px 1px 0 0"></div>
                        <div style="width:14px;height:55px;background:var(--sa-text);border-radius:1px 1px 0 0"></div>
                        <div style="width:8px;height:25px;background:var(--sa-text);border-radius:1px 1px 0 0"></div>
                        <div style="width:20px;height:70px;background:var(--sa-text);border-radius:1px 1px 0 0"></div>
                        <div style="width:10px;height:45px;background:var(--sa-text);border-radius:1px 1px 0 0"></div>
                        <div style="width:8px;height:35px;background:var(--sa-text);border-radius:1px 1px 0 0"></div>
                        <div style="width:12px;height:60px;background:var(--sa-text);border-radius:1px 1px 0 0"></div>
                        <div style="width:6px;height:28px;background:var(--sa-text);border-radius:1px 1px 0 0"></div>
                        <div style="width:16px;height:48px;background:var(--sa-text);border-radius:1px 1px 0 0"></div>
                        <div style="width:10px;height:38px;background:var(--sa-text);border-radius:1px 1px 0 0"></div>
                        <div style="width:8px;height:55px;background:var(--sa-text);border-radius:1px 1px 0 0"></div>
                        <div style="width:14px;height:42px;background:var(--sa-text);border-radius:1px 1px 0 0"></div>
                    </div>
                </div>
            </div>

            <!-- RIGHT — Register Card -->
            <div class="sa-card">
                <h2 class="sa-card__title">Đăng ký</h2>

                <!-- Error messages -->
                <% String mess = (String) request.getAttribute("mess");
                   if (mess != null) { %>
                    <div class="sa-alert sa-alert--error">
                        <i class="fas fa-exclamation-circle"></i> <%= mess %>
                    </div>
                <% } %>

                <form action="seller-register" method="post" id="sellerRegForm">
                    <div class="sa-form-group">
                        <input type="email" name="email" class="sa-input" id="regEmail"
                               placeholder="Email" required autocomplete="email">
                        <div class="sa-error-msg" id="emailError"></div>
                    </div>
                    <div class="sa-form-group">
                        <input type="text" name="fullname" class="sa-input" id="regFullname"
                               placeholder="Họ và tên" required autocomplete="name">
                    </div>
                    <div class="sa-form-group">
                        <input type="tel" name="phone" class="sa-input" id="regPhone"
                               placeholder="Số điện thoại" required autocomplete="tel">
                        <div class="sa-error-msg" id="phoneError"></div>
                    </div>
                    <div class="sa-form-group">
                        <div class="sa-input-wrap">
                            <input type="password" name="password" class="sa-input" id="regPass"
                                   placeholder="Mật khẩu" required autocomplete="new-password">
                            <button type="button" class="sa-input-toggle" onclick="toggleRegPassword('regPass','toggleIcon1')" title="Hiện/Ẩn mật khẩu">
                                <i class="fas fa-eye-slash" id="toggleIcon1"></i>
                            </button>
                        </div>
                    </div>
                    <div class="sa-form-group">
                        <div class="sa-input-wrap">
                            <input type="password" name="re-password" class="sa-input" id="regRepass"
                                   placeholder="Nhập lại mật khẩu" required autocomplete="new-password">
                            <button type="button" class="sa-input-toggle" onclick="toggleRegPassword('regRepass','toggleIcon2')" title="Hiện/Ẩn mật khẩu">
                                <i class="fas fa-eye-slash" id="toggleIcon2"></i>
                            </button>
                        </div>
                        <div class="sa-error-msg" id="repassError"></div>
                    </div>

                    <button type="submit" class="sa-btn sa-btn--primary" id="regBtn">TIẾP THEO</button>
                </form>

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

                <div class="sa-policy">
                    Bằng việc đăng kí, bạn đã đồng ý với Shopee về<br>
                    <a href="#">Điều khoản dịch vụ</a> & <a href="#">Chính sách Bảo mật</a>
                </div>

                <div class="sa-switch">
                    Bạn đã có tài khoản? <a href="seller-login">Đăng nhập</a>
                </div>
            </div>
        </div>
    </main>

    <!-- FOOTER -->
    <footer class="sa-footer">
        © 2026 Shopee. Tất cả các quyền được bảo lưu.
    </footer>

</div>

<script>
function toggleRegPassword(inputId, iconId) {
    var input = document.getElementById(inputId);
    var icon = document.getElementById(iconId);
    if (input.type === 'password') {
        input.type = 'text';
        icon.className = 'fas fa-eye';
    } else {
        input.type = 'password';
        icon.className = 'fas fa-eye-slash';
    }
}

document.getElementById('sellerRegForm').addEventListener('submit', function(e) {
    var pass = document.getElementById('regPass').value;
    var repass = document.getElementById('regRepass').value;
    var phone = document.getElementById('regPhone').value;
    var email = document.getElementById('regEmail').value;

    // Clear errors
    document.querySelectorAll('.sa-error-msg').forEach(function(el) {
        el.classList.remove('sa-error-msg--show');
    });

    var hasError = false;

    // Validate email
    if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
        document.getElementById('emailError').textContent = 'Email không hợp lệ';
        document.getElementById('emailError').classList.add('sa-error-msg--show');
        hasError = true;
    }

    // Validate phone
    if (!/^[0-9]{9,11}$/.test(phone.replace(/\s/g, ''))) {
        document.getElementById('phoneError').textContent = 'Số điện thoại không hợp lệ';
        document.getElementById('phoneError').classList.add('sa-error-msg--show');
        hasError = true;
    }

    // Validate password match
    if (pass !== repass) {
        document.getElementById('repassError').textContent = 'Mật khẩu nhập lại không khớp';
        document.getElementById('repassError').classList.add('sa-error-msg--show');
        hasError = true;
    }

    if (hasError) {
        e.preventDefault();
        return;
    }

    var btn = document.getElementById('regBtn');
    btn.disabled = true;
    btn.innerHTML = '<span class="sa-spinner"></span> Đang xử lý...';
});
</script>
</body>
</html>
