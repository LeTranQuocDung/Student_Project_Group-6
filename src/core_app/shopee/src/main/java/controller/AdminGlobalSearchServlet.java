package controller;

import com.google.gson.Gson;
import dal.GlobalSearchDAO;
import model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * API endpoint cho tính năng Global Search trên Admin Panel.
 * Trả về JSON kết quả tìm kiếm xuyên suốt products, users, orders, categories.
 * URL: /admin-search?q=keyword
 */
@WebServlet(name = "AdminGlobalSearchServlet", urlPatterns = {"/admin-search"})
public class AdminGlobalSearchServlet extends HttpServlet {

    private final Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json; charset=UTF-8");

        HttpSession session = request.getSession();
        User admin = (User) session.getAttribute("account");

        if (admin == null) {
            response.setStatus(401);
            response.getWriter().write("{\"error\":\"Unauthorized\"}");
            return;
        }

        String keyword = request.getParameter("q");
        if (keyword == null || keyword.trim().length() < 2) {
            response.getWriter().write("{\"products\":[],\"users\":[],\"orders\":[],\"categories\":[]}");
            return;
        }

        GlobalSearchDAO dao = new GlobalSearchDAO();
        Map<String, List<Map<String, String>>> results = dao.search(keyword.trim());

        // Đếm tổng kết quả
        int total = 0;
        for (List<?> list : results.values()) {
            total += list.size();
        }

        Map<String, Object> output = new HashMap<>();
        output.put("results", results);
        output.put("total", total);
        output.put("keyword", keyword);

        response.getWriter().write(gson.toJson(output));
    }
}
