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

@WebServlet(name = "SearchServlet", urlPatterns = { "/search" })
public class SearchServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Get the search keyword from "txt" or "keyword" parameter
        String txtSearch = request.getParameter("txt");
        if (txtSearch == null || txtSearch.trim().isEmpty()) {
            txtSearch = request.getParameter("keyword"); // support both for Shopee-like URL
        }

        // Always pass non-null keyword back to UI to prevent issues
        if (txtSearch == null) {
            txtSearch = "";
        }

        // 2. Lấy các filter parameters
        String[] cateIds = request.getParameterValues("cateId");
        String[] locations = request.getParameterValues("location");
        String minPriceStr = request.getParameter("minPrice");
        String maxPriceStr = request.getParameter("maxPrice");
        String ratingStr = request.getParameter("rating");

        // 3. Lấy sort và page parameters
        String sortBy = request.getParameter("sortBy");
        if (sortBy == null || sortBy.isEmpty()) {
            sortBy = "popular"; // mặc định: Liên quan
        }

        int page = 1;
        try {
            page = Integer.parseInt(request.getParameter("page"));
        } catch (Exception e) {
            // Mặc định trang 1
        }
        if (page < 1)
            page = 1;

        // 4. Call DAO
        ProductDAO productDao = new ProductDAO();

        // Đếm tổng sản phẩm để tính phân trang
        int totalProducts = productDao.countSearchProducts(txtSearch, cateIds, locations, minPriceStr, maxPriceStr,
                ratingStr);
        int pageSize = productDao.getPageSize();
        int totalPages = (int) Math.ceil((double) totalProducts / pageSize);
        if (totalPages < 1)
            totalPages = 1;
        if (page > totalPages)
            page = totalPages;

        List<ProductDTO> products = productDao.searchProducts(txtSearch, cateIds, locations, minPriceStr, maxPriceStr,
                ratingStr, sortBy, page);

        // 5. Might need categories for header/sidebar menu
        CategoryDAO categoryDao = new CategoryDAO();
        List<Category> categories = categoryDao.getAllCategories();

        // 6. Set attributes for JSP
        request.setAttribute("products", products);
        request.setAttribute("categories", categories);
        request.setAttribute("txtS", txtSearch);
        request.setAttribute("sortBy", sortBy);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalProducts", totalProducts);

        // 7. Forward to the search layout
        request.getRequestDispatcher("search.jsp").forward(request, response);
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
