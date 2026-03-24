# 📝 AI Chat Log — Tuần 7-8 Supplement: Admin CRUD, Audit Log & Stress Test

---

### 💬 Hội thoại 1: AdminProductServlet — CRUD sản phẩm

**User:**
Viết cho mình trang admin quản lý sản phẩm: thêm, sửa, xóa, xem danh sách có phân trang và tìm kiếm

**ChatGPT:**
OK, mình sẽ viết `AdminProductServlet` theo pattern chuẩn:

- **doGet**: Hiển thị danh sách sản phẩm (phân trang + tìm kiếm)
- **doPost**: Xử lý CRUD dựa trên parameter `action`

```java
@WebServlet("/admin-products")
public class AdminProductServlet extends HttpServlet {
    @Override
    protected void doGet(...) {
        String search = request.getParameter("search");
        int page = getPage(request);

        ProductDAO dao = new ProductDAO();
        List<Product> products = dao.getAdminProducts(search, page);
        int totalProducts = dao.countAdminProducts(search);
        int totalPages = (int) Math.ceil((double) totalProducts / dao.getPageSize());

        request.setAttribute("products", products);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.getRequestDispatcher("admin_products.jsp").forward(...);
    }

    @Override
    protected void doPost(...) {
        String action = request.getParameter("action");
        if ("add".equals(action)) {
            // INSERT sản phẩm mới
        } else if ("edit".equals(action)) {
            // UPDATE sản phẩm
        } else if ("delete".equals(action)) {
            // SOFT DELETE (is_deleted = 1)
        }
        response.sendRedirect("admin-products");
    }
}
```

**User:**
Soft Delete là gì? Tại sao không DELETE thẳng?

**ChatGPT:**
**Hard Delete** (`DELETE FROM products WHERE id = 5`): xóa vĩnh viễn khỏi DB. Nếu admin lỡ tay → KHÔNG thể phục hồi.

**Soft Delete** (`UPDATE products SET is_deleted = 1 WHERE id = 5`): chỉ đánh dấu, dữ liệu vẫn còn trong DB. Ưu điểm:
- Admin có thể khôi phục (undo)
- Giữ được lịch sử đơn hàng cũ (nếu xóa Product thật, order_items sẽ bị mất reference)
- Có thể làm trang "Thùng rác" (Recycle Bin)

Tất cả query SELECT của hệ thống đều có `WHERE is_deleted = 0` để chỉ hiện sản phẩm "sống".

---

### 💬 Hội thoại 2: Bulk Actions — Xóa/Khôi phục hàng loạt

**User:**
Admin muốn tick chọn nhiều sản phẩm rồi xóa 1 lần. Làm sao?

**ChatGPT:**
Dùng checkbox gửi mảng `selectedIds`:

Frontend:
```html
<form method="POST" action="admin-products">
    <input type="hidden" name="action" value="bulk_delete">
    <input type="checkbox" name="selectedIds" value="1">
    <input type="checkbox" name="selectedIds" value="2">
    <input type="checkbox" name="selectedIds" value="5">
    <button type="submit">Xóa đã chọn</button>
</form>
```

Backend:
```java
String[] ids = request.getParameterValues("selectedIds");
// ids = ["1", "2", "5"]
dao.bulkDeleteProducts(ids);
```

DAO:
```java
public void bulkDeleteProducts(String[] ids) {
    String sql = "UPDATE products SET is_deleted = 1 WHERE id IN (?,?,?)";
    // Build IN clause động dựa trên ids.length
}
```

Mình dùng hàm `buildInClause(int size)` để tạo chuỗi `(?,?,?)` với đúng số lượng placeholder, tránh SQL Injection.

---

### 💬 Hội thoại 3: Audit Log — Ghi lại mọi hành động của Admin

**User:**
Thầy hỏi: "Nếu admin A xóa trộm sản phẩm, làm sao biết ai đã xóa?" Giải quyết thế nào?

**ChatGPT:**
Tạo hệ thống **Audit Log**! Mỗi hành động CRUD đều được ghi lại:

Bảng:
```sql
CREATE TABLE audit_logs (
    id INT IDENTITY(1,1) PRIMARY KEY,
    admin_id INT,
    action NVARCHAR(20),      -- CREATE, UPDATE, DELETE, RESTORE
    target_table NVARCHAR(50), -- products, orders, users
    target_id NVARCHAR(50),
    description NVARCHAR(500),
    created_at DATETIME DEFAULT GETDATE()
);
```

Sau mỗi thao tác trong AdminProductServlet:
```java
AuditLogDAO audit = new AuditLogDAO();

// Khi thêm sản phẩm:
audit.insertLog(adminId, "CREATE", "products", "-", "Thêm mới sản phẩm: " + name);

// Khi xóa:
audit.insertLog(adminId, "DELETE", "products", id, "Xóa sản phẩm vào thùng rác");

// Khi xóa vĩnh viễn:
audit.insertLog(adminId, "DELETE_PERM", "products", id, "Xóa VĨNH VIỄN sản phẩm");
```

Có trang `/admin-logs` hiển thị toàn bộ nhật ký:
- Ai đã làm gì (admin_id → tên admin)
- Làm vào lúc nào (created_at)
- Ảnh hưởng đến bảng/dữ liệu nào

**User:**
Vậy Admin có thể xóa log không?

**ChatGPT:**
Trong hệ thống thực tế, Audit Log KHÔNG BAO GIỜ được phép xóa — đó là nguyên tắc bảo mật cơ bản (non-repudiation). Trong project này, chỉ Super Admin mới xem được log, và không có chức năng xóa log.

---

### 💬 Hội thoại 4: Stress Test Tool — Project B Simulator

**User:**
Đề tài yêu cầu có "Công cụ giả lập stress test". Hướng dẫn mình viết

**ChatGPT:**
Mình viết bằng Python vì nó đơn giản hơn Java cho task này:

```python
import requests
import threading
from concurrent.futures import ThreadPoolExecutor

class UserSimulator:
    """Mô phỏng 1 người dùng"""

    def __init__(self, user_id, base_url):
        self.session = requests.Session()
        self.base_url = base_url

    def do_login(self):
        return self.session.post(f"{self.base_url}/login",
            data={"user": f"user{self.user_id}@gmail.com", "pass": "123456"})

    def do_browse_home(self):
        return self.session.get(f"{self.base_url}/home")

    def do_add_to_cart(self, product_id):
        return self.session.post(f"{self.base_url}/add_to_cart",
            data={"productId": product_id, "qty": 1})

    def do_checkout(self):
        return self.session.post(f"{self.base_url}/checkout")

    def run_full_scenario(self):
        """Kịch bản: Login → Browse → Add cart → Checkout"""
        self.do_login()
        self.do_browse_home()
        self.do_add_to_cart(random.randint(1, 100))
        self.do_checkout()

# Chạy 100 user đồng thời
with ThreadPoolExecutor(max_workers=100) as executor:
    for i in range(100):
        executor.submit(lambda: UserSimulator(i, "http://localhost:8080").run_full_scenario())
```

**User:**
Kết quả stress test hiển thị thế nào?

**ChatGPT:**
Mình tạo class `MetricsCollector` thu thập:
- Tổng số request, thành công/thất bại
- Response time: Average, P95, P99
- Throughput (requests/second)
- Peak concurrent users
- Timeline (biểu đồ text: số request theo từng giây)

Output sẽ trông như:
```
╔══════════════════════════════════════════╗
║  📊 BÁO CÁO KẾT QUẢ KIỂM TRA TẢI      ║
╠══════════════════════════════════════════╣
  ⏱️ Thời gian:    45.2 giây
  👥 Users:        100
  📨 Requests:     850
  ✅ Thành công:   842 (99.1%)
  ❌ Thất bại:     8 (0.9%)
  🚀 Throughput:   18.8 req/s

  📈 Response Time:
     Avg:   234 ms
     P95:   567 ms
     P99:  1203 ms
╚══════════════════════════════════════════╝
```

Điểm cần kiểm tra: nếu không có lỗi "Negative Stock" (kho âm) → chứng tỏ cơ chế Atomic Update hoạt động đúng!

**User:**
P95, P99 nghĩa là gì?

**ChatGPT:**
- **P95 (Percentile 95)**: 95% request có response time ≤ giá trị này. Chỉ 5% chậm hơn.
- **P99 (Percentile 99)**: 99% request nhanh hơn giá trị này. Chỉ 1% chậm hơn.

Đây là metric chuẩn trong ngành để đánh giá hiệu suất hệ thống. Trung bình (Avg) có thể bị ảnh hưởng bởi outlier, nhưng P95/P99 cho thấy trải nghiệm của phần lớn user.

---

*Kết thúc: Hoàn thành AdminProductServlet với CRUD + Bulk Actions + Soft Delete, AuditLogDAO cho nhật ký admin, và tool Python Stress Test mô phỏng 100 user đồng thời.*
