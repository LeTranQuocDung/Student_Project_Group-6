package dal;

import model.Shop;
import model.ProductDTO;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ShopDAO extends DBContext {

    /**
     * Lấy thông tin shop theo ID
     */
    public Shop getShopById(int shopId) {
        String sql = "SELECT s.*, u.full_name, u.email FROM shops s "
                + "LEFT JOIN users u ON s.owner_id = u.id WHERE s.id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, shopId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Shop shop = new Shop();
                shop.setId(rs.getInt("id"));
                shop.setOwnerId(rs.getInt("owner_id"));
                shop.setShopName(rs.getString("shop_name"));
                shop.setRating(rs.getDouble("rating"));
                shop.setCreatedAt(rs.getTimestamp("created_at"));
                shop.setOwnerAvatar(rs.getString("avatar"));
                
                // Computed fields
                shop.setProductCount(getProductCount(shopId));
                shop.setFollowerCount(getFollowerCount(shopId));
                String rr = rs.getString("response_rate");
                shop.setResponseRate(rr != null ? rr : "0%");
                String rt = rs.getString("response_time");
                shop.setResponseTime(rt != null ? rt : "chưa có");
                shop.setOwnerName(rs.getString("full_name"));
                shop.setLocation(rs.getString("location"));
                return shop;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Đếm số sản phẩm của shop
     */
    public int getProductCount(int shopId) {
        String sql = "SELECT COUNT(*) FROM products WHERE shop_id = ? AND (is_deleted = 0 OR is_deleted IS NULL)";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, shopId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * Đếm số người theo dõi shop
     */
    public int getFollowerCount(int shopId) {
        String sql = "SELECT COUNT(*) FROM shop_followers WHERE shop_id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, shopId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) {
            // Bảng chưa tồn tại thì trả 0
        }
        return 0;
    }

    /**
     * Kiểm tra user đã follow shop chưa
     */
    public boolean isFollowing(int userId, int shopId) {
        String sql = "SELECT COUNT(*) FROM shop_followers WHERE user_id = ? AND shop_id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, shopId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1) > 0;
        } catch (Exception e) {}
        return false;
    }

    /**
     * Toggle follow shop
     */
    public boolean toggleFollow(int userId, int shopId) {
        if (isFollowing(userId, shopId)) {
            String sql = "DELETE FROM shop_followers WHERE user_id = ? AND shop_id = ?";
            try (Connection conn = getConnection();
                 PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, userId);
                ps.setInt(2, shopId);
                ps.executeUpdate();
            } catch (Exception e) { e.printStackTrace(); }
            return false;
        } else {
            String sql = "INSERT INTO shop_followers (user_id, shop_id) VALUES (?, ?)";
            try (Connection conn = getConnection();
                 PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, userId);
                ps.setInt(2, shopId);
                ps.executeUpdate();
            } catch (Exception e) { e.printStackTrace(); }
            return true;
        }
    }

    /**
     * Lấy sản phẩm của shop (có phân trang + sắp xếp)
     */
    public List<ProductDTO> getShopProducts(int shopId, String sort, int page, int pageSize) {
        List<ProductDTO> list = new ArrayList<>();
        String orderBy;
        switch (sort != null ? sort : "popular") {
            case "newest": orderBy = "p.created_at DESC"; break;
            case "bestselling": orderBy = "sold DESC"; break;
            case "price_asc": orderBy = "p.price ASC"; break;
            case "price_desc": orderBy = "p.price DESC"; break;
            default: orderBy = "p.id DESC"; break;
        }

        String sql = "SELECT p.*, "
                + "(SELECT ISNULL(SUM(oi.quantity),0) FROM order_items oi "
                + "JOIN product_variants pv ON oi.variant_id = pv.id "
                + "WHERE pv.product_id = p.id) AS sold "
                + "FROM products p WHERE p.shop_id = ? AND (p.is_deleted = 0 OR p.is_deleted IS NULL) "
                + "ORDER BY " + orderBy + " "
                + "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, shopId);
            ps.setInt(2, (page - 1) * pageSize);
            ps.setInt(3, pageSize);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                ProductDTO dto = new ProductDTO();
                dto.setId(rs.getInt("id"));
                dto.setName(rs.getString("name"));
                dto.setPrice(rs.getBigDecimal("price"));
                dto.setImageUrl(rs.getString("image_url"));
                dto.setSoldCount(rs.getInt("sold"));
                list.add(dto);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Lấy sản phẩm bán chạy nhất của shop
     */
    public List<ProductDTO> getTopSellingProducts(int shopId, int limit) {
        return getShopProducts(shopId, "bestselling", 1, limit);
    }

    // =============================================
    // ===== ADMIN SHOP MANAGEMENT METHODS =====
    // =============================================

    /**
     * Tạo shop mới — trả về ID shop hoặc -1 nếu lỗi
     */
    public int createShop(String shopName, int ownerId, double rating, String location) {
        String sql = "INSERT INTO shops (owner_id, shop_name, rating, location, response_rate, response_time) "
                + "VALUES (?, ?, ?, ?, N'90%', N'trong vài giờ'); SELECT SCOPE_IDENTITY() AS newId;";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, ownerId);
            ps.setNString(2, shopName);
            ps.setDouble(3, rating);
            ps.setNString(4, location);
            boolean hasResult = ps.execute();
            if (hasResult) {
                try (ResultSet rs = ps.getResultSet()) {
                    if (rs.next()) return rs.getInt(1);
                }
            }
            if (ps.getMoreResults()) {
                try (ResultSet rs = ps.getResultSet()) {
                    if (rs.next()) return rs.getInt(1);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return -1;
    }

    /**
     * Lấy danh sách shops đơn giản (cho dropdown chọn shop trong form)
     */
    public List<Shop> getAllShopsSimple() {
        List<Shop> list = new ArrayList<>();
        String sql = "SELECT id, shop_name FROM shops ORDER BY shop_name";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Shop shop = new Shop();
                shop.setId(rs.getInt("id"));
                shop.setShopName(rs.getString("shop_name"));
                list.add(shop);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Lấy tất cả shops kèm thống kê (số SP, tổng doanh thu, số đơn hàng)
     */
    public List<Shop> getAllShopsForAdmin() {
        List<Shop> list = new ArrayList<>();
        String sql = "SELECT s.*, "
                + "u.full_name AS owner_name, "
                + "(SELECT COUNT(*) FROM products p WHERE p.shop_id = s.id AND (p.is_deleted = 0 OR p.is_deleted IS NULL)) AS product_count, "
                + "(SELECT ISNULL(SUM(oi.quantity * oi.price_at_purchase), 0) "
                + "   FROM order_items oi "
                + "   JOIN product_variants pv ON oi.variant_id = pv.id "
                + "   JOIN products p2 ON pv.product_id = p2.id "
                + "   JOIN orders o ON oi.order_id = o.id "
                + "   WHERE p2.shop_id = s.id AND o.is_deleted = 0) AS total_revenue, "
                + "(SELECT COUNT(DISTINCT o2.id) "
                + "   FROM orders o2 "
                + "   JOIN order_items oi2 ON o2.id = oi2.order_id "
                + "   JOIN product_variants pv2 ON oi2.variant_id = pv2.id "
                + "   JOIN products p3 ON pv2.product_id = p3.id "
                + "   WHERE p3.shop_id = s.id AND o2.is_deleted = 0) AS order_count "
                + "FROM shops s "
                + "LEFT JOIN users u ON s.owner_id = u.id "
                + "ORDER BY s.id";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Shop shop = new Shop();
                shop.setId(rs.getInt("id"));
                shop.setOwnerId(rs.getInt("owner_id"));
                shop.setShopName(rs.getString("shop_name"));
                shop.setRating(rs.getDouble("rating"));
                shop.setCreatedAt(rs.getTimestamp("created_at"));
                shop.setOwnerAvatar(rs.getString("avatar"));
                shop.setProductCount(rs.getInt("product_count"));
                shop.setResponseRate(rs.getString("response_rate"));
                shop.setResponseTime(rs.getString("response_time"));
                // Store extra admin fields using existing setters
                shop.setFollowerCount(rs.getInt("order_count"));
                // We'll store owner_name and revenue via transient fields
                shop.setOwnerName(rs.getString("owner_name"));
                shop.setTotalRevenue(rs.getDouble("total_revenue"));
                shop.setLocation(rs.getString("location"));
                list.add(shop);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Cập nhật thông tin shop
     */
    public boolean updateShop(int shopId, String shopName, double rating, String location) {
        String sql = "UPDATE shops SET shop_name = ?, rating = ?, location = ? WHERE id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setNString(1, shopName);
            ps.setDouble(2, rating);
            ps.setNString(3, location);
            ps.setInt(4, shopId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Lấy đơn hàng liên quan tới shop (qua products.shop_id)
     * Trả về: [orderId, customerName, email, totalPrice, status, createdAt]
     */
    public List<String[]> getShopOrders(int shopId, String statusFilter) {
        List<String[]> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT DISTINCT o.id, u.full_name, u.email, o.total_price, o.status, o.created_at "
                + "FROM orders o "
                + "JOIN users u ON o.user_id = u.id "
                + "JOIN order_items oi ON o.id = oi.order_id "
                + "JOIN product_variants pv ON oi.variant_id = pv.id "
                + "JOIN products p ON pv.product_id = p.id "
                + "WHERE p.shop_id = ? AND o.is_deleted = 0 ");

        boolean hasFilter = (statusFilter != null && !statusFilter.isEmpty() && !statusFilter.equalsIgnoreCase("ALL"));
        if (hasFilter) {
            sql.append("AND o.status = ? ");
        }
        sql.append("ORDER BY o.created_at DESC");

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            ps.setInt(1, shopId);
            if (hasFilter) {
                ps.setString(2, statusFilter);
            }
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new String[]{
                        String.valueOf(rs.getInt("id")),
                        rs.getString("full_name"),
                        rs.getString("email"),
                        String.valueOf(rs.getDouble("total_price")),
                        rs.getString("status"),
                        rs.getTimestamp("created_at").toString()
                });
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Thống kê nhanh cho 1 shop: tổng doanh thu, tổng đơn, tổng SP
     * Trả về: [totalRevenue, orderCount, productCount]
     */
    public double[] getShopStats(int shopId) {
        double[] stats = new double[3];
        String sql = "SELECT "
                + "(SELECT ISNULL(SUM(oi.quantity * oi.price_at_purchase), 0) "
                + "   FROM order_items oi "
                + "   JOIN product_variants pv ON oi.variant_id = pv.id "
                + "   JOIN products p ON pv.product_id = p.id "
                + "   JOIN orders o ON oi.order_id = o.id "
                + "   WHERE p.shop_id = ? AND o.is_deleted = 0) AS total_revenue, "
                + "(SELECT COUNT(DISTINCT o2.id) "
                + "   FROM orders o2 "
                + "   JOIN order_items oi2 ON o2.id = oi2.order_id "
                + "   JOIN product_variants pv2 ON oi2.variant_id = pv2.id "
                + "   JOIN products p2 ON pv2.product_id = p2.id "
                + "   WHERE p2.shop_id = ? AND o2.is_deleted = 0) AS order_count, "
                + "(SELECT COUNT(*) FROM products p3 WHERE p3.shop_id = ? AND (p3.is_deleted = 0 OR p3.is_deleted IS NULL)) AS product_count";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, shopId);
            ps.setInt(2, shopId);
            ps.setInt(3, shopId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                stats[0] = rs.getDouble("total_revenue");
                stats[1] = rs.getDouble("order_count");
                stats[2] = rs.getDouble("product_count");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return stats;
    }
}
