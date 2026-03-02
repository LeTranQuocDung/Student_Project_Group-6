package controller;

import dal.UserDAO;
import model.User;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "AdminUserServlet", urlPatterns = { "/admin-users" })
public class AdminUserServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        UserDAO dao = new UserDAO();
        List<User> users = dao.getAllUsers();
        request.setAttribute("users", users);
        request.getRequestDispatcher("admin_users.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        UserDAO dao = new UserDAO();

        try {
            if ("delete".equals(action)) {
                int userId = Integer.parseInt(request.getParameter("id"));
                dao.deleteUser(userId);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect("admin-users");
    }
}
