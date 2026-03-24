package controller;

import model.User;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "SellerOnboardingServlet", urlPatterns = {"/seller-onboarding"})
public class SellerOnboardingServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Kiểm tra đăng nhập — chưa login thì chuyển về trang login
        User acc = (User) request.getSession().getAttribute("account");
        if (acc == null) {
            response.sendRedirect("seller-login");
            return;
        }

        request.getRequestDispatcher("seller_onboarding.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
