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

    /**
     * Query NHẸ cho trang chủ — KHÔNG JOIN order_items (tránh SUM chậm).
     * Chỉ lấy 30 sản phẩm mới nhất với giá thấp nhất.
     */
    public List<ProductDTO> getHomeProducts() {
        List<ProductDTO> list = new ArrayList<>();
        String sql = "SELECT TOP 30 p.id, p.name, s.shop_name, " +
                "(SELECT MIN(v.price) FROM product_variants v WHERE v.product_id = p.id) as min_price, " +
                "p.image_url, 0 as sold_count, s.rating, s.location, p.category_id " +
                "FROM products p " +
                "JOIN shops s ON p.shop_id = s.id " +
                "WHERE p.is_deleted = 0 " +
                "ORDER BY p.id DESC";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                ProductDTO dto = new ProductDTO(
                        rs.getInt("id"),
                        rs.getString("name"),
                        rs.getString("shop_name"),
                        rs.getBigDecimal("min_price"),
                        rs.getString("image_url"));
                dto.setSoldCount(rs.getInt("sold_count"));
                dto.setRating(rs.getDouble("rating"));
                dto.setLocation(rs.getString("location"));
                dto.setCategoryId(rs.getInt("category_id"));
                list.add(dto);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

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
            sql.append("AND p.category_id IN (");
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
            for (int i = 0; i < locations.length; i++) {
                if (i > 0) sql.append(" OR ");
                sql.append("s.location LIKE ?");
                parameters.add("%" + locations[i] + "%");
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
                        + "WHERE p.is_deleted = 0 ");

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

        StringBuilder sql = new StringBuilder(
                "SELECT p.id, p.name, s.shop_name, MIN(v.price) as min_price, p.image_url, "
                + "COALESCE(SUM(oi.quantity), 0) as sold_count, "
                + "s.rating, s.location, p.category_id ");

        sql.append("FROM products p "
                + "JOIN shops s ON p.shop_id = s.id "
                + "JOIN product_variants v ON p.id = v.product_id "
                + "LEFT JOIN order_items oi ON v.id = oi.variant_id ");

        sql.append("WHERE p.is_deleted = 0 ");

        List<Object> parameters = new ArrayList<>();
        buildFilterClauses(sql, parameters, txtSearch, cateIds, locations, minPriceStr, maxPriceStr, ratingStr);

        sql.append("GROUP BY p.id, p.name, s.shop_name, p.image_url, s.rating, s.location, p.category_id ");

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
            // "popular" hoặc mặc định → Liên quan: ưu tiên sản phẩm khớp keyword + bán chạy
            if (txtSearch != null && !txtSearch.trim().isEmpty()) {
                sql.append("ORDER BY CASE WHEN p.name LIKE ? THEN 0 ELSE 1 END, sold_count DESC, p.id DESC ");
                parameters.add(txtSearch.trim() + "%"); // Ưu tiên tên bắt đầu bằng keyword
            } else {
                sql.append("ORDER BY sold_count DESC, p.id DESC ");
            }
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
                ProductDTO dto = new ProductDTO(
                        rs.getInt("id"),
                        rs.getString("name"),
                        rs.getString("shop_name"),
                        rs.getBigDecimal("min_price"),
                        rs.getString("image_url"));
                dto.setSoldCount(rs.getInt("sold_count"));
                dto.setRating(rs.getDouble("rating"));
                dto.setLocation(rs.getString("location"));
                dto.setCategoryId(rs.getInt("category_id"));
                list.add(dto);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // 2. Get Detail (Trả về Product Full)
    public Product getProductById(int id) {
        String sql = "SELECT * FROM products WHERE id = ? AND is_deleted = 0";
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
    // 3b. Get products by shop (Admin shop detail — phân trang + tìm kiếm)
    public List<Product> getProductsByShopId(int shopId, String search, int page) {
        List<Product> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT p.*, s.shop_name FROM products p LEFT JOIN shops s ON p.shop_id = s.id "
            + "WHERE p.shop_id = ? AND (p.is_deleted = 0 OR p.is_deleted IS NULL) ");
        List<Object> params = new ArrayList<>();
        params.add(shopId);

        if (search != null && !search.isEmpty()) {
            sql.append("AND p.name LIKE ? ");
            params.add("%" + search + "%");
        }
        sql.append("ORDER BY p.id DESC ");

        if (page < 1) page = 1;
        int offset = (page - 1) * PAGE_SIZE;
        sql.append("OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
        params.add(offset);
        params.add(PAGE_SIZE);

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Product p = new Product(
                    rs.getInt("id"), rs.getInt("shop_id"),
                    rs.getString("name"), rs.getString("description"),
                    rs.getBigDecimal("price"), rs.getString("image_url"),
                    rs.getTimestamp("created_at"), rs.getInt("category_id"));
                p.setShopName(rs.getString("shop_name"));
                list.add(p);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public int countProductsByShopId(int shopId, String search) {
        StringBuilder sql = new StringBuilder(
            "SELECT COUNT(*) FROM products WHERE shop_id = ? AND (is_deleted = 0 OR is_deleted IS NULL) ");
        List<Object> params = new ArrayList<>();
        params.add(shopId);
        if (search != null && !search.isEmpty()) {
            sql.append("AND name LIKE ? ");
            params.add("%" + search + "%");
        }
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    // 4. Insert (Admin)
    public void insertProduct(String name, java.math.BigDecimal price, String img, int categoryId, int shopId) {
        // Dùng IDENTITY để lấy ID sản phẩm vừa tạo, rồi tạo variant mặc định
        String sqlProduct = "INSERT INTO products (shop_id, name, description, price, image_url, category_id) VALUES (?, ?, N'Mô tả sản phẩm', ?, ?, ?); SELECT SCOPE_IDENTITY() AS newId";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sqlProduct)) {
            ps.setInt(1, shopId);
            ps.setString(2, name);
            ps.setBigDecimal(3, price);
            ps.setString(4, img);
            ps.setInt(5, categoryId);
            boolean hasResult = ps.execute();
            int newProductId = -1;
            // Tìm resultset chứa SCOPE_IDENTITY
            if (hasResult) {
                try (ResultSet rs = ps.getResultSet()) {
                    if (rs.next()) newProductId = rs.getInt(1);
                }
            }
            if (newProductId <= 0) {
                // Fallback: skip to next result set
                if (ps.getMoreResults()) {
                    try (ResultSet rs = ps.getResultSet()) {
                        if (rs.next()) newProductId = rs.getInt(1);
                    }
                }
            }
            // Tạo variant mặc định
            if (newProductId > 0) {
                String sqlVariant = "INSERT INTO product_variants (product_id, color, price, stock) VALUES (?, N'Mặc định', ?, 100)";
                try (PreparedStatement ps2 = conn.prepareStatement(sqlVariant)) {
                    ps2.setInt(1, newProductId);
                    ps2.setBigDecimal(2, price);
                    ps2.executeUpdate();
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // 5. Delete (Admin) - Soft Delete
    public void deleteProduct(String id) {
        try (Connection conn = getConnection()) {
            conn.prepareStatement("UPDATE products SET is_deleted = 1 WHERE id=" + id).executeUpdate();
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

    public void bulkDeleteProducts(String[] ids) {
        if (ids == null || ids.length == 0) return;
        String sql = "UPDATE products SET is_deleted = 1 WHERE id IN " + buildInClause(ids.length);
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            for (int i = 0; i < ids.length; i++) {
                ps.setInt(i + 1, Integer.parseInt(ids[i]));
            }
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void bulkRestoreProducts(String[] ids) {
        if (ids == null || ids.length == 0) return;
        String sql = "UPDATE products SET is_deleted = 0 WHERE id IN " + buildInClause(ids.length);
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            for (int i = 0; i < ids.length; i++) {
                ps.setInt(i + 1, Integer.parseInt(ids[i]));
            }
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void bulkDeletePermanentProducts(String[] ids) {
        if (ids == null || ids.length == 0) return;
        String sql = "DELETE FROM products WHERE id IN " + buildInClause(ids.length);
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            for (int i = 0; i < ids.length; i++) {
                ps.setInt(i + 1, Integer.parseInt(ids[i]));
            }
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    // --- END BULK ACTIONS ---

    // Admin: lấy danh sách sản phẩm đã xóa (Thùng rác)
    public List<Product> getDeletedProducts(String search, int page) {
        List<Product> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT p.*, s.shop_name FROM products p LEFT JOIN shops s ON p.shop_id = s.id WHERE p.is_deleted = 1 ");
        List<Object> params = new ArrayList<>();

        if (search != null && !search.isEmpty()) {
            sql.append("AND p.name LIKE ? ");
            params.add("%" + search + "%");
        }
        sql.append("ORDER BY p.id DESC ");

        if (page < 1) page = 1;
        int offset = (page - 1) * PAGE_SIZE;
        sql.append("OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
        params.add(offset);
        params.add(PAGE_SIZE);

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Product p = new Product(
                        rs.getInt("id"),
                        rs.getInt("shop_id"),
                        rs.getString("name"),
                        rs.getString("description"),
                        rs.getBigDecimal("price"),
                        rs.getString("image_url"),
                        rs.getTimestamp("created_at"),
                        rs.getInt("category_id"));
                p.setShopName(rs.getString("shop_name"));
                list.add(p);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

     // Admin: khôi phục sản phẩm
    public void restoreProduct(String id) {
        try (Connection conn = getConnection()) {
            conn.prepareStatement("UPDATE products SET is_deleted = 0 WHERE id=" + id).executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // 6. Update (Admin)
    public void updateProduct(int id, String name, java.math.BigDecimal price, String img, int categoryId, int shopId) {
        String sql = "UPDATE products SET shop_id = ?, name = ?, price = ?, image_url = ?, category_id = ? WHERE id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, shopId);
            ps.setString(2, name);
            ps.setBigDecimal(3, price);
            ps.setString(4, img);
            ps.setInt(5, categoryId);
            ps.setInt(6, id);
            ps.executeUpdate();

            // Đồng bộ giá vào variant (nếu có) hoặc tạo variant mới
            String checkVariant = "SELECT COUNT(*) FROM product_variants WHERE product_id = ?";
            try (PreparedStatement psCheck = conn.prepareStatement(checkVariant)) {
                psCheck.setInt(1, id);
                try (ResultSet rs = psCheck.executeQuery()) {
                    if (rs.next() && rs.getInt(1) > 0) {
                        // Cập nhật giá tất cả variant
                        String updVariant = "UPDATE product_variants SET price = ? WHERE product_id = ?";
                        try (PreparedStatement psUpd = conn.prepareStatement(updVariant)) {
                            psUpd.setBigDecimal(1, price);
                            psUpd.setInt(2, id);
                            psUpd.executeUpdate();
                        }
                    } else {
                        // Tạo variant mặc định nếu chưa có
                        String insVariant = "INSERT INTO product_variants (product_id, color, price, stock) VALUES (?, N'Mặc định', ?, 100)";
                        try (PreparedStatement psIns = conn.prepareStatement(insVariant)) {
                            psIns.setInt(1, id);
                            psIns.setBigDecimal(2, price);
                            psIns.executeUpdate();
                        }
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // 7. Get All Products (Admin)
    public List<Product> getAdminProducts(String search, int page) {
        List<Product> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT p.*, s.shop_name FROM products p LEFT JOIN shops s ON p.shop_id = s.id WHERE p.is_deleted = 0 ");
        List<Object> params = new ArrayList<>();

        if (search != null && !search.isEmpty()) {
            sql.append("AND p.name LIKE ? ");
            params.add("%" + search + "%");
        }
        sql.append("ORDER BY p.id DESC ");

        if (page < 1) page = 1;
        int offset = (page - 1) * PAGE_SIZE;
        sql.append("OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
        params.add(offset);
        params.add(PAGE_SIZE);

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Product p = new Product(
                        rs.getInt("id"),
                        rs.getInt("shop_id"),
                        rs.getString("name"),
                        rs.getString("description"),
                        rs.getBigDecimal("price"),
                        rs.getString("image_url"),
                        rs.getTimestamp("created_at"),
                        rs.getInt("category_id"));
                p.setShopName(rs.getString("shop_name"));
                list.add(p);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public int countAdminProducts(String search) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM products WHERE is_deleted = 0 ");
        List<Object> params = new ArrayList<>();
        if (search != null && !search.isEmpty()) {
            sql.append("AND name LIKE ? ");
            params.add("%" + search + "%");
        }
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
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
