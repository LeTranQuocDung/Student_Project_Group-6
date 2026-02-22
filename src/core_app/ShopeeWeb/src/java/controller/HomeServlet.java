package controller;

import dal.ProductDAO;
import model.ProductDTO;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "HomeServlet", urlPatterns = {"/home", "/search"})
public class HomeServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String txtSearch = request.getParameter("txt");
        String categoryIdRaw = request.getParameter("cid");

        ProductDAO dao = new ProductDAO();
        List<ProductDTO> list;

        if (categoryIdRaw != null && !categoryIdRaw.isEmpty()) {
            int cid = Integer.parseInt(categoryIdRaw);
            list = dao.getProductsByCategory(cid);
        } else {
            list = dao.searchProducts(txtSearch);
        }

        request.setAttribute("products", list);
        request.setAttribute("txtS", txtSearch);
        request.getRequestDispatcher("shopee_home.jsp").forward(request, response);
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
