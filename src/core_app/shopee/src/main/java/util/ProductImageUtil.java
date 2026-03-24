package util;

import java.util.HashMap;
import java.util.Map;

/**
 * Utility class để map tên sản phẩm => ảnh thực tế LOCAL.
 * Ảnh nằm trong webapp/images/products/{category}/
 * Dùng chung cho cả Product, ProductDTO, và tất cả các trang hiển thị.
 */
public class ProductImageUtil {

    // Thumbnail chính cho mỗi loại sản phẩm (dùng trên listing page)
    private static final Map<String, String> CATEGORY_THUMBNAIL = new HashMap<>();

    static {
        CATEGORY_THUMBNAIL.put("ao_thun", "images/products/ao_thun/1.jpg");
        CATEGORY_THUMBNAIL.put("ao_phong", "images/products/ao_phong/1.jpg");
        CATEGORY_THUMBNAIL.put("quan_jean", "images/products/quan_jean/1.jpg");
        CATEGORY_THUMBNAIL.put("giay", "images/products/giay/1.jpg");
        CATEGORY_THUMBNAIL.put("tai_nghe", "images/products/tai_nghe/1.jpg");
        CATEGORY_THUMBNAIL.put("op_lung", "images/products/op_lung/1.jpg");
        CATEGORY_THUMBNAIL.put("balo", "images/products/balo/1.jpg");
        CATEGORY_THUMBNAIL.put("dong_ho", "images/products/dong_ho/1.jpg");
        CATEGORY_THUMBNAIL.put("ao_khoac", "images/products/ao_khoac/1.jpg");
        CATEGORY_THUMBNAIL.put("quan_short", "images/products/quan_short/1.jpg");
        CATEGORY_THUMBNAIL.put("tui_xach", "images/products/tui_xach/1.jpg");
        CATEGORY_THUMBNAIL.put("kinh_mat", "images/products/kinh_mat/1.jpg");
        CATEGORY_THUMBNAIL.put("non_mu", "images/products/non_mu/1.jpg");
        CATEGORY_THUMBNAIL.put("vi_da", "images/products/vi_da/1.jpg");
        CATEGORY_THUMBNAIL.put("den_led", "images/products/den_led/1.jpg");
        CATEGORY_THUMBNAIL.put("phu_kien_dt", "images/products/phu_kien_dt/1.jpg");
    }

    /**
     * Xác định loại sản phẩm dựa trên tên
     */
    public static String getCategoryKey(String productName) {
        if (productName == null)
            return "ao_thun";
        String n = productName.toLowerCase();

        if (n.contains("áo thun") || n.contains("canifa"))
            return "ao_thun";
        if (n.contains("áo phông") || n.contains("dạ quang"))
            return "ao_phong";
        if (n.contains("áo khoác") || n.contains("hoodie") || n.contains("chống nắng"))
            return "ao_khoac";
        if (n.contains("quần jean") || n.contains("quần jeans"))
            return "quan_jean";
        if (n.contains("quần short") || n.contains("quần đùi"))
            return "quan_short";
        if (n.contains("giày") || n.contains("sneaker") || n.contains("dép"))
            return "giay";
        if (n.contains("tai nghe") || n.contains("bluetooth") || n.contains("earphone") || n.contains("headphone"))
            return "tai_nghe";
        if (n.contains("ốp lưng") || n.contains("ốp điện thoại") || n.contains("case iphone"))
            return "op_lung";
        if (n.contains("balo") || n.contains("ba lô"))
            return "balo";
        if (n.contains("đồng hồ") || n.contains("watch"))
            return "dong_ho";
        if (n.contains("kính mát") || n.contains("kính râm") || n.contains("uv400"))
            return "kinh_mat";
        if (n.contains("ví da") || n.contains("ví nam") || n.contains("ví nữ"))
            return "vi_da";
        if (n.contains("túi đeo") || n.contains("túi xách"))
            return "tui_xach";
        if (n.contains("nón") || n.contains("mũ") || n.contains("lưỡi trai"))
            return "non_mu";
        if (n.contains("đèn led") || n.contains("đèn trang trí"))
            return "den_led";
        if (n.contains("sạc") || n.contains("cáp") || n.contains("phụ kiện"))
            return "phu_kien_dt";

        return "ao_thun";
    }

    /**
     * Trả về ảnh thumbnail LOCAL liên quan dựa trên tên sản phẩm.
     * Luôn override URL cũ (picsum/unsplash) bằng ảnh local.
     */
    public static String getRelevantImageUrl(String productName, String currentImageUrl) {
        // Nếu đã là ảnh local products → giữ nguyên
        if (currentImageUrl != null && currentImageUrl.startsWith("images/products/")) {
            return currentImageUrl;
        }

        // Map sang ảnh local
        String key = getCategoryKey(productName);
        return CATEGORY_THUMBNAIL.getOrDefault(key, CATEGORY_THUMBNAIL.get("ao_thun"));
    }

    /**
     * Trả về danh sách ảnh gallery (cho trang chi tiết sản phẩm).
     * Trả tên thư mục category → servlet sẽ list files trong đó.
     */
    public static String getCategoryFolder(String productName) {
        return "images/products/" + getCategoryKey(productName);
    }
}
