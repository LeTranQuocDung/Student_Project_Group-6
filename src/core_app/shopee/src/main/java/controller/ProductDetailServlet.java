package controller;

import dal.ProductDAO;
import model.Product;
import util.ProductImageUtil;
import java.io.File;
import java.io.IOException;
import java.util.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "ProductDetailServlet", urlPatterns = { "/product_detail" })
public class ProductDetailServlet extends HttpServlet {

    // ===== MÀU SẮC =====
    private static final Map<String, String[]> CATEGORY_COLORS = new HashMap<>();
    // ===== SIZE / PHIÊN BẢN =====
    private static final Map<String, String[]> CATEGORY_VARIANTS = new HashMap<>();
    // ===== NHÃN VARIANT =====
    private static final Map<String, String> CATEGORY_VARIANT_LABEL = new HashMap<>();
    // ===== TÊN DANH MỤC HIỂN THỊ =====
    private static final Map<String, String> CATEGORY_DISPLAY_NAME = new HashMap<>();

    static {
        // Áo thun
        CATEGORY_COLORS.put("ao_thun", new String[] { "Trắng", "Đen", "Xám", "Navy", "Be" });
        CATEGORY_VARIANTS.put("ao_thun", new String[] { "S", "M", "L", "XL", "XXL" });
        CATEGORY_VARIANT_LABEL.put("ao_thun", "Size");
        CATEGORY_DISPLAY_NAME.put("ao_thun", "Thời Trang Nam");

        // Áo phông
        CATEGORY_COLORS.put("ao_phong", new String[] { "Trắng", "Đen", "Xanh Rêu", "Tím Than", "Kem" });
        CATEGORY_VARIANTS.put("ao_phong", new String[] { "S", "M", "L", "XL", "XXL" });
        CATEGORY_VARIANT_LABEL.put("ao_phong", "Size");
        CATEGORY_DISPLAY_NAME.put("ao_phong", "Thời Trang Nam Nữ");

        // Quần jean
        CATEGORY_COLORS.put("quan_jean", new String[] { "Xanh Đậm", "Xanh Nhạt", "Đen", "Xám Khói" });
        CATEGORY_VARIANTS.put("quan_jean", new String[] { "28", "29", "30", "31", "32" });
        CATEGORY_VARIANT_LABEL.put("quan_jean", "Size");
        CATEGORY_DISPLAY_NAME.put("quan_jean", "Thời Trang Nam");

        // Giày / Dép
        CATEGORY_COLORS.put("giay", new String[] { "Trắng", "Đen", "Đỏ", "Xanh Dương" });
        CATEGORY_VARIANTS.put("giay", new String[] { "38", "39", "40", "41", "42", "43" });
        CATEGORY_VARIANT_LABEL.put("giay", "Size");
        CATEGORY_DISPLAY_NAME.put("giay", "Giày Dép Nam Nữ");

        // Tai nghe
        CATEGORY_COLORS.put("tai_nghe", new String[] { "Trắng", "Đen", "Hồng" });
        CATEGORY_VARIANTS.put("tai_nghe", new String[] { "Bản Thường", "Bản Pro", "Bản Pro Max" });
        CATEGORY_VARIANT_LABEL.put("tai_nghe", "Phiên Bản");
        CATEGORY_DISPLAY_NAME.put("tai_nghe", "Thiết Bị Điện Tử");

        // Ốp lưng
        CATEGORY_COLORS.put("op_lung", new String[] { "Trong Suốt", "Đen", "Hồng Pastel", "Xanh Mint" });
        CATEGORY_VARIANTS.put("op_lung",
                new String[] { "iPhone 13", "iPhone 14", "iPhone 15", "iPhone 15 Pro", "iPhone 16 Pro Max" });
        CATEGORY_VARIANT_LABEL.put("op_lung", "Dòng Máy");
        CATEGORY_DISPLAY_NAME.put("op_lung", "Phụ Kiện Điện Thoại");

        // Balo
        CATEGORY_COLORS.put("balo", new String[] { "Đen", "Xám", "Navy", "Xanh Rêu" });
        CATEGORY_VARIANTS.put("balo", new String[] { "Size S (15L)", "Size M (20L)", "Size L (30L)" });
        CATEGORY_VARIANT_LABEL.put("balo", "Kích Cỡ");
        CATEGORY_DISPLAY_NAME.put("balo", "Túi Ví Nam Nữ");

        // Đồng hồ
        CATEGORY_COLORS.put("dong_ho", new String[] { "Dây Da Nâu", "Dây Da Đen", "Dây Kim Loại Bạc" });
        CATEGORY_VARIANTS.put("dong_ho", new String[] { "Nam (40mm)", "Nữ (32mm)" });
        CATEGORY_VARIANT_LABEL.put("dong_ho", "Phiên Bản");
        CATEGORY_DISPLAY_NAME.put("dong_ho", "Đồng Hồ & Phụ Kiện");

        // Áo khoác
        CATEGORY_COLORS.put("ao_khoac", new String[] { "Đen", "Xám", "Xanh Rêu", "Be" });
        CATEGORY_VARIANTS.put("ao_khoac", new String[] { "M", "L", "XL", "XXL" });
        CATEGORY_VARIANT_LABEL.put("ao_khoac", "Size");
        CATEGORY_DISPLAY_NAME.put("ao_khoac", "Thời Trang Nam Nữ");

        // Quần short
        CATEGORY_COLORS.put("quan_short", new String[] { "Đen", "Xám", "Navy", "Trắng" });
        CATEGORY_VARIANTS.put("quan_short", new String[] { "M", "L", "XL", "XXL" });
        CATEGORY_VARIANT_LABEL.put("quan_short", "Size");
        CATEGORY_DISPLAY_NAME.put("quan_short", "Thời Trang Thể Thao");

        // Túi đeo chéo
        CATEGORY_COLORS.put("tui_xach", new String[] { "Đen", "Nâu", "Xám", "Be" });
        CATEGORY_VARIANTS.put("tui_xach", new String[] { "Size Nhỏ", "Size Vừa", "Size Lớn" });
        CATEGORY_VARIANT_LABEL.put("tui_xach", "Kích Cỡ");
        CATEGORY_DISPLAY_NAME.put("tui_xach", "Túi Ví Nam Nữ");

        // Kính mát
        CATEGORY_COLORS.put("kinh_mat", new String[] { "Đen", "Nâu", "Bạc Gương", "Xanh" });
        CATEGORY_VARIANTS.put("kinh_mat", new String[] { "Nam", "Nữ", "Unisex" });
        CATEGORY_VARIANT_LABEL.put("kinh_mat", "Phiên Bản");
        CATEGORY_DISPLAY_NAME.put("kinh_mat", "Phụ Kiện Thời Trang");

        // Nón / Mũ
        CATEGORY_COLORS.put("non_mu", new String[] { "Đen", "Trắng", "Be", "Navy" });
        CATEGORY_VARIANTS.put("non_mu", new String[] { "Free Size" });
        CATEGORY_VARIANT_LABEL.put("non_mu", "Size");
        CATEGORY_DISPLAY_NAME.put("non_mu", "Phụ Kiện Thời Trang");

        // Ví da
        CATEGORY_COLORS.put("vi_da", new String[] { "Đen", "Nâu", "Nâu Bò", "Xanh Navy" });
        CATEGORY_VARIANTS.put("vi_da", new String[] { "Ví Ngắn", "Ví Dài", "Ví Bóp" });
        CATEGORY_VARIANT_LABEL.put("vi_da", "Kiểu Dáng");
        CATEGORY_DISPLAY_NAME.put("vi_da", "Túi Ví Nam Nữ");

        // Đèn LED
        CATEGORY_COLORS.put("den_led", new String[] { "Trắng Ấm", "Nhiều Màu RGB", "Trắng Lạnh" });
        CATEGORY_VARIANTS.put("den_led", new String[] { "3m", "5m", "10m" });
        CATEGORY_VARIANT_LABEL.put("den_led", "Chiều Dài");
        CATEGORY_DISPLAY_NAME.put("den_led", "Đồ Trang Trí");

        // Phụ kiện ĐT
        CATEGORY_COLORS.put("phu_kien_dt", new String[] { "Trắng", "Đen" });
        CATEGORY_VARIANTS.put("phu_kien_dt", new String[] { "1m", "1.5m", "2m" });
        CATEGORY_VARIANT_LABEL.put("phu_kien_dt", "Chiều Dài Cáp");
        CATEGORY_DISPLAY_NAME.put("phu_kien_dt", "Phụ Kiện Điện Thoại");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String idRaw = request.getParameter("id");
            if (idRaw == null) {
                response.sendRedirect("home");
                return;
            }
            int id = Integer.parseInt(idRaw);

            ProductDAO dao = new ProductDAO();
            Product p = dao.getProductById(id);

            if (p == null) {
                p = new Product();
                p.setId(id);
                p.setName("Ốp Lưng Iphone TPU hoa tiết da mềm mèo tặng hoa");
                p.setPrice(new java.math.BigDecimal("15900.0"));
                p.setDescription(generateDescription(p.getName()));
            } else {
                if (p.getDescription() == null || p.getDescription().trim().isEmpty()
                        || p.getDescription().contains("Hàng chuẩn Mall")
                        || p.getDescription().contains("Auto Generated")) {
                    p.setDescription(generateDescription(p.getName()));
                }
            }

            // Lấy ảnh gallery từ thư mục local
            String categoryKey = ProductImageUtil.getCategoryKey(p.getName());
            List<String> images = getLocalImages(categoryKey, request);
            if (!images.isEmpty()) {
                p.setImageUrl(images.get(0));
            }

            // Options
            String[] colors = CATEGORY_COLORS.getOrDefault(categoryKey, new String[] { "Mặc định" });
            String[] variants = CATEGORY_VARIANTS.getOrDefault(categoryKey, new String[] { "Tiêu chuẩn" });
            String variantLabel = CATEGORY_VARIANT_LABEL.getOrDefault(categoryKey, "Phiên Bản");
            String categoryDisplayName = CATEGORY_DISPLAY_NAME.getOrDefault(categoryKey, "Shopee");

            // Đánh giá
            dal.ReviewDAO revDao = new dal.ReviewDAO();
            List<model.Review> reviews = revDao.getReviewsByProductId(id);
            int soldCount = dao.getSoldCount(id);
            int totalStock = dao.getTotalStock(id);

            // Wishlist: lấy số lượt thích thật từ DB
            dal.WishlistDAO wishlistDao = new dal.WishlistDAO();
            int wishlistCount = wishlistDao.countByProductId(id);
            boolean isLiked = false;
            jakarta.servlet.http.HttpSession session = request.getSession(false);
            model.User currentUser = (session != null) ? (model.User) session.getAttribute("user") : null;
            if (currentUser != null) {
                isLiked = wishlistDao.isLiked(currentUser.getId(), id);
            }

            // Shop: lấy thông tin shop thật từ DB
            dal.ShopDAO shopDAO = new dal.ShopDAO();
            model.Shop shop = shopDAO.getShopById(p.getShopId());

            // Kiểm tra quyền viết đánh giá: chỉ cho phép khi user đã mua và đơn hàng COMPLETED
            boolean canReview = false;
            boolean hasReviewed = false;
            model.User reviewUser = (session != null) ? (model.User) session.getAttribute("account") : null;
            if (reviewUser != null) {
                dal.OrderDAO orderDAO = new dal.OrderDAO();
                canReview = orderDAO.hasCompletedOrder(reviewUser.getId(), id);
                
                // Nếu đã mua nhưng đã đánh giá rồi → không cho đánh giá nữa
                if (canReview) {
                    hasReviewed = revDao.hasReviewed(reviewUser.getId(), id);
                    if (hasReviewed) {
                        canReview = false;
                    }
                }
            }

            // Gửi dữ liệu sang JSP
            request.setAttribute("detail", p);
            request.setAttribute("listImg", images);
            request.setAttribute("reviews", reviews);
            request.setAttribute("soldCount", soldCount);
            request.setAttribute("totalStock", totalStock);
            request.setAttribute("productColors", colors);
            request.setAttribute("productVariants", variants);
            request.setAttribute("variantLabel", variantLabel);
            request.setAttribute("categoryDisplayName", categoryDisplayName);
            request.setAttribute("wishlistCount", wishlistCount);
            request.setAttribute("isLiked", isLiked);
            request.setAttribute("shop", shop);
            request.setAttribute("canReview", canReview);
            request.setAttribute("hasReviewed", hasReviewed);

            request.getRequestDispatcher("product_detail.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("home");
        }
    }

    /**
     * Lấy danh sách ảnh local từ thư mục images/products/{category}/
     */
    private List<String> getLocalImages(String categoryKey, HttpServletRequest request) {
        List<String> images = new ArrayList<>();
        String folderPath = "images/products/" + categoryKey;

        try {
            String realPath = request.getServletContext().getRealPath("/" + folderPath);
            if (realPath != null) {
                File folder = new File(realPath);
                if (folder.exists() && folder.isDirectory()) {
                    File[] files = folder.listFiles((dir, name) ->
                            name.endsWith(".png") || name.endsWith(".jpg") || name.endsWith(".jpeg") || name.endsWith(".webp"));
                    if (files != null) {
                        Arrays.sort(files);
                        for (File f : files) {
                            images.add(folderPath + "/" + f.getName());
                        }
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        // Fallback: nếu không tìm thấy file → dùng 1 ảnh mặc định
        if (images.isEmpty()) {
            images.add(folderPath + "/1.jpg");
        }

        return images;
    }

    /**
     * Tạo mô tả chi tiết cho sản phẩm
     */
    private String generateDescription(String productName) {
        if (productName == null)
            return "Đang cập nhật mô tả sản phẩm...";

        String categoryKey = ProductImageUtil.getCategoryKey(productName);

        switch (categoryKey) {
            case "ao_thun":
                return "🔥 ĐẶC ĐIỂM NỔI BẬT:\n"
                        + "- Chất liệu: Cotton cao cấp 100%, mềm mại, thoáng mát\n"
                        + "- Form: Regular Fit, cổ tròn, tay ngắn\n"
                        + "- Đường may tỉ mỉ, không bai nhão, không phai màu\n\n"
                        + "📏 SIZE: S(45-55kg) | M(55-65kg) | L(65-75kg) | XL(75-85kg) | XXL(85-95kg)\n\n"
                        + "🧺 BẢO QUẢN: Giặt lộn trái, không dùng chất tẩy mạnh, phơi bóng râm";

            case "ao_phong":
                return "🔥 ĐẶC ĐIỂM NỔI BẬT:\n"
                        + "- Chất liệu: Cotton Poly, co giãn 4 chiều, thoáng mát\n"
                        + "- Form: Oversize trendy, vải dạ quang phát sáng trong bóng tối\n"
                        + "- Unisex - phù hợp cả nam và nữ\n\n"
                        + "📏 SIZE: S(40-50kg) | M(50-62kg) | L(62-74kg) | XL(74-85kg) | XXL(85-95kg)";

            case "quan_jean":
                return "🔥 ĐẶC ĐIỂM NỔI BẬT:\n"
                        + "- Chất liệu: Denim cao cấp, co giãn nhẹ\n"
                        + "- Form: Ống rộng (Wide Leg), trendy, trẻ trung\n"
                        + "- Màu wash chuẩn, không phai, không ra màu\n\n"
                        + "📏 SIZE: 28(Eo 70-74) | 29(74-78) | 30(78-82) | 31(82-86) | 32(86-90)";

            case "giay":
                return "🔥 ĐẶC ĐIỂM NỔI BẬT:\n"
                        + "- Upper vải mesh thoáng khí + da tổng hợp cao cấp\n"
                        + "- Đế EVA siêu nhẹ, đàn hồi tốt, chống trượt\n"
                        + "- Unisex, đệm lót êm ái\n\n"
                        + "📏 SIZE: 38(23.5cm) | 39(24cm) | 40(24.5cm) | 41(25cm) | 42(25.5cm) | 43(26cm)";

            case "tai_nghe":
                return "🔥 ĐẶC ĐIỂM NỔI BẬT:\n"
                        + "- Bluetooth 5.0, khoảng cách 10m\n"
                        + "- Driver 13mm, bass mạnh, treble trong trẻo\n"
                        + "- Pin 4-5h, hộp sạc 300mAh, chống nước IPX4\n\n"
                        + "📦 THÔNG SỐ: BT 5.0 | 20Hz-20kHz | Sạc Type-C 1.5h | ~5g/bên";

            case "op_lung":
                return "🔥 ĐẶC ĐIỂM NỔI BẬT:\n"
                        + "- TPU cao cấp, in UV sắc nét, không bong tróc\n"
                        + "- Chống sốc, viền bảo vệ camera +0.5mm, màn hình +1mm\n"
                        + "- Siêu nhẹ ~30g\n\n"
                        + "📱 TƯƠNG THÍCH: iPhone 13/14/15/15 Pro/16/16 Pro Max";

            case "balo":
                return "🔥 ĐẶC ĐIỂM NỔI BẬT:\n"
                        + "- Polyester chống thấm nước, Unisex\n"
                        + "- Ngăn laptop riêng (14-15.6 inch), nhiều ngăn tiện lợi\n"
                        + "- Khóa YKK, dây đeo đệm êm vai\n\n"
                        + "📐 KÍCH THƯỚC: Cao 45cm x Rộng 30cm x Sâu 15cm (~20L)";

            case "dong_ho":
                return "🔥 ĐẶC ĐIỂM NỔI BẬT:\n"
                        + "- Kính khoáng cường lực chống xước\n"
                        + "- Dây da thật, máy Quartz Miyota Nhật Bản\n"
                        + "- Chống nước 3ATM (30m)\n\n"
                        + "📐 THÔNG SỐ: Mặt 40mm(Nam)/32mm(Nữ), dày 8mm, ~50g";

            case "ao_khoac":
                return "🔥 ĐẶC ĐIỂM NỔI BẬT:\n"
                        + "- Chất liệu vải dù 2 lớp, chống nắng, chống gió, nhẹ\n"
                        + "- Form Unisex chuẩn dáng, chỉ số UV UPF 50+\n"
                        + "- Có túi kéo khóa 2 bên tiện lợi\n\n"
                        + "📏 SIZE: M(50-60kg) | L(60-70kg) | XL(70-80kg) | XXL(80-90kg)";

            case "quan_short":
                return "🔥 ĐẶC ĐIỂM NỔI BẬT:\n"
                        + "- Chất liệu: Thun lạnh co giãn 4 chiều, thoáng mát\n"
                        + "- Thiết kế có túi kéo khóa 2 bên, lưng chun co giãn\n"
                        + "- Phù hợp tập gym, chạy bộ, đi chơi\n\n"
                        + "📏 SIZE: M(55-65kg) | L(65-75kg) | XL(75-85kg) | XXL(85-95kg)";

            case "tui_xach":
                return "🔥 ĐẶC ĐIỂM NỔI BẬT:\n"
                        + "- Chất liệu da PU cao cấp, bền bỉ, chống thấm nước nhẹ\n"
                        + "- Phong cách Hàn Quốc, nhiều ngăn tiện dụng\n"
                        + "- Dây đeo có thể điều chỉnh\n\n"
                        + "📐 KÍCH THƯỚC: Rộng 22cm x Cao 16cm x Sâu 8cm";

            case "kinh_mat":
                return "🔥 ĐẶC ĐIỂM NỔI BẬT:\n"
                        + "- Tròng kính chống UV400, bảo vệ mắt 100%\n"
                        + "- Gọng hợp kim nhẹ, không gỉ, không gây dị ứng da\n"
                        + "- Thiết kế Unisex, phù hợp nhiều khuôn mặt\n\n"
                        + "📋 BỘ SP: Kính + Hộp đựng + Khăn lau + Túi bảo vệ";

            case "non_mu":
                return "🔥 ĐẶC ĐIỂM NỔI BẬT:\n"
                        + "- Chất liệu: Vải kaki/canvas cao cấp, chống nắng tốt\n"
                        + "- Thêu chữ/logo tinh tế, phong cách streetwear\n"
                        + "- Điều chỉnh khóa phía sau, Free Size\n\n"
                        + "📏 SIZE: Free Size (vòng đầu 54-60cm)";

            case "vi_da":
                return "🔥 ĐẶC ĐIỂM NỔI BẬT:\n"
                        + "- Chất liệu da bò thật 100%, mềm mại, bền bỉ\n"
                        + "- Nhiều ngăn: 6 ngăn thẻ, 2 ngăn tiền, 1 ngăn khóa kéo\n"
                        + "- Thiết kế sang trọng, lịch lãm cho nam giới\n\n"
                        + "📐 KÍCH THƯỚC: 12cm x 10cm x 2cm";

            case "den_led":
                return "🔥 ĐẶC ĐIỂM NỔI BẬT:\n"
                        + "- Dây LED nhiều màu RGB, điều khiển từ xa\n"
                        + "- 16 triệu màu sắc, nhiều chế độ nháy\n"
                        + "- Tuổi thọ 50.000 giờ, dán tường dễ dàng\n\n"
                        + "📐 Chiều dài: 3m / 5m / 10m | Nguồn USB 5V";

            case "phu_kien_dt":
                return "🔥 ĐẶC ĐIỂM NỔI BẬT:\n"
                        + "- Dây bọc Nylon/TPE bền bỉ, chống đứt gãy\n"
                        + "- Sạc nhanh PD/QC 3.0, truyền dữ liệu tốc độ cao\n"
                        + "- Tương thích: iPhone, Samsung, Xiaomi...\n\n"
                        + "📐 Chiều dài: 1m / 1.5m / 2m | Cổng: Type-C / Lightning";

            default:
                return "🔥 ĐẶC ĐIỂM NỔI BẬT:\n"
                        + "- Sản phẩm chính hãng, chất lượng cao\n"
                        + "- Thiết kế hiện đại, chất liệu bền bỉ\n"
                        + "- Đóng gói cẩn thận, giao hàng nhanh\n\n"
                        + "⚡ CHÍNH SÁCH: Đổi trả 7 ngày | Hoàn tiền 100%";
        }
    }
}
