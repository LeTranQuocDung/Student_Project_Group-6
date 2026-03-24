package controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;
import service.MigrationService;

@WebServlet(name = "AdminImportServlet", urlPatterns = { "/admin-import" })
public class AdminImportServlet extends HttpServlet {

    // Kiểm tra quyền MANAGE_SYSTEM
    private boolean checkPermission(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("account") == null) {
            response.sendRedirect("login");
            return false;
        }
        Object account = session.getAttribute("account");
        if (account instanceof User) {
            User user = (User) account;
            if (!user.hasPermission("MANAGE_SYSTEM")) {
                response.sendRedirect("admin?error=access_denied");
                return false;
            }
        }
        return true;
    }

    // 1. KHI VÀO TRANG (GET) -> CHỈ HIỆN GIAO DIỆN ADMIN, KHÔNG CHẠY CODE
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!checkPermission(request, response)) return;
        request.getRequestDispatcher("admin_import.jsp").forward(request, response);
    }

    // 2. KHI BẤM NÚT (POST) -> MỚI CHẠY CODE IMPORT
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!checkPermission(request, response)) return;
        try {
            // Gọi Service chạy Migration
            MigrationService service = new MigrationService();
            String logs = service.startMigration();

            // Gửi log kết quả về lại trang JSP
            request.setAttribute("logs", logs);

            // Ghi nhật ký hệ thống
            HttpSession sess = request.getSession();
            User admin = (User) sess.getAttribute("account");
            int adminId = (admin != null) ? admin.getId() : 1;
            
            dal.AuditLogDAO audit = new dal.AuditLogDAO();
            audit.insertLog(adminId, "CREATE", "multiple_tables", "-", "Chạy tiến trình Import/Migration dữ liệu mẫu");

        } catch (Exception e) {
            request.setAttribute("logs", "Lỗi Fatal: " + e.getMessage());
            e.printStackTrace();
        }
        // Load lại trang admin_import.jsp để hiện log trực tiếp
        request.getRequestDispatcher("admin_import.jsp").forward(request, response);
    }
}