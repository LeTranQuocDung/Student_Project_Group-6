package controller;

import model.Admin;
import model.User;
import java.io.IOException;
import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * BỘ LỌC BẢO MẬT ADMIN
 * 
 * Chặn TẤT CẢ request đến /admin* nếu chưa đăng nhập bằng tài khoản Admin.
 * Nếu không phải admin → redirect về /login
 */
@WebFilter(filterName = "AdminAuthFilter", urlPatterns = { "/admin", "/admin-import", "/admin-products",
        "/admin-orders", "/admin-users", "/admin-generate" })
// NOTE: /admin-verify-otp is intentionally NOT included here
// because the admin hasn't completed 2FA yet at that point
public class AdminAuthFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Khởi tạo filter (không cần làm gì)
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        // 1. Lấy session hiện tại (không tạo mới nếu chưa có)
        HttpSession session = httpRequest.getSession(false);

        // 2. Kiểm tra đã đăng nhập chưa
        if (session == null || session.getAttribute("account") == null) {
            // Chưa đăng nhập → đá về login
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/login");
            return;
        }

        // 3. Kiểm tra có phải Admin không
        Object account = session.getAttribute("account");

        boolean isAdmin = false;
        if (account instanceof Admin) {
            isAdmin = true;
        } else if (account instanceof User) {
            User user = (User) account;
            isAdmin = "admin".equalsIgnoreCase(user.getRole());
        }

        if (!isAdmin) {
            // Đăng nhập rồi nhưng KHÔNG phải admin → đá về trang chủ
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/home");
            return;
        }

        // 4. Là Admin → cho đi tiếp
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
        // Hủy filter (không cần làm gì)
    }
}
