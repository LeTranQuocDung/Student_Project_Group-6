package dal;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class StatsDAO extends DBContext {

    // 1. Tổng doanh thu
    public double getTotalRevenue() {
        try (Connection conn = getConnection()) {
            ResultSet rs = conn.prepareStatement("SELECT SUM(total_price) FROM orders").executeQuery();
            if (rs.next()) {
                return rs.getDouble(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    // 2. Tổng số đơn hàng
    public int countOrders() {
        try (Connection conn = getConnection()) {
            ResultSet rs = conn.prepareStatement("SELECT COUNT(*) FROM orders").executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    // 3. Tổng số người dùng
    public int countUsers() {
        try (Connection conn = getConnection()) {
            ResultSet rs = conn.prepareStatement("SELECT COUNT(*) FROM users WHERE role != 'ADMIN'").executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    // 4. Lấy doanh thu 7 ngày gần nhất (Để vẽ biểu đồ)
    // Trả về List<Double>: [100000, 500000, 0, 200000...]
    public List<Double> getRevenueLast7Days() {
        List<Double> list = new ArrayList<>();
        String sql = "SELECT TOP 7 CAST(created_at AS DATE) as date, SUM(total_price) as total "
                + "FROM orders "
                + "GROUP BY CAST(created_at AS DATE) "
                + "ORDER BY date DESC";

        try (Connection conn = getConnection()) {
            ResultSet rs = conn.prepareStatement(sql).executeQuery();
            while (rs.next()) {
                list.add(rs.getDouble("total"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // 5. Tổng số sản phẩm
    public int countProducts() {
        try (Connection conn = getConnection()) {
            ResultSet rs = conn.prepareStatement("SELECT COUNT(*) FROM products").executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    // 6. Đếm đơn hàng theo trạng thái
    public int countOrdersByStatus(String status) {
        String sql = "SELECT COUNT(*) FROM orders WHERE status = ?";
        try (Connection conn = getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
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
        try (Connection conn = getConnection()) {
            ResultSet rs = conn.prepareStatement(sql).executeQuery();
            while (rs.next()) {
                list.add(new String[] { rs.getString("name"), String.valueOf(rs.getInt("total_sold")) });
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}
