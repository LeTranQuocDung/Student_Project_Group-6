package controller;

import dal.ProductDAO;
import java.io.IOException;
import java.math.BigDecimal;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "ProductManageServlet", urlPatterns = { "/product-manage" })
public class ProductManageServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "";
        }

        if (action.equals("delete")) {
            String id = request.getParameter("id");
            ProductDAO dao = new ProductDAO();
            dao.deleteProduct(id);
            response.sendRedirect("home");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Xử lý form thêm sản phẩm
        try {
            String name = request.getParameter("name");
            String priceRaw = request.getParameter("price");
            // Mặc định ảnh nếu không nhập
            String image = "https://down-vn.img.susercontent.com/file/sg-11134201-22100-s6q7y2y2mhivda";

            BigDecimal price = BigDecimal.ZERO;
            if (priceRaw != null && !priceRaw.isEmpty()) {
                price = new BigDecimal(priceRaw);
            }

            ProductDAO dao = new ProductDAO();
            // Gọi hàm insert mới (3 tham số)
            dao.insertProduct(name, price, image);

            response.sendRedirect("home");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("home");
        }
    }
}
