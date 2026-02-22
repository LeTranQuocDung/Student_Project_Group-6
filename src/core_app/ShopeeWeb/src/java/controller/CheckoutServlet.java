package controller;

import dal.OrderDAO;
import model.Cart;
import model.User;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "CheckoutServlet", urlPatterns = {"/checkout"})
public class CheckoutServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Cart cart = (Cart) session.getAttribute("cart");
        User user = (User) session.getAttribute("account");

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        if (cart == null || cart.getItems().isEmpty()) {
            response.sendRedirect("home");
            return;
        }

        try {
            OrderDAO dao = new OrderDAO();

            dao.addOrderTransaction(user, cart);

            session.removeAttribute("cart");

            response.sendRedirect("checkout_success.jsp");

        } catch (Exception e) {
            e.printStackTrace();

            response.sendRedirect("cart.jsp?error=checkout_failed");
        }
    }

    // Thêm hàm này vào trong CheckoutServlet
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.sendRedirect("cart.jsp");
    }
}
