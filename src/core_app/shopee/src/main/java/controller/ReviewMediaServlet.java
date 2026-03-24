package controller;

import java.io.File;
import java.io.IOException;
import java.io.OutputStream;
import java.nio.file.Files;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * Servlet phục vụ file ảnh/video review từ thư mục ngoài webapps.
 * File được lưu tại: {catalina.base}/review_uploads/
 * URL truy cập: /uploads/reviews/{filename}
 */
@WebServlet(name = "ReviewMediaServlet", urlPatterns = {"/uploads/reviews/*"})
public class ReviewMediaServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String pathInfo = request.getPathInfo();
        if (pathInfo == null || pathInfo.equals("/")) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        // Lấy tên file từ URL (chỉ lấy phần cuối, chống path traversal)
        String fileName = pathInfo.substring(pathInfo.lastIndexOf('/') + 1);
        
        // Chống path traversal
        if (fileName.contains("..") || fileName.contains("/") || fileName.contains("\\")) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        // Tìm file trong thư mục upload
        String uploadDir = getUploadDirectory();
        File file = new File(uploadDir, fileName);

        if (!file.exists() || !file.isFile()) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        // Set content type dựa trên extension
        String contentType = getServletContext().getMimeType(file.getName());
        if (contentType == null) {
            contentType = "application/octet-stream";
        }
        response.setContentType(contentType);
        response.setContentLengthLong(file.length());
        
        // Cache 7 ngày
        response.setHeader("Cache-Control", "public, max-age=604800");

        // Stream file về browser
        try (OutputStream out = response.getOutputStream()) {
            Files.copy(file.toPath(), out);
        }
    }

    /**
     * Lấy đường dẫn thư mục lưu trữ file upload.
     * Sử dụng {catalina.base}/review_uploads/ để file không bị xóa khi redeploy.
     */
    public static String getUploadDirectory() {
        String catalinaBase = System.getProperty("catalina.base");
        if (catalinaBase == null) {
            catalinaBase = System.getProperty("user.dir");
        }
        String uploadDir = catalinaBase + File.separator + "review_uploads";
        File dir = new File(uploadDir);
        if (!dir.exists()) {
            dir.mkdirs();
        }
        return uploadDir;
    }
}
