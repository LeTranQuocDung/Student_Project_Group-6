package controller;

import dal.UserDAO;
import util.PasswordService;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "RegisterServlet", urlPatterns = { "/register" })
public class RegisterServlet extends HttpServlet {

    // 1. Vào trang đăng ký
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("register.jsp").forward(request, response);
    }

    // 2. Xử lý khi bấm nút Đăng ký
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Lấy dữ liệu từ form
        String email = request.getParameter("email");
        String fullname = request.getParameter("fullname");
        String phone = request.getParameter("phone");
        String pass = request.getParameter("password");
        String rePass = request.getParameter("re-password");

        // Validate cơ bản
        if (!pass.equals(rePass)) {
            request.setAttribute("mess", "Mật khẩu nhập lại không khớp!");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        UserDAO dao = new UserDAO();
        if (dao.checkEmailExist(email)) {
            request.setAttribute("mess", "Email này đã được sử dụng!");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        // 🔒 Mã hóa password bằng Argon2id (thay thế MD5)
        String passHash = PasswordService.hash(pass);

        // Tạo OTP ngẫu nhiên 6 số
        String otp = String.format("%06d", new java.util.Random().nextInt(999999));

        // Lưu thông tin tạm vào Session
        jakarta.servlet.http.HttpSession session = request.getSession();
        session.setAttribute("reg_email", email);
        session.setAttribute("reg_pass_hash", passHash);
        session.setAttribute("reg_fullname", fullname);
        session.setAttribute("reg_phone", phone);
        session.setAttribute("reg_otp", otp);
        session.setAttribute("reg_otp_expiry", System.currentTimeMillis() + (10 * 60 * 1000)); // 10 minutes

        // Gửi OTP qua email
        boolean emailSent = util.EmailService.sendOtpEmail(email, otp);

        if (emailSent) {
            // Chuyển sang trang nhập OTP
            response.sendRedirect("verify_otp.jsp");
        } else {
            // Hiển thị lỗi
            request.setAttribute("mess", "Lỗi gửi email xác thực. Vui lòng kiểm tra lại cấu hình hoặc thử lại!");
            request.getRequestDispatcher("register.jsp").forward(request, response);
        }
    }
}