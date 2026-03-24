package controller;

import dal.UserDAO;
import model.User;
import util.PasswordService;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "SellerLoginServlet", urlPatterns = {"/seller-login"})
public class SellerLoginServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Nếu đã đăng nhập → chuyển thẳng vào seller onboarding
        User acc = (User) request.getSession().getAttribute("account");
        if (acc != null) {
            response.sendRedirect("seller-onboarding");
            return;
        }
        request.getRequestDispatcher("seller_login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String u = request.getParameter("user");
        String p = request.getParameter("pass");

        UserDAO dao = new UserDAO();
        User account = dao.findByEmailOrPhone(u);

        boolean passwordValid = false;
        if (account != null) {
            String hashFromDB = account.getPasswordHash();
            if (hashFromDB != null) {
                passwordValid = PasswordService.verify(p, hashFromDB);
            }
        }

        if (account != null && passwordValid) {
            HttpSession session = request.getSession();
            session.setAttribute("account", account);
            // Đăng nhập thành công → chuyển vào trang onboarding
            response.sendRedirect("seller-onboarding");
        } else {
            request.setAttribute("error", "Tài khoản hoặc mật khẩu không đúng!");
            request.getRequestDispatcher("seller_login.jsp").forward(request, response);
        }
    }
}
