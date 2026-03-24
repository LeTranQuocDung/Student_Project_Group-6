package controller;

import dal.WishlistDAO;
import model.User;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * API endpoint cho tính năng Yêu thích (Wishlist).
 * POST /wishlist?productId=X → toggle like, trả JSON
 * GET  /wishlist?productId=X → lấy trạng thái + count
 */
@WebServlet(name = "WishlistServlet", urlPatterns = { "/wishlist" })
public class WishlistServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();

        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null) {
            response.setStatus(401);
            out.print("{\"error\":\"Vui lòng đăng nhập để thích sản phẩm\",\"loginRequired\":true}");
            return;
        }

        String pidStr = request.getParameter("productId");
        if (pidStr == null) {
            response.setStatus(400);
            out.print("{\"error\":\"Thiếu productId\"}");
            return;
        }

        try {
            int productId = Integer.parseInt(pidStr);
            WishlistDAO dao = new WishlistDAO();
            boolean liked = dao.toggleLike(user.getId(), productId);
            int count = dao.countByProductId(productId);

            out.print("{\"liked\":" + liked + ",\"count\":" + count + "}");
        } catch (NumberFormatException e) {
            response.setStatus(400);
            out.print("{\"error\":\"productId không hợp lệ\"}");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();

        String pidStr = request.getParameter("productId");
        if (pidStr == null) {
            response.setStatus(400);
            out.print("{\"error\":\"Thiếu productId\"}");
            return;
        }

        try {
            int productId = Integer.parseInt(pidStr);
            WishlistDAO dao = new WishlistDAO();
            int count = dao.countByProductId(productId);

            boolean liked = false;
            HttpSession session = request.getSession(false);
            User user = (session != null) ? (User) session.getAttribute("user") : null;
            if (user != null) {
                liked = dao.isLiked(user.getId(), productId);
            }

            out.print("{\"liked\":" + liked + ",\"count\":" + count + "}");
        } catch (NumberFormatException e) {
            response.setStatus(400);
            out.print("{\"error\":\"productId không hợp lệ\"}");
        }
    }
}
