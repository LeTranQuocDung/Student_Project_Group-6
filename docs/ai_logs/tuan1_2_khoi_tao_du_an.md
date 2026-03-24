# 📝 AI Chat Log — Tuần 1 & 2: Khởi Tạo Dự Án & Thiết Kế Database

---

### 💬 Hội thoại 1: Chọn công nghệ cho dự án

**User:**
Mình cần làm 1 trang web mô phỏng Shopee cho môn LAB211 ở FPT. Yêu cầu dùng Java Web (Servlet/JSP). Mình nên chọn stack nào?

**ChatGPT:**
Với yêu cầu môn LAB211 dùng Java Web, mình gợi ý stack sau:

- **Backend**: Java 17 + Servlet/JSP (Jakarta EE 10)
- **Server**: Apache Tomcat 10.1.x (tương thích Jakarta namespace)
- **Database**: SQL Server Express (FPT hay dùng) hoặc MySQL
- **Build tool**: Maven (quản lý dependency tự động)
- **Frontend**: HTML5/CSS3/JS thuần (không cần framework)

Lý do chọn Tomcat 10 thay vì Tomcat 9: Tomcat 10+ dùng namespace `jakarta.servlet` thay cho `javax.servlet` cũ. Nếu dùng JDK 17 thì nên dùng Tomcat 10 để tương thích.

**User:**
OK vậy giúp mình tạo cấu trúc thư mục Maven chuẩn cho project Java Web đi

**ChatGPT:**
Đây là cấu trúc chuẩn cho Maven Web Application:

```
src/core_app/
├── pom.xml
├── src/
│   └── main/
│       ├── java/
│       │   ├── controller/    ← Servlet (Controller)
│       │   ├── dal/           ← Data Access Layer (DAO)
│       │   ├── model/         ← Java Bean / POJO
│       │   └── util/          ← Utility classes
│       └── webapp/
│           ├── WEB-INF/
│           │   └── web.xml
│           ├── css/
│           ├── js/
│           └── *.jsp          ← Giao diện
└── tomcat_dir/                ← Đính kèm Tomcat luôn
```

Mình sẽ tạo file `pom.xml` với các dependency cần thiết: `jakarta.servlet-api`, `mssql-jdbc`, `jstl`...

**User:**
Tạo luôn file pom.xml cho mình

**ChatGPT:**
```xml
<project>
    <modelVersion>4.0.0</modelVersion>
    <groupId>com.shopee</groupId>
    <artifactId>shopee-web</artifactId>
    <version>1.0-SNAPSHOT</version>
    <packaging>war</packaging>

    <properties>
        <maven.compiler.source>17</maven.compiler.source>
        <maven.compiler.target>17</maven.compiler.target>
    </properties>

    <dependencies>
        <dependency>
            <groupId>jakarta.servlet</groupId>
            <artifactId>jakarta.servlet-api</artifactId>
            <version>6.0.0</version>
            <scope>provided</scope>
        </dependency>
        <dependency>
            <groupId>com.microsoft.sqlserver</groupId>
            <artifactId>mssql-jdbc</artifactId>
            <version>12.4.2.jre11</version>
        </dependency>
        <!-- Thêm các dependency khác -->
    </dependencies>
</project>
```

---

### 💬 Hội thoại 2: Thiết kế Database ERD

**User:**
Giúp mình thiết kế database cho trang Shopee clone. Cần có: User, Product, Shop, Order, Cart, Category, Review

**ChatGPT:**
Đây là thiết kế ERD cho hệ thống e-commerce:

**Bảng Users:**
```sql
CREATE TABLE users (
    id INT IDENTITY(1,1) PRIMARY KEY,
    username NVARCHAR(100),
    email NVARCHAR(200) UNIQUE NOT NULL,
    password NVARCHAR(500) NOT NULL,
    full_name NVARCHAR(200),
    phone NVARCHAR(20),
    role NVARCHAR(20) DEFAULT 'CUSTOMER',
    wallet DECIMAL(15,2) DEFAULT 0,
    is_deleted BIT DEFAULT 0,
    created_at DATETIME DEFAULT GETDATE()
);
```

**Bảng Products:**
```sql
CREATE TABLE products (
    id INT IDENTITY(1,1) PRIMARY KEY,
    shop_id INT FOREIGN KEY REFERENCES shops(id),
    name NVARCHAR(500) NOT NULL,
    description NVARCHAR(MAX),
    price DECIMAL(15,2),
    image_url NVARCHAR(1000),
    category_id INT FOREIGN KEY REFERENCES categories(id),
    is_deleted BIT DEFAULT 0,
    created_at DATETIME DEFAULT GETDATE()
);
```

**Bảng Product_Variants (để hỗ trợ nhiều size/màu):**
```sql
CREATE TABLE product_variants (
    id INT IDENTITY(1,1) PRIMARY KEY,
    product_id INT FOREIGN KEY REFERENCES products(id),
    color NVARCHAR(100),
    size NVARCHAR(50),
    price DECIMAL(15,2),
    stock INT DEFAULT 0
);
```

Mình tách `product_variants` riêng vì 1 sản phẩm có thể có nhiều biến thể (màu, size), mỗi biến thể có giá và tồn kho riêng.

**User:**
Quan hệ giữa Order và Product thế nào? Tại sao không JOIN thẳng?

**ChatGPT:**
Rất hay! Vì 1 đơn hàng có thể chứa nhiều sản phẩm, và 1 sản phẩm có thể nằm trong nhiều đơn hàng → đây là quan hệ **N-N (Many-to-Many)**. Phải tạo bảng trung gian:

```sql
CREATE TABLE orders (
    id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT FOREIGN KEY REFERENCES users(id),
    total_price DECIMAL(15,2),
    status NVARCHAR(20) DEFAULT 'PENDING',
    is_deleted BIT DEFAULT 0,
    created_at DATETIME DEFAULT GETDATE()
);

CREATE TABLE order_items (
    id INT IDENTITY(1,1) PRIMARY KEY,
    order_id INT FOREIGN KEY REFERENCES orders(id),
    variant_id INT FOREIGN KEY REFERENCES product_variants(id),
    quantity INT,
    price_at_purchase DECIMAL(15,2)   -- Lưu giá tại thời điểm mua
);
```

Trường `price_at_purchase` rất quan trọng: nếu sau này shop thay đổi giá sản phẩm, đơn hàng cũ vẫn giữ nguyên giá lúc mua.

---

### 💬 Hội thoại 3: Tạo DBContext kết nối SQL Server

**User:**
Viết cho mình class DBContext để kết nối SQL Server, dùng file db.properties để config

**ChatGPT:**
```java
package dal;

import java.sql.Connection;
import java.sql.DriverManager;
import java.io.InputStream;
import java.util.Properties;

public class DBContext {
    protected Connection getConnection() throws Exception {
        Properties props = new Properties();
        InputStream input = getClass().getClassLoader()
            .getResourceAsStream("db.properties");
        props.load(input);

        String url = props.getProperty("db.url");
        String user = props.getProperty("db.user");
        String pass = props.getProperty("db.password");

        Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        return DriverManager.getConnection(url, user, pass);
    }
}
```

File `db.properties`:
```properties
db.url=jdbc:sqlserver://localhost:1433;databaseName=shopeeweb_lab211;encrypt=false
db.user=sa
db.password=zxczxc123
```

Mình tách config ra file riêng để khi deploy lên máy khác chỉ cần sửa 1 file, không cần sửa code Java.

**User:**
Tại sao dùng Properties thay vì hardcode?

**ChatGPT:**
3 lý do:
1. **Bảo mật**: Không để password trong source code (nếu push lên GitHub sẽ bị lộ)
2. **Linh hoạt**: Mỗi máy có username/password SQL Server khác nhau, chỉ cần sửa file `.properties`
3. **Best practice**: Đây là cách chuẩn trong Java Enterprise, tách configuration khỏi code

---

*Kết thúc tuần 1-2: Đã hoàn thành cấu trúc project Maven, thiết kế 7 bảng Database, và class DBContext kết nối SQL Server.*
