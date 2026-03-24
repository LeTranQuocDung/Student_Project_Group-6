# 📝 AI Chat Log — Tuần 3 & 4: Xây Dựng Model & DAO Layer

---

### 💬 Hội thoại 1: Tạo Model Classes (Java Bean)

**User:**
Tạo cho mình class User.java và Product.java theo chuẩn Java Bean

**ChatGPT:**
```java
package model;

public class User {
    private int id;
    private String fullName;
    private String email;
    private String phone;
    private double wallet;
    private String passwordHash;
    private String note;
    private String role;

    // Constructor đầy đủ
    public User(int id, String fullName, String email, String phone,
                double wallet, String passwordHash, String note, String role) {
        this.id = id;
        this.fullName = fullName;
        this.email = email;
        this.phone = phone;
        this.wallet = wallet;
        this.passwordHash = passwordHash;
        this.note = note;
        this.role = role;
    }

    // Getter & Setter cho từng trường...
}
```

Lưu ý: mình đặt tên trường là `passwordHash` chứ không phải `password` để nhắc nhở rằng đây là hash, không phải plaintext.

**User:**
Tại sao cần class ProductDTO ngoài class Product?

**ChatGPT:**
Câu hỏi rất tốt! **DTO = Data Transfer Object**. Lý do cần tách:

- **Product**: chứa TẤT CẢ thông tin trong bảng `products` (dùng cho Admin, chi tiết sản phẩm)
- **ProductDTO**: chứa thông tin ĐÃ GỘP từ nhiều bảng (product + shop + variants + order_items), dùng cho trang danh sách, search

```java
public class ProductDTO {
    private int id;
    private String name;
    private String shopName;       // Từ bảng shops
    private BigDecimal minPrice;   // MIN(price) từ product_variants
    private String imageUrl;
    private int soldCount;         // SUM(quantity) từ order_items
    private double rating;         // Từ bảng shops
    private String location;       // Từ bảng shops
}
```

ProductDTO giúp tránh truy vấn N+1: thay vì query sản phẩm rồi query shop cho từng cái, ta JOIN 1 lần lấy hết.

---

### 💬 Hội thoại 2: Viết UserDAO — Đăng nhập & Đăng ký

**User:**
Viết hàm login cho UserDAO, tìm user bằng email hoặc phone

**ChatGPT:**
```java
public User findByEmailOrPhone(String loginIdentifier) {
    String sql = "SELECT * FROM Users WHERE (email = ? OR phone = ? OR username = ?) AND is_deleted = 0";
    try (Connection conn = getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setString(1, loginIdentifier);
        ps.setString(2, loginIdentifier);
        ps.setString(3, loginIdentifier);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            return mapUserFromResultSet(rs);
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return null;
}
```

Lưu ý: hàm này chỉ TÌM user, KHÔNG kiểm tra password trong SQL. Password sẽ được verify bằng Argon2 ở tầng Controller. Lý do: Argon2 hash mỗi lần ra giá trị khác nhau (do salt random), nên không thể `WHERE password = ?` được.

**User:**
Hàm signup thì sao?

**ChatGPT:**
```java
public boolean signup(String email, String passHash, String fullName, String phone) {
    String sql = "INSERT INTO Users (username, email, password, full_name, phone, role, wallet) "
               + "VALUES (?, ?, ?, ?, ?, 'CUSTOMER', 0)";
    try (Connection conn = getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setString(1, email);
        ps.setString(2, email);
        ps.setString(3, passHash);  // Đã hash bằng Argon2
        ps.setString(4, fullName);
        ps.setString(5, phone);
        return ps.executeUpdate() > 0;
    } catch (Exception e) {
        e.printStackTrace();
        return false;
    }
}
```

Mấy điểm quan trọng:
- Dùng `PreparedStatement` với `?` placeholder → chống SQL Injection
- Password đã được hash TRƯỚC khi truyền vào hàm này
- Role mặc định là `'CUSTOMER'`, wallet = 0

---

### 💬 Hội thoại 3: Viết ProductDAO — Search động

**User:**
Mình muốn viết hàm search sản phẩm có filter theo: keyword, category, location, giá min/max, rating. Làm sao cho linh hoạt?

**ChatGPT:**
Bạn cần dùng kỹ thuật **Dynamic SQL Building**. Ý tưởng: xây câu SQL dần dần, chỉ thêm mệnh đề WHERE khi filter đó không null.

```java
public List<ProductDTO> searchProducts(String txtSearch, String[] cateIds,
        String[] locations, String minPrice, String maxPrice,
        String rating, String sortBy, int page) {

    StringBuilder sql = new StringBuilder(
        "SELECT p.id, p.name, s.shop_name, MIN(v.price) as min_price... "
        + "FROM products p "
        + "JOIN shops s ON p.shop_id = s.id "
        + "JOIN product_variants v ON p.id = v.product_id "
        + "WHERE p.is_deleted = 0 ");

    List<Object> parameters = new ArrayList<>();

    // Thêm filter NẾU có
    if (txtSearch != null && !txtSearch.isEmpty()) {
        sql.append("AND p.name LIKE ? ");
        parameters.add("%" + txtSearch + "%");
    }

    if (cateIds != null && cateIds.length > 0) {
        sql.append("AND p.category_id IN (?,?,...) ");
        // Thêm từng id vào parameters
    }

    // ORDER BY + OFFSET FETCH cho phân trang
    sql.append("OFFSET ? ROWS FETCH NEXT 30 ROWS ONLY");
}
```

Cách này giúp 1 hàm duy nhất xử lý được mọi tổ hợp filter, không cần viết 10 hàm khác nhau.

**User:**
Tại sao dùng StringBuilder mà không nối String bình thường?

**ChatGPT:**
Vì String trong Java là **immutable** (bất biến). Mỗi lần nối `+` sẽ tạo object String mới trong heap memory. Với SQL dài 10-20 đoạn nối, `StringBuilder` hiệu quả hơn rất nhiều vì nó sửa trực tiếp trên buffer, không tạo object mới.

---

### 💬 Hội thoại 4: Xử lý phân trang

**User:**
OFFSET FETCH là gì? Khác gì LIMIT?

**ChatGPT:**
- **MySQL**: dùng `LIMIT offset, count` (ví dụ `LIMIT 30, 30` = bỏ 30 lấy 30)
- **SQL Server 2012+**: dùng `OFFSET ? ROWS FETCH NEXT ? ROWS ONLY`

Cả 2 đều làm cùng 1 việc: bỏ qua N dòng đầu, lấy M dòng tiếp theo.

Ví dụ trang 3, mỗi trang 30 sản phẩm:
```sql
OFFSET 60 ROWS FETCH NEXT 30 ROWS ONLY
-- Bỏ 60 dòng đầu (trang 1+2), lấy 30 dòng tiếp (trang 3)
```

Công thức: `offset = (page - 1) * pageSize`

**User:**
Nếu database có 100,000 sản phẩm thì OFFSET có chậm không?

**ChatGPT:**
Đúng, OFFSET lớn sẽ chậm vì DB vẫn phải scan qua tất cả dòng trước đó. Nhưng với quy mô 12,000 sản phẩm của LAB211, hiệu năng vẫn ổn (< 100ms). Nếu scale lên triệu dòng, có thể dùng **Keyset Pagination** (WHERE id > last_id) thay thế. Nhưng đó là ngoài phạm vi bài lab rồi.

---

*Kết thúc tuần 3-4: Hoàn thành Model layer (User, Product, ProductDTO, Cart, CartItem, Category) và DAO layer (UserDAO, ProductDAO, CategoryDAO) với các chức năng CRUD cơ bản và search filter động.*
