package dal;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class StressDAO extends DBContext {

    // Hàm mua hàng này sẽ bị lỗi Race Condition nếu không đồng bộ
    public boolean buyProduct(int productId) {
        Connection conn = null;
        try {
            conn = getConnection();

            // 1. Kiểm tra tồn kho
            String sqlCheck = "SELECT stock FROM ProductVariants WHERE id = ?";
            PreparedStatement psCheck = conn.prepareStatement(sqlCheck);
            psCheck.setInt(1, productId);
            ResultSet rs = psCheck.executeQuery();

            int currentStock = 0;
            if (rs.next()) {
                currentStock = rs.getInt("stock");
            }

            // 2. Logic kiểm tra
            if (currentStock > 0) {

                // GIẢ LẬP ĐỘ TRỄ MẠNG (Đây là lúc lỗi xảy ra: thằng khác chen vào mua)
                Thread.sleep(100);

                // 3. Trừ kho
                String sqlUpdate = "UPDATE ProductVariants SET stock = stock - 1 WHERE id = ?";
                PreparedStatement psUpdate = conn.prepareStatement(sqlUpdate);
                psUpdate.setInt(1, productId);
                psUpdate.executeUpdate();

                return true; // Mua thành công
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false; // Hết hàng
    }

    // Hàm reset kho về 1 để test lại
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
