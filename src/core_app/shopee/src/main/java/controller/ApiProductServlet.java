package controller;

import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import dal.ProductDAO;
import model.ProductDTO;

import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * API endpoint trả JSON cho mobile app
 * GET /api/products?txt=keyword → trả danh sách sản phẩm dạng JSON
 */
@WebServlet(name = "ApiProductServlet", urlPatterns = {"/api/products"})
public class ApiProductServlet extends HttpServlet {

    private final Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // CORS cho mobile app
        response.setHeader("Access-Control-Allow-Origin", "*");
        response.setHeader("Access-Control-Allow-Methods", "GET, POST, OPTIONS");
        response.setHeader("Access-Control-Allow-Headers", "Content-Type");
        response.setContentType("application/json;charset=UTF-8");

        String txt = request.getParameter("txt");
        if (txt == null) txt = "";

        ProductDAO dao = new ProductDAO();
        List<ProductDTO> products = dao.searchProducts(txt);

        JsonArray arr = new JsonArray();
        for (ProductDTO p : products) {
            JsonObject obj = new JsonObject();
            obj.addProperty("id", p.getId());
            obj.addProperty("name", p.getName());
            obj.addProperty("minPrice", p.getMinPrice());
            obj.addProperty("imageUrl", p.getImageUrl());
            obj.addProperty("shopName", p.getShopName());
            obj.addProperty("soldCount", 0);
            obj.addProperty("rating", 4.5);
            arr.add(obj);
        }

        response.getWriter().write(arr.toString());
    }

    @Override
    protected void doOptions(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setHeader("Access-Control-Allow-Origin", "*");
        response.setHeader("Access-Control-Allow-Methods", "GET, POST, OPTIONS");
        response.setHeader("Access-Control-Allow-Headers", "Content-Type");
        response.setStatus(200);
    }
}
