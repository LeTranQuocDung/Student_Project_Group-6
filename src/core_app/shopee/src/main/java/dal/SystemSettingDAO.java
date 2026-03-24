package dal;

import model.SystemSetting;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class SystemSettingDAO extends DBContext {

    // Lấy tất cả setting hiện có
    public List<SystemSetting> getAllSettings() {
        List<SystemSetting> list = new ArrayList<>();
        String sql = "SELECT * FROM system_settings ORDER BY setting_group, setting_key";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(new SystemSetting(
                        rs.getString("setting_key"),
                        rs.getString("setting_value"),
                        rs.getString("description"),
                        rs.getString("setting_group"),
                        rs.getTimestamp("updated_at")
                ));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Lấy danh sách setting dưới dạng Map Key-Value để nhúng vào front-end cho tiện
    public Map<String, String> getSettingsMap() {
        Map<String, String> map = new HashMap<>();
        String sql = "SELECT setting_key, setting_value FROM system_settings";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
             while (rs.next()) {
                 map.put(rs.getString("setting_key"), rs.getString("setting_value"));
             }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return map;
    }

    // Cập nhật giá trị setting
    public boolean updateSetting(String key, String value) {
        String sql = "UPDATE system_settings SET setting_value = ?, updated_at = GETDATE() WHERE setting_key = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, value);
            ps.setString(2, key);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // Lấy một setting cụ thể
    public String getSettingValue(String key) {
        String sql = "SELECT setting_value FROM system_settings WHERE setting_key = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, key);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getString("setting_value");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
}
