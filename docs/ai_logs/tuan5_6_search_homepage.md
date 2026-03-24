# 📝 AI Chat Log — Tuần 5-6 Supplement: Tìm Kiếm Nâng Cao & Trang Chủ

---

### 💬 Hội thoại 1: SearchServlet — Luồng tìm kiếm e-commerce

**User:**
Shopee thật có filter theo: danh mục, địa điểm, giá, rating, sắp xếp (phổ biến, mới nhất, giá tăng/giảm, bán chạy). Mình muốn làm giống vậy

**ChatGPT:**
OK! Luồng sẽ như sau:

1. User gõ keyword vào ô search → GET `/search?txt=iphone`
2. User chọn thêm filter → `/search?txt=iphone&cateId=1&location=HCM&minPrice=5000000`
3. SearchServlet nhận TẤT CẢ filter → gọi ProductDAO → trả kết quả

```java
@WebServlet("/search")
public class SearchServlet extends HttpServlet {
    protected void processRequest(HttpServletRequest request, ...) {
        // 1. Nhận keyword
        String txtSearch = request.getParameter("txt");

        // 2. Nhận filter
        String[] cateIds = request.getParameterValues("cateId");
        String[] locations = request.getParameterValues("location");
        String minPrice = request.getParameter("minPrice");
        String maxPrice = request.getParameter("maxPrice");
        String rating = request.getParameter("rating");

        // 3. Nhận sort & page
        String sortBy = request.getParameter("sortBy");  // popular/newest/...
        int page = Integer.parseInt(request.getParameter("page"));

        // 4. Gọi DAO
        List<ProductDTO> products = dao.searchProducts(
            txtSearch, cateIds, locations, minPrice, maxPrice,
            rating, sortBy, page);

        // 5. Tính phân trang
        int totalProducts = dao.countSearchProducts(...);
        int totalPages = (int) Math.ceil((double) totalProducts / 30);

        // 6. Đẩy sang JSP
        request.setAttribute("products", products);
        request.setAttribute("totalPages", totalPages);
        request.getRequestDispatcher("search.jsp").forward(request, response);
    }
}
```

**User:**
Tại sao dùng `getParameterValues` cho cateId mà dùng `getParameter` cho rating?

**ChatGPT:**
- `getParameter("rating")`: trả về **1 giá trị** (String). Dùng khi chỉ có 1 giá trị (rating >= 4.0)
- `getParameterValues("cateId")`: trả về **mảng String[]**. Dùng khi user có thể chọn **nhiều giá trị** (checkbox)

Ví dụ URL: `/search?cateId=1&cateId=3&cateId=5`
→ `getParameterValues("cateId")` trả về `["1", "3", "5"]`
→ SQL sẽ là `WHERE category_id IN (1, 3, 5)`

---

### 💬 Hội thoại 2: Smart Category Filter

**User:**
Trên Shopee, khi mình search "Áo" thì bên trái hiện danh mục liên quan: "Áo thun", "Áo khoác", "Áo sơ mi". Làm sao?

**ChatGPT:**
Tạo hàm `getRelevantCategories` trong CategoryDAO:

```java
public List<Category> getRelevantCategories(String keyword) {
    String sql = "SELECT DISTINCT c.* FROM categories c "
               + "JOIN products p ON p.category_id = c.id "
               + "WHERE p.name LIKE ? AND p.is_deleted = 0";
    // Tìm các category CÓ CHỨA sản phẩm khớp keyword
}
```

Ý tưởng: không hiện TẤT CẢ category, mà chỉ hiện những category có sản phẩm liên quan đến từ khóa. Nếu search "iPhone" → chỉ hiện "Điện thoại", "Phụ kiện điện thoại", không hiện "Thời trang".

Trong SearchServlet:
```java
List<Category> relevantCategories = categoryDao.getRelevantCategories(txtSearch);
request.setAttribute("categories", relevantCategories);  // Sidebar trái
```

---

### 💬 Hội thoại 3: Tối ưu trang chủ bằng In-Memory Cache

**User:**
Trang chủ load chậm quá, mỗi lần mở phải query DB lấy 30 sản phẩm + category. Có cách nào nhanh hơn?

**ChatGPT:**
Dùng **In-Memory Cache**! Ý tưởng: lần đầu query DB, lưu kết quả vào biến `static` trong Java. Các lần sau đọc từ RAM thay vì query DB.

```java
@WebServlet(urlPatterns = {"/home"}, loadOnStartup = 1)
public class HomeServlet extends HttpServlet {

    private static List<ProductDTO> cachedProducts = null;
    private static List<Category> cachedCategories = null;
    private static long cacheTimestamp = 0;
    private static final long CACHE_DURATION_MS = 5 * 60 * 1000; // 5 phút

    @Override
    public void init() throws ServletException {
        // Pre-warm cache khi Tomcat khởi động
        new Thread(() -> refreshCache(), "CacheWarm").start();
    }

    private static synchronized void refreshCache() {
        ProductDAO dao = new ProductDAO();
        cachedProducts = dao.getHomeProducts();
        cachedCategories = new CategoryDAO().getAllCategories();
        cacheTimestamp = System.currentTimeMillis();
    }

    protected void processRequest(...) {
        // Kiểm tra cache còn hạn không
        if (cachedProducts == null ||
            (System.currentTimeMillis() - cacheTimestamp) > CACHE_DURATION_MS) {
            refreshCache();
        }
        // Trả dữ liệu từ RAM, ~0ms
        request.setAttribute("products", cachedProducts);
    }
}
```

**User:**
`loadOnStartup = 1` là gì?

**ChatGPT:**
Thông thường Servlet chỉ được khởi tạo khi có request đầu tiên đến URL của nó. `loadOnStartup = 1` bắt Tomcat khởi tạo Servlet ngay khi server start, TRƯỚC khi có request nào. Số 1 là độ ưu tiên (số nhỏ = load trước).

Lý do dùng: để cache được "nung nóng" sẵn trước khi user đầu tiên vào trang chủ, tránh cảm giác load chậm.

**User:**
Nếu admin thêm/sửa/xóa sản phẩm thì cache có bị cũ không?

**ChatGPT:**
Đúng! Nên mình thêm hàm `invalidateCache()`:

```java
public static void invalidateCache() {
    cachedProducts = null;
    cachedCategories = null;
    cacheTimestamp = 0;
}
```

Trong `AdminProductServlet`, sau mỗi thao tác CRUD, gọi:
```java
HomeServlet.invalidateCache();
```

Lần sau user vào trang chủ, cache sẽ tự động refresh từ DB vì `cachedProducts == null`.

**User:**
Keyword `synchronized` ở hàm refreshCache là gì?

**ChatGPT:**
`synchronized` đảm bảo chỉ 1 thread được chạy hàm này tại 1 thời điểm. Nếu không có nó, khi cache hết hạn, 100 request đồng thời có thể cùng gọi `refreshCache()` → query DB 100 lần. Với `synchronized`, chỉ thread đầu tiên query DB, 99 thread còn lại chờ thread đầu xong rồi dùng cache mới.

---

### 💬 Hội thoại 4: Query tối ưu cho trang chủ

**User:**
Hàm searchProducts JOIN 4 bảng, rất chậm. Trang chủ chỉ cần hiện tên + giá + ảnh. Có cách nào nhanh hơn?

**ChatGPT:**
Viết 1 query riêng `getHomeProducts()` — NHẸ hơn nhiều:

```java
public List<ProductDTO> getHomeProducts() {
    // KHÔNG JOIN order_items → không cần tính SUM(sold)
    // Chỉ JOIN products + shops + subquery MIN(price)
    String sql = "SELECT TOP 30 p.id, p.name, s.shop_name, "
        + "(SELECT MIN(v.price) FROM product_variants v WHERE v.product_id = p.id) as min_price, "
        + "p.image_url, 0 as sold_count, s.rating, s.location "
        + "FROM products p JOIN shops s ON p.shop_id = s.id "
        + "WHERE p.is_deleted = 0 ORDER BY p.id DESC";
}
```

So sánh:
- `searchProducts()`: JOIN 4 bảng + GROUP BY + ORDER BY sold_count → nặng (~200ms)
- `getHomeProducts()`: JOIN 2 bảng + correlated subquery → nhẹ (~30ms)

Trang chủ chỉ hiện 30 sản phẩm mới nhất, không cần biết đã bán bao nhiêu, nên bỏ qua JOIN `order_items` là hợp lý.

---

*Kết thúc: Hoàn thành SearchServlet với 6 loại filter + 5 kiểu sắp xếp, HomeServlet với cơ chế In-Memory Cache, và 2 query tối ưu cho trang chủ vs trang search.*
