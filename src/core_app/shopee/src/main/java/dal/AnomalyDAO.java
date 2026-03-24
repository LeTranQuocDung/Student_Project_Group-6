package dal;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * DAO phát hiện bất thường trong hệ thống.
 * Chạy các query kiểm tra dữ liệu đơn hàng, user, sản phẩm, review
 * và trả về danh sách cảnh báo.
 */
public class AnomalyDAO extends DBContext {

    /**
     * Lấy tất cả cảnh báo bất thường hiện tại.
     * @return List<Map> mỗi map chứa: type, severity, message, count, icon, color
     */
    public List<Map<String, Object>> getAllAlerts() {
        List<Map<String, Object>> alerts = new ArrayList<>();
        checkHighValueOrders(alerts);
        checkAbnormalRegistrations(alerts);
        checkMassCancellations(alerts);
        checkOutOfStockProducts(alerts);
        checkReviewSpam(alerts);
        return alerts;
    }

    /**
     * Đếm tổng cảnh báo theo severity.
     */
    public Map<String, Integer> getAlertCountsBySeverity() {
        List<Map<String, Object>> all = getAllAlerts();
        Map<String, Integer> counts = new HashMap<>();
        counts.put("HIGH", 0);
        counts.put("MEDIUM", 0);
        counts.put("LOW", 0);
        counts.put("TOTAL", all.size());
        for (Map<String, Object> a : all) {
            String sev = (String) a.get("severity");
            counts.put(sev, counts.getOrDefault(sev, 0) + 1);
        }
        return counts;
    }

    // === 1. Đơn hàng giá trị cao (> 5,000,000đ trong 24h) ===
    private void checkHighValueOrders(List<Map<String, Object>> alerts) {
        String sql = "SELECT COUNT(*) AS cnt, MAX(total_price) AS maxVal " +
                     "FROM orders WHERE total_price > 5000000 " +
                     "AND created_at >= DATEADD(HOUR, -24, GETDATE())";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next() && rs.getInt("cnt") > 0) {
                Map<String, Object> alert = new HashMap<>();
                alert.put("type", "HIGH_VALUE_ORDER");
                alert.put("severity", "HIGH");
                alert.put("icon", "fa-money-bill-wave");
                alert.put("color", "#e53935");
                alert.put("count", rs.getInt("cnt"));
                alert.put("message", rs.getInt("cnt") + " don hang gia tri cao (>" +
                    String.format("%,.0f", 5000000.0) + "d) trong 24h qua. " +
                    "Max: " + String.format("%,.0f", rs.getDouble("maxVal")) + "d");
                alerts.add(alert);
            }
        } catch (Exception e) { e.printStackTrace(); }
    }

    // === 2. Đăng ký bất thường (> 10 user trong 1 giờ) ===
    private void checkAbnormalRegistrations(List<Map<String, Object>> alerts) {
        String sql = "SELECT COUNT(*) AS cnt FROM users " +
                     "WHERE created_at >= DATEADD(HOUR, -1, GETDATE()) AND role != 'ADMIN'";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next() && rs.getInt("cnt") > 10) {
                Map<String, Object> alert = new HashMap<>();
                alert.put("type", "ABNORMAL_REGISTRATIONS");
                alert.put("severity", "MEDIUM");
                alert.put("icon", "fa-user-plus");
                alert.put("color", "#ff9800");
                alert.put("count", rs.getInt("cnt"));
                alert.put("message", rs.getInt("cnt") + " tai khoan moi dang ky trong 1 gio qua. Co the la bot/spam.");
                alerts.add(alert);
            }
        } catch (Exception e) { e.printStackTrace(); }
    }

    // === 3. Hủy đơn liên tục (> 5 đơn hủy trong 24h) ===
    private void checkMassCancellations(List<Map<String, Object>> alerts) {
        String sql = "SELECT COUNT(*) AS cnt FROM orders " +
                     "WHERE status = 'CANCELLED' AND created_at >= DATEADD(HOUR, -24, GETDATE())";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next() && rs.getInt("cnt") > 5) {
                Map<String, Object> alert = new HashMap<>();
                alert.put("type", "MASS_CANCELLATIONS");
                alert.put("severity", "MEDIUM");
                alert.put("icon", "fa-ban");
                alert.put("color", "#f57c00");
                alert.put("count", rs.getInt("cnt"));
                alert.put("message", rs.getInt("cnt") + " don hang bi huy trong 24h qua. Can kiem tra nguyen nhan.");
                alerts.add(alert);
            }
        } catch (Exception e) { e.printStackTrace(); }
    }

    // === 4. Sản phẩm hết hàng (stock = 0) ===
    private void checkOutOfStockProducts(List<Map<String, Object>> alerts) {
        String sql = "SELECT COUNT(DISTINCT pv.product_id) AS cnt " +
                     "FROM product_variants pv " +
                     "JOIN products p ON pv.product_id = p.id " +
                     "WHERE pv.stock = 0 AND p.is_deleted = 0";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next() && rs.getInt("cnt") > 0) {
                Map<String, Object> alert = new HashMap<>();
                alert.put("type", "OUT_OF_STOCK");
                alert.put("severity", "LOW");
                alert.put("icon", "fa-box-open");
                alert.put("color", "#1e88e5");
                alert.put("count", rs.getInt("cnt"));
                alert.put("message", rs.getInt("cnt") + " san pham het hang (stock = 0). Can nhap them hang.");
                alerts.add(alert);
            }
        } catch (Exception e) { e.printStackTrace(); }
    }

    // === 5. Review spam (> 5 review từ 1 user trong 1 ngày) ===
    private void checkReviewSpam(List<Map<String, Object>> alerts) {
        String sql = "SELECT user_id, COUNT(*) AS cnt FROM reviews " +
                     "WHERE created_at >= DATEADD(HOUR, -24, GETDATE()) " +
                     "GROUP BY user_id HAVING COUNT(*) > 5";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            int spamUsers = 0;
            while (rs.next()) { spamUsers++; }
            if (spamUsers > 0) {
                Map<String, Object> alert = new HashMap<>();
                alert.put("type", "REVIEW_SPAM");
                alert.put("severity", "MEDIUM");
                alert.put("icon", "fa-comment-slash");
                alert.put("color", "#8e24aa");
                alert.put("count", spamUsers);
                alert.put("message", spamUsers + " user gui > 5 review trong 24h. Nghi ngo spam.");
                alerts.add(alert);
            }
        } catch (Exception e) { e.printStackTrace(); }
    }
}
