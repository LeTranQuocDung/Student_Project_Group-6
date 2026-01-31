package controller;

import dal.UserDAO;
import model.User;
import java.io.IOException;
import java.security.MessageDigest;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "LoginServlet", urlPatterns = {"/login"})
public class LoginServlet extends HttpServlet {

    // Hàm mã hóa MD5 (Giống trong DataGenerator để khớp với DB)
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

    // GET: Mở trang đăng nhập
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("login.jsp").forward(request, response);
    }

    // POST: Xử lý khi bấm nút "Đăng Nhập"
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String email = request.getParameter("email");
        String pass = request.getParameter("password");
        
        // 1. Mã hóa pass người dùng nhập để so sánh với pass hash trong DB
        String passHash = getMd5(pass);

        // 2. Gọi DAO kiểm tra
        UserDAO dao = new UserDAO();
        User user = dao.login(email, passHash); // Hàm này trả về User hoặc Admin tùy role

        if (user != null) {
            // --- ĐĂNG NHẬP THÀNH CÔNG ---
            HttpSession session = request.getSession();
            
            // Lưu nguyên object User (hoặc Admin) vào session
            // Bên JSP sẽ dùng "account" để lấy ra
            session.setAttribute("account", user);
            
            // Set thời gian sống của session (ví dụ: 30 phút)
            session.setMaxInactiveInterval(30 * 60);

            response.sendRedirect("home");
        } else {
            // --- ĐĂNG NHẬP THẤT BẠI ---
            request.setAttribute("mess", "Sai email hoặc mật khẩu!");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
}