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

    // ===== ADMIN ORDER MANAGEMENT =====

    // Lấy tất cả đơn hàng (kèm tên khách hàng)
    public List<String[]> getAllOrders() {
        List<String[]> list = new ArrayList<>();
        String sql = "SELECT o.id, u.full_name, u.email, o.total_price, o.status, o.created_at "
                + "FROM orders o JOIN users u ON o.user_id = u.id "
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
}