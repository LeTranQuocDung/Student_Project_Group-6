package controller;

import dal.ShopDAO;
import model.Shop;
import model.ProductDTO;
import model.User;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "ShopServlet", urlPatterns = { "/shop", "/shop/follow" })
public class ShopServlet extends HttpServlet {

    private static final int PAGE_SIZE = 20;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String path = request.getServletPath();

        // Default shop view
        try {
            String idStr = request.getParameter("id");
            int shopId = (idStr != null) ? Integer.parseInt(idStr) : 1;

            ShopDAO shopDAO = new ShopDAO();
            Shop shop = shopDAO.getShopById(shopId);

            if (shop == null) {
                response.sendRedirect("home");
                return;
            }

            // Pagination
            String pageStr = request.getParameter("page");
            int page = (pageStr != null) ? Integer.parseInt(pageStr) : 1;
            if (page < 1) page = 1;

            // Sort
            String sort = request.getParameter("sort");
            if (sort == null) sort = "popular";

            // Products
            List<ProductDTO> products = shopDAO.getShopProducts(shopId, sort, page, PAGE_SIZE);
            int totalProducts = shopDAO.getProductCount(shopId);
            int totalPages = (int) Math.ceil((double) totalProducts / PAGE_SIZE);

            // Top sellers
            List<ProductDTO> topSellers = shopDAO.getTopSellingProducts(shopId, 6);

            // User follow status
            boolean isFollowing = false;
            HttpSession session = request.getSession(false);
            User user = (session != null) ? (User) session.getAttribute("user") : null;
            if (user != null) {
                isFollowing = shopDAO.isFollowing(user.getId(), shopId);
            }

            // Pass to JSP
            request.setAttribute("shop", shop);
            request.setAttribute("products", products);
            request.setAttribute("topSellers", topSellers);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("currentSort", sort);
            request.setAttribute("isFollowing", isFollowing);
            request.setAttribute("pageSize", PAGE_SIZE);

            request.getRequestDispatcher("shop.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("home");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();

        // Follow/Unfollow toggle
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null) {
            response.setStatus(401);
            out.print("{\"error\":\"Vui lòng đăng nhập\",\"loginRequired\":true}");
            return;
        }

        String idStr = request.getParameter("shopId");
        if (idStr == null) {
            response.setStatus(400);
            out.print("{\"error\":\"Thiếu shopId\"}");
            return;
        }

        try {
            int shopId = Integer.parseInt(idStr);
            ShopDAO dao = new ShopDAO();
            boolean following = dao.toggleFollow(user.getId(), shopId);
            int count = dao.getFollowerCount(shopId);
            out.print("{\"following\":" + following + ",\"followerCount\":" + count + "}");
        } catch (NumberFormatException e) {
            response.setStatus(400);
            out.print("{\"error\":\"shopId không hợp lệ\"}");
        }
    }
}
