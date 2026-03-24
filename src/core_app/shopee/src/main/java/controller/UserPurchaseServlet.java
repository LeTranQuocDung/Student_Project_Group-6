package controller;

import dal.OrderDAO;
import model.User;
import java.io.IOException;
import java.util.List;
import java.util.LinkedHashMap;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "UserPurchaseServlet", urlPatterns = {"/user/purchase"})
public class UserPurchaseServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User acc = (User) session.getAttribute("account");

        if (acc == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String tab = request.getParameter("tab");
        if (tab == null) tab = "ALL";

        // Map tab to DB status
        String statusFilter;
        switch (tab.toUpperCase()) {
            case "PENDING": statusFilter = "PENDING"; break;
            case "SHIPPING": statusFilter = "SHIPPING"; break;
            case "DELIVERING": statusFilter = "DELIVERING"; break;
            case "COMPLETED": statusFilter = "COMPLETED"; break;
            case "CANCELLED": statusFilter = "CANCELLED"; break;
            case "REFUND": statusFilter = "REFUND"; break;
            default: statusFilter = "ALL"; break;
        }

        OrderDAO orderDAO = new OrderDAO();
        List<String[]> orders = orderDAO.getOrdersByUserId(acc.getId(), statusFilter);

        // For each order, get its items
        Map<String, List<String[]>> orderItemsMap = new LinkedHashMap<>();
        for (String[] order : orders) {
            String orderId = order[0];
            List<String[]> items = orderDAO.getOrderItems(Integer.parseInt(orderId));
            orderItemsMap.put(orderId, items);
        }

        request.setAttribute("orders", orders);
        request.setAttribute("orderItemsMap", orderItemsMap);
        request.setAttribute("currentTab", tab.toUpperCase());

        request.getRequestDispatcher("/user_purchase.jsp").forward(request, response);
    }
}
