# 📝 AI Chat Log — Tuần 7 & 8: Luồng Mua Hàng, Transaction & Data Generation

---

### 💬 Hội thoại 1: Xây dựng giỏ hàng (Cart in Session)

**User:**
Mình muốn làm giỏ hàng cho trang Shopee clone. Giỏ hàng nên lưu ở đâu? Database hay Session?

**ChatGPT:**
Có 2 cách tiếp cận:

| Cách | Ưu điểm | Nhược điểm |
|---|---|---|
| **Session (RAM)** | Nhanh, đơn giản, không cần truy vấn DB | Mất khi hết session hoặc restart server |
| **Database** | Giỏ hàng bền vững, đồng bộ nhiều thiết bị | Phức tạp hơn, cần query mỗi lần load |

Với quy mô LAB211, mình khuyên dùng **Session** vì:
- Đơn giản, phù hợp thời gian dự án
- Không cần tạo thêm bảng `carts` trong DB
- Shopee thật cũng dùng hybrid (cache + DB)

```java
public class Cart {
    private List<CartItem> items = new ArrayList<>();

    public void addItem(CartItem newItem) {
        // Kiểm tra sản phẩm đã có trong giỏ chưa
        for (CartItem item : items) {
            if (item.getProduct().getId() == newItem.getProduct().getId()) {
                item.setQuantity(item.getQuantity() + newItem.getQuantity());
                return;
            }
        }
        items.add(newItem);
    }

    public BigDecimal getTotalMoney() {
        BigDecimal total = BigDecimal.ZERO;
        for (CartItem item : items) {
            total = total.add(item.getPrice()
                .multiply(BigDecimal.valueOf(item.getQuantity())));
        }
        return total;
    }
}
```

**User:**
Nếu user chưa đăng nhập mà thêm giỏ hàng thì sao?

**ChatGPT:**
Vẫn hoạt động bình thường! Vì giỏ hàng lưu trong Session, Session được tạo tự động cho mọi visitor (kể cả khách). Khi user đăng nhập, Session vẫn là cùng 1 instance → giỏ hàng vẫn còn. Chỉ khi bấm "Thanh toán" mới yêu cầu đăng nhập.

---

### 💬 Hội thoại 2: AddToCartServlet — Hỗ trợ AJAX

**User:**
Khi bấm "Thêm vào giỏ hàng" trên trang sản phẩm, mình muốn không reload lại trang. Làm sao?

**ChatGPT:**
Dùng AJAX! Frontend gửi request bằng `fetch()` hoặc `XMLHttpRequest`, backend trả về JSON thay vì redirect.

Cách phân biệt request AJAX vs form thường: kiểm tra header `X-Requested-With`:

```java
@WebServlet("/add_to_cart")
public class AddToCartServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, ...) {

        boolean isAjax = "XMLHttpRequest".equals(
            request.getHeader("X-Requested-With"));

        // ... xử lý thêm vào giỏ hàng ...

        if (isAjax) {
            response.setContentType("application/json");
            response.getWriter().write(
                "{\"success\":true,\"cartCount\":" + cart.getTotalQuantity() + "}");
        } else {
            response.sendRedirect("product?id=" + productId);
        }
    }
}
```

Frontend JS:
```javascript
fetch('/add_to_cart', {
    method: 'POST',
    headers: {'X-Requested-With': 'XMLHttpRequest'},
    body: new FormData(form)
})
.then(res => res.json())
.then(data => {
    if (data.success) {
        // Cập nhật badge số lượng giỏ hàng
        document.querySelector('.cart-count').textContent = data.cartCount;
        showToast('Đã thêm vào giỏ hàng!');
    }
});
```

---

### 💬 Hội thoại 3: Transaction & chống Race Condition (QUAN TRỌNG NHẤT)

**User:**
Khi 100 người cùng mua 1 sản phẩm chỉ còn 5 cái trong kho, làm sao đảm bảo kho không bị âm?

**ChatGPT:**
Đây là bài toán **Race Condition** kinh điển trong hệ thống e-commerce! 

**Vấn đề**: Nếu code như sau:
```java
// SAI! Không an toàn với multi-thread!
int stock = dao.getStock(productId);  // Thread A đọc: stock = 5
if (stock >= qty) {                   // Thread A: 5 >= 1 → OK
    dao.updateStock(productId, stock - qty);  // Thread A: set stock = 4
}
// Nhưng giữa lúc đọc và lúc update, Thread B cũng đọc stock = 5
// → Thread B cũng thấy đủ hàng → cả 2 đều trừ → stock bị sai!
```

**Giải pháp**: Dùng **Atomic Update** — gộp kiểm tra và trừ kho vào 1 câu SQL duy nhất:

```java
// ĐÚNG! Atomic Update
String sql = "UPDATE product_variants SET stock = stock - ? "
           + "WHERE id = ? AND stock >= ?";
// SQL Server tự khóa dòng (row-level lock) khi chạy UPDATE
// Chỉ trả affected = 1 nếu stock thực sự >= qty
```

**User:**
Giải thích kỹ hơn tại sao cách này an toàn?

**ChatGPT:**
Khi SQL Server nhận câu UPDATE, nó sẽ:

1. **Khóa dòng dữ liệu** (row-level lock) của variant đó
2. **Đọc giá trị stock hiện tại** tại chính thời điểm đó
3. **Kiểm tra điều kiện** `stock >= ?`
4. Nếu đúng → **trừ stock** và **giải phóng khóa**
5. Nếu sai → **không làm gì** và **giải phóng khóa**, trả `affected = 0`

Tất cả 5 bước này là **Atomic** (nguyên tử) — không thread nào chen vào giữa được. Nếu 100 thread cùng gửi UPDATE, SQL Server sẽ xếp hàng (queue) và xử lý từng cái một.

**User:**
Vậy còn phần Transaction nữa, viết đầy đủ hàm addOrder cho mình

**ChatGPT:**
```java
public void addOrder(User u, Cart cart) throws Exception {
    Connection conn = null;
    try {
        conn = getConnection();
        conn.setAutoCommit(false);  // BẮT ĐẦU TRANSACTION

        // Bước A: Tạo đơn hàng
        String sqlOrder = "INSERT INTO orders (...) VALUES (...)";
        PreparedStatement psOrder = conn.prepareStatement(sqlOrder,
            Statement.RETURN_GENERATED_KEYS);
        // ... set parameters ...
        psOrder.executeUpdate();
        int orderId = getGeneratedKey(psOrder);

        // Bước B: Duyệt từng sản phẩm trong giỏ
        for (CartItem item : cart.getItems()) {
            // 1. Kiểm tra tồn kho
            // 2. Trừ kho bằng Atomic Update (AND stock >= ?)
            // 3. Nếu affected == 0 → throw Exception
            // 4. INSERT vào order_items
        }

        // Bước C: Mọi thứ OK → COMMIT
        conn.commit();

    } catch (Exception e) {
        // Bước D: Có lỗi → ROLLBACK toàn bộ
        if (conn != null) conn.rollback();
        throw new Exception("Giao dịch thất bại: " + e.getMessage());
    } finally {
        if (conn != null) conn.close();
    }
}
```

Điểm then chốt: `setAutoCommit(false)` làm cho mọi thao tác SQL nằm trong 1 Transaction. Nếu bất kỳ sản phẩm nào trong giỏ hết hàng giữa chừng → `rollback()` hủy TOÀN BỘ (kể cả đơn hàng đã INSERT ở bước A).

---

### 💬 Hội thoại 4: Sinh 12,000 sản phẩm mẫu bằng Python

**User:**
Thầy yêu cầu database phải có tối thiểu 10,000 dòng dữ liệu. Làm sao sinh nhanh?

**ChatGPT:**
Viết script Python sinh CSV:

```python
import csv, random

categories = ["Điện thoại", "Laptop", "Thời trang", "Gia dụng", ...]
adjectives = ["Cao cấp", "Chính hãng", "Giá rẻ", "Hot sale", ...]

with open('products.csv', 'w', newline='', encoding='utf-8') as f:
    writer = csv.writer(f)
    writer.writerow(['id', 'shop_id', 'name', 'description', 'price',
                     'image_url', 'category_id'])

    for i in range(1, 12001):
        name = f"{random.choice(adjectives)} {random.choice(product_names)}"
        price = random.randint(10000, 50000000)
        image = f"https://picsum.photos/400/400?random={i}"
        category = random.randint(1, len(categories))
        shop_id = random.randint(1, 200)

        writer.writerow([i, shop_id, name, f'Mô tả {name}',
                        price, image, category])
```

Hình ảnh lấy từ [Picsum Photos](https://picsum.photos) — dịch vụ cung cấp ảnh random miễn phí, rất phù hợp cho mock data.

**User:**
12,000 sản phẩm mà hình đều giống nhau thì xấu lắm

**ChatGPT:**
Mình đã thêm tham số `?random={i}` vào URL Picsum, mỗi số `i` khác nhau sẽ trả về ảnh khác nhau. Với 12,000 sản phẩm, bạn sẽ có 12,000 ảnh khác nhau mà không cần tải về local!

---

### 💬 Hội thoại 5: Import CSV vào SQL Server bằng Java

**User:**
Viết cho mình tool import file CSV vào database SQL Server

**ChatGPT:**
Tạo class `SqlServerImport.java` trong package `migration`:

```java
public class SqlServerImport {
    public static void main(String[] args) {
        // 1. Đọc file CSV bằng BufferedReader
        // 2. Parse từng dòng
        // 3. INSERT vào DB bằng PreparedStatement
        // 4. Dùng Batch Insert (addBatch + executeBatch)
        //    để tăng tốc: 12,000 INSERT chạy trong ~5 giây
    }
}
```

Mẹo tăng tốc: thay vì `executeUpdate()` từng dòng (12,000 lần gọi DB), dùng **Batch Insert**:
```java
ps.addBatch();
if (count % 500 == 0) {
    ps.executeBatch();  // Gửi 500 dòng 1 lần
}
```

Giảm từ 12,000 round-trip xuống còn 24 round-trip → nhanh gấp 500 lần!

---

*Kết thúc tuần 7-8: Hoàn thành AddToCartServlet, CheckoutServlet, OrderDAO với Transaction chống âm kho. Script Python sinh 12,000 sản phẩm mẫu và tool import CSV vào SQL Server.*
