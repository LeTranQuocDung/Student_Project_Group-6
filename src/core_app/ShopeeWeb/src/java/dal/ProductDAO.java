package dal;

import model.ProductDTO;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class ProductDAO extends DBContext {

    // 1. Lấy danh sách hiển thị Home (Trả về DTO)
    public List<ProductDTO> searchProducts(String txtSearch) {
        List<ProductDTO> list = new ArrayList<>();
        String sql = "SELECT TOP 60 p.id, p.name, s.shop_name, MIN(v.price) as min_price " +
                     "FROM Products p " +
                     "JOIN Shops s ON p.shop_id = s.id " +
                     "JOIN ProductVariants v ON p.id = v.product_id ";
        
        if (txtSearch != null && !txtSearch.trim().isEmpty()) {
            sql += "WHERE p.name LIKE ? ";
        }
        sql += "GROUP BY p.id, p.name, s.shop_name ORDER BY p.id DESC";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            if (txtSearch != null && !txtSearch.trim().isEmpty()) {
                ps.setString(1, "%" + txtSearch + "%");
            }
            
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new ProductDTO(
                    rs.getInt("id"),
                    rs.getString("name"),
                    rs.getString("shop_name"),
                    rs.getDouble("min_price")
                ));
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    // 2. Xóa sản phẩm (Phải xóa Variant trước)
    public void deleteProduct(String id) {
        String sql1 = "DELETE FROM ProductVariants WHERE product_id = ?";
        String sql2 = "DELETE FROM Products WHERE id = ?";
        
        try (Connection conn = getConnection()) {
            // Xóa con (Variant)
            PreparedStatement ps1 = conn.prepareStatement(sql1);
            ps1.setString(1, id);
            ps1.executeUpdate();
            
            // Xóa cha (Product)
            PreparedStatement ps2 = conn.prepareStatement(sql2);
            ps2.setString(1, id);
            ps2.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
    }

    // 3. Thêm sản phẩm mới
    public void insertProduct(String name, String desc) {
        String sql = "INSERT INTO Products (shop_id, name, description) VALUES (1, ?, ?)";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, name);
            ps.setString(2, desc);
            ps.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
    }
}