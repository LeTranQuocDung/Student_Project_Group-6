package dal;

import model.Cart;
import model.CartItem;
import model.User;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class OrderDAO extends DBContext {

    public void addOrder(User u, Cart cart) throws Exception {
        Connection conn = null;
        PreparedStatement psOrder = null;
        PreparedStatement psDetail = null;
        PreparedStatement psUpdateStock = null;
        PreparedStatement psCheckStock = null;

        try {
            conn = getConnection();

            // 1. TẮT CHẾ ĐỘ TỰ ĐỘNG LƯU (Bắt đầu Transaction)
            conn.setAutoCommit(false);

            // -----------------------------------------------------------
            // BƯỚC A: TẠO ĐƠN HÀNG (Bảng Orders)
            // -----------------------------------------------------------
            String sqlOrder = "INSERT INTO orders (user_id, total_price, created_at, status) VALUES (?, ?, ?, 'PENDING')";
            // Cần lấy ra ID của đơn hàng vừa tạo để dùng cho bảng OrderItems
            psOrder = conn.prepareStatement(sqlOrder, Statement.RETURN_GENERATED_KEYS);

            psOrder.setInt(1, u.getId());
            psOrder.setBigDecimal(2, cart.getTotalMoney());
            psOrder.setTimestamp(3, new Timestamp(System.currentTimeMillis()));
            psOrder.executeUpdate();

            // Lấy ID đơn hàng vừa sinh ra
            ResultSet rs = psOrder.getGeneratedKeys();
            int orderId = 0;
            if (rs.next()) {
                orderId = rs.getInt(1);
            }

            // -----------------------------------------------------------
            // BƯỚC B: DUYỆT GIỎ HÀNG ĐỂ XỬ LÝ TỪNG MÓN
            // -----------------------------------------------------------
            String sqlDetail = "INSERT INTO order_items (order_id, variant_id, quantity, price_at_purchase) VALUES (?, ?, ?, ?)";
            // Kiểm tra stock theo product_id (vì CartItem chứa Product, không phải Variant)
            String sqlCheckStock = "SELECT TOP 1 id as variant_id, stock FROM product_variants WHERE product_id = ? ORDER BY stock DESC";
            // UPDATE trừ stock theo variant_id cụ thể, kèm điều kiện WHERE stock >= ? để chống RACE CONDITION
            String sqlUpdateStock = "UPDATE product_variants SET stock = stock - ? WHERE id = ? AND stock >= ?";

            psDetail = conn.prepareStatement(sqlDetail);
            psCheckStock = conn.prepareStatement(sqlCheckStock);
            psUpdateStock = conn.prepareStatement(sqlUpdateStock);

            for (CartItem item : cart.getItems()) {
                int productId = item.getProduct().getId();
                int qtyToBuy = item.getQuantity();

                // 1. Kiểm tra tồn kho hiện tại và lấy variant_id thực tế
                int actualVariantId = 0;
                psCheckStock.setInt(1, productId);
                try (ResultSet rsStock = psCheckStock.executeQuery()) {
                    if (rsStock.next()) {
                        actualVariantId = rsStock.getInt("variant_id");
                        int currentStock = rsStock.getInt("stock");
                        if (currentStock < qtyToBuy) {
                            throw new Exception("Sản phẩm '" + item.getProduct().getName()
                                    + "' không đủ số lượng trong kho (Còn lại: " + currentStock + ")");
                        }
                    } else {
                        throw new Exception(
                                "Không tìm thấy dữ liệu tồn kho cho sản phẩm: " + item.getProduct().getName());
                    }
                }

                // 2. Thực hiện trừ kho theo variant_id cụ thể
                psUpdateStock.setInt(1, qtyToBuy);
                psUpdateStock.setInt(2, actualVariantId);
                psUpdateStock.setInt(3, qtyToBuy);
                int affected = psUpdateStock.executeUpdate();

                if (affected == 0) {
                    throw new Exception("Sản phẩm '" + item.getProduct().getName()
                            + "' vừa được người khác mua khiến tạm thời hết hàng. Vui lòng thanh toán lại.");
                }

                // 3. Lưu vào OrderItems với variant_id thực tế
                psDetail.setInt(1, orderId);
                psDetail.setInt(2, actualVariantId);
                psDetail.setInt(3, qtyToBuy);
                psDetail.setBigDecimal(4, item.getPrice());
                psDetail.executeUpdate();
            }


            // -----------------------------------------------------------
            // BƯỚC C: CHỐT ĐƠN (COMMIT)
            // -----------------------------------------------------------
            // Nếu chạy đến đây mà không lỗi gì -> Lưu tất cả vào DB
            conn.commit();

        } catch (Exception e) {
            // -----------------------------------------------------------
            // BƯỚC D: CÓ LỖI -> HỦY TOÀN BỘ (ROLLBACK)
            // -----------------------------------------------------------
            if (conn != null) {
                try {
                    conn.rollback(); // Quay ngược thời gian về lúc chưa mua
                } catch (Exception ex) {
                    ex.printStackTrace();
                }
            }
            e.printStackTrace();
            throw new Exception("Giao dịch thất bại: " + e.getMessage());

        } finally {
            // Đóng kết nối
            if (psOrder != null)
                psOrder.close();
            if (psDetail != null)
                psDetail.close();
            if (conn != null)
                conn.close();
        }
    }

    // ===== USER ORDER QUERIES =====

    // Lấy đơn hàng của user theo status (cho trang Đơn Mua)
    public List<String[]> getOrdersByUserId(int userId, String statusFilter) {
        List<String[]> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT o.id, o.total_price, o.status, o.created_at "
                + "FROM orders o "
                + "WHERE o.user_id = ? AND o.is_deleted = 0 ");

        boolean hasFilter = (statusFilter != null && !statusFilter.isEmpty() && !statusFilter.equalsIgnoreCase("ALL"));
        if (hasFilter) {
            sql.append("AND o.status = ? ");
        }
        sql.append("ORDER BY o.created_at DESC");

        try (Connection conn = getConnection();
                PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            ps.setInt(1, userId);
            if (hasFilter) {
                ps.setString(2, statusFilter);
            }
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new String[] {
                        String.valueOf(rs.getInt("id")),
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

    // Lấy chi tiết items của 1 đơn hàng
    public List<String[]> getOrderItems(int orderId) {
        List<String[]> list = new ArrayList<>();
        String sql = "SELECT oi.quantity, oi.price_at_purchase, p.name, p.image_url, p.id " +
                     "FROM order_items oi " +
                     "JOIN product_variants pv ON oi.variant_id = pv.id " +
                     "JOIN products p ON pv.product_id = p.id " +
                     "WHERE oi.order_id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new String[] {
                    rs.getString("name"),
                    rs.getString("image_url"),
                    String.valueOf(rs.getInt("quantity")),
                    String.valueOf(rs.getDouble("price_at_purchase")),
                    String.valueOf(rs.getInt("id"))
                });
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // ===== ADMIN ORDER MANAGEMENT =====

    // Lấy tất cả đơn hàng (kèm tên khách hàng) có filter trạng thái
    public List<String[]> getAllOrders(String statusFilter) {
        List<String[]> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT o.id, u.full_name, u.email, o.total_price, o.status, o.created_at "
                + "FROM orders o JOIN users u ON o.user_id = u.id "
                + "WHERE o.is_deleted = 0 ");
        
        boolean hasFilter = (statusFilter != null && !statusFilter.isEmpty() && !statusFilter.equalsIgnoreCase("ALL"));
        if (hasFilter) {
            sql.append("AND o.status = ? ");
        }
        sql.append("ORDER BY o.created_at DESC");
        
        try (Connection conn = getConnection();
                PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            if (hasFilter) {
                ps.setString(1, statusFilter);
            }
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new String[] {
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

    // Cập nhật trạng thái đơn hàng
    public void updateOrderStatus(int orderId, String newStatus) {
        String sql = "UPDATE orders SET status = ? WHERE id = ?";
        try (Connection conn = getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, newStatus);
            ps.setInt(2, orderId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Lấy N đơn hàng gần nhất (cho Dashboard)
    public List<String[]> getRecentOrders(int limit) {
        List<String[]> list = new ArrayList<>();
        String sql = "SELECT TOP " + limit + " o.id, u.full_name, o.total_price, o.status, o.created_at "
                + "FROM orders o JOIN users u ON o.user_id = u.id "
                + "WHERE o.is_deleted = 0 "
                + "ORDER BY o.created_at DESC";
        try (Connection conn = getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new String[] {
                        String.valueOf(rs.getInt("id")),
                        rs.getString("full_name"),
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

    // Xóa đơn hàng (Soft Delete)
    public void deleteOrder(int orderId) {
        String sql = "UPDATE orders SET is_deleted = 1 WHERE id = ?";
        try (Connection conn = getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Lấy danh sách đơn hàng đã xóa (Thùng rác)
    public List<String[]> getDeletedOrders() {
        List<String[]> list = new ArrayList<>();
        String sql = "SELECT o.id, u.full_name, u.email, o.total_price, o.status, o.created_at "
                + "FROM orders o JOIN users u ON o.user_id = u.id "
                + "WHERE o.is_deleted = 1 "
                + "ORDER BY o.created_at DESC";
        
        try (Connection conn = getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new String[] {
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

    // Khôi phục đơn hàng
    public void restoreOrder(int orderId) {
        String sql = "UPDATE orders SET is_deleted = 0 WHERE id = ?";
        try (Connection conn = getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
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

    public void bulkUpdateOrderStatus(String[] ids, String newStatus) {
        if (ids == null || ids.length == 0 || newStatus == null) return;
        String sql = "UPDATE orders SET status = ? WHERE id IN " + buildInClause(ids.length);
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, newStatus);
            for (int i = 0; i < ids.length; i++) {
                ps.setInt(i + 2, Integer.parseInt(ids[i]));
            }
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void bulkDeleteOrders(String[] ids) {
        if (ids == null || ids.length == 0) return;
        String sql = "UPDATE orders SET is_deleted = 1 WHERE id IN " + buildInClause(ids.length);
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            for (int i = 0; i < ids.length; i++) {
                ps.setInt(i + 1, Integer.parseInt(ids[i]));
            }
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void bulkRestoreOrders(String[] ids) {
        if (ids == null || ids.length == 0) return;
        String sql = "UPDATE orders SET is_deleted = 0 WHERE id IN " + buildInClause(ids.length);
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            for (int i = 0; i < ids.length; i++) {
                ps.setInt(i + 1, Integer.parseInt(ids[i]));
            }
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void bulkDeletePermanentOrders(String[] ids) {
        if (ids == null || ids.length == 0) return;
        
        Connection conn = null;
        PreparedStatement psItems = null;
        PreparedStatement psOrders = null;
        
        try {
            conn = getConnection();
            conn.setAutoCommit(false);
            
            // Xóa cascade Order_Items trước
            String sqlItems = "DELETE FROM order_items WHERE order_id IN " + buildInClause(ids.length);
            psItems = conn.prepareStatement(sqlItems);
            for (int i = 0; i < ids.length; i++) {
                psItems.setInt(i + 1, Integer.parseInt(ids[i]));
            }
            psItems.executeUpdate();
            
            // Xóa ở bảng Orders
            String sqlOrders = "DELETE FROM orders WHERE id IN " + buildInClause(ids.length);
            psOrders = conn.prepareStatement(sqlOrders);
            for (int i = 0; i < ids.length; i++) {
                psOrders.setInt(i + 1, Integer.parseInt(ids[i]));
            }
            psOrders.executeUpdate();
            
            conn.commit();
        } catch (Exception e) {
            if(conn != null) {
                try { conn.rollback(); } catch(Exception ex) {}
            }
            e.printStackTrace();
        } finally {
            try {
                if(psItems != null) psItems.close();
                if(psOrders != null) psOrders.close();
                if(conn != null) {
                    conn.setAutoCommit(true);
                    conn.close();
                }
            } catch(Exception ex) {}
        }
    }
    // --- END BULK ACTIONS ---

    /**
     * Kiểm tra user đã có đơn hàng COMPLETED chứa sản phẩm này chưa.
     * Dùng để xác minh quyền viết đánh giá.
     */
    public boolean hasCompletedOrder(int userId, int productId) {
        String sql = "SELECT COUNT(*) FROM orders o "
                + "JOIN order_items oi ON o.id = oi.order_id "
                + "JOIN product_variants pv ON oi.variant_id = pv.id "
                + "WHERE o.user_id = ? AND pv.product_id = ? AND o.status = 'COMPLETED' AND o.is_deleted = 0";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, productId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Xác nhận người dùng đã nhận hàng: DELIVERING → COMPLETED.
     * Chỉ update nếu đơn hàng thuộc user và đang ở trạng thái DELIVERING.
     */
    public void confirmReceived(int userId, int orderId) {
        String sql = "UPDATE orders SET status = 'COMPLETED' WHERE id = ? AND user_id = ? AND status = 'DELIVERING' AND is_deleted = 0";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            ps.setInt(2, userId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}