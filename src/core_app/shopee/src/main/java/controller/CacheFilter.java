package controller;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * Performance Filter: Thêm cache headers cho static resources.
 * - CSS, JS, images: cache 7 ngày (604800 giây)
 * - Giảm số request lặp lại từ browser
 */
@WebFilter(filterName = "CacheFilter", urlPatterns = {"/css/*", "/js/*", "/images/*", "/fonts/*"})
public class CacheFilter implements Filter {

    private static final int CACHE_DURATION_SECONDS = 604800; // 7 ngày

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        httpResponse.setHeader("Cache-Control", "public, max-age=" + CACHE_DURATION_SECONDS);
        httpResponse.setHeader("Vary", "Accept-Encoding");
        chain.doFilter(request, response);
    }
}
