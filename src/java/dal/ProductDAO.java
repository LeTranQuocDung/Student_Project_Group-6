package dal;

import model.Product;
import model.ProductDTO;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class ProductDAO extends DBContext {

    // 1. Search cho Home (Trả về DTO)
    public List<ProductDTO> searchProducts(String txtSearch) {
        List<ProductDTO> list = new ArrayList<>();
        String sql = "SELECT TOP 60 p.id, p.name, s.shop_name, MIN(v.price) as min_price, p.image_url "
                + "FROM Products p "
                + "JOIN Shops s ON p.shop_id = s.id "
                + "JOIN ProductVariants v ON p.id = v.product_id ";

        if (txtSearch != null && !txtSearch.isEmpty()) {
            sql += "WHERE p.name LIKE ? ";
        }

        sql += "GROUP BY p.id, p.name, s.shop_name, p.image_url ORDER BY p.id DESC";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            if (txtSearch != null && !txtSearch.isEmpty()) {
                ps.setString(1, "%" + txtSearch + "%");
            }
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new ProductDTO(
                        rs.getInt("id"),
                        rs.getString("name"),
                        rs.getString("shop_name"),
                        rs.getDouble("min_price"),
                        rs.getString("image_url")
                ));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // 2. Get Detail (Trả về Product Full)
    public Product getProductById(int id) {
        String sql = "SELECT * FROM Products WHERE id = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new Product(
                        rs.getInt("id"),
                        rs.getInt("shop_id"),
                        rs.getString("name"),
                        rs.getString("description"),
                        rs.getDouble("price"),
                        rs.getString("image_url")
                );
            }
        } catch (Exception e) {
        }
        return null;
    }

    // 3. Get Images
    public List<String> getProductImages(int productId) {
        List<String> list = new ArrayList<>();
        String sql = "SELECT image_url FROM ProductImages WHERE product_id = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, productId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(rs.getString("image_url"));
            }
        } catch (Exception e) {
        }
        return list;
    }

    // 4. Insert (Admin)
    public void insertProduct(String name, double price, String img) {
        String sql = "INSERT INTO Products (shop_id, name, description, price, image_url) VALUES (1, ?, N'Mô tả', ?, ?)";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, name);
            ps.setDouble(2, price);
            ps.setString(3, img);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // 5. Delete
    public void deleteProduct(String id) {
        try (Connection conn = getConnection()) {
            conn.prepareStatement("DELETE FROM ProductImages WHERE product_id=" + id).executeUpdate();
            conn.prepareStatement("DELETE FROM ProductVariants WHERE product_id=" + id).executeUpdate();
            conn.prepareStatement("DELETE FROM Products WHERE id=" + id).executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
