package controller;

import dal.StatsDAO;
import dal.OrderDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;

@WebServlet(name = "AdminServlet", urlPatterns = { "/admin" })
public class AdminServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        StatsDAO dao = new StatsDAO();
        OrderDAO orderDAO = new OrderDAO();

        // 1. Lấy các con số tổng quan (Cards)
        request.setAttribute("totalRevenue", dao.getTotalRevenue());
        request.setAttribute("totalOrders", dao.countOrders());
        request.setAttribute("totalUsers", dao.countUsers());
        request.setAttribute("totalProducts", dao.countProducts());

        // 2. Lấy dữ liệu vẽ biểu đồ (Chart) từ Database
        List<Double> revenueList = dao.getRevenueLast7Days();
        String chartData = revenueList.isEmpty() ? "[0,0,0,0,0,0,0]" : revenueList.toString();

        // Mặc định tên cột (Gán 7 nhãn dù dữ liệu có thể ít hơn)
        String chartLabels = "['Ngày 1', 'Ngày 2', 'Ngày 3', 'Ngày 4', 'Ngày 5', 'Ngày 6', 'Ngày 7']";

        request.setAttribute("chartData", chartData);
        request.setAttribute("chartLabels", chartLabels);

        // 3. Dữ liệu thực cho Doughnut Chart (trạng thái đơn hàng)
        request.setAttribute("ordersPending", dao.countOrdersByStatus("PENDING"));
        request.setAttribute("ordersCompleted", dao.countOrdersByStatus("COMPLETED"));
        request.setAttribute("ordersCancelled", dao.countOrdersByStatus("CANCELLED"));

        // 4. Đơn hàng gần đây (5 đơn mới nhất)
        List<String[]> recentOrders = orderDAO.getRecentOrders(5);
        request.setAttribute("recentOrders", recentOrders);

        // 5. Chuyển trang
        request.getRequestDispatcher("admin.jsp").forward(request, response);
    }
}
