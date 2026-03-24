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

@WebServlet(name = "HomeServlet", urlPatterns = { "/home" }, loadOnStartup = 1)
public class HomeServlet extends HttpServlet {

    // ===== IN-MEMORY CACHE cho trang chủ =====
    private static List<ProductDTO> cachedProducts = null;
    private static List<model.Category> cachedCategories = null;
    private static long cacheTimestamp = 0;
    private static final long CACHE_DURATION_MS = 5 * 60 * 1000; // Cache 5 phút

    @Override
    public void init() throws ServletException {
        super.init();
        // Pre-warm cache in background thread (không block Tomcat startup)
        new Thread(() -> {
            try {
                long start = System.currentTimeMillis();
                refreshCache();
                long elapsed = System.currentTimeMillis() - start;
            } catch (Exception e) {
            }
        }, "HomeServlet-CacheWarm").start();
    }

    /**
     * Refresh cache từ DB (chỉ chạy 1 lần mỗi 5 phút)
     */
    private static synchronized void refreshCache() {
        ProductDAO dao = new ProductDAO();
        cachedProducts = dao.getHomeProducts(); // Query nhẹ, không JOIN order_items

        dal.CategoryDAO categoryDao = new dal.CategoryDAO();
        cachedCategories = categoryDao.getAllCategories();

        cacheTimestamp = System.currentTimeMillis();
    }

    /**
     * Xóa cache (gọi khi admin thay đổi dữ liệu)
     */
    public static void invalidateCache() {
        cachedProducts = null;
        cachedCategories = null;
        cacheTimestamp = 0;
    }

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        long start = System.currentTimeMillis();

        // Kiểm tra cache có hết hạn không
        boolean cacheExpired = cachedProducts == null || cachedCategories == null
                || (System.currentTimeMillis() - cacheTimestamp) > CACHE_DURATION_MS;

        if (cacheExpired) {
            refreshCache();
        }

        // Đẩy dữ liệu từ cache sang JSP (cực nhanh, ~0ms)
        request.setAttribute("products", cachedProducts);
        request.setAttribute("categories", cachedCategories);
        request.setAttribute("txtS", request.getParameter("txt"));

        long elapsed = System.currentTimeMillis() - start;
        if (elapsed > 50) {
            // Slow processRequest was detected.
        }

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
