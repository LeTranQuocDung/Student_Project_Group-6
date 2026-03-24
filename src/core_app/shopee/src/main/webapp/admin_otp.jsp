<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="vi">

    <head>
        <meta charset="UTF-8">
        <title>Xác thực Admin | Shopee Clone</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
        <style>
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }

            body {
                font-family: 'Inter', sans-serif;
                background: linear-gradient(135deg, #ee4d2d 0%, #ff7b54 50%, #ee4d2d 100%);
                min-height: 100vh;
                display: flex;
                align-items: center;
                justify-content: center;
                overflow: hidden;
            }

            /* Animated background particles */
            .bg-particles {
                position: fixed;
                top: 0;
                left: 0;
                right: 0;
                bottom: 0;
                pointer-events: none;
                z-index: 0;
            }

            .bg-particles::before,
            .bg-particles::after {
                content: '';
                position: absolute;
                border-radius: 50%;
                background: rgba(255, 255, 255, 0.05);
                animation: float 6s ease-in-out infinite;
            }

            .bg-particles::before {
                width: 300px;
                height: 300px;
                top: -50px;
                right: -50px;
                animation-delay: 0s;
            }

            .bg-particles::after {
                width: 200px;
                height: 200px;
                bottom: -30px;
                left: -30px;
                animation-delay: 3s;
            }

            @keyframes float {

                0%,
                100% {
                    transform: translateY(0) scale(1);
                }

                50% {
                    transform: translateY(-30px) scale(1.05);
                }
            }

            /* Main card */
            .otp-card {
                background: #ffffff;
                border-radius: 20px;
                box-shadow: 0 25px 60px rgba(0, 0, 0, 0.2);
                width: 460px;
                max-width: 95vw;
                padding: 45px 40px;
                position: relative;
                z-index: 1;
                animation: slideUp 0.5s ease-out;
            }

            @keyframes slideUp {
                from {
                    opacity: 0;
                    transform: translateY(40px);
                }

                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            /* Shield icon */
            .shield-icon {
                width: 70px;
                height: 70px;
                background: linear-gradient(135deg, #ee4d2d, #ff7b54);
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                margin: 0 auto 20px;
                box-shadow: 0 8px 25px rgba(238, 77, 45, 0.3);
                animation: pulse 2s ease-in-out infinite;
            }

            @keyframes pulse {

                0%,
                100% {
                    box-shadow: 0 8px 25px rgba(238, 77, 45, 0.3);
                }

                50% {
                    box-shadow: 0 8px 40px rgba(238, 77, 45, 0.5);
                }
            }

            .shield-icon i {
                color: white;
                font-size: 30px;
            }

            .otp-title {
                text-align: center;
                font-weight: 700;
                color: #222;
                font-size: 22px;
                margin-bottom: 8px;
            }

            .otp-subtitle {
                text-align: center;
                color: #888;
                font-size: 14px;
                margin-bottom: 30px;
                line-height: 1.5;
            }

            .otp-subtitle .email-highlight {
                color: #ee4d2d;
                font-weight: 600;
            }

            /* OTP Input boxes */
            .otp-inputs {
                display: flex;
                gap: 10px;
                justify-content: center;
                margin-bottom: 25px;
            }

            .otp-inputs input {
                width: 52px;
                height: 60px;
                text-align: center;
                font-size: 24px;
                font-weight: 700;
                color: #333;
                border: 2px solid #e0e0e0;
                border-radius: 12px;
                outline: none;
                transition: all 0.3s ease;
                background: #fafafa;
            }

            .otp-inputs input:focus {
                border-color: #ee4d2d;
                background: #fff;
                box-shadow: 0 0 0 3px rgba(238, 77, 45, 0.15);
                transform: scale(1.05);
            }

            .otp-inputs input.filled {
                border-color: #ee4d2d;
                background: #fff5f3;
            }

            .otp-inputs input.error-shake {
                animation: shake 0.4s ease;
                border-color: #dc3545;
            }

            @keyframes shake {

                0%,
                100% {
                    transform: translateX(0);
                }

                25% {
                    transform: translateX(-8px);
                }

                75% {
                    transform: translateX(8px);
                }
            }

            /* Timer */
            .timer-section {
                text-align: center;
                margin-bottom: 20px;
            }

            .timer-badge {
                display: inline-flex;
                align-items: center;
                gap: 6px;
                background: #f8f9fa;
                padding: 8px 16px;
                border-radius: 20px;
                font-size: 13px;
                color: #666;
            }

            .timer-badge .time {
                color: #ee4d2d;
                font-weight: 700;
            }

            .timer-badge.expired {
                background: #fff3cd;
                color: #856404;
            }

            /* Submit button */
            .btn-verify {
                width: 100%;
                height: 48px;
                background: linear-gradient(135deg, #ee4d2d, #ff6b45);
                color: white;
                border: none;
                border-radius: 12px;
                font-size: 16px;
                font-weight: 600;
                cursor: pointer;
                transition: all 0.3s ease;
                display: flex;
                align-items: center;
                justify-content: center;
                gap: 8px;
                margin-bottom: 15px;
            }

            .btn-verify:hover {
                background: linear-gradient(135deg, #d73211, #ee4d2d);
                transform: translateY(-2px);
                box-shadow: 0 8px 25px rgba(238, 77, 45, 0.3);
            }

            .btn-verify:disabled {
                opacity: 0.6;
                cursor: not-allowed;
                transform: none;
                box-shadow: none;
            }

            /* Resend section */
            .resend-section {
                text-align: center;
                padding-top: 10px;
                border-top: 1px solid #f0f0f0;
            }

            .resend-text {
                color: #888;
                font-size: 13px;
                margin-bottom: 8px;
            }

            .btn-resend {
                background: none;
                border: 2px solid #ee4d2d;
                color: #ee4d2d;
                padding: 8px 24px;
                border-radius: 8px;
                font-size: 13px;
                font-weight: 600;
                cursor: pointer;
                transition: all 0.3s ease;
            }

            .btn-resend:hover:not(:disabled) {
                background: #ee4d2d;
                color: white;
            }

            .btn-resend:disabled {
                opacity: 0.4;
                cursor: not-allowed;
                border-color: #ccc;
                color: #ccc;
            }

            /* Back link */
            .back-link {
                text-align: center;
                margin-top: 20px;
            }

            .back-link a {
                color: #888;
                font-size: 13px;
                text-decoration: none;
                transition: color 0.2s;
            }

            .back-link a:hover {
                color: #ee4d2d;
            }

            /* Alert styles */
            .alert-custom {
                border-radius: 10px;
                padding: 12px 16px;
                font-size: 13px;
                margin-bottom: 20px;
                display: flex;
                align-items: center;
                gap: 8px;
                animation: slideDown 0.3s ease;
            }

            @keyframes slideDown {
                from {
                    opacity: 0;
                    transform: translateY(-10px);
                }

                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            .alert-error {
                background: #fff2f0;
                border: 1px solid #ffccc7;
                color: #cf1322;
            }

            .alert-success {
                background: #f6ffed;
                border: 1px solid #b7eb8f;
                color: #389e0d;
            }

            /* Loading spinner */
            .spinner {
                display: none;
                width: 20px;
                height: 20px;
                border: 2px solid rgba(255, 255, 255, 0.3);
                border-top: 2px solid white;
                border-radius: 50%;
                animation: spin 0.8s linear infinite;
            }

            @keyframes spin {
                to {
                    transform: rotate(360deg);
                }
            }
        </style>
    </head>

    <body>
        <div class="bg-particles"></div>

        <div class="otp-card">
            <!-- Shield Icon -->
            <div class="shield-icon">
                <i class="fas fa-shield-halved"></i>
            </div>

            <h2 class="otp-title">Xác Thực Admin</h2>
            <p class="otp-subtitle">
                Mã xác thực 6 số đã được gửi đến<br>
                <span class="email-highlight">
                    <%= session.getAttribute("adminMaskedEmail") !=null ? session.getAttribute("adminMaskedEmail")
                        : "***@***.com" %>
                </span>
            </p>

            <!-- Alert Messages -->
            <% String error=(String) request.getAttribute("error"); if (error !=null) { %>
                <div class="alert-custom alert-error">
                    <i class="fas fa-exclamation-circle"></i>
                    <%= error %>
                </div>
                <% } %>

                    <% String success=(String) request.getAttribute("success"); if (success !=null) { %>
                        <div class="alert-custom alert-success">
                            <i class="fas fa-check-circle"></i>
                            <%= success %>
                        </div>
                        <% } %>

                            <!-- OTP Form -->
                            <form id="otpForm" action="admin-verify-otp" method="post">
                                <div class="otp-inputs">
                                    <input type="text" name="otp1" maxlength="1" pattern="[0-9]" inputmode="numeric"
                                        autocomplete="off" autofocus>
                                    <input type="text" name="otp2" maxlength="1" pattern="[0-9]" inputmode="numeric"
                                        autocomplete="off">
                                    <input type="text" name="otp3" maxlength="1" pattern="[0-9]" inputmode="numeric"
                                        autocomplete="off">
                                    <input type="text" name="otp4" maxlength="1" pattern="[0-9]" inputmode="numeric"
                                        autocomplete="off">
                                    <input type="text" name="otp5" maxlength="1" pattern="[0-9]" inputmode="numeric"
                                        autocomplete="off">
                                    <input type="text" name="otp6" maxlength="1" pattern="[0-9]" inputmode="numeric"
                                        autocomplete="off">
                                </div>

                                <!-- Timer -->
                                <div class="timer-section">
                                    <div class="timer-badge" id="timerBadge">
                                        <i class="fas fa-clock"></i>
                                        Mã hết hạn sau: <span class="time" id="countdown">10:00</span>
                                    </div>
                                </div>

                                <button type="submit" class="btn-verify" id="btnVerify">
                                    <span id="btnText">Xác Nhận</span>
                                    <div class="spinner" id="spinner"></div>
                                </button>
                            </form>

                            <!-- Resend -->
                            <div class="resend-section">
                                <p class="resend-text">Không nhận được mã?</p>
                                <form action="admin-verify-otp" method="post" style="display: inline;">
                                    <input type="hidden" name="action" value="resend">
                                    <button type="submit" class="btn-resend" id="btnResend">
                                        <i class="fas fa-redo-alt"></i> Gửi lại mã
                                        <span id="resendTimer"></span>
                                    </button>
                                </form>
                            </div>

                            <!-- Back to login -->
                            <div class="back-link">
                                <a href="login"><i class="fas fa-arrow-left"></i> Quay lại trang đăng nhập</a>
                            </div>
        </div>

        <script>
            // ════════════════════════════════════════════════
            // 1. AUTO-FOCUS & AUTO-JUMP BETWEEN OTP INPUTS
            // ════════════════════════════════════════════════
            const inputs = document.querySelectorAll('.otp-inputs input');

            inputs.forEach((input, index) => {
                // Chỉ cho phép nhập số
                input.addEventListener('input', (e) => {
                    let val = e.target.value.replace(/[^0-9]/g, '');
                    e.target.value = val;

                    if (val.length === 1) {
                        e.target.classList.add('filled');
                        // Nhảy sang ô tiếp theo
                        if (index < inputs.length - 1) {
                            inputs[index + 1].focus();
                        }
                    } else {
                        e.target.classList.remove('filled');
                    }
                });

                // Backspace → quay lại ô trước
                input.addEventListener('keydown', (e) => {
                    if (e.key === 'Backspace' && !e.target.value && index > 0) {
                        inputs[index - 1].focus();
                        inputs[index - 1].value = '';
                        inputs[index - 1].classList.remove('filled');
                    }
                    // Enter → submit
                    if (e.key === 'Enter') {
                        e.preventDefault();
                        document.getElementById('otpForm').submit();
                    }
                });

                // Paste support (dán mã 6 số)
                input.addEventListener('paste', (e) => {
                    e.preventDefault();
                    let pasteData = e.clipboardData.getData('text').replace(/[^0-9]/g, '');
                    if (pasteData.length >= 6) {
                        for (let i = 0; i < 6; i++) {
                            inputs[i].value = pasteData[i];
                            inputs[i].classList.add('filled');
                        }
                        inputs[5].focus();
                    }
                });
            });

        // ════════════════════════════════════════════════
        // 2. COUNTDOWN TIMER (10 phút)
        // ════════════════════════════════════════════════
        <%
                Long otpExpiry = (Long) session.getAttribute("adminOtpExpiry");
            long remainMs = 0;
            if (otpExpiry != null) {
                remainMs = otpExpiry - System.currentTimeMillis();
                if (remainMs < 0) remainMs = 0;
            }
        %>
                let totalSeconds = Math.floor(<%= remainMs %> / 1000);
            const countdownEl = document.getElementById('countdown');
            const timerBadge = document.getElementById('timerBadge');
            const btnVerify = document.getElementById('btnVerify');

            function updateCountdown() {
                if (totalSeconds <= 0) {
                    countdownEl.textContent = 'Đã hết hạn!';
                    timerBadge.classList.add('expired');
                    btnVerify.disabled = true;
                    return;
                }

                let mins = Math.floor(totalSeconds / 60);
                let secs = totalSeconds % 60;
                countdownEl.textContent = String(mins).padStart(2, '0') + ':' + String(secs).padStart(2, '0');
                totalSeconds--;
                setTimeout(updateCountdown, 1000);
            }

            updateCountdown();

        // ════════════════════════════════════════════════
        // 3. RESEND COOLDOWN (60 giây)
        // ════════════════════════════════════════════════
        <%
                Long lastSent = (Long) session.getAttribute("adminOtpLastSent");
            long cooldownRemain = 0;
            if (lastSent != null) {
                cooldownRemain = 60 - ((System.currentTimeMillis() - lastSent) / 1000);
                if (cooldownRemain < 0) cooldownRemain = 0;
            }
        %>
                let resendCooldown = <%= cooldownRemain %>;
            const btnResend = document.getElementById('btnResend');
            const resendTimerEl = document.getElementById('resendTimer');

            function updateResendCooldown() {
                if (resendCooldown <= 0) {
                    btnResend.disabled = false;
                    resendTimerEl.textContent = '';
                    return;
                }

                btnResend.disabled = true;
                resendTimerEl.textContent = ' (' + resendCooldown + 's)';
                resendCooldown--;
                setTimeout(updateResendCooldown, 1000);
            }

            updateResendCooldown();

            // ════════════════════════════════════════════════
            // 4. SUBMIT LOADING STATE
            // ════════════════════════════════════════════════
            document.getElementById('otpForm').addEventListener('submit', function () {
                const btnText = document.getElementById('btnText');
                const spinner = document.getElementById('spinner');
                btnText.textContent = 'Đang xác thực...';
                spinner.style.display = 'block';
                btnVerify.disabled = true;
            });
        </script>
    </body>

    </html>