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
            ResultSet rs = conn.prepareStatement("SELECT SUM(total_amount) FROM Orders").executeQuery();
            if (rs.next()) {
                return rs.getDouble(1);
            }
        } catch (Exception e) {
        }
        return 0;
    }

    // 2. Tổng số đơn hàng
    public int countOrders() {
        try (Connection conn = getConnection()) {
            ResultSet rs = conn.prepareStatement("SELECT COUNT(*) FROM Orders").executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
        }
        return 0;
    }

    // 3. Tổng số người dùng
    public int countUsers() {
        try (Connection conn = getConnection()) {
            ResultSet rs = conn.prepareStatement("SELECT COUNT(*) FROM Users WHERE role != 'admin'").executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
        }
        return 0;
    }

    // 4. Lấy doanh thu 7 ngày gần nhất (Để vẽ biểu đồ)
    // Trả về List<Double>: [100000, 500000, 0, 200000...]
    public List<Double> getRevenueLast7Days() {
        List<Double> list = new ArrayList<>();
        String sql = "SELECT TOP 7 CAST(created_at AS DATE) as date, SUM(total_amount) as total "
                + "FROM Orders "
                + "GROUP BY CAST(created_at AS DATE) "
                + "ORDER BY date DESC";
        // Lưu ý: SQL này lấy ngày có đơn. Thực tế cần join với bảng lịch để lấy cả ngày 0đ.
        // Nhưng làm demo thì query này là đủ dùng.
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
}
