package controller;

import dal.UserDAO;
import model.User;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

@WebServlet(name = "UserProfileServlet", urlPatterns = {"/user/account/profile"})
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,  // 1 MB
    maxFileSize       = 1024 * 1024,  // 1 MB
    maxRequestSize    = 5 * 1024 * 1024 // 5 MB
)
public class UserProfileServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User acc = (User) session.getAttribute("account");

        if (acc == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        UserDAO dao = new UserDAO();
        User freshUser = dao.getUserById(acc.getId());
        if (freshUser != null) {
            session.setAttribute("account", freshUser);
            request.setAttribute("user", freshUser);
        } else {
            request.setAttribute("user", acc);
        }

        request.getRequestDispatcher("/user_profile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        User acc = (User) session.getAttribute("account");

        if (acc == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Đọc form params
        String fullName = request.getParameter("fullName");
        String phone = request.getParameter("phone");
        String gender = request.getParameter("gender");
        String dateOfBirth = request.getParameter("dateOfBirth");

        // Validate cơ bản
        if (fullName == null || fullName.trim().isEmpty()) {
            session.setAttribute("error", "Tên không được để trống");
            response.sendRedirect(request.getContextPath() + "/user/account/profile");
            return;
        }

        if (phone != null && !phone.trim().isEmpty() && !phone.trim().matches("^[0-9]{9,15}$")) {
            session.setAttribute("error", "Số điện thoại không hợp lệ (9-15 chữ số)");
            response.sendRedirect(request.getContextPath() + "/user/account/profile");
            return;
        }

        UserDAO dao = new UserDAO();

        // Xử lý avatar upload
        try {
            Part filePart = request.getPart("avatarFile");
            if (filePart != null && filePart.getSize() > 0) {
                String fileName = getSubmittedFileName(filePart);
                if (fileName != null && !fileName.isEmpty()) {
                    // Validate extension
                    String ext = fileName.substring(fileName.lastIndexOf(".")).toLowerCase();
                    if (".jpg".equals(ext) || ".jpeg".equals(ext) || ".png".equals(ext)) {
                        // Validate size (1MB max)
                        if (filePart.getSize() <= 1024 * 1024) {
                            // Lưu vào thư mục cố định (không bị xóa khi redeploy)
                            File uploadFolder = new File(AvatarServlet.AVATAR_DIR);
                            if (!uploadFolder.exists()) {
                                uploadFolder.mkdirs();
                            }

                            // Tên file unique theo userId + timestamp
                            String uniqueName = "avatar_" + acc.getId() + "_" + System.currentTimeMillis() + ext;
                            Path filePath = Paths.get(AvatarServlet.AVATAR_DIR, uniqueName);

                            // Save file
                            try (InputStream input = filePart.getInputStream()) {
                                Files.copy(input, filePath, StandardCopyOption.REPLACE_EXISTING);
                            }

                            // URL trỏ đến AvatarServlet: /avatars/filename.jpg
                            String avatarUrl = request.getContextPath() + "/avatars/" + uniqueName;
                            dao.updateAvatar(acc.getId(), avatarUrl);
                        } else {
                            session.setAttribute("error", "Ảnh quá lớn. Tối đa 1MB.");
                            response.sendRedirect(request.getContextPath() + "/user/account/profile");
                            return;
                        }
                    } else {
                        session.setAttribute("error", "Chỉ hỗ trợ định dạng .JPG, .JPEG, .PNG");
                        response.sendRedirect(request.getContextPath() + "/user/account/profile");
                        return;
                    }
                }
            }
        } catch (Exception e) {
            System.err.println("[Avatar Upload] Error: " + e.getMessage());
            e.printStackTrace();
        }

        // Cập nhật profile
        boolean success = dao.updateProfile(acc.getId(), fullName.trim(), phone, gender, dateOfBirth);

        if (success) {
            User freshUser = dao.getUserById(acc.getId());
            if (freshUser != null) {
                session.setAttribute("account", freshUser);
            }
            session.setAttribute("success", "Cập nhật hồ sơ thành công!");
        } else {
            session.setAttribute("error", "Cập nhật thất bại, vui lòng thử lại.");
        }

        response.sendRedirect(request.getContextPath() + "/user/account/profile");
    }

    private String getSubmittedFileName(Part part) {
        String contentDisp = part.getHeader("content-disposition");
        if (contentDisp == null) return null;
        for (String token : contentDisp.split(";")) {
            if (token.trim().startsWith("filename")) {
                String name = token.substring(token.indexOf("=") + 2, token.length() - 1);
                // Handle IE full path
                int lastSlash = name.lastIndexOf("\\");
                if (lastSlash >= 0) name = name.substring(lastSlash + 1);
                return name;
            }
        }
        return null;
    }
}
