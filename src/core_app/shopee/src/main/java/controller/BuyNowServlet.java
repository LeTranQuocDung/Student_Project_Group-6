package controller;

import dal.ProductDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Cart;
import model.CartItem;
import model.Product;
import model.User;

@WebServlet(name = "BuyNowServlet", urlPatterns = { "/buy_now" })
public class BuyNowServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("account");

        // 1. Chưa đăng nhập -> bắt login
        if (user == null) {
            // Lưu lại trang hiện tại để sau khi login quay lại
            String productId = request.getParameter("productId");
            response.sendRedirect("login.jsp?redirect=product_detail%3Fid%3D" + productId);
            return;
        }

        try {
            int productId = Integer.parseInt(request.getParameter("productId"));
            int qty = Integer.parseInt(request.getParameter("qty"));
            if (qty < 1)
                qty = 1;

            // 2. Lấy sản phẩm từ DB
            ProductDAO pDao = new ProductDAO();
            Product product = pDao.getProductById(productId);

            if (product != null) {
                // 3. Tạo giỏ hàng tạm cho Buy Now (thêm vào giỏ rồi nhảy checkout)
                Cart cart = (Cart) session.getAttribute("cart");
                if (cart == null) {
                    cart = new Cart();
                }

                CartItem item = new CartItem(product, qty, product.getPrice());
                cart.addItem(item);
                session.setAttribute("cart", cart);

                // 4. Redirect thẳng đến trang giỏ hàng để checkout
                response.sendRedirect("cart");
            } else {
                response.sendRedirect("home");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("home");
        }
    }
}
