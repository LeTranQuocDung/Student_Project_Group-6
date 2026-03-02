package dal;

import model.Product;
import model.ProductDTO;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class ProductDAO extends DBContext {

    private static final int PAGE_SIZE = 30;

    // Overload cho các trang chỉ search bằng keyword (ví dụ HomeServlet)
    public List<ProductDTO> searchProducts(String txtSearch) {
        return searchProducts(txtSearch, null, null, null, null, null, null, 1);
    }

    // Overload cũ (6 params) để không break code cũ
    public List<ProductDTO> searchProducts(String txtSearch, String[] cateIds, String[] locations, String minPriceStr,
            String maxPriceStr, String ratingStr) {
        return searchProducts(txtSearch, cateIds, locations, minPriceStr, maxPriceStr, ratingStr, null, 1);
    }

    // ===== Helper: build WHERE + HAVING clause chung cho search và count =====
    private void buildFilterClauses(StringBuilder sql, List<Object> parameters,
            String txtSearch, String[] cateIds, String[] locations,
            String minPriceStr, String maxPriceStr, String ratingStr) {

        if (txtSearch != null && !txtSearch.isEmpty()) {
            sql.append("AND p.name LIKE ? ");
            parameters.add("%" + txtSearch + "%");
        }

        if (cateIds != null && cateIds.length > 0) {
            sql.append("AND (p.id % 20 + 1) IN (");
            for (int i = 0; i < cateIds.length; i++) {
                sql.append("?");
                if (i < cateIds.length - 1)
                    sql.append(",");
                parameters.add(Integer.parseInt(cateIds[i]));
            }
            sql.append(") ");
        }

        if (locations != null && locations.length > 0) {
            sql.append("AND (");
            boolean firstLoc = true;
            for (String loc : locations) {
                if (!firstLoc)
                    sql.append(" OR ");
                if ("hcm".equals(loc))
                    sql.append("p.id % 3 NOT IN (0, 2)");
                else if ("hn".equals(loc))
                    sql.append("p.id % 2 = 0");
                else if ("dn".equals(loc))
                    sql.append("p.id % 3 = 0");
                firstLoc = false;
            }
            sql.append(") ");
        }

        if (ratingStr != null && !ratingStr.isEmpty()) {
            sql.append("AND s.rating >= ? ");
            parameters.add(new java.math.BigDecimal(ratingStr));
        }
    }

    private void buildHavingClause(StringBuilder sql, List<Object> parameters,
            String minPriceStr, String maxPriceStr) {
        boolean hasMinPrice = minPriceStr != null && !minPriceStr.trim().isEmpty();
        boolean hasMaxPrice = maxPriceStr != null && !maxPriceStr.trim().isEmpty();
        if (hasMinPrice || hasMaxPrice) {
            sql.append("HAVING 1=1 ");
            if (hasMinPrice) {
                sql.append("AND MIN(v.price) >= ? ");
                parameters.add(new java.math.BigDecimal(minPriceStr));
            }
            if (hasMaxPrice) {
                sql.append("AND MIN(v.price) <= ? ");
                parameters.add(new java.math.BigDecimal(maxPriceStr));
            }
        }
    }

    // ===== Đếm tổng sản phẩm (cho phân trang) =====
    public int countSearchProducts(String txtSearch, String[] cateIds, String[] locations,
            String minPriceStr, String maxPriceStr, String ratingStr) {
        StringBuilder sql = new StringBuilder(
                "SELECT COUNT(*) as total FROM ("
                        + "SELECT p.id, MIN(v.price) as min_price "
                        + "FROM products p "
                        + "JOIN shops s ON p.shop_id = s.id "
                        + "JOIN product_variants v ON p.id = v.product_id "
                        + "WHERE 1=1 ");

        List<Object> parameters = new ArrayList<>();
        buildFilterClauses(sql, parameters, txtSearch, cateIds, locations, minPriceStr, maxPriceStr, ratingStr);
        sql.append("GROUP BY p.id ");
        buildHavingClause(sql, parameters, minPriceStr, maxPriceStr);
        sql.append(") as cnt");

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < parameters.size(); i++) {
                ps.setObject(i + 1, parameters.get(i));
            }
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("total");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int getPageSize() {
        return PAGE_SIZE;
    }

    // 1. Search với bộ lọc + sắp xếp + phân trang
    public List<ProductDTO> searchProducts(String txtSearch, String[] cateIds, String[] locations, String minPriceStr,
            String maxPriceStr, String ratingStr, String sortBy, int page) {
        List<ProductDTO> list = new ArrayList<>();

        // Xử lý sort cần thêm cột sold_count cho "bestselling"
        boolean needSold = "bestselling".equals(sortBy);

        StringBuilder sql = new StringBuilder(
                "SELECT p.id, p.name, s.shop_name, MIN(v.price) as min_price, p.image_url ");

        if (needSold) {
            sql.append(", COALESCE(SUM(oi.quantity), 0) as sold_count ");
        }

        sql.append("FROM products p "
                + "JOIN shops s ON p.shop_id = s.id "
                + "JOIN product_variants v ON p.id = v.product_id ");

        if (needSold) {
            sql.append("LEFT JOIN order_items oi ON v.id = oi.variant_id ");
        }

        sql.append("WHERE 1=1 ");

        List<Object> parameters = new ArrayList<>();
        buildFilterClauses(sql, parameters, txtSearch, cateIds, locations, minPriceStr, maxPriceStr, ratingStr);

        sql.append("GROUP BY p.id, p.name, s.shop_name, p.image_url ");

        buildHavingClause(sql, parameters, minPriceStr, maxPriceStr);

        // ORDER BY dựa trên sortBy
        if ("newest".equals(sortBy)) {
            sql.append("ORDER BY p.id DESC "); // id lớn = mới nhất
        } else if ("bestselling".equals(sortBy)) {
            sql.append("ORDER BY sold_count DESC, p.id DESC ");
        } else if ("price_asc".equals(sortBy)) {
            sql.append("ORDER BY min_price ASC ");
        } else if ("price_desc".equals(sortBy)) {
            sql.append("ORDER BY min_price DESC ");
        } else {
            // "popular" hoặc mặc định → Liên quan (theo keyword match + id)
            sql.append("ORDER BY p.id DESC ");
        }

        // Phân trang bằng OFFSET / FETCH NEXT (SQL Server 2012+)
        if (page < 1)
            page = 1;
        int offset = (page - 1) * PAGE_SIZE;
        sql.append("OFFSET ? ROWS FETCH NEXT ? ROWS ONLY ");
        parameters.add(offset);
        parameters.add(PAGE_SIZE);

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < parameters.size(); i++) {
                ps.setObject(i + 1, parameters.get(i));
            }

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new ProductDTO(
                        rs.getInt("id"),
                        rs.getString("name"),
                        rs.getString("shop_name"),
                        rs.getBigDecimal("min_price"),
                        rs.getString("image_url")));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // 2. Get Detail (Trả về Product Full)
    public Product getProductById(int id) {
        String sql = "SELECT * FROM products WHERE id = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new Product(
                        rs.getInt("id"),
                        rs.getInt("shop_id"),
                        rs.getString("name"),
                        rs.getString("description"),
                        rs.getBigDecimal("price"),
                        rs.getString("image_url"),
                        rs.getTimestamp("created_at"));
            }
        } catch (Exception e) {
        }
        return null;
    }

    // 3. Get Images (Do Lab không có bảng hình phụ, mượn tạm hàm này hoặc disable)
    public List<String> getProductImages(int productId) {
        List<String> list = new ArrayList<>();
        // Trong DB mô phỏng hiện tại không có bảng ProductImages, chỉ có hình chính,
        // hàm này có thể cho return []
        return list;
    }

    // 4. Insert (Admin)
    public void insertProduct(String name, java.math.BigDecimal price, String img) {
        String sql = "INSERT INTO products (shop_id, name, description, price, image_url) VALUES (1, ?, 'Mô tả', ?, ?)";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, name);
            ps.setBigDecimal(2, price);
            ps.setString(3, img);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // 5. Delete (Admin)
    public void deleteProduct(String id) {
        try (Connection conn = getConnection()) {
            conn.prepareStatement("DELETE FROM product_variants WHERE product_id=" + id).executeUpdate();
            conn.prepareStatement("DELETE FROM products WHERE id=" + id).executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // 6. Update (Admin)
    public void updateProduct(int id, String name, java.math.BigDecimal price, String img) {
        String sql = "UPDATE products SET name = ?, price = ?, image_url = ? WHERE id = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, name);
            ps.setBigDecimal(2, price);
            ps.setString(3, img);
            ps.setInt(4, id);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // 7. Get All Products (Admin)
    public List<Product> getAllProducts() {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT * FROM products ORDER BY id DESC";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new Product(
                        rs.getInt("id"),
                        rs.getInt("shop_id"),
                        rs.getString("name"),
                        rs.getString("description"),
                        rs.getBigDecimal("price"),
                        rs.getString("image_url"),
                        rs.getTimestamp("created_at")));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // 8. Get Sold Count for a product (from order_items via product_variants)
    public int getSoldCount(int productId) {
        String sql = "SELECT COALESCE(SUM(oi.quantity), 0) as sold " +
                "FROM order_items oi " +
                "JOIN product_variants pv ON oi.variant_id = pv.id " +
                "WHERE pv.product_id = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, productId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("sold");
            }
        } catch (Exception e) {
            // Table might not exist yet, return 0
        }
        return 0;
    }

    // 9. Get Total Stock for a product (sum of all variants)
    public int getTotalStock(int productId) {
        String sql = "SELECT COALESCE(SUM(stock), 0) as total_stock " +
                "FROM product_variants WHERE product_id = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, productId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("total_stock");
            }
        } catch (Exception e) {
            // Table might not exist yet, return 0
        }
        return 0;
    }
}
