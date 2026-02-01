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

        // 1. Kiểm tra đăng nhập
        if (user == null) {
            response.sendRedirect("login.jsp"); // Chưa đăng nhập bắt đi login
            return;
        }

        // 2. Kiểm tra giỏ hàng
        if (cart == null || cart.getItems().isEmpty()) {
            response.sendRedirect("home");
            return;
        }

        // 3. Gọi DAO xử lý Transaction
        try {
            OrderDAO dao = new OrderDAO();
            dao.addOrder(user, cart); // Hàm Transaction nãy viết
            
            // 4. Thành công -> Xóa giỏ hàng
            session.removeAttribute("cart");
            
            // 5. Chuyển hướng trang thông báo
            response.sendRedirect("checkout_success.jsp");
            
        } catch (Exception e) {
            e.printStackTrace();
            // Lỗi -> Về lại giỏ hàng và báo lỗi (Ông có thể thêm msg)
            response.sendRedirect("cart.jsp?error=checkout_failed"); 
        }
    }
}