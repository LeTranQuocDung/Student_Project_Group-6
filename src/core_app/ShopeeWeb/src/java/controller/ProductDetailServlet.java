package controller;

import dal.ProductDAO;
import model.Product;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "ProductDetailServlet", urlPatterns = {"/product-detail"})
public class ProductDetailServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            ProductDAO dao = new ProductDAO();
            
            // 1. Lấy thông tin sản phẩm
            Product p = dao.getProductById(id);
            
            // 2. Lấy danh sách ảnh gallery
            List<String> images = dao.getProductImages(id);
            
            // 3. Gửi sang JSP
            request.setAttribute("detail", p);
            request.setAttribute("images", images);
            
            request.getRequestDispatcher("product-detail.jsp").forward(request, response);
            
        } catch (Exception e) {
            // Nếu lỗi ID hoặc không tìm thấy -> Về trang chủ
            response.sendRedirect("home");
        }
    }
}