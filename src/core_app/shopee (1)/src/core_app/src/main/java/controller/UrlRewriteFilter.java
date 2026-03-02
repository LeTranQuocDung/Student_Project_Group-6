package controller;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

@WebFilter(filterName = "UrlRewriteFilter", urlPatterns = {"/*"})
public class UrlRewriteFilter implements Filter {

    // Tham số Shopee thật: /[slug]-i.[shopId].[productId]
    private static final Pattern PRODUCT_URL_PATTERN = Pattern.compile(".*-i\\.\\d+\\.(\\d+)(?:\\?.*)?$");

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;

        String requestURI = req.getRequestURI();
        
        // Bỏ qua các file tĩnh và các path đặc biệt
        if (requestURI.contains("/css/") || requestURI.contains("/images/") || requestURI.contains("/js/") || requestURI.contains("/user/")) {
            chain.doFilter(request, response);
            return;
        }

        Matcher matcher = PRODUCT_URL_PATTERN.matcher(requestURI);
        if (matcher.matches()) {
            // Lấy productId từ regex group 1
            String productId = matcher.group(1);
            
            // Chuyển hướng nội bộ (forward) về ProductDetailServlet
            req.getRequestDispatcher("/product_detail?id=" + productId).forward(req, res);
            return;
        }

        // Nếu không khớp pattern nào, tiếp tục chuỗi filter bình thường
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
    }
}
