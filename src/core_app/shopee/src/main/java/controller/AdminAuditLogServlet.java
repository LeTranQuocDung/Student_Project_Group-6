package controller;

import dal.AuditLogDAO;
import model.AuditLog;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "AdminAuditLogServlet", urlPatterns = { "/admin-logs" })
public class AdminAuditLogServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int page = 1;
        int pageSize = 20;

        String pageParam = request.getParameter("page");
        if (pageParam != null) {
            try {
                page = Integer.parseInt(pageParam);
            } catch (NumberFormatException e) {
                // Ignore and use default
            }
        }

        AuditLogDAO dao = new AuditLogDAO();
        int totalLogs = dao.countLogs();
        int totalPages = (int) Math.ceil((double) totalLogs / pageSize);
        List<AuditLog> logs = dao.getLogs(page, pageSize);

        request.setAttribute("logs", logs);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);

        request.getRequestDispatcher("admin_audit_logs.jsp").forward(request, response);
    }
}
