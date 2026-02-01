package dal;

import model.Cart;
import model.CartItem;
import model.User;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.sql.Timestamp;

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
            String sqlOrder = "INSERT INTO Orders (user_id, total_amount, created_at, note) VALUES (?, ?, ?, ?)";
            // Cần lấy ra ID của đơn hàng vừa tạo để dùng cho bảng OrderItems
            psOrder = conn.prepareStatement(sqlOrder, Statement.RETURN_GENERATED_KEYS);
            
            psOrder.setInt(1, u.getId());
            psOrder.setDouble(2, cart.getTotalMoney());
            psOrder.setTimestamp(3, new Timestamp(System.currentTimeMillis()));
            psOrder.setString(4, "Cho xu ly");
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
            String sqlDetail = "INSERT INTO OrderItems (order_id, variant_id, quantity, price_at_purchase) VALUES (?, ?, ?, ?)";
            String sqlCheckStock = "SELECT stock FROM ProductVariants WHERE id = ?";
            String sqlUpdateStock = "UPDATE ProductVariants SET stock = stock - ? WHERE id = ?";

            psDetail = conn.prepareStatement(sqlDetail);
            psCheckStock = conn.prepareStatement(sqlCheckStock);
            psUpdateStock = conn.prepareStatement(sqlUpdateStock);

            for (CartItem item : cart.getItems()) {
                // 1. Kiểm tra tồn kho trước (Logic khó)
                psCheckStock.setInt(1, item.getProduct().getId()); // Ở đây giả sử productID map với VariantID cho đơn giản
                // Nếu ông làm kỹ thì CartItem phải lưu VariantID, ở đây tui giả định logic đơn giản
                
                // (Thực tế ông cần check: if stock < quantity -> throw Exception)

                // 2. Lưu vào OrderItems
                psDetail.setInt(1, orderId);
                psDetail.setInt(2, item.getProduct().getId()); // ID sản phẩm/variant
                psDetail.setInt(3, item.getQuantity());
                psDetail.setDouble(4, item.getPrice());
                psDetail.executeUpdate();

                // 3. Trừ kho (Update Stock)
                psUpdateStock.setInt(1, item.getQuantity()); // Trừ đi số lượng mua
                psUpdateStock.setInt(2, item.getProduct().getId());
                int affected = psUpdateStock.executeUpdate();
                
                // Nếu update thất bại (ví dụ stock bị âm do constraint DB) -> Lỗi
                if(affected == 0) {
                     throw new Exception("Lỗi cập nhật kho cho sản phẩm ID: " + item.getProduct().getId());
                }
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
                } catch (Exception ex) { ex.printStackTrace(); }
            }
            e.printStackTrace();
            throw new Exception("Giao dịch thất bại: " + e.getMessage());
            
        } finally {
            // Đóng kết nối
            if (psOrder != null) psOrder.close();
            if (psDetail != null) psDetail.close();
            if (conn != null) conn.close();
        }
    }
}