package controller;

import model.Admin;
import model.User;
import util.EmailService;
import java.io.IOException;
import java.security.SecureRandom;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * SERVLET XÁC THỰC OTP ADMIN
 * 
 * Xử lý nhập mã OTP, gửi lại mã, kiểm tra hết hạn & giới hạn số lần nhập sai.
 */
@WebServlet(name = "AdminOtpServlet", urlPatterns = { "/admin-verify-otp" })
public class AdminOtpServlet extends HttpServlet {

    private static final SecureRandom secureRandom = new SecureRandom();
    private static final int MAX_ATTEMPTS = 5;
    private static final long LOCK_DURATION_MS = 5 * 60 * 1000; // 5 phút
    private static final long RESEND_COOLDOWN_MS = 60 * 1000; // 60 giây
    private static final long OTP_EXPIRY_MS = 10 * 60 * 1000; // 10 phút

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // Nếu chưa có pendingAdmin trong session → đá về login
        if (session == null || session.getAttribute("pendingAdmin") == null) {
            response.sendRedirect("login");
            return;
        }

        request.getRequestDispatcher("admin_otp.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // Guard: chưa có session hoặc chưa có pending admin
        if (session == null || session.getAttribute("pendingAdmin") == null) {
            response.sendRedirect("login");
            return;
        }

        String action = request.getParameter("action");

        // ═══════════════════════════════════════════════
        // TRƯỜNG HỢP 1: GỬI LẠI MÃ OTP
        // ═══════════════════════════════════════════════
        if ("resend".equals(action)) {
            handleResend(request, response, session);
            return;
        }

        // ═══════════════════════════════════════════════
        // TRƯỜNG HỢP 2: XÁC THỰC OTP
        // ═══════════════════════════════════════════════
        handleVerify(request, response, session);
    }

    /**
     * Xử lý gửi lại OTP
     */
    private void handleResend(HttpServletRequest request, HttpServletResponse response, HttpSession session)
            throws ServletException, IOException {

        // Kiểm tra cooldown (60 giây)
        Long lastSent = (Long) session.getAttribute("adminOtpLastSent");
        if (lastSent != null) {
            long elapsed = System.currentTimeMillis() - lastSent;
            if (elapsed < RESEND_COOLDOWN_MS) {
                long remainSec = (RESEND_COOLDOWN_MS - elapsed) / 1000;
                request.setAttribute("error", "Vui lòng đợi " + remainSec + " giây trước khi gửi lại mã.");
                request.getRequestDispatcher("admin_otp.jsp").forward(request, response);
                return;
            }
        }

        // Tạo OTP mới
        String newOtp = generateOtp();
        long newExpiry = System.currentTimeMillis() + OTP_EXPIRY_MS;

        session.setAttribute("adminOtp", newOtp);
        session.setAttribute("adminOtpExpiry", newExpiry);
        session.setAttribute("adminOtpLastSent", System.currentTimeMillis());
        session.setAttribute("adminOtpAttempts", 0); // Reset số lần nhập sai

        // Lấy email admin
        Object pendingAdmin = session.getAttribute("pendingAdmin");
        String email = "";
        if (pendingAdmin instanceof Admin) {
            email = ((Admin) pendingAdmin).getEmail();
        } else if (pendingAdmin instanceof User) {
            email = ((User) pendingAdmin).getEmail();
        }

        boolean sent = EmailService.sendAdminOtpEmail(email, newOtp);

        if (sent) {
            request.setAttribute("success", "Mã xác thực mới đã được gửi đến email của bạn!");
        } else {
            request.setAttribute("error", "Không thể gửi mã. Vui lòng thử lại!");
        }

        request.getRequestDispatcher("admin_otp.jsp").forward(request, response);
    }

    /**
     * Xử lý xác thực OTP
     */
    private void handleVerify(HttpServletRequest request, HttpServletResponse response, HttpSession session)
            throws ServletException, IOException {

        // Kiểm tra khóa do nhập sai quá nhiều
        Long lockUntil = (Long) session.getAttribute("adminOtpLockUntil");
        if (lockUntil != null && System.currentTimeMillis() < lockUntil) {
            long remainSec = (lockUntil - System.currentTimeMillis()) / 1000;
            request.setAttribute("error",
                    "Bạn đã nhập sai quá nhiều lần. Vui lòng thử lại sau " + remainSec + " giây.");
            request.getRequestDispatcher("admin_otp.jsp").forward(request, response);
            return;
        }

        // Lấy OTP từ form (6 ô riêng biệt ghép lại)
        StringBuilder otpBuilder = new StringBuilder();
        for (int i = 1; i <= 6; i++) {
            String digit = request.getParameter("otp" + i);
            if (digit != null && !digit.isEmpty()) {
                otpBuilder.append(digit.trim());
            }
        }
        String inputOtp = otpBuilder.toString();

        // Lấy OTP từ session
        String sessionOtp = (String) session.getAttribute("adminOtp");
        Long otpExpiry = (Long) session.getAttribute("adminOtpExpiry");
        Integer attempts = (Integer) session.getAttribute("adminOtpAttempts");

        if (attempts == null)
            attempts = 0;

        // Kiểm tra hết hạn
        if (otpExpiry == null || System.currentTimeMillis() > otpExpiry) {
            request.setAttribute("error", "Mã OTP đã hết hạn! Vui lòng bấm \"Gửi lại mã\" để nhận mã mới.");
            request.getRequestDispatcher("admin_otp.jsp").forward(request, response);
            return;
        }

        // So sánh OTP
        if (sessionOtp != null && sessionOtp.equals(inputOtp)) {
            // ✅ ĐÚNG → Đăng nhập Admin thành công
            Object pendingAdmin = session.getAttribute("pendingAdmin");
            session.setAttribute("account", pendingAdmin);

            // Xóa các key OTP
            session.removeAttribute("pendingAdmin");
            session.removeAttribute("adminOtp");
            session.removeAttribute("adminOtpExpiry");
            session.removeAttribute("adminOtpAttempts");
            session.removeAttribute("adminOtpLastSent");
            session.removeAttribute("adminOtpLockUntil");
            session.removeAttribute("adminMaskedEmail");

            response.sendRedirect("admin");
        } else {
            // ❌ SAI → Tăng số lần nhập sai
            attempts++;
            session.setAttribute("adminOtpAttempts", attempts);

            if (attempts >= MAX_ATTEMPTS) {
                // Khóa 5 phút
                session.setAttribute("adminOtpLockUntil", System.currentTimeMillis() + LOCK_DURATION_MS);
                request.setAttribute("error", "Bạn đã nhập sai " + MAX_ATTEMPTS + " lần. Tài khoản bị khóa 5 phút!");
            } else {
                int remaining = MAX_ATTEMPTS - attempts;
                request.setAttribute("error", "Mã OTP không đúng! Bạn còn " + remaining + " lần thử.");
            }

            request.getRequestDispatcher("admin_otp.jsp").forward(request, response);
        }
    }

    private String generateOtp() {
        int otp = 100000 + secureRandom.nextInt(900000);
        return String.valueOf(otp);
    }
}
