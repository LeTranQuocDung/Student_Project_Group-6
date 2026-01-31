package controller;

import java.io.IOException;
import java.io.IOException;
import javax.servlet.ServletException; // Đổi từ jakarta sang javax
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import service.MigrationService;

@WebServlet(name = "AdminImportServlet", urlPatterns = {"/admin-import"})
public class AdminImportServlet extends HttpServlet {

    // 1. KHI VÀO TRANG (GET) -> CHỈ HIỆN GIAO DIỆN ADMIN, KHÔNG CHẠY CODE
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("admin.jsp").forward(request, response);
    }

    // 2. KHI BẤM NÚT (POST) -> MỚI CHẠY CODE IMPORT
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Gọi Service chạy Migration
            MigrationService service = new MigrationService();
            String logs = service.startMigration(); 
            
            // Gửi log kết quả về lại trang JSP
            request.setAttribute("logs", logs);
            
        } catch (Exception e) {
            request.setAttribute("logs", "Lỗi Fatal: " + e.getMessage());
            e.printStackTrace();
        }
        // Load lại trang admin.jsp để hiện log
        request.getRequestDispatcher("admin.jsp").forward(request, response);
    }
}