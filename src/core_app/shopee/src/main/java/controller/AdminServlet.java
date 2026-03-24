package controller;

import dal.StatsDAO;
import dal.OrderDAO;
import dal.AuditLogDAO;
import model.AuditLog;
import java.io.IOException;
import java.util.List;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "AdminServlet", urlPatterns = { "/admin" })
public class AdminServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        StatsDAO dao = new StatsDAO();
        OrderDAO orderDAO = new OrderDAO();

        // 1. Lấy 4 con số tổng quan chỉ bằng 1 câu SQL (thay vì 4 câu riêng)
        Map<String, Object> stats = dao.getDashboardStats();
        request.setAttribute("totalRevenue", stats.get("totalRevenue"));
        request.setAttribute("totalOrders", stats.get("totalOrders"));
        request.setAttribute("totalUsers", stats.get("totalUsers"));
        request.setAttribute("totalProducts", stats.get("totalProducts"));

        // 2. Lấy dữ liệu vẽ biểu đồ (Chart) từ Database
        List<Double> revenueList = dao.getRevenueLast7Days();
        String chartData = revenueList.isEmpty() ? "[0,0,0,0,0,0,0]" : revenueList.toString();
        String chartLabels = "['Ngày 1', 'Ngày 2', 'Ngày 3', 'Ngày 4', 'Ngày 5', 'Ngày 6', 'Ngày 7']";
        request.setAttribute("chartData", chartData);
        request.setAttribute("chartLabels", chartLabels);

        // 3. Dữ liệu Doughnut Chart - gộp 3 query thành 1
        Map<String, Integer> statusCounts = dao.getOrderStatusCounts();
        request.setAttribute("ordersPending", statusCounts.get("PENDING"));
        request.setAttribute("ordersCompleted", statusCounts.get("COMPLETED"));
        request.setAttribute("ordersCancelled", statusCounts.get("CANCELLED"));

        // 4. Đơn hàng gần đây (5 đơn mới nhất)
        List<String[]> recentOrders = orderDAO.getRecentOrders(5);
        request.setAttribute("recentOrders", recentOrders);

        // 5. Audit logs gần đây (5 hành động mới nhất)
        AuditLogDAO auditDAO = new AuditLogDAO();
        List<AuditLog> recentLogs = auditDAO.getLogs(1, 5);
        request.setAttribute("recentLogs", recentLogs);

        // 6. Top sản phẩm bán chạy (5 sản phẩm)
        List<String[]> topProducts = dao.getTopSellingProducts(5);
        request.setAttribute("topProducts", topProducts);

        // 7. Chuyển trang
        request.getRequestDispatcher("admin.jsp").forward(request, response);
    }
}
