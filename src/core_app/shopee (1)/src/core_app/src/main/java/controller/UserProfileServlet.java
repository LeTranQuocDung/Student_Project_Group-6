package controller;

import dal.UserDAO;
import model.User;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "UserProfileServlet", urlPatterns = {"/user/account/profile"})
public class UserProfileServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User acc = (User) session.getAttribute("account");

        // Chưa đăng nhập → redirect về login
        if (acc == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Lấy dữ liệu mới nhất từ DB
        UserDAO dao = new UserDAO();
        User freshUser = dao.getUserById(acc.getId());
        if (freshUser != null) {
            session.setAttribute("account", freshUser);
            request.setAttribute("user", freshUser);
        } else {
            request.setAttribute("user", acc);
        }

        request.getRequestDispatcher("/user_profile.jsp").forward(request, response);
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

        // Đọc form params
        String fullName = request.getParameter("fullName");
        String phone = request.getParameter("phone");
        String gender = request.getParameter("gender");
        String dateOfBirth = request.getParameter("dateOfBirth");

        // Validate cơ bản
        if (fullName == null || fullName.trim().isEmpty()) {
            session.setAttribute("error", "Tên không được để trống");
            response.sendRedirect(request.getContextPath() + "/user/account/profile");
            return;
        }

        // Cập nhật DB
        UserDAO dao = new UserDAO();
        boolean success = dao.updateProfile(acc.getId(), fullName.trim(), phone, gender, dateOfBirth);

        if (success) {
            // Cập nhật lại session
            User freshUser = dao.getUserById(acc.getId());
            if (freshUser != null) {
                session.setAttribute("account", freshUser);
            }
            session.setAttribute("success", "Cập nhật hồ sơ thành công!");
        } else {
            session.setAttribute("error", "Cập nhật thất bại, vui lòng thử lại.");
        }

        response.sendRedirect(request.getContextPath() + "/user/account/profile");
    }
}
