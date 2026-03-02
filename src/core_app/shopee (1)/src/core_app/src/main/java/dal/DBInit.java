package dal;

import java.sql.Connection;
import java.sql.Statement;

public class DBInit {
    public static void main(String[] args) {
        DBContext db = new DBContext();
        try (Connection conn = db.getConnection();
                Statement stmt = conn.createStatement()) {

            // Note: IF NOT EXISTS doesn't work the same in SQL Server CREATE TABLE
            // directly.
            // Using a simple try-catch block or checking OBJECT_ID is better if needed,
            // but for initialization we can drop and recreate or just run it (it will error
            // if exist but continue).

            try {
                stmt.executeUpdate("DROP TABLE IF EXISTS reviews;");
            } catch (Exception e) {
            }
            try {
                stmt.executeUpdate("DROP TABLE IF EXISTS categories;");
            } catch (Exception e) {
            }

            // Create Categories
            stmt.executeUpdate("CREATE TABLE categories (" +
                    "id INT IDENTITY(1,1) PRIMARY KEY," +
                    "name NVARCHAR(100) NOT NULL," +
                    "image_url NVARCHAR(255)" +
                    ");");

            // Create Reviews
            stmt.executeUpdate("CREATE TABLE reviews (" +
                    "id INT IDENTITY(1,1) PRIMARY KEY," +
                    "product_id INT NOT NULL," +
                    "user_id INT NOT NULL," +
                    "rating INT NOT NULL CHECK(rating >= 1 AND rating <= 5)," +
                    "comment NVARCHAR(MAX)," +
                    "created_at DATETIME DEFAULT CURRENT_TIMESTAMP," +
                    "has_media BIT DEFAULT 0," + // BIT instead of BOOLEAN
                    "FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE," +
                    "FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE" +
                    ");");

            // Mock Data - Categories (Using SET IDENTITY_INSERT ON to insert explicit IDs)
            stmt.executeUpdate("SET IDENTITY_INSERT categories ON;");
            stmt.executeUpdate("INSERT INTO categories (id, name, image_url) VALUES " +
            // Row 1
                    "(1, N'Thời Trang Nam', 'images/cat_thoi_trang_nam.webp')," +
                    "(2, N'Điện Thoại & Phụ Kiện', 'images/cat_dien_thoai.webp')," +
                    "(3, N'Thiết Bị Điện Tử', 'images/cat_thiet_bi_dien_tu.webp')," +
                    "(4, N'Máy Tính & Laptop', 'images/cat_may_tinh_laptop.webp')," +
                    "(5, N'Máy Ảnh & Máy Quay Phim', 'images/cat_may_anh.webp')," +
                    "(6, N'Đồng Hồ', 'images/cat_dong_ho.webp')," +
                    "(7, N'Giày Dép Nam', 'images/cat_giay_dep_nam.webp')," +
                    "(8, N'Thiết Bị Điện Gia Dụng', 'images/cat_thiet_bi_gia_dung.webp')," +
                    "(9, N'Thể Thao & Du Lịch', 'images/cat_the_thao.webp')," +
                    "(10, N'Ô Tô & Xe Máy & Xe Đạp', 'images/cat_oto_xe_may.webp')," +
                    // Row 2
                    "(11, N'Thời Trang Nữ', 'images/cat_thoi_trang_nu.webp')," +
                    "(12, N'Mẹ & Bé', 'images/cat_me_be.webp')," +
                    "(13, N'Nhà Cửa & Đời Sống', 'images/cat_nha_cua.webp')," +
                    "(14, N'Sắc Đẹp', 'images/cat_sac_dep.webp')," +
                    "(15, N'Sức Khỏe', 'images/cat_suc_khoe.webp')," +
                    "(16, N'Giày Dép Nữ', 'images/cat_giay_dep_nu.webp')," +
                    "(17, N'Túi Ví Nữ', 'images/cat_tui_vi_nu.webp')," +
                    "(18, N'Phụ Kiện & Trang Sức Nữ', 'images/cat_phu_kien_nu.webp')," +
                    "(19, N'Bách Hóa Online', 'images/cat_bach_hoa.webp')," +
                    "(20, N'Nhà Sách Online', 'images/cat_nha_sach.webp');");
            stmt.executeUpdate("SET IDENTITY_INSERT categories OFF;");

            // Mock Data - Users (matching actual schema: id, username, password, full_name,
            // role)
            stmt.executeUpdate("SET IDENTITY_INSERT users ON;");
            stmt.executeUpdate("INSERT INTO users (id, username, password, full_name, role) VALUES " +
                    "(1, 'nguyenvana', '123456', N'Nguyễn Văn A', 'CUSTOMER')," +
                    "(2, 'tranthib', '123456', N'Trần Thị B', 'CUSTOMER');");
            stmt.executeUpdate("SET IDENTITY_INSERT users OFF;");

            // Mock Data - Reviews
            stmt.executeUpdate("SET IDENTITY_INSERT reviews ON;");
            stmt.executeUpdate(
                    "INSERT INTO reviews (id, product_id, user_id, rating, comment, created_at, has_media) VALUES " +
                            "(1, 1, 1, 5, N'Sản phẩm rất đẹp, đóng gói cẩn thận. Giao hàng nhanh! Shop tư vấn nhiệt tình.', '2023-10-01 10:00:00', 1),"
                            + // 1 instead of true
                            "(2, 1, 2, 4, N'Chất lượng cũng tạm được, hơi mỏng xíu nhưng phù hợp giá tiền. Hình ảnh mang tính chất nhận xu.', '2023-10-02 14:30:00', 0),"
                            +
                            "(3, 2, 1, 5, N'Rất hài lòng, sẽ ủng hộ shop tiếp. Đóng gói rất chắc chắn đáng tiền mua.', '2023-10-03 09:15:00', 1);");
            stmt.executeUpdate("SET IDENTITY_INSERT reviews OFF;");

            System.out.println("Database initialized successfully.");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
