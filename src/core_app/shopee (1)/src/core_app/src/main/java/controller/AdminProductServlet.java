package controller;

import dal.ProductDAO;
import model.Product;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "AdminProductServlet", urlPatterns = { "/admin-products" })
public class AdminProductServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        ProductDAO dao = new ProductDAO();
        List<Product> products = dao.getAllProducts();
        request.setAttribute("products", products);
        request.getRequestDispatcher("admin_products.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        ProductDAO dao = new ProductDAO();

        try {
            if ("add".equals(action)) {
                String name = request.getParameter("name");
                String priceRaw = request.getParameter("price");
                String image = request.getParameter("image_url");

                if (image == null || image.isEmpty()) {
                    image = "https://down-vn.img.susercontent.com/file/sg-11134201-22100-s6q7y2y2mhivda";
                }

                BigDecimal price = BigDecimal.ZERO;
                if (priceRaw != null && !priceRaw.isEmpty()) {
                    price = new BigDecimal(priceRaw);
                }

                dao.insertProduct(name, price, image);

            } else if ("edit".equals(action)) {
                String idRaw = request.getParameter("id");
                String name = request.getParameter("name");
                String priceRaw = request.getParameter("price");
                String image = request.getParameter("image_url");

                int id = Integer.parseInt(idRaw);
                BigDecimal price = BigDecimal.ZERO;
                if (priceRaw != null && !priceRaw.isEmpty()) {
                    price = new BigDecimal(priceRaw);
                }

                dao.updateProduct(id, name, price, image);

            } else if ("delete".equals(action)) {
                String id = request.getParameter("id");
                dao.deleteProduct(id);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect("admin-products");
    }
}
