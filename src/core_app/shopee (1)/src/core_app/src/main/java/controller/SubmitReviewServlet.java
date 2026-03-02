package controller;

import dal.ReviewDAO;
import model.User;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "SubmitReviewServlet", urlPatterns = {"/submit_review"})
public class SubmitReviewServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Ensure UTF-8 Encoding
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("account");

        String productIdRaw = request.getParameter("productId");
        
        if (user == null || productIdRaw == null) {
            // Redirect to login or home if not authenticated or missing product ID
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            int productId = Integer.parseInt(productIdRaw);
            int rating = Integer.parseInt(request.getParameter("rating"));
            String comment = request.getParameter("comment");

            ReviewDAO reviewDao = new ReviewDAO();
            // Insert review into DB
            reviewDao.insertReview(productId, user.getId(), rating, comment);

            // Redirect back to the product detail page
            response.sendRedirect("product_detail?id=" + productId);

        } catch (Exception e) {
            e.printStackTrace();
            // If there's an error parsing or inserting, redirect to home as fallback
            response.sendRedirect("home");
        }
    }
}
