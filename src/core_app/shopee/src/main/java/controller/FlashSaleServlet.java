package controller;

import dal.ProductDAO;
import dal.CategoryDAO;
import model.ProductDTO;
import model.Category;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "FlashSaleServlet", urlPatterns = { "/flash_sale" })
public class FlashSaleServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        ProductDAO dao = new ProductDAO();
        CategoryDAO categoryDao = new CategoryDAO();

        // Lấy sản phẩm cho flash sale (page 1, tối đa 30 sản phẩm)
        List<ProductDTO> products = dao.searchProducts(null, null, null, null, null, null, "bestselling", 1);

        // Lấy danh mục
        List<Category> categories = categoryDao.getAllCategories();

        request.setAttribute("flashProducts", products);
        request.setAttribute("categories", categories);

        request.getRequestDispatcher("flash_sale.jsp").forward(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }
}
