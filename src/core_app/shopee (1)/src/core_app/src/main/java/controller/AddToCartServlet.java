package controller;

import dal.ProductDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.math.BigDecimal;
import model.Cart;
import model.CartItem;
import model.Product;

@WebServlet(name = "AddToCartServlet", urlPatterns = { "/add_to_cart" })
public class AddToCartServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        // Check if this is an AJAX request
        boolean isAjax = "XMLHttpRequest".equals(request.getHeader("X-Requested-With"));

        try {
            int productId = Integer.parseInt(request.getParameter("productId"));
            int qty = Integer.parseInt(request.getParameter("qty"));

            // Validate quantity
            if (qty < 1)
                qty = 1;

            // Get product from DB
            ProductDAO pDao = new ProductDAO();
            Product product = pDao.getProductById(productId);

            if (product != null) {
                // Get or create Cart in session
                HttpSession session = request.getSession();
                Cart cart = (Cart) session.getAttribute("cart");
                if (cart == null) {
                    cart = new Cart();
                }

                // Create CartItem and add to Cart
                CartItem item = new CartItem(product, qty, product.getPrice());
                cart.addItem(item);

                // Save back to session
                session.setAttribute("cart", cart);

                if (isAjax) {
                    // Return JSON for AJAX requests
                    response.setContentType("application/json");
                    response.getWriter().write("{\"success\":true,\"cartCount\":" + cart.getTotalQuantity()
                            + ",\"message\":\"Sản phẩm đã được thêm vào Giỏ Hàng\"}");
                } else {
                    // Redirect for normal form submissions
                    response.sendRedirect("san-pham-i.686868." + productId + "?added=true");
                }
            } else {
                if (isAjax) {
                    response.setContentType("application/json");
                    response.setStatus(404);
                    response.getWriter().write("{\"success\":false,\"message\":\"Không tìm thấy sản phẩm\"}");
                } else {
                    response.sendRedirect("home");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            if (isAjax) {
                response.setContentType("application/json");
                response.setStatus(500);
                response.getWriter().write("{\"success\":false,\"message\":\"Lỗi hệ thống: " + e.getMessage() + "\"}");
            } else {
                response.sendRedirect("home");
            }
        }
    }
}
