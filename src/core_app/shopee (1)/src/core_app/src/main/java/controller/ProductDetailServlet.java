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

@WebServlet(name = "ProductDetailServlet", urlPatterns = { "/product_detail" })
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

            // Nếu không tìm thấy sản phẩm -> Tạo sản phẩm Mock thay vì redirect
            List<String> images = null;
            if (p == null) {
                p = new Product();
                p.setId(id);
                p.setName(
                        "Ốp Lưng Iphone TPU hoa tiết da mềm mèo tặng hoa 6/6splus/7/8/plus/x/xs/11/12/13/14/15/16/pro/max/plus/promax-Awifi P5-11");
                p.setPrice(new java.math.BigDecimal("15900.0"));
                p.setImageUrl("images/ốp lưng iphone tpu 3.webp");
                // Mock Images
                images = java.util.Arrays.asList(
                        "images/ốp lưng iphone tpu 3.webp",
                        "images/ốp lưng iphone tpu 2.webp",
                        "images/ốp lưng iphone tpu 1.webp",
                        "images/ốp lưng iphone tpu 4.webp");
            } else {
                // Lấy thêm list ảnh phụ (Gallery)
                images = dao.getProductImages(id);
            }

            // 3. Lấy danh sách đánh giá
            dal.ReviewDAO revDao = new dal.ReviewDAO();
            List<model.Review> reviews = revDao.getReviewsByProductId(id);

            // 3b. Lấy số lượng đã bán
            int soldCount = dao.getSoldCount(id);

            // 3c. Lấy tổng tồn kho
            int totalStock = dao.getTotalStock(id);

            // 4. Gửi dữ liệu sang JSP
            request.setAttribute("detail", p);
            request.setAttribute("listImg", images);
            request.setAttribute("reviews", reviews);
            request.setAttribute("soldCount", soldCount);
            request.setAttribute("totalStock", totalStock);

            // 5. Mở trang giao diện
            request.getRequestDispatcher("product_detail.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("home");
        }
    }
}
