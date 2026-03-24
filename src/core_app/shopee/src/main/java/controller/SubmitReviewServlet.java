package controller;

import dal.ReviewDAO;
import dal.OrderDAO;
import model.User;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

@WebServlet(name = "SubmitReviewServlet", urlPatterns = {"/submit_review"})
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,    // 1 MB
    maxFileSize = 10 * 1024 * 1024,     // 10 MB per file
    maxRequestSize = 50 * 1024 * 1024   // 50 MB total
)
public class SubmitReviewServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Ensure UTF-8 Encoding
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("account");

        String productIdRaw = request.getParameter("productId");
        
        if (user == null || productIdRaw == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            int productId = Integer.parseInt(productIdRaw);
            
            // Kiểm tra quyền: user phải có đơn hàng COMPLETED chứa sản phẩm này
            OrderDAO orderDao = new OrderDAO();
            if (!orderDao.hasCompletedOrder(user.getId(), productId)) {
                response.sendRedirect("product_detail?id=" + productId);
                return;
            }
            
            int rating = Integer.parseInt(request.getParameter("rating"));
            String comment = request.getParameter("comment");

            // Xử lý upload media files
            List<Part> mediaParts = new ArrayList<>();
            for (Part part : request.getParts()) {
                if ("media".equals(part.getName()) && part.getSize() > 0) {
                    mediaParts.add(part);
                }
            }

            boolean hasMedia = !mediaParts.isEmpty();

            ReviewDAO reviewDao = new ReviewDAO();
            
            // Kiểm tra: mỗi user chỉ được đánh giá 1 lần per sản phẩm
            if (reviewDao.hasReviewed(user.getId(), productId)) {
                response.sendRedirect("product_detail?id=" + productId);
                return;
            }
            
            // Insert review vào DB và nhận lại reviewId
            int reviewId = reviewDao.insertReview(productId, user.getId(), rating, comment, hasMedia);

            if (reviewId > 0 && hasMedia) {
                // Lưu file vào thư mục NGOÀI webapps (không bị xóa khi redeploy)
                String uploadPath = ReviewMediaServlet.getUploadDirectory();

                for (Part part : mediaParts) {
                    String fileName = getUniqueFileName(part);
                    String filePath = uploadPath + File.separator + fileName;
                    
                    // Lưu file
                    try (InputStream input = part.getInputStream()) {
                        Files.copy(input, Paths.get(filePath), StandardCopyOption.REPLACE_EXISTING);
                    }

                    // Xác định loại media
                    String contentType = part.getContentType();
                    String mediaType = "image";
                    if (contentType != null && contentType.startsWith("video")) {
                        mediaType = "video";
                    }

                    // Lưu media URL vào DB (đường dẫn relative cho servlet phục vụ)
                    String mediaUrl = "uploads/reviews/" + fileName;
                    reviewDao.insertReviewMedia(reviewId, mediaUrl, mediaType);
                }
            }

            // Redirect back to the product detail page
            response.sendRedirect("product_detail?id=" + productId);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("home");
        }
    }

    /**
     * Tạo tên file unique để tránh trùng lặp
     */
    private String getUniqueFileName(Part part) {
        String originalName = "";
        String contentDisp = part.getHeader("content-disposition");
        if (contentDisp != null) {
            for (String token : contentDisp.split(";")) {
                if (token.trim().startsWith("filename")) {
                    originalName = token.substring(token.indexOf('=') + 1).trim().replace("\"", "");
                    // Xử lý đường dẫn Windows
                    if (originalName.contains("\\")) {
                        originalName = originalName.substring(originalName.lastIndexOf("\\") + 1);
                    }
                    break;
                }
            }
        }
        
        // Lấy extension
        String ext = "";
        int dotIdx = originalName.lastIndexOf('.');
        if (dotIdx > 0) {
            ext = originalName.substring(dotIdx);
        }
        
        return UUID.randomUUID().toString() + ext;
    }
}
