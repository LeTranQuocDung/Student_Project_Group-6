package dal;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * DAO tìm kiếm toàn cục cho Admin Panel.
 * Tìm kiếm đồng thời trên nhiều bảng: products, users, orders, categories.
 * Trả về kết quả gộp dưới dạng Map dễ serialize thành JSON.
 */
public class GlobalSearchDAO extends DBContext {

    /**
     * Tìm kiếm toàn cục trên nhiều bảng cùng lúc.
     * Mỗi bảng lấy tối đa 5 kết quả phù hợp nhất.
     */
    public Map<String, List<Map<String, String>>> search(String keyword) {
        Map<String, List<Map<String, String>>> results = new HashMap<>();
        results.put("products", searchProducts(keyword));
        results.put("users", searchUsers(keyword));
        results.put("orders", searchOrders(keyword));
        results.put("categories", searchCategories(keyword));
        return results;
    }

    private List<Map<String, String>> searchProducts(String keyword) {
        List<Map<String, String>> list = new ArrayList<>();
        String sql = "SELECT TOP 5 p.id, p.name, " +
                "CAST((SELECT MIN(price) FROM product_variants pv WHERE pv.product_id = p.id) AS VARCHAR) AS price, " +
                "p.image_url " +
                "FROM products p " +
                "WHERE p.is_deleted = 0 AND (p.name LIKE ? OR CAST(p.id AS VARCHAR) = ?) " +
                "ORDER BY p.name";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, "%" + keyword + "%");
            ps.setString(2, keyword);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, String> item = new HashMap<>();
                    item.put("id", String.valueOf(rs.getInt("id")));
                    item.put("name", rs.getString("name"));
                    item.put("price", rs.getString("price") != null ? rs.getString("price") : "N/A");
                    item.put("image", rs.getString("image_url") != null ? rs.getString("image_url") : "");
                    item.put("link", "admin-products?search=" + rs.getString("name"));
                    list.add(item);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    private List<Map<String, String>> searchUsers(String keyword) {
        List<Map<String, String>> list = new ArrayList<>();
        String sql = "SELECT TOP 5 id, full_name, email, phone, role " +
                "FROM users " +
                "WHERE is_deleted = 0 AND (full_name LIKE ? OR email LIKE ? OR phone LIKE ? OR CAST(id AS VARCHAR) = ?) " +
                "ORDER BY full_name";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            String like = "%" + keyword + "%";
            ps.setString(1, like);
            ps.setString(2, like);
            ps.setString(3, like);
            ps.setString(4, keyword);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, String> item = new HashMap<>();
                    item.put("id", String.valueOf(rs.getInt("id")));
                    item.put("name", rs.getString("full_name"));
                    item.put("email", rs.getString("email") != null ? rs.getString("email") : "");
                    item.put("phone", rs.getString("phone") != null ? rs.getString("phone") : "");
                    item.put("role", rs.getString("role"));
                    item.put("link", "admin-users");
                    list.add(item);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    private List<Map<String, String>> searchOrders(String keyword) {
        List<Map<String, String>> list = new ArrayList<>();
        String sql = "SELECT TOP 5 o.id, o.status, o.total_price, o.created_at, u.full_name AS customer_name " +
                "FROM orders o LEFT JOIN users u ON o.user_id = u.id " +
                "WHERE o.is_deleted = 0 AND (CAST(o.id AS VARCHAR) LIKE ? OR u.full_name LIKE ?) " +
                "ORDER BY o.created_at DESC";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            String like = "%" + keyword + "%";
            ps.setString(1, like);
            ps.setString(2, like);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, String> item = new HashMap<>();
                    item.put("id", String.valueOf(rs.getInt("id")));
                    item.put("customer", rs.getString("customer_name") != null ? rs.getString("customer_name") : "Guest");
                    item.put("status", rs.getString("status"));
                    item.put("total", String.format("%,.0f", rs.getDouble("total_price")));
                    item.put("date", rs.getTimestamp("created_at") != null ? rs.getTimestamp("created_at").toString().substring(0, 16) : "");
                    item.put("link", "admin-orders");
                    list.add(item);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    private List<Map<String, String>> searchCategories(String keyword) {
        List<Map<String, String>> list = new ArrayList<>();
        String sql = "SELECT TOP 5 id, name, image_url " +
                "FROM categories " +
                "WHERE is_deleted = 0 AND (name LIKE ? OR CAST(id AS VARCHAR) = ?) " +
                "ORDER BY name";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, "%" + keyword + "%");
            ps.setString(2, keyword);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, String> item = new HashMap<>();
                    item.put("id", String.valueOf(rs.getInt("id")));
                    item.put("name", rs.getString("name"));
                    item.put("image", rs.getString("image_url") != null ? rs.getString("image_url") : "");
                    item.put("link", "admin-categories");
                    list.add(item);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}
