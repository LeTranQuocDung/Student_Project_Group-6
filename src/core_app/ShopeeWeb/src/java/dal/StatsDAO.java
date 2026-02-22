package dal;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class StatsDAO extends DBContext {

 
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

 
    public List<Double> getRevenueLast7Days() {
        List<Double> list = new ArrayList<>();
        String sql = "SELECT TOP 7 CAST(created_at AS DATE) as date, SUM(total_amount) as total "
                + "FROM Orders "
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
}