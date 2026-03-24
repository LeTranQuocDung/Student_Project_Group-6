package controller;

import model.User;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "UserSettingsServlet", urlPatterns = {
    "/user/account/bank",
    "/user/account/notification",
    "/user/account/privacy",
    "/user/account/personal"
})
public class UserSettingsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User acc = (User) session.getAttribute("account");
        if (acc == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String path = request.getServletPath();
        String jsp;
        switch (path) {
            case "/user/account/bank":
                jsp = "/user_bank.jsp";
                break;
            case "/user/account/notification":
                jsp = "/user_notification.jsp";
                break;
            case "/user/account/privacy":
                jsp = "/user_privacy.jsp";
                break;
            case "/user/account/personal":
                jsp = "/user_personal.jsp";
                break;
            default:
                jsp = "/user_profile.jsp";
                break;
        }

        request.getRequestDispatcher(jsp).forward(request, response);
    }
}
