package migration;

import dal.DBContext;
import java.sql.Connection;
import java.sql.Statement;

public class UpdateCategories {
    public static void main(String[] args) {
        DBContext db = new DBContext();
        try (Connection conn = db.getConnection();
                Statement stmt = conn.createStatement()) {

            stmt.executeUpdate("DELETE FROM categories;");

            stmt.executeUpdate("SET IDENTITY_INSERT categories ON;");
            stmt.executeUpdate("INSERT INTO categories (id, name, image_url) VALUES " +
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

            System.out.println("Categories updated successfully!");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
