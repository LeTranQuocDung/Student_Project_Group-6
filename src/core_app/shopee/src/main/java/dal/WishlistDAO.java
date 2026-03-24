package dal;

import java.sql.*;

public class WishlistDAO extends DBContext {

    /**
     * Đếm tổng lượt thích của 1 sản phẩm
     */
    public int countByProductId(int productId) {
        String sql = "SELECT COUNT(*) FROM wishlist WHERE product_id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, productId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * Kiểm tra user đã thích sản phẩm chưa
     */
    public boolean isLiked(int userId, int productId) {
        String sql = "SELECT COUNT(*) FROM wishlist WHERE user_id = ? AND product_id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, productId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1) > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Toggle like: nếu chưa thích → thêm, đã thích → xóa.
     * @return true nếu sau toggle = đang thích, false nếu đã bỏ thích
     */
    public boolean toggleLike(int userId, int productId) {
        if (isLiked(userId, productId)) {
            // Bỏ thích
            String sql = "DELETE FROM wishlist WHERE user_id = ? AND product_id = ?";
            try (Connection conn = getConnection();
                 PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, userId);
                ps.setInt(2, productId);
                ps.executeUpdate();
            } catch (Exception e) {
                e.printStackTrace();
            }
            return false;
        } else {
            // Thêm thích
            String sql = "INSERT INTO wishlist (user_id, product_id) VALUES (?, ?)";
            try (Connection conn = getConnection();
                 PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, userId);
                ps.setInt(2, productId);
                ps.executeUpdate();
            } catch (Exception e) {
                e.printStackTrace();
            }
            return true;
        }
    }
}
