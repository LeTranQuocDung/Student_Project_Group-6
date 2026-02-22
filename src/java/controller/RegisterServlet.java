package controller;

import dal.UserDAO;
import java.io.IOException;
import java.security.MessageDigest;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "RegisterServlet", urlPatterns = {"/register"})
public class RegisterServlet extends HttpServlet {

    // Hàm mã hóa MD5 (Copy y chang bên LoginServlet để khớp nhau)
    private String getMd5(String input) {
        try {
            MessageDigest md = MessageDigest.getInstance("MD5");
            byte[] messageDigest = md.digest(input.getBytes());
            java.math.BigInteger no = new java.math.BigInteger(1, messageDigest);
            String hashtext = no.toString(16);
            while (hashtext.length() < 32) {
                hashtext = "0" + hashtext;
            }
            return hashtext;
        } catch (Exception e) {
            return "";
        }
    }

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

        // Mã hóa pass và Lưu vào DB
        String passHash = getMd5(pass);
        dao.signup(email, passHash, fullname, phone);

        // Chuyển về trang Login và báo thành công
        request.setAttribute("mess", "Đăng ký thành công! Hãy đăng nhập.");
        request.getRequestDispatcher("login.jsp").forward(request, response);
    }
}