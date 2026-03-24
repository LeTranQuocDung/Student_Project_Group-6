package controller;

import dal.AnomalyDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet(name = "AdminAnomalyServlet", urlPatterns = {"/admin-alerts"})
public class AdminAnomalyServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        AnomalyDAO anomalyDAO = new AnomalyDAO();

        // Lấy tất cả cảnh báo
        List<Map<String, Object>> alerts = anomalyDAO.getAllAlerts();
        Map<String, Integer> counts = anomalyDAO.getAlertCountsBySeverity();

        request.setAttribute("alerts", alerts);
        request.setAttribute("highCount", counts.get("HIGH"));
        request.setAttribute("mediumCount", counts.get("MEDIUM"));
        request.setAttribute("lowCount", counts.get("LOW"));
        request.setAttribute("totalAlerts", counts.get("TOTAL"));

        request.getRequestDispatcher("admin_alerts.jsp").forward(request, response);
    }
}
