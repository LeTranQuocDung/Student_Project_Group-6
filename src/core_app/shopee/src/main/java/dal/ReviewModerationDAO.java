package dal;

import model.Review;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO cho hệ thống xét duyệt đánh giá (Review Moderation).
 * Quản lý trạng thái: PENDING → APPROVED / REJECTED
 */
public class ReviewModerationDAO extends DBContext {

    /**
     * Đảm bảo cột status tồn tại trong bảng reviews.
     * Gọi lúc startup hoặc lần đầu truy cập.
     */
    public void ensureStatusColumn() {
        String sql = "IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='reviews' AND COLUMN_NAME='status') " +
                "ALTER TABLE reviews ADD status VARCHAR(20) DEFAULT 'APPROVED'";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * Lấy danh sách đánh giá theo trạng thái (PENDING, APPROVED, REJECTED, ALL).
     */
    public List<Review> getReviewsByStatus(String status, int page, int pageSize) {
        List<Review> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT r.id, r.product_id, r.user_id, r.rating, r.comment, r.created_at, r.has_media, " +
            "ISNULL(r.status, 'APPROVED') AS status, " +
            "u.full_name AS username, p.name AS product_name " +
            "FROM reviews r " +
            "LEFT JOIN users u ON r.user_id = u.id " +
            "LEFT JOIN products p ON r.product_id = p.id "
        );

        if (status != null && !status.equalsIgnoreCase("ALL")) {
            sql.append("WHERE ISNULL(r.status, 'APPROVED') = ? ");
        }

        sql.append("ORDER BY r.created_at DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            int idx = 1;
            if (status != null && !status.equalsIgnoreCase("ALL")) {
                ps.setString(idx++, status);
            }
            ps.setInt(idx++, (page - 1) * pageSize);
            ps.setInt(idx, pageSize);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Review r = new Review();
                    r.setId(rs.getInt("id"));
                    r.setProductId(rs.getInt("product_id"));
                    r.setUserId(rs.getInt("user_id"));
                    r.setRating(rs.getInt("rating"));
                    r.setComment(rs.getString("comment"));
                    r.setCreatedAt(rs.getTimestamp("created_at"));
                    r.setHasMedia(rs.getBoolean("has_media"));
                    r.setUsername(rs.getString("username"));
                    r.setProductName(rs.getString("product_name"));
                    r.setStatus(rs.getString("status"));
                    list.add(r);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Đếm tổng đánh giá theo trạng thái.
     */
    public int countByStatus(String status) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM reviews r ");
        if (status != null && !status.equalsIgnoreCase("ALL")) {
            sql.append("WHERE ISNULL(r.status, 'APPROVED') = ?");
        }
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            if (status != null && !status.equalsIgnoreCase("ALL")) {
                ps.setString(1, status);
            }
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * Đếm nhanh số lượng review theo từng trạng thái (cho badges).
     */
    public int[] getStatusCounts() {
        int pending = 0, approved = 0, rejected = 0;
        String sql = "SELECT ISNULL(status, 'APPROVED') AS s, COUNT(*) AS cnt FROM reviews GROUP BY ISNULL(status, 'APPROVED')";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                String s = rs.getString("s");
                int cnt = rs.getInt("cnt");
                if ("PENDING".equals(s)) pending = cnt;
                else if ("APPROVED".equals(s)) approved = cnt;
                else if ("REJECTED".equals(s)) rejected = cnt;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return new int[]{pending, approved, rejected};
    }

    /**
     * Cập nhật trạng thái 1 review.
     */
    public boolean updateStatus(int reviewId, String newStatus) {
        String sql = "UPDATE reviews SET status = ? WHERE id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, newStatus);
            ps.setInt(2, reviewId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Bulk update trạng thái nhiều reviews cùng lúc.
     */
    public int bulkUpdateStatus(String[] ids, String newStatus) {
        if (ids == null || ids.length == 0) return 0;
        StringBuilder sb = new StringBuilder("UPDATE reviews SET status = ? WHERE id IN (");
        for (int i = 0; i < ids.length; i++) {
            sb.append(i > 0 ? ",?" : "?");
        }
        sb.append(")");
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sb.toString())) {
            ps.setString(1, newStatus);
            for (int i = 0; i < ids.length; i++) {
                ps.setInt(i + 2, Integer.parseInt(ids[i]));
            }
            return ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * Xóa vĩnh viễn review.
     */
    public boolean deleteReview(int reviewId) {
        String sql = "DELETE FROM reviews WHERE id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, reviewId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Bulk delete vĩnh viễn.
     */
    public int bulkDelete(String[] ids) {
        if (ids == null || ids.length == 0) return 0;
        StringBuilder sb = new StringBuilder("DELETE FROM reviews WHERE id IN (");
        for (int i = 0; i < ids.length; i++) {
            sb.append(i > 0 ? ",?" : "?");
        }
        sb.append(")");
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sb.toString())) {
            for (int i = 0; i < ids.length; i++) {
                ps.setInt(i + 1, Integer.parseInt(ids[i]));
            }
            return ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }
}
