package controller;

import dal.AuditLogDAO;
import dal.SystemSettingDAO;
import model.SystemSetting;
import model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.Enumeration;
import java.util.List;
import java.util.Map;

@WebServlet(name = "AdminSettingServlet", urlPatterns = {"/admin-settings"})
public class AdminSettingServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User admin = (User) session.getAttribute("account");

        if (admin == null || !admin.hasPermission("MANAGE_SYSTEM")) {
            response.sendRedirect("login");
            return;
        }

        SystemSettingDAO settingDAO = new SystemSettingDAO();
        List<SystemSetting> settingsList = settingDAO.getAllSettings();
        
        request.setAttribute("settingsList", settingsList);
        // Chuyển Map để dùng trong View linh hoạt hơn
        Map<String, String> settingsMap = settingDAO.getSettingsMap();
        request.setAttribute("settings", settingsMap);

        request.getRequestDispatcher("admin_settings.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User admin = (User) session.getAttribute("account");

        if (admin == null || !admin.hasPermission("MANAGE_SYSTEM")) {
            response.sendRedirect("login");
            return;
        }

        SystemSettingDAO settingDAO = new SystemSettingDAO();
        int updateCount = 0;

        // Lặp qua tất cả params submit từ form
        Enumeration<String> parameterNames = request.getParameterNames();
        while (parameterNames.hasMoreElements()) {
            String key = parameterNames.nextElement();
            if (key.startsWith("setting_")) {
                String settingKey = key.substring(8); // Bỏ chữ 'setting_' ở đầu
                String value = request.getParameter(key);
                // Update vào DB
                if (settingDAO.updateSetting(settingKey, value)) {
                    updateCount++;
                }
            }
        }

        if (updateCount > 0) {
            AuditLogDAO logDAO = new AuditLogDAO();
            logDAO.insertLog(admin.getId(), "UPDATE", "System Settings", null, "Updated " + updateCount + " system settings config");
            
            // Cập nhật lại application scope để các trang khác tự động thấy Setting mới nhất ngay lập tức
            request.getServletContext().setAttribute("globalSettings", settingDAO.getSettingsMap());
            
            session.setAttribute("successMessage", "Đã lưu " + updateCount + " thiết lập hệ thống thành công!");
        }

        response.sendRedirect("admin-settings");
    }
}
