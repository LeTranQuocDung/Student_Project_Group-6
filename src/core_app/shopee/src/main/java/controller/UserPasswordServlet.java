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

@WebServlet(name = "UserPasswordServlet", urlPatterns = {"/user/account/password"})
public class UserPasswordServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User acc = (User) session.getAttribute("account");
        if (acc == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        request.getRequestDispatcher("/user_password.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        User acc = (User) session.getAttribute("account");

        if (acc == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        // Validate
        if (currentPassword == null || currentPassword.isEmpty() ||
            newPassword == null || newPassword.isEmpty() ||
            confirmPassword == null || confirmPassword.isEmpty()) {
            session.setAttribute("error", "Vui lòng nhập đầy đủ thông tin");
            response.sendRedirect(request.getContextPath() + "/user/account/password");
            return;
        }

        if (newPassword.length() < 6) {
            session.setAttribute("error", "Mật khẩu mới phải có ít nhất 6 ký tự");
            response.sendRedirect(request.getContextPath() + "/user/account/password");
            return;
        }

        if (!newPassword.equals(confirmPassword)) {
            session.setAttribute("error", "Mật khẩu xác nhận không khớp");
            response.sendRedirect(request.getContextPath() + "/user/account/password");
            return;
        }

        // Verify current password
        String hashFromDB = acc.getPasswordHash();
        boolean passwordValid = false;
        try {
            passwordValid = PasswordService.verify(currentPassword, hashFromDB);
        } catch (Exception e) {
            // Fallback: direct compare for legacy MD5
            passwordValid = hashFromDB.equals(currentPassword);
        }

        if (!passwordValid) {
            session.setAttribute("error", "Mật khẩu hiện tại không đúng");
            response.sendRedirect(request.getContextPath() + "/user/account/password");
            return;
        }

        // Hash new password and update
        String newHash = PasswordService.hash(newPassword);
        UserDAO dao = new UserDAO();
        boolean success = dao.updatePassword(acc.getId(), newHash);

        if (success) {
            // Update session
            acc.setPasswordHash(newHash);
            session.setAttribute("account", acc);
            session.setAttribute("success", "Đổi mật khẩu thành công!");
        } else {
            session.setAttribute("error", "Đổi mật khẩu thất bại, vui lòng thử lại");
        }

        response.sendRedirect(request.getContextPath() + "/user/account/password");
    }
}
