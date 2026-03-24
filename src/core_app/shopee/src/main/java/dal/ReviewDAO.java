package dal;

import model.Review;
import model.Review.ReviewMedia;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class ReviewDAO extends DBContext {

    private static boolean tableChecked = false;

    /**
     * Tự động tạo bảng review_media nếu chưa tồn tại.
     * Chỉ chạy 1 lần duy nhất khi app khởi động.
     */
    private void ensureReviewMediaTable() {
        if (tableChecked) return;
        String sql = "IF OBJECT_ID('dbo.review_media', 'U') IS NULL " +
                "CREATE TABLE dbo.review_media (" +
                "id INT IDENTITY(1,1) PRIMARY KEY, " +
                "review_id INT NOT NULL, " +
                "media_url NVARCHAR(500) NOT NULL, " +
                "media_type VARCHAR(10) DEFAULT 'image' CHECK(media_type IN ('image', 'video')), " +
                "created_at DATETIME DEFAULT GETDATE(), " +
                "FOREIGN KEY (review_id) REFERENCES dbo.reviews(id) ON DELETE CASCADE)";
        try (Connection conn = getConnection();
             Statement st = conn.createStatement()) {
            st.execute(sql);
            tableChecked = true;
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public List<Review> getReviewsByProductId(int productId) {
        List<Review> list = new ArrayList<>();
        // JOIN with users to get username AND avatar
        String sql = "SELECT r.*, u.username, u.avatar FROM reviews r JOIN users u ON r.user_id = u.id WHERE r.product_id = ? ORDER BY r.created_at DESC";
        try (Connection conn = getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {
             
            ps.setInt(1, productId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Review review = new Review();
                    review.setId(rs.getInt("id"));
                    review.setProductId(rs.getInt("product_id"));
                    review.setUserId(rs.getInt("user_id"));
                    review.setRating(rs.getInt("rating"));
                    review.setComment(rs.getString("comment"));
                    review.setCreatedAt(rs.getTimestamp("created_at"));
                    review.setHasMedia(rs.getBoolean("has_media"));
                    
                    review.setUsername(rs.getString("username"));
                    
                    // Lấy avatar người dùng
                    try {
                        review.setUserAvatar(rs.getString("avatar"));
                    } catch (Exception e) {
                        // Cột avatar chưa tồn tại
                    }
                    
                    list.add(review);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        // Lấy media cho từng review có has_media = true
        for (Review review : list) {
            if (review.isHasMedia()) {
                loadMediaForReview(review);
            }
        }
        
        return list;
    }

    /**
     * Lấy danh sách media (ảnh/video) cho một review.
     * Dùng ReviewMedia object để JSTL có thể truy cập ${media.url} và ${media.type}
     */
    private void loadMediaForReview(Review review) {
        ensureReviewMediaTable();
        String sql = "SELECT media_url, media_type FROM review_media WHERE review_id = ? ORDER BY id ASC";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, review.getId());
            try (ResultSet rs = ps.executeQuery()) {
                List<ReviewMedia> mediaList = new ArrayList<>();
                List<String> urls = new ArrayList<>();
                List<String> types = new ArrayList<>();
                while (rs.next()) {
                    String url = rs.getString("media_url");
                    String type = rs.getString("media_type");
                    mediaList.add(new ReviewMedia(url, type));
                    urls.add(url);
                    types.add(type);
                }
                review.setMediaList(mediaList);
                review.setMediaUrls(urls);
                review.setMediaTypes(types);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * Kiểm tra user đã đánh giá sản phẩm này chưa.
     * Dùng để giới hạn mỗi user chỉ được đánh giá 1 lần per sản phẩm.
     */
    public boolean hasReviewed(int userId, int productId) {
        String sql = "SELECT COUNT(*) FROM reviews WHERE user_id = ? AND product_id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, productId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Insert review và trả về ID của review vừa tạo
     */
    public int insertReview(int productId, int userId, int rating, String comment, boolean hasMedia) {
        String sql = "INSERT INTO reviews (product_id, user_id, rating, comment, has_media) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
             
            ps.setInt(1, productId);
            ps.setInt(2, userId);
            ps.setInt(3, rating);
            ps.setString(4, comment);
            ps.setBoolean(5, hasMedia);
            
            ps.executeUpdate();
            
            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) {
                    return keys.getInt(1);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return -1;
    }

    /**
     * Giữ phương thức cũ để tương thích (backward compatible)
     */
    public void insertReview(int productId, int userId, int rating, String comment) {
        insertReview(productId, userId, rating, comment, false);
    }

    /**
     * Insert media (ảnh/video) cho một review
     */
    public void insertReviewMedia(int reviewId, String mediaUrl, String mediaType) {
        ensureReviewMediaTable();
        String sql = "INSERT INTO review_media (review_id, media_url, media_type) VALUES (?, ?, ?)";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, reviewId);
            ps.setString(2, mediaUrl);
            ps.setString(3, mediaType);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
