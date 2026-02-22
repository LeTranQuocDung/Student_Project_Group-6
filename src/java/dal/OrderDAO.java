package dal;

import model.Cart;
import model.CartItem;
import model.User;
import model.OrderDTO; // Nhớ check xem ông đã tạo file này chưa nhé
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class OrderDAO extends DBContext {

    // --- HÀM A: DÙNG ĐỂ KHÁCH ĐẶT HÀNG (TRANSACTION) ---
    public void addOrder(User u, Cart cart) throws Exception {
        Connection conn = null;
        PreparedStatement psOrder = null;
        PreparedStatement psDetail = null;
        PreparedStatement psUpdateStock = null;
        PreparedStatement psCheckStock = null;

        try {
            conn = getConnection();
            conn.setAutoCommit(false); // Bắt đầu giao dịch

            String sqlOrder = "INSERT INTO Orders (user_id, total_amount, created_at, note) VALUES (?, ?, ?, ?)";
            psOrder = conn.prepareStatement(sqlOrder, Statement.RETURN_GENERATED_KEYS);
            
            psOrder.setInt(1, u.getId());
            psOrder.setDouble(2, cart.getTotalMoney());
            psOrder.setTimestamp(3, new Timestamp(System.currentTimeMillis()));
            psOrder.setString(4, "Cho xu ly");
            psOrder.executeUpdate();

            ResultSet rs = psOrder.getGeneratedKeys();
            int orderId = 0;
            if (rs.next()) {
                orderId = rs.getInt(1);
            }

            String sqlDetail = "INSERT INTO OrderItems (order_id, variant_id, quantity, price_at_purchase) VALUES (?, ?, ?, ?)";
            String sqlUpdateStock = "UPDATE ProductVariants SET stock = stock - ? WHERE id = ?";

            psDetail = conn.prepareStatement(sqlDetail);
            psUpdateStock = conn.prepareStatement(sqlUpdateStock);

            for (CartItem item : cart.getItems()) {
                // Lưu chi tiết đơn hàng
                psDetail.setInt(1, orderId);
                psDetail.setInt(2, item.getProduct().getId());
                psDetail.setInt(3, item.getQuantity());
                psDetail.setDouble(4, item.getPrice());
                psDetail.executeUpdate();

                // Cập nhật kho hàng
                psUpdateStock.setInt(1, item.getQuantity());
                psUpdateStock.setInt(2, item.getProduct().getId());
                int affected = psUpdateStock.executeUpdate();
                
                if(affected == 0) {
                     throw new Exception("Lỗi cập nhật kho cho sản phẩm ID: " + item.getProduct().getId());
                }
            }
            conn.commit(); // Chốt đơn thành công
        } catch (Exception e) {
            if (conn != null) { conn.rollback(); } // Lỗi thì hủy hết
            throw e;
        } finally {
            if (conn != null) conn.close();
        }
    }

    // --- HÀM B: DÙNG ĐỂ ADMIN XEM DANH SÁCH ĐƠN HÀNG (DÁN THÊM VÀO ĐÂY) ---
    public List<OrderDTO> getAllOrders() {
        List<OrderDTO> list = new ArrayList<>();
        String sql = "SELECT o.id, u.full_name, o.total_amount, o.created_at, o.note " +
                     "FROM Orders o JOIN Users u ON o.user_id = u.id ORDER BY o.id DESC";
        try (Connection conn = getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new OrderDTO(
                    rs.getInt("id"),
                    rs.getString("full_name"),
                    rs.getDouble("total_amount"),
                    rs.getTimestamp("created_at"),
                    rs.getString("note")
                ));
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }
}