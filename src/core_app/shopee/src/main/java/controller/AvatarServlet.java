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
 * Servlet phục vụ file avatar từ thư mục lưu trữ cố định (không bị xóa khi redeploy).
 * URL: /avatars/avatar_1_xxx.jpg → đọc file từ AVATAR_DIR và trả về browser.
 */
@WebServlet(name = "AvatarServlet", urlPatterns = {"/avatars/*"})
public class AvatarServlet extends HttpServlet {

    // Thư mục lưu avatar cố định (nằm ngoài Tomcat webapps)
    public static final String AVATAR_DIR = System.getProperty("user.home") + File.separator + "shopee_avatars";

    @Override
    public void init() throws ServletException {
        // Tạo thư mục nếu chưa có
        File dir = new File(AVATAR_DIR);
        if (!dir.exists()) {
            dir.mkdirs();
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String pathInfo = request.getPathInfo();
        if (pathInfo == null || pathInfo.equals("/")) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        // Lấy tên file (bỏ dấu / đầu tiên)
        String fileName = pathInfo.substring(1);

        // Chặn path traversal (../../../etc/passwd)
        if (fileName.contains("..") || fileName.contains("/") || fileName.contains("\\")) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        File avatarFile = new File(AVATAR_DIR, fileName);
        if (!avatarFile.exists() || !avatarFile.isFile()) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        // Set content type
        String mimeType = getServletContext().getMimeType(avatarFile.getName());
        if (mimeType == null) mimeType = "application/octet-stream";
        response.setContentType(mimeType);

        // Cache avatar 1 ngày (avatar thay đổi ít)
        response.setHeader("Cache-Control", "public, max-age=86400");
        response.setContentLengthLong(avatarFile.length());

        // Stream file ra response
        try (OutputStream out = response.getOutputStream()) {
            Files.copy(avatarFile.toPath(), out);
        }
    }
}
