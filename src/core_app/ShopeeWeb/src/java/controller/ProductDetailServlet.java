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

@WebServlet(name = "ProductDetailServlet", urlPatterns = {"/product_detail"})
public class ProductDetailServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // 1. Lấy ID sản phẩm từ URL (vd: product-detail?id=5)
            String idRaw = request.getParameter("id");
            if (idRaw == null) {
                response.sendRedirect("home");
                return;
            }
            int id = Integer.parseInt(idRaw);

            // 2. Gọi DAO lấy dữ liệu
            ProductDAO dao = new ProductDAO();
            Product p = dao.getProductById(id);

            // Nếu không tìm thấy sản phẩm -> Về trang chủ
            if (p == null) {
                response.sendRedirect("home");
                return;
            }

            // 3. Lấy thêm list ảnh phụ (Gallery)
            List<String> images = dao.getProductImages(id);

            // 4. Gửi dữ liệu sang JSP
            request.setAttribute("detail", p);
            request.setAttribute("listImg", images);

            // 5. Mở trang giao diện
            request.getRequestDispatcher("product_detail.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("home");
        }
    }
}
