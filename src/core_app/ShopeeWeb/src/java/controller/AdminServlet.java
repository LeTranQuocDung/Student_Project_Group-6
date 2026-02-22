package controller;

import dal.StatsDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;

@WebServlet(name = "AdminServlet", urlPatterns = {"/admin"})
public class AdminServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        StatsDAO dao = new StatsDAO();

        request.setAttribute("totalRevenue", dao.getTotalRevenue());
        request.setAttribute("totalOrders", dao.countOrders());
        request.setAttribute("totalUsers", dao.countUsers());

        String chartData = "[1500000, 2300000, 1800000, 3200000, 2100000, 1100000, 4500000]";
        String chartLabels = "['Thứ 2', 'Thứ 3', 'Thứ 4', 'Thứ 5', 'Thứ 6', 'Thứ 7', 'CN']";

        request.setAttribute("chartData", chartData);
        request.setAttribute("chartLabels", chartLabels);

        request.getRequestDispatcher("admin.jsp").forward(request, response);
    }
}
