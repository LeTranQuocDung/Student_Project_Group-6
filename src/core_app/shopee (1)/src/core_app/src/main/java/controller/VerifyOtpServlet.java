package controller;

import dal.UserDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "VerifyOtpServlet", urlPatterns = {"/verify_otp"})
public class VerifyOtpServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("verify_otp.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        String enteredOtp = request.getParameter("otp");
        
        String sessionOtp = (String) session.getAttribute("reg_otp");
        Long otpExpiry = (Long) session.getAttribute("reg_otp_expiry");
        
        if (sessionOtp == null || otpExpiry == null) {
            request.setAttribute("error", "Phiên đăng ký không hợp lệ hoặc đã hết hạn. Vui lòng đăng ký lại.");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }
        
        if (System.currentTimeMillis() > otpExpiry) {
            request.setAttribute("error", "Mã OTP đã hết hạn. Vui lòng đăng ký lại.");
            request.getRequestDispatcher("verify_otp.jsp").forward(request, response);
            return;
        }
        
        if (!sessionOtp.equals(enteredOtp)) {
            request.setAttribute("error", "Mã OTP không chính xác.");
            request.getRequestDispatcher("verify_otp.jsp").forward(request, response);
            return;
        }
        
        // OTP Success, save to DB
        String email = (String) session.getAttribute("reg_email");
        String passHash = (String) session.getAttribute("reg_pass_hash");
        String fullname = (String) session.getAttribute("reg_fullname");
        String phone = (String) session.getAttribute("reg_phone");
        
        UserDAO dao = new UserDAO();
        boolean isSuccess = dao.signup(email, passHash, fullname, phone);
        
        if (isSuccess) {
            // Clear session data
            session.removeAttribute("reg_email");
            session.removeAttribute("reg_pass_hash");
            session.removeAttribute("reg_fullname");
            session.removeAttribute("reg_phone");
            session.removeAttribute("reg_otp");
            session.removeAttribute("reg_otp_expiry");
            
            // Redirect to login
            request.setAttribute("mess", "Đăng ký thành công! Hãy đăng nhập.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        } else {
            request.setAttribute("error", "Lỗi đăng ký (Có thể email hoặc SĐT đã tồn tại). Vui lòng thử lại!");
            request.getRequestDispatcher("verify_otp.jsp").forward(request, response);
        }
    }
}
