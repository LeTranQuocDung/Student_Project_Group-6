package controller;

import dal.OrderDAO;
import model.Cart;
import model.CartItem;
import model.Product;
import model.User;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "ApiCheckoutServlet", urlPatterns = {"/api/simulator-checkout"})
public class ApiCheckoutServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {

            User dummyUser = new User();
            dummyUser.setId(1);

            Cart dummyCart = new Cart();
            Product p = new Product();
            p.setId(1);
            dummyCart.addItem(new CartItem(p, 1, 50000));

            OrderDAO dao = new OrderDAO();
            dao.addOrderTransaction(dummyUser, dummyCart);

            response.getWriter().write("{\"status\":\"SUCCESS\", \"message\":\"Thanh toan va tru kho thanh cong!\"}");

        } catch (Exception e) {

            response.getWriter().write("{\"status\":\"ERROR\", \"message\":\"" + e.getMessage() + "\"}");
        }
    }
}
