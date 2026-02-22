package dal;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class StressDAO extends DBContext {


    public boolean buyProduct(int productId) {
        Connection conn = null;
        try {
            conn = getConnection();

           
            String sqlCheck = "SELECT stock FROM ProductVariants WHERE id = ?";
            PreparedStatement psCheck = conn.prepareStatement(sqlCheck);
            psCheck.setInt(1, productId);
            ResultSet rs = psCheck.executeQuery();

            int currentStock = 0;
            if (rs.next()) {
                currentStock = rs.getInt("stock");
            }

            
            if (currentStock > 0) {

             
                Thread.sleep(100);

           
                String sqlUpdate = "UPDATE ProductVariants SET stock = stock - 1 WHERE id = ?";
                PreparedStatement psUpdate = conn.prepareStatement(sqlUpdate);
                psUpdate.setInt(1, productId);
                psUpdate.executeUpdate();

                return true; 
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false; 
    }


    public void resetStock(int productId) {
        try (Connection conn = getConnection()) {
            String sql = "UPDATE ProductVariants SET stock = 1 WHERE id = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, productId);
            ps.executeUpdate();
        } catch (Exception e) {
        }
    }
}