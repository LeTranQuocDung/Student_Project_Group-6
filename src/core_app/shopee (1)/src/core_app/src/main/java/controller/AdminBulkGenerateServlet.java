package controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import service.BulkDataService;

@WebServlet(name = "AdminBulkGenerateServlet", urlPatterns = { "/admin-generate" })
public class AdminBulkGenerateServlet extends HttpServlet {

    // GET -> Hiện giao diện
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("admin_generate.jsp").forward(request, response);
    }

    // POST -> Chạy tạo dữ liệu
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String countStr = request.getParameter("count");
            int count = 10; // Mặc định

            if (countStr != null && !countStr.isEmpty()) {
                count = Integer.parseInt(countStr);
                // Giới hạn an toàn
                if (count < 1) count = 1;
                if (count > 10000) count = 10000;
            }

            BulkDataService service = new BulkDataService();
            String logs = service.generate(count);
            request.setAttribute("logs", logs);
            request.setAttribute("generatedCount", count);

        } catch (NumberFormatException e) {
            request.setAttribute("logs", "❌ Số lượng không hợp lệ: " + e.getMessage());
        } catch (Exception e) {
            request.setAttribute("logs", "❌ Lỗi hệ thống: " + e.getMessage());
            e.printStackTrace();
        }

        request.getRequestDispatcher("admin_generate.jsp").forward(request, response);
    }
}
