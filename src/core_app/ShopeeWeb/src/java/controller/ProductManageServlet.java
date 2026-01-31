package controller;

import dal.ProductDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Admin;
import model.User;

@WebServlet(name = "ProductManageServlet", urlPatterns = {"/product-manage"})
public class ProductManageServlet extends HttpServlet {

    // Hàm kiểm tra quyền Admin (Chống việc User gõ link trực tiếp để xóa)
    private boolean isAdmin(HttpServletRequest req) {
        HttpSession session = req.getSession();
        User acc = (User) session.getAttribute("account");
        return acc != null && (acc instanceof Admin);
    }

    // XỬ LÝ XÓA (GET)
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Check quyền: Phải là Admin mới được xóa
        if (!isAdmin(req)) {
            resp.sendRedirect("home"); // Đuổi về trang chủ
            return;
        }

        String action = req.getParameter("action");
        if ("delete".equals(action)) {
            String id = req.getParameter("id");
            ProductDAO dao = new ProductDAO();
            dao.deleteProduct(id); // Gọi hàm xóa trong DAO
        }
        resp.sendRedirect("home");
    }

    // XỬ LÝ THÊM MỚI (POST)
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8"); // Để nhận tiếng Việt không bị lỗi font
        
        // Check quyền
        if (!isAdmin(req)) {
            resp.sendRedirect("home");
            return;
        }

        String name = req.getParameter("name");
        String desc = req.getParameter("desc");
        // Giá tiền (price) hiện tại Demo chưa lưu vào bảng Products (vì nó nằm bên Variant), 
        // nhưng ông có thể mở rộng sau. Tạm thời chỉ lưu Tên + Mô tả.
        
        ProductDAO dao = new ProductDAO();
        dao.insertProduct(name, desc); // Gọi hàm thêm trong DAO
        
        resp.sendRedirect("home");
    }
}