package controller;

import dal.OrderDAO;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "AdminOrderServlet", urlPatterns = { "/admin-orders" })
public class AdminOrderServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        OrderDAO dao = new OrderDAO();
        List<String[]> orders = dao.getAllOrders();
        request.setAttribute("orders", orders);
        request.getRequestDispatcher("admin_orders.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        OrderDAO dao = new OrderDAO();

        try {
            if ("updateStatus".equals(action)) {
                int orderId = Integer.parseInt(request.getParameter("orderId"));
                String status = request.getParameter("status");
                dao.updateOrderStatus(orderId, status);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect("admin-orders");
    }
}
