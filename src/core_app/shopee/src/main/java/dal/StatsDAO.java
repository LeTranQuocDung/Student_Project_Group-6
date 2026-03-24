package dal;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class StatsDAO extends DBContext {

    /**
     * Gộp 4 thống kê tổng quan vào 1 câu SQL duy nhất.
     * Trả về Map chứa: totalRevenue, totalOrders, totalUsers, totalProducts
     * Trước đây cần 4 lần getConnection() riêng biệt → giờ chỉ cần 1.
     */
    public Map<String, Object> getDashboardStats() {
        Map<String, Object> stats = new HashMap<>();
        stats.put("totalRevenue", 0.0);
        stats.put("totalOrders", 0);
        stats.put("totalUsers", 0);
        stats.put("totalProducts", 0);

        String sql = "SELECT " +
                "(SELECT ISNULL(SUM(total_price), 0) FROM orders) AS totalRevenue, " +
                "(SELECT COUNT(*) FROM orders) AS totalOrders, " +
                "(SELECT COUNT(*) FROM users WHERE role != 'ADMIN') AS totalUsers, " +
                "(SELECT COUNT(*) FROM products WHERE is_deleted = 0) AS totalProducts";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                stats.put("totalRevenue", rs.getDouble("totalRevenue"));
                stats.put("totalOrders", rs.getInt("totalOrders"));
                stats.put("totalUsers", rs.getInt("totalUsers"));
                stats.put("totalProducts", rs.getInt("totalProducts"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return stats;
    }

    /**
     * Gộp 3 lần đếm trạng thái đơn hàng vào 1 câu SQL.
     * Trước đây gọi countOrdersByStatus() 3 lần = 3 connection → giờ chỉ 1.
     */
    public Map<String, Integer> getOrderStatusCounts() {
        Map<String, Integer> counts = new HashMap<>();
        counts.put("PENDING", 0);
        counts.put("COMPLETED", 0);
        counts.put("CANCELLED", 0);

        String sql = "SELECT status, COUNT(*) AS cnt FROM orders WHERE status IN ('PENDING','COMPLETED','CANCELLED') GROUP BY status";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                counts.put(rs.getString("status"), rs.getInt("cnt"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return counts;
    }

    // 4. Lấy doanh thu 7 ngày gần nhất (Để vẽ biểu đồ)
    public List<Double> getRevenueLast7Days() {
        List<Double> list = new ArrayList<>();
        String sql = "SELECT TOP 7 CAST(created_at AS DATE) as date, SUM(total_price) as total "
                + "FROM orders "
                + "GROUP BY CAST(created_at AS DATE) "
                + "ORDER BY date DESC";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(rs.getDouble("total"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // 7. Top sản phẩm bán chạy (theo số lượng order_items)
    public List<String[]> getTopSellingProducts(int limit) {
        List<String[]> list = new ArrayList<>();
        String sql = "SELECT TOP " + limit + " p.name, SUM(oi.quantity) as total_sold "
                + "FROM order_items oi "
                + "JOIN product_variants pv ON oi.variant_id = pv.id "
                + "JOIN products p ON pv.product_id = p.id "
                + "GROUP BY p.name "
                + "ORDER BY total_sold DESC";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(new String[] { rs.getString("name"), String.valueOf(rs.getInt("total_sold")) });
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // ===== Các hàm cũ giữ lại để không break code khác =====

    public double getTotalRevenue() {
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement("SELECT ISNULL(SUM(total_price), 0) FROM orders");
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getDouble(1);
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }

    public int countOrders() {
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement("SELECT COUNT(*) FROM orders");
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }

    public int countUsers() {
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement("SELECT COUNT(*) FROM users WHERE role != 'ADMIN'");
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }

    public int countProducts() {
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement("SELECT COUNT(*) FROM products WHERE is_deleted = 0");
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }

    public int countOrdersByStatus(String status) {
        String sql = "SELECT COUNT(*) FROM orders WHERE status = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }
}
