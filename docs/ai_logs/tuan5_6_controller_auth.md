# 📝 AI Chat Log — Tuần 5 & 6: Controller Layer + Xác thực & Bảo mật

---

### 💬 Hội thoại 1: Viết LoginServlet & RegisterServlet

**User:**
Viết cho mình LoginServlet xử lý đăng nhập. Yêu cầu: hỗ trợ đăng nhập bằng email hoặc SĐT

**ChatGPT:**
OK, luồng đăng nhập sẽ như sau:

1. `doGet` → hiển thị form `login.jsp`
2. `doPost` → nhận email/phone + password → tìm user → verify password → lưu session

```java
@WebServlet(urlPatterns = {"/login"})
public class LoginServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String u = request.getParameter("user");
        String p = request.getParameter("pass");

        UserDAO dao = new UserDAO();
        User account = dao.findByEmailOrPhone(u);

        boolean passwordValid = false;
        if (account != null) {
            passwordValid = PasswordService.verify(p, account.getPasswordHash());
        }

        if (account != null && passwordValid) {
            HttpSession session = request.getSession();
            session.setAttribute("account", account);
            response.sendRedirect("home");
        } else {
            request.setAttribute("error", "Tài khoản hoặc mật khẩu không đúng!");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
}
```

**User:**
Forward và Redirect khác nhau thế nào? Tại sao lúc thành công dùng redirect mà lỗi lại dùng forward?

**ChatGPT:**
Câu hỏi kinh điển!

| | `forward` | `sendRedirect` |
|---|---|---|
| Xảy ra ở | Server-side | Client-side (trình duyệt) |
| URL trên thanh địa chỉ | **Không đổi** | **Đổi** sang URL mới |
| Request data | **Giữ nguyên** (setAttribute vẫn còn) | **Mất hết** (request mới) |
| Dùng khi | Cần truyền dữ liệu lỗi về JSP | Thành công, chuyển trang mới |

Nên:
- **Lỗi → forward**: giữ được `request.setAttribute("error", ...)` để JSP hiển thị
- **Thành công → redirect**: tránh user bấm F5 gửi lại form (double submit problem)

---

### 💬 Hội thoại 2: Thêm xác thực OTP cho Admin

**User:**
Thầy yêu cầu Admin phải xác thực 2 lớp (2FA). Làm sao thêm OTP qua email?

**ChatGPT:**
Ý tưởng: Sau khi Admin nhập đúng mật khẩu, KHÔNG cho vào Dashboard ngay. Thay vào đó:

1. Tạo OTP 6 chữ số bằng `SecureRandom`
2. Lưu OTP vào Session (kèm thời gian hết hạn 10 phút)
3. Gửi OTP qua email bằng Jakarta Mail API
4. Redirect đến trang nhập OTP
5. Khi Admin nhập đúng OTP → mới cho vào Dashboard

```java
// Trong LoginServlet, sau khi verify password thành công:
if ("admin".equalsIgnoreCase(account.getRole())) {
    String otp = generateOtp();  // SecureRandom, 6 chữ số
    long expiryTime = System.currentTimeMillis() + 10 * 60 * 1000;

    session.setAttribute("pendingAdmin", account);
    session.setAttribute("adminOtp", otp);
    session.setAttribute("adminOtpExpiry", expiryTime);

    EmailService.sendAdminOtpEmail(adminEmail, otp);
    response.sendRedirect("admin-verify-otp");
}
```

**User:**
SecureRandom khác gì java.util.Random thường?

**ChatGPT:**
- `java.util.Random`: dùng thuật toán **Linear Congruential Generator**, có thể đoán được giá trị tiếp theo nếu biết seed → KHÔNG AN TOÀN cho bảo mật
- `SecureRandom`: lấy entropy từ hệ điều hành (`/dev/urandom` trên Linux, `CryptGenRandom` trên Windows) → KHÔNG THỂ đoán trước

Với OTP bảo mật, bắt buộc phải dùng `SecureRandom`.

---

### 💬 Hội thoại 3: Mã hóa mật khẩu Argon2 thay MD5

**User:**
Dự án trước mình dùng MD5 để hash password. Có vấn đề gì không?

**ChatGPT:**
Vấn đề CỰC KỲ LỚN! MD5 được thiết kế để **nhanh** → hacker có thể brute-force **hàng tỷ hash/giây** bằng GPU. Rainbow Table cho MD5 có sẵn trên internet.

Thay thế bằng **Argon2id** — thuật toán đoạt giải nhất cuộc thi Password Hashing Competition 2015:
- Tiêu tốn nhiều RAM (chống GPU attack)
- Có salt random (mỗi lần hash ra kết quả khác nhau)
- Có cost parameter (điều chỉnh độ chậm)

Mình đã thêm dependency:
```xml
<dependency>
    <groupId>de.mkammerer</groupId>
    <artifactId>argon2-jvm</artifactId>
    <version>2.11</version>
</dependency>
```

```java
public class PasswordService {
    public static String hash(String password) {
        Argon2 argon2 = Argon2Factory.create(Argon2Factory.Argon2Types.ARGON2id);
        return argon2.hash(10, 65536, 1, password.toCharArray());
    }

    public static boolean verify(String password, String hash) {
        Argon2 argon2 = Argon2Factory.create(Argon2Factory.Argon2Types.ARGON2id);
        return argon2.verify(hash, password.toCharArray());
    }
}
```

**User:**
Nếu mình đã có user cũ dùng MD5 thì sao?

**ChatGPT:**
Dùng kỹ thuật **Auto Migration**: Khi user đăng nhập, nếu hash trong DB bắt đầu bằng `$argon2` → verify bằng Argon2. Nếu không → verify bằng MD5, và nếu đúng thì hash lại bằng Argon2 rồi update vào DB. Dần dần tất cả user sẽ chuyển sang Argon2.

---

### 💬 Hội thoại 4: Viết AdminAuthFilter — Bảo vệ trang Admin

**User:**
Làm sao chặn user thường không cho truy cập trang admin?

**ChatGPT:**
Dùng **Servlet Filter**! Filter chạy TRƯỚC mọi Servlet, kiểm tra quyền truy cập:

```java
@WebFilter(urlPatterns = {"/admin", "/admin-products", "/admin-orders", ...})
public class AdminAuthFilter implements Filter {
    @Override
    public void doFilter(ServletRequest request, ServletResponse response,
                         FilterChain chain) throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpSession session = httpRequest.getSession(false);

        // Tầng 1: Chưa đăng nhập?
        if (session == null || session.getAttribute("account") == null) {
            ((HttpServletResponse) response).sendRedirect("/login");
            return;
        }

        // Tầng 2: Không phải Admin?
        User account = (User) session.getAttribute("account");
        if (!"admin".equalsIgnoreCase(account.getRole())) {
            ((HttpServletResponse) response).sendRedirect("/home");
            return;
        }

        // OK → cho đi tiếp
        chain.doFilter(request, response);
    }
}
```

**User:**
`getSession(false)` là sao? Tại sao không phải `getSession()`?

**ChatGPT:**
- `getSession()` hoặc `getSession(true)`: nếu chưa có Session → TẠO MỚI Session
- `getSession(false)`: nếu chưa có Session → trả về `null`, KHÔNG tạo mới

Trong trường hợp bảo mật, phải dùng `false`. Nếu dùng `true`, hacker gửi request đến `/admin-products` sẽ tự động được tạo Session mới → có thể bypass kiểm tra `session == null`.

---

### 💬 Hội thoại 5: Thêm RBAC (Role-Based Access Control)

**User:**
Thầy hỏi: "Nếu có nhiều admin nhưng mỗi admin chỉ quản lý 1 phần (VD: admin A quản lý sản phẩm, admin B quản lý đơn hàng) thì sao?" Làm sao xử lý?

**ChatGPT:**
Đây là bài toán **RBAC** — phân quyền theo vai trò! Cần thêm 2 bảng:

```sql
CREATE TABLE admin_roles (
    id INT PRIMARY KEY,
    role_name NVARCHAR(100),
    description NVARCHAR(500)
);

CREATE TABLE role_permissions (
    role_id INT FOREIGN KEY REFERENCES admin_roles(id),
    permission_id NVARCHAR(50)   -- VD: 'MANAGE_PRODUCTS', 'MANAGE_ORDERS'
);
```

Trong Filter, sau khi xác nhận là Admin, kiểm tra thêm:
```java
if (path.equals("/admin-products")) {
    hasPermission = currentUser.hasPermission("MANAGE_PRODUCTS");
} else if (path.equals("/admin-orders")) {
    hasPermission = currentUser.hasPermission("MANAGE_ORDERS");
}
```

Super Admin (role_id = 1) luôn bypass mọi kiểm tra.

---

*Kết thúc tuần 5-6: Hoàn thành LoginServlet, RegisterServlet, LogoutServlet, AdminAuthFilter với xác thực OTP 2FA, mã hóa Argon2, và hệ thống phân quyền RBAC.*
