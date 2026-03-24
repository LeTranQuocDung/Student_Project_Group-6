package controller;

import dal.UserDAO;
import util.PasswordService;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "SellerRegisterServlet", urlPatterns = {"/seller-register"})
public class SellerRegisterServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("seller_register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String fullname = request.getParameter("fullname");
        String phone = request.getParameter("phone");
        String pass = request.getParameter("password");
        String rePass = request.getParameter("re-password");

        // Validate mật khẩu khớp
        if (!pass.equals(rePass)) {
            request.setAttribute("mess", "Mật khẩu nhập lại không khớp!");
            request.getRequestDispatcher("seller_register.jsp").forward(request, response);
            return;
        }

        if (phone == null || !phone.matches("^[0-9]{9,15}$")) {
            request.setAttribute("mess", "Số điện thoại không hợp lệ (9-15 chữ số)!");
            request.getRequestDispatcher("seller_register.jsp").forward(request, response);
            return;
        }

        UserDAO dao = new UserDAO();
        if (dao.checkEmailExist(email)) {
            request.setAttribute("mess", "Email này đã được sử dụng!");
            request.getRequestDispatcher("seller_register.jsp").forward(request, response);
            return;
        }

        // Mã hóa password bằng Argon2id
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
        session.setAttribute("reg_otp_expiry", System.currentTimeMillis() + (10 * 60 * 1000));

        // Gửi OTP qua email
        boolean emailSent = util.EmailService.sendOtpEmail(email, otp);

        if (emailSent) {
            // Chuyển sang trang nhập OTP (dùng chung trang OTP hiện có)
            response.sendRedirect("verify_otp.jsp");
        } else {
            request.setAttribute("mess", "Lỗi gửi email xác thực. Vui lòng thử lại!");
            request.getRequestDispatcher("seller_register.jsp").forward(request, response);
        }
    }
}
