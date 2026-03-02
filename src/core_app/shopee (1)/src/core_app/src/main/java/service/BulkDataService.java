package service;

import dal.DBContext;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.Random;

/**
 * Service tạo dữ liệu sản phẩm số lượng lớn tự động.
 * Mỗi sản phẩm sẽ kèm 2 biến thể (Trắng-M, Đen-L).
 */
public class BulkDataService extends DBContext {

    private static final String[] PRODUCT_NAMES = {
            "Áo thun nam CANIFA ngắn tay cổ tròn form thường chất cotton",
            "Áo phông nam nữ tay ngắn cổ tròn form rộng vải dạ quang",
            "Quần Jean Nam Ống Rộng Cao Cấp Trẻ Trung",
            "Giày Thể Thao Sneaker Nam Nữ",
            "Tai nghe không dây Bluetooth 5.0",
            "Ốp lưng iPhone 13 14 15 Pro Max",
            "Balo thời trang nam nữ Unisex",
            "Đồng hồ nam nữ dây da chống nước",
            "Áo khoác nam nữ dù 2 lớp chống nắng",
            "Quần short thể thao nam nữ thoáng mát",
            "Túi đeo chéo nam nữ thời trang Hàn Quốc",
            "Kính mát nam nữ chống UV400 thời trang",
            "Nón lưỡi trai thêu chữ thời trang Unisex",
            "Dép quai ngang nam nữ đế mềm êm chân",
            "Ví da nam cao cấp nhiều ngăn",
            "Đèn LED trang trí phòng ngủ nhiều màu"
    };

    private static final String[] DESCRIPTIONS = {
            "Hàng chuẩn Mall. Chất lượng cao. Bảo hành 30 ngày.",
            "Sản phẩm hot trend 2026. Freeship toàn quốc.",
            "Hàng nhập khẩu chính hãng. Đổi trả miễn phí 7 ngày.",
            "Best seller tháng này. Mua 2 giảm thêm 10%.",
            "Chất liệu cao cấp, form dáng chuẩn. Hàng có sẵn.",
            "Auto Generated - Dữ liệu mẫu cho hệ thống test."
    };

    private static final String[] COLORS = {"Trắng", "Đen", "Xám", "Xanh Navy", "Đỏ"};
    private static final String[] SIZES = {"S", "M", "L", "XL", "XXL", "Free Size"};

    private static final int[] BASE_PRICES = {
            55000, 79000, 99000, 120000, 150000, 185000, 199000,
            250000, 310000, 350000, 399000, 450000, 499000
    };

    private final Random random = new Random();
    private final StringBuilder logs = new StringBuilder();

    /**
     * Tạo số lượng sản phẩm chỉ định kèm biến thể.
     * @param count số sản phẩm cần tạo
     * @return log string hiển thị kết quả
     */
    public String generate(int count) {
        logs.setLength(0);
        log("🚀 <b>BẮT ĐẦU TẠO " + count + " SẢN PHẨM TỰ ĐỘNG...</b>");
        log("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");

        long startTime = System.currentTimeMillis();
        int productCount = 0;
        int variantCount = 0;

        try (Connection conn = getConnection()) {
            if (conn == null) {
                log("❌ <span style='color:red'>Không thể kết nối Database!</span>");
                return logs.toString();
            }

            conn.setAutoCommit(false);

            // SQL: Insert product, lấy ID vừa tạo
            String sqlProduct = "INSERT INTO products (shop_id, name, description, price, image_url) VALUES (?, ?, ?, ?, ?)";
            // SQL: Insert variant
            String sqlVariant = "INSERT INTO product_variants (product_id, color, size, stock, price, note) VALUES (?, ?, ?, ?, ?, ?)";

            try (PreparedStatement psProduct = conn.prepareStatement(sqlProduct, Statement.RETURN_GENERATED_KEYS);
                 PreparedStatement psVariant = conn.prepareStatement(sqlVariant)) {

                for (int i = 1; i <= count; i++) {
                    // --- Tạo Product ---
                    int shopId = random.nextInt(8) + 1; // 1-8
                    String name = PRODUCT_NAMES[random.nextInt(PRODUCT_NAMES.length)] + " " + (100 + random.nextInt(900));
                    String desc = DESCRIPTIONS[random.nextInt(DESCRIPTIONS.length)];
                    int basePrice = BASE_PRICES[random.nextInt(BASE_PRICES.length)];
                    String imageUrl = "https://picsum.photos/seed/auto_" + System.currentTimeMillis() + "_" + i + "/400/400";

                    psProduct.setInt(1, shopId);
                    psProduct.setString(2, name);
                    psProduct.setString(3, desc);
                    psProduct.setDouble(4, basePrice);
                    psProduct.setString(5, imageUrl);
                    psProduct.executeUpdate();

                    // Lấy ID sản phẩm vừa tạo
                    ResultSet rs = psProduct.getGeneratedKeys();
                    int productId = 0;
                    if (rs.next()) {
                        productId = rs.getInt(1);
                    }
                    rs.close();
                    productCount++;

                    // --- Tạo 2 Variants cho mỗi sản phẩm ---
                    for (int v = 0; v < 2; v++) {
                        String color = COLORS[v % COLORS.length];
                        String size = SIZES[random.nextInt(SIZES.length)];
                        int stock = 20 + random.nextInt(131); // 20-150
                        // Giá variant dao động ±10% so với giá gốc
                        double variantPrice = basePrice * (0.9 + random.nextDouble() * 0.2);

                        psVariant.setInt(1, productId);
                        psVariant.setString(2, color);
                        psVariant.setString(3, size);
                        psVariant.setInt(4, stock);
                        psVariant.setDouble(5, variantPrice);
                        psVariant.setString(6, "Auto Generated");
                        psVariant.addBatch();
                        variantCount++;
                    }

                    // Execute variant batch mỗi 500 sản phẩm
                    if (i % 500 == 0) {
                        psVariant.executeBatch();
                        log("⏳ Đã tạo <b>" + i + "/" + count + "</b> sản phẩm...");
                    }
                }

                // Execute remaining variants
                psVariant.executeBatch();
            }

            conn.commit();

            long elapsed = System.currentTimeMillis() - startTime;
            log("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
            log("<h3 style='color:#0dcf45'>✅ HOÀN THÀNH!</h3>");
            log("📦 Sản phẩm đã tạo: <b>" + productCount + "</b>");
            log("🔄 Biến thể đã tạo: <b>" + variantCount + "</b>");
            log("⏱️ Thời gian: <b>" + elapsed + "ms</b> (" + String.format("%.1f", elapsed / 1000.0) + " giây)");
            log("💡 Vào trang <a href='admin-products' style='color:#00a8ff'>Quản lý Sản Phẩm</a> để kiểm tra.");

        } catch (Exception e) {
            e.printStackTrace();
            log("<h3 style='color:red'>❌ LỖI: " + e.getMessage() + "</h3>");
            log("Chi tiết: " + e.getClass().getSimpleName());
        }

        return logs.toString();
    }

    private void log(String msg) {
        logs.append(msg).append("<br>");
    }
}
