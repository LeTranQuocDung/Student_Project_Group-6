package listener;

import controller.ReviewMediaServlet;
import dal.SystemSettingDAO;
import jakarta.servlet.ServletContext;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;
import java.io.File;
import java.util.Map;

@WebListener
public class AppStartupListener implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        ServletContext context = sce.getServletContext();

        // 1. Tạo thư mục review_uploads (ngoài webapps, không bị xóa khi redeploy)
        try {
            String uploadDir = ReviewMediaServlet.getUploadDirectory();
            File dir = new File(uploadDir);
            if (!dir.exists()) {
                dir.mkdirs();
            }
            System.out.println("[ShopeeWeb] Review uploads dir: " + uploadDir);
        } catch (Exception e) {
            System.err.println("[ShopeeWeb] Failed to create review_uploads dir: " + e.getMessage());
        }

        // 2. Nạp cấu hình hệ thống vào RAM
        SystemSettingDAO settingDAO = new SystemSettingDAO();
        try {
            Map<String, String> globalSettings = settingDAO.getSettingsMap();
            context.setAttribute("globalSettings", globalSettings);
        } catch (Exception e) {
            System.err.println("Failed to load settings on startup: " + e.getMessage());
        }
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        // Cleanup if necessary
    }
}
