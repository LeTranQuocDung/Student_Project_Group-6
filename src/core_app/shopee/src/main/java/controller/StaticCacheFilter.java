package controller;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * Filter thêm Cache-Control header cho static resources (CSS, JS, images).
 * Giúp browser cache lại file tĩnh, tránh download lại mỗi lần load trang.
 */
@WebFilter(urlPatterns = { "/css/*", "/js/*", "/images/*" })
public class StaticCacheFilter implements Filter {

    // Cache static files trong 7 ngày (604800 giây)
    private static final int MAX_AGE_SECONDS = 7 * 24 * 60 * 60;

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletResponse httpResponse = (HttpServletResponse) response;

        // Cache mạnh: browser không cần hỏi lại server trong 7 ngày
        httpResponse.setHeader("Cache-Control", "public, max-age=" + MAX_AGE_SECONDS + ", immutable");

        chain.doFilter(request, response);
    }
}
