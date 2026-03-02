package controller;

import dal.UserDAO;
import model.Admin;
import model.User;
import util.EmailService;
import util.PasswordService;
import java.io.IOException;
import java.security.SecureRandom;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "LoginServlet", urlPatterns = { "/login" })
public class LoginServlet extends HttpServlet {

    private static final SecureRandom secureRandom = new SecureRandom();

    /**
     * Tạo mã OTP 6 chữ số ngẫu nhiên (SecureRandom)
     */
    private String generateOtp() {
        int otp = 100000 + secureRandom.nextInt(900000);
        return String.valueOf(otp);
    }

    // 1. Vào trang login -> Hiện form
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("login.jsp").forward(request, response);
    }

    // 2. Bấm nút Đăng nhập -> Xử lý
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String u = request.getParameter("user");
        if (u == null || u.trim().isEmpty()) {
            u = request.getParameter("email");
        }
        
        String p = request.getParameter("pass");
        if (p == null || p.trim().isEmpty()) {
            p = request.getParameter("password");
        }

        // 🔒 Tìm user trước, verify sau
        UserDAO dao = new UserDAO();
        User account = dao.findByEmailOrPhone(u);

        // Kiểm tra user tồn tại VÀ password đúng (chỉ dùng Argon2)
        boolean passwordValid = false;
        if (account != null) {
            String hashFromDB = account.getPasswordHash();
            if (hashFromDB != null) {
                passwordValid = PasswordService.verify(p, hashFromDB);
            }
        }

        if (account != null && passwordValid) {

            // Kiểm tra nếu là Admin → Yêu cầu xác thực OTP qua email
            if (account instanceof Admin || "admin".equalsIgnoreCase(account.getRole())) {

                HttpSession session = request.getSession();

                // Kiểm tra xem admin có bị khóa do nhập sai quá nhiều không
                Long lockUntil = (Long) session.getAttribute("adminOtpLockUntil");
                if (lockUntil != null && System.currentTimeMillis() < lockUntil) {
                    long remainSec = (lockUntil - System.currentTimeMillis()) / 1000;
                    request.setAttribute("error",
                            "Tài khoản bị khóa tạm thời. Vui lòng thử lại sau " + remainSec + " giây.");
                    request.getRequestDispatcher("login.jsp").forward(request, response);
                    return;
                }

                // Tạo OTP 6 số
                String otp = generateOtp();
                long expiryTime = System.currentTimeMillis() + 10 * 60 * 1000;

                // Lưu vào session
                session.setAttribute("pendingAdmin", account);
                session.setAttribute("adminOtp", otp);
                session.setAttribute("adminOtpExpiry", expiryTime);
                session.setAttribute("adminOtpAttempts", 0);
                session.setAttribute("adminOtpLastSent", System.currentTimeMillis());

                // Gửi OTP qua email
                String adminEmail = account.getEmail();
                boolean sent = EmailService.sendAdminOtpEmail(adminEmail, otp);

                if (sent) {
                    String maskedEmail = maskEmail(adminEmail);
                    session.setAttribute("adminMaskedEmail", maskedEmail);
                    response.sendRedirect("admin-verify-otp");
                } else {
                    request.setAttribute("error", "Không thể gửi mã xác thực. Vui lòng thử lại!");
                    request.getRequestDispatcher("login.jsp").forward(request, response);
                }

            } else {
                // USER THƯỜNG → Đăng nhập bình thường (không cần OTP)
                HttpSession session = request.getSession();
                session.setAttribute("account", account);
                
                // Nếu là mobile app (gửi param email), trả về JSON
                if (request.getParameter("email") != null) {
                    response.setContentType("application/json");
                    response.getWriter().write("{\"success\": true}");
                } else {
                    response.sendRedirect("home");
                }
            }
        } else {
            // Thất bại
            if (request.getParameter("email") != null) {
                // Return 401 Unauthorized cho Mobile
                response.setStatus(401);
                response.setContentType("application/json");
                response.getWriter().write("{\"success\": false, \"message\": \"Sai email hoặc mật khẩu!\"}");
            } else {
                // Return giao diện báo đỏ cho Web
                request.setAttribute("error", "Tài khoản hoặc mật khẩu không đúng!");
                request.getRequestDispatcher("login.jsp").forward(request, response);
            }
        }
    }

    /**
     * Che email: ví dụ admin@gmail.com → a***n@gmail.com
     */
    private String maskEmail(String email) {
        if (email == null || !email.contains("@"))
            return "***@***.com";
        String[] parts = email.split("@");
        String name = parts[0];
        String domain = parts[1];
        if (name.length() <= 2) {
            return name.charAt(0) + "***@" + domain;
        }
        return name.charAt(0) + "***" + name.charAt(name.length() - 1) + "@" + domain;
    }

}
