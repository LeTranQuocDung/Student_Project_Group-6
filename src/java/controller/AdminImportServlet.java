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
        // Vào trang giao diện import
        request.getRequestDispatcher("admin_import.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // 1. Chạy logic Import
            MigrationService service = new MigrationService();
            String logs = service.startMigration(); 
            
            // 2. Gửi log ngược lại trang admin_import.jsp để hiện trong hộp đen
            request.setAttribute("logs", logs);
            
        } catch (Exception e) {
            request.setAttribute("logs", "Lỗi Fatal: " + e.getMessage());
            e.printStackTrace();
        }
        // 3. QUAN TRỌNG: Forward về admin_import.jsp chứ không phải admin.jsp
        request.getRequestDispatcher("admin_import.jsp").forward(request, response);
    }
}