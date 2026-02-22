package controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import service.MigrationService;

@WebServlet(name = "AdminImportServlet", urlPatterns = {"/admin-import"})
public class AdminImportServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("admin_import.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {

            MigrationService service = new MigrationService();
            String logs = service.startMigration();

            request.setAttribute("logs", logs);

        } catch (Exception e) {
            request.setAttribute("logs", "Lỗi Fatal: " + e.getMessage());
            e.printStackTrace();
        }

        request.getRequestDispatcher("admin.jsp").forward(request, response);
    }
}
