package controller;

import dal.StatsDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "AdminServlet", urlPatterns = {"/admin"})
public class AdminServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        StatsDAO dao = new StatsDAO();

        // Lấy dữ liệu thực từ DB thông qua DAO
        double revenue = dao.getTotalRevenue();
        int orders = dao.countOrders();
        int users = dao.countUsers();

        // Đẩy vào request attribute để JSP hiển thị (xóa bỏ chữ null)
        request.setAttribute("totalRevenue", revenue);
        request.setAttribute("totalOrders", orders);
        request.setAttribute("totalUsers", users);

        // Giả lập dữ liệu biểu đồ cho đẹp
        request.setAttribute("chartData", "[15, 23, 18, 32, 21, 11, 45]");
        request.setAttribute("chartLabels", "['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN']");

        request.getRequestDispatcher("admin.jsp").forward(request, response);
    }
}