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

    public void addOrderTransaction(User u, Cart cart) throws Exception {
        Connection conn = null;
        try {
            conn = getConnection();
        
            conn.setAutoCommit(false);

            String sqlOrder = "INSERT INTO Orders (user_id, total_amount, created_at, note) VALUES (?, ?, ?, ?)";
            PreparedStatement psOrder = conn.prepareStatement(sqlOrder, Statement.RETURN_GENERATED_KEYS);
            psOrder.setInt(1, u.getId());
            psOrder.setDouble(2, cart.getTotalMoney());
            psOrder.setTimestamp(3, new Timestamp(System.currentTimeMillis()));
            psOrder.setString(4, "Don hang tu Simulator");
            psOrder.executeUpdate();

            ResultSet rs = psOrder.getGeneratedKeys();
            int orderId = 0;
            if (rs.next()) {
                orderId = rs.getInt(1);
            }

         
            String sqlDetail = "INSERT INTO OrderItems (order_id, variant_id, quantity, price_at_purchase) VALUES (?, ?, ?, ?)";
            String sqlUpdateStock = "UPDATE ProductVariants SET stock = stock - ? WHERE id = ? AND stock >= ?";

            PreparedStatement psDetail = conn.prepareStatement(sqlDetail);
            PreparedStatement psUpdateStock = conn.prepareStatement(sqlUpdateStock);

            for (CartItem item : cart.getItems()) {
                psDetail.setInt(1, orderId);
                psDetail.setInt(2, item.getProduct().getId());
                psDetail.setInt(3, item.getQuantity());
                psDetail.setDouble(4, item.getPrice());
                psDetail.executeUpdate();

                psUpdateStock.setInt(1, item.getQuantity());
                psUpdateStock.setInt(2, item.getProduct().getId());
                psUpdateStock.setInt(3, item.getQuantity()); 
                int affected = psUpdateStock.executeUpdate();

                if (affected == 0) {
                  
                    throw new Exception("San pham ID " + item.getProduct().getId() + " da het hang!");
                }
            }

       
            String sqlWallet = "UPDATE Users SET wallet = wallet - ? WHERE id = ? AND wallet >= ?";
            PreparedStatement psWallet = conn.prepareStatement(sqlWallet);
            psWallet.setDouble(1, cart.getTotalMoney());
            psWallet.setInt(2, u.getId());
            psWallet.setDouble(3, cart.getTotalMoney());
            int walletAffected = psWallet.executeUpdate();

            if (walletAffected == 0) {
                throw new Exception("Vi cua ban khong du tien!");
            }

            conn.commit();

        } catch (Exception e) {
          
            if (conn != null) {
                conn.rollback();
            }
            throw new Exception(e.getMessage());
        } finally {
            if (conn != null) {
                conn.setAutoCommit(true);
                conn.close();
            }
        }
    }
}
