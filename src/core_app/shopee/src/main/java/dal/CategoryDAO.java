package dal;

import model.Category;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class CategoryDAO extends DBContext {

    // ===== PERFORMANCE: In-Memory Category Cache (5 phút) =====
    private static List<Category> cachedCategories = null;
    private static long cacheTimestamp = 0;
    private static final long CACHE_DURATION_MS = 5 * 60 * 1000; // 5 phút

    public static void clearCache() {
        cachedCategories = null;
        cacheTimestamp = 0;
    }

    public List<Category> getAllCategories() {
        // Trả về cache nếu còn hạn
        if (cachedCategories != null && (System.currentTimeMillis() - cacheTimestamp) < CACHE_DURATION_MS) {
            return new ArrayList<>(cachedCategories); // trả bản copy để tránh mutation
        }

        List<Category> list = new ArrayList<>();
        String sql = "SELECT * FROM categories WHERE is_deleted = 0";
        try (Connection conn = getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                list.add(new Category(
                        rs.getInt("id"),
                        rs.getString("name"),
                        rs.getString("image_url")
                ));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        // Lưu vào cache
        cachedCategories = new ArrayList<>(list);
        cacheTimestamp = System.currentTimeMillis();

        return list;
    }

    // Admin: Thêm danh mục
    public void insertCategory(String name, String imageUrl) {
        String sql = "INSERT INTO categories (name, image_url) VALUES (?, ?)";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, name);
            ps.setString(2, imageUrl);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Admin: Cập nhật danh mục
    public void updateCategory(int id, String name, String imageUrl) {
        String sql = "UPDATE categories SET name = ?, image_url = ? WHERE id = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, name);
            ps.setString(2, imageUrl);
            ps.setInt(3, id);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Admin: Xóa danh mục (Soft Delete)
    public void deleteCategory(int id) {
        String sql = "UPDATE categories SET is_deleted = 1 WHERE id = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Admin: Lấy danh mục đã xóa (Thùng rác)
    public List<Category> getDeletedCategories() {
        List<Category> list = new ArrayList<>();
        String sql = "SELECT * FROM categories WHERE is_deleted = 1";
        try (Connection conn = getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                list.add(new Category(
                        rs.getInt("id"),
                        rs.getString("name"),
                        rs.getString("image_url")
                ));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Admin: Khôi phục danh mục
    public void restoreCategory(int id) {
        String sql = "UPDATE categories SET is_deleted = 0 WHERE id = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Tìm danh mục có sản phẩm liên quan đến keyword (smart filter)
    public List<Category> getRelevantCategories(String keyword) {
        List<Category> list = new ArrayList<>();
        if (keyword == null || keyword.trim().isEmpty()) {
            return getAllCategories();
        }
        String sql = "SELECT c.id, c.name, c.image_url, COUNT(p.id) as product_count "
                + "FROM categories c "
                + "INNER JOIN products p ON p.category_id = c.id AND p.is_deleted = 0 "
                + "WHERE c.is_deleted = 0 AND p.name LIKE ? "
                + "GROUP BY c.id, c.name, c.image_url "
                + "ORDER BY product_count DESC";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, "%" + keyword.trim() + "%");
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new Category(
                        rs.getInt("id"),
                        rs.getString("name"),
                        rs.getString("image_url")
                ));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // --- BULK ACTIONS ---
    private String buildInClause(int size) {
        StringBuilder sb = new StringBuilder("(");
        for (int i = 0; i < size; i++) {
            sb.append("?");
            if (i < size - 1) sb.append(",");
        }
        sb.append(")");
        return sb.toString();
    }

    public void bulkDeleteCategories(String[] ids) {
        if (ids == null || ids.length == 0) return;
        String sql = "UPDATE categories SET is_deleted = 1 WHERE id IN " + buildInClause(ids.length);
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            for (int i = 0; i < ids.length; i++) {
                ps.setInt(i + 1, Integer.parseInt(ids[i]));
            }
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void bulkRestoreCategories(String[] ids) {
        if (ids == null || ids.length == 0) return;
        String sql = "UPDATE categories SET is_deleted = 0 WHERE id IN " + buildInClause(ids.length);
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            for (int i = 0; i < ids.length; i++) {
                ps.setInt(i + 1, Integer.parseInt(ids[i]));
            }
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void bulkDeletePermanentCategories(String[] ids) {
        if (ids == null || ids.length == 0) return;
        String sql = "DELETE FROM categories WHERE id IN " + buildInClause(ids.length);
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            for (int i = 0; i < ids.length; i++) {
                ps.setInt(i + 1, Integer.parseInt(ids[i]));
            }
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    // --- END BULK ACTIONS ---
}
