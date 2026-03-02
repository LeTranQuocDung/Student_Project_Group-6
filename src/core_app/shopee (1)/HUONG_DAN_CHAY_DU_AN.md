# 🛒 Hướng Dẫn Cài Đặt & Chạy Dự Án: ShopeeWeb (Shopee Clone)

Dự án bao gồm **3 thành phần chính**:
- **Project A** — Java Web App (Servlet/JSP) chạy trên Apache Tomcat 10
- **ShopeeApp** — Ứng dụng Mobile (React Native / Expo)
- **Project B Simulator** — Tool Python giả lập stress-test Flash Sale

---

## ⚡ CÁCH NHANH NHẤT (Dành cho người không biết code)

> **Chỉ cần 1 bước duy nhất:**
> 
> Nhấp đúp vào file **`NHAN_DE_CHAY.bat`** — Script sẽ **TỰ ĐỘNG LÀM TẤT CẢ**:
>    - ✅ **Tự cài JDK 17** nếu chưa có (qua winget)
>    - ✅ **Tự cài Maven** nếu chưa có (tải + cấu hình PATH)
>    - ✅ **Tự cài Python** nếu chưa có (qua winget)
>    - ✅ **Tự cài SQL Server Express** nếu chưa có (qua winget)
>    - ✅ **Tự cấu hình SQL Server** (bật Mixed Auth, TCP/IP, kích hoạt SA)
>    - ✅ **Tự phát hiện** server name và mật khẩu SA
>    - ✅ **Tự cập nhật** file cấu hình kết nối database
>    - ✅ Tạo Database + bảng tự động
>    - ✅ Sinh 12.000 sản phẩm mẫu
>    - ✅ Import dữ liệu vào Database
>    - ✅ Build project
>    - ✅ Khởi động server
>    - ✅ Tự mở trình duyệt vào trang chủ!
> 
> **Không cần cài gì trước! Chỉ cần có Internet.**
> 
> **Sau khi chạy xong** → Trình duyệt tự mở: **http://localhost:8080/home**

*Nếu muốn tìm hiểu chi tiết từng bước, đọc tiếp bên dưới.*

---

## 📋 Yêu Cầu Hệ Thống (Cài trước khi bắt đầu)

| Phần mềm | Phiên bản tối thiểu | Link tải |
|---|---|---|
| **JDK** | 17 trở lên | [Oracle JDK](https://www.oracle.com/java/technologies/downloads/) hoặc [OpenJDK](https://adoptium.net/) |
| **Apache Maven** | 3.8+ | [maven.apache.org](https://maven.apache.org/download.cgi) |
| **SQL Server** | 2019+ (hoặc Express) | [SQL Server Downloads](https://www.microsoft.com/en-us/sql-server/sql-server-downloads) |
| **SQL Server Management Studio (SSMS)** | Bất kỳ | [SSMS Download](https://learn.microsoft.com/en-us/sql/ssms/download-sql-server-management-studio-ssms) |
| **Python** | 3.8+ | [python.org](https://www.python.org/downloads/) |
| **Node.js** *(cho Mobile App)* | 18+ | [nodejs.org](https://nodejs.org/) |
| **Git** *(khuyến khích)* | Bất kỳ | [git-scm.com](https://git-scm.com/) |

### ⚙️ Kiểm tra cài đặt

Mở **PowerShell** hoặc **CMD** và chạy lần lượt:

```bash
java -version        # Phải thấy: openjdk version "17.x.x" hoặc cao hơn
mvn -version         # Phải thấy: Apache Maven 3.x.x
python --version     # Phải thấy: Python 3.x.x
node -v              # Phải thấy: v18.x.x hoặc cao hơn (nếu cần chạy Mobile App)
```

> **Lưu ý quan trọng**: Đảm bảo `JAVA_HOME` và `MAVEN_HOME` (hoặc `M2_HOME`) đã được thêm vào biến môi trường `PATH` của hệ thống.

---

## 🗄️ Bước 1: Khởi Tạo Cơ Sở Dữ Liệu (SQL Server)

### 1.1. Tạo Database

1. Mở **SQL Server Management Studio (SSMS)**.
2. Kết nối đến SQL Server local với thông tin:
   - **Server**: `localhost,1433` (hoặc `localhost\SQLEXPRESS` nếu dùng Express)
   - **Login**: `sa`
   - **Password**: mật khẩu SA của bạn (mặc định: `zxczxc123`)
   
   > ⚠️ **Nếu bạn dùng mật khẩu `sa` khác**, sửa mật khẩu trong file:
   > `src/core_app/db.properties` (dòng `db.password=...`).
   > Hoặc nếu dùng `NHAN_DE_CHAY.bat`, script sẽ tự hỏi mật khẩu.

3. Tạo database mới:
   ```sql
   CREATE DATABASE shopeeweb_lab211;
   ```

4. Chạy script khởi tạo bảng:
   - Mở và thực thi file: `src/core_app/init_sqlserver.sql`

### 1.2. Sinh Dữ Liệu Mẫu (12.000 sản phẩm)

Mở **PowerShell** tại thư mục gốc project (nơi chứa file này) và chạy:

```bash
python data/shopee_scraper.py
```

> Script sẽ tự sinh ~12,000 sản phẩm với ảnh mẫu từ [Picsum](https://picsum.photos), lưu vào thư mục `data/`.

### 1.3. Import Dữ Liệu Vào Database

```bash
cd src\core_app
mvn clean compile exec:java -Dexec.mainClass="migration.SqlServerImport"
```

> Script này sẽ đọc các file CSV từ thư mục `data/` và import vào database `shopeeweb_lab211`.

---

## 🚀 Bước 2: Build & Chạy Web Server (Java Web)

Dự án đã đính kèm sẵn **Apache Tomcat 10.1.19** trong thư mục `src/core_app/tomcat_dir/`, bạn **không cần tải Tomcat riêng**.

### Cách 1: Chạy bằng file tự động (Khuyến nghị ✅)

Nhấp đúp vào file **`RUNB2.bat`** ở thư mục gốc project.

Script sẽ tự động:
1. Tắt Tomcat cũ (nếu đang chạy)
2. Build project bằng Maven (`mvn clean package`)
3. Deploy file WAR vào Tomcat
4. Khởi động server

> Khi thấy dòng `Server startup in...` → Server đã sẵn sàng!

### Cách 2: Chạy thủ công bằng Terminal

```bash
# 1. Di chuyển vào thư mục core_app
cd src\core_app

# 2. Build project thành file .war
mvn package

# 3. Copy WAR vào Tomcat
Copy-Item -Force "target\shopee-web-1.0-SNAPSHOT.war" "tomcat_dir\apache-tomcat-10.1.19\webapps\ROOT.war"

# 4. Khởi động Tomcat (giữ cửa sổ log)
& ".\tomcat_dir\apache-tomcat-10.1.19\bin\catalina.bat" run
```

> Để tắt server: nhấn `Ctrl+C` trong cửa sổ Terminal.
> Nếu muốn chạy server ngầm, thay `catalina.bat run` bằng `startup.bat`.

### 🌐 Truy Cập Website

Khi server đã khởi động thành công, mở trình duyệt:

| Trang | URL |
|---|---|
| **Trang chủ Shopee** | [http://localhost:8080/home](http://localhost:8080/home) |
| **Tìm kiếm sản phẩm** | [http://localhost:8080/search?txt=iphone](http://localhost:8080/search?txt=iphone) |

### 🔑 Tài Khoản Mặc Định

| Vai trò | Username | Password |
|---|---|---|
| Admin | `admin` | `admin123` |

### 🤖 Cấu Hình AI Gemini Chat (Shopee AI)

Tính năng tư vấn AI yêu cầu **API Key** của Google Gemini:
- Các API key đã được cấu hình sẵn trong file:
  `src/core_app/src/main/webapp/shopee_home.jsp`
  *(Gồm 3 key tự động xoay vòng khi hết hạn mức 429)*
- Bạn có thể mở file trên để thay thế hoặc thêm key mới nếu cần.

---

## 📱 Bước 3: Chạy Ứng Dụng Mobile (ShopeeApp - React Native / Expo)

### 3.1. Cài đặt dependencies

```bash
cd ShopeeApp
npm install
```

### 3.2. Cấu hình API Server

Mở file `ShopeeApp/config.js` và thay đổi `API_BASE` cho phù hợp:

```javascript
// Khi test trên cùng mạng WiFi — thay bằng IP máy chạy server
// Chạy "ipconfig" trong CMD để xem IP LAN của bạn
export const API_BASE = 'http://192.168.1.xxx:8080';

// Khi đã deploy lên server thật
// export const API_BASE = 'https://your-domain.com';
```

> 💡 **Mẹo**: Chạy `ipconfig` trong CMD → tìm dòng `IPv4 Address` → đó là IP cần điền.

### 3.3. Chạy app

```bash
npx expo start
```

- Quét mã QR bằng app **Expo Go** trên điện thoại (cùng mạng WiFi).
- Hoặc nhấn `a` để mở trên Android Emulator, `w` để mở trên trình duyệt.

### 3.4. Build APK (để chia sẻ cho người khác)

```bash
# Cài EAS CLI (nếu chưa có)
npm install -g eas-cli

# Đăng nhập Expo
eas login

# Build APK cho Android
eas build --platform android --profile preview
```

> File APK sẽ được tải về từ link Expo cung cấp sau khi build xong.

---

## 🧪 Bước 4: Chạy Stress Test (Project B Simulator)

Tool giả lập 100 user mua hàng Flash Sale cùng lúc để kiểm tra khả năng chịu tải của server.

### 4.1. Cài đặt thư viện Python

```bash
pip install requests
```

### 4.2. Chạy test

```bash
cd ProjectB_Simulator
python stress_test.py
```

> **Yêu cầu**: Server Tomcat phải đang chạy tại `http://localhost:8080`.

**Kết quả kỳ vọng**: Terminal sẽ hiển thị:
- ✅ Server chạy an toàn — nếu không có lỗi
- ⚠️ Cảnh báo "Kho bị âm (Negative Stock)" — nếu phát hiện race condition

---

## 📁 Cấu Trúc Thư Mục Project

```
ShopeeWeb/
├── 📄 HUONG_DAN_CHAY_DU_AN.md    ← File hướng dẫn này
├── 📄 README.md                   ← Mô tả tổng quan dự án
├── 🟢 NHAN_DE_CHAY.bat           ← ⚡ NHẤP ĐÚP ĐỂ CHẠY TẤT CẢ (1 click)
├── 📄 RUNB2.bat                   ← Script build & run (khi đã có DB)
│
├── 📂 src/
│   └── 📂 core_app/               ← 🔧 Project A: Java Web App
│       ├── 📄 pom.xml              ← Cấu hình Maven & dependencies
│       ├── 📄 init_sqlserver.sql   ← Script tạo bảng (SQL Server)
│       ├── 📂 src/main/java/       ← Source code Java (Servlet, DAO, Model...)
│       ├── 📂 src/main/webapp/     ← Giao diện JSP, CSS, JS
│       └── 📂 tomcat_dir/          ← Apache Tomcat 10.1.19 (đính kèm sẵn)
│
├── 📂 ShopeeApp/                   ← 📱 Ứng dụng Mobile (React Native / Expo)
│   ├── 📄 App.js                   ← Entry point
│   ├── 📄 config.js                ← Cấu hình API server
│   ├── 📂 screens/                 ← Các màn hình (Home, Login, Account, QR Scan)
│   └── 📄 package.json             ← Dependencies
│
├── 📂 data/                        ← 📊 Dữ liệu mẫu
│   ├── 📄 shopee_scraper.py        ← Script sinh 12,000 sản phẩm
│   ├── 📄 products.csv             ← Dữ liệu sản phẩm
│   ├── 📄 product_variants.csv     ← Dữ liệu biến thể (size, màu)
│   └── 📄 shops.csv                ← Dữ liệu shop
│
├── 📂 ProjectB_Simulator/          ← 🧪 Tool Stress Test
│   └── 📄 stress_test.py           ← Script test 100 user concurrent
│
├── 📂 docs/                        ← 📚 Tài liệu phân tích
│   ├── 📂 analysis/                ← ERD, Flowchart
│   └── 📂 ai_logs/                 ← Nhật ký giao tiếp AI
│
└── 📂 cart-ui/                     ← 🛒 Giao diện giỏ hàng (HTML/JS)
```

---

## ❓ Xử Lý Lỗi Thường Gặp

### 1. ❌ `mvn` không nhận lệnh
```
'mvn' is not recognized as an internal or external command
```
→ Thêm đường dẫn Maven vào biến môi trường `PATH`. Ví dụ: `C:\maven\bin`.

### 2. ❌ Không kết nối được SQL Server
```
com.microsoft.sqlserver.jdbc.SQLServerException: Login failed
```
→ Kiểm tra:
- SQL Server đã bật **TCP/IP** trên port `1433` (mở SQL Server Configuration Manager).
- Tài khoản `sa` đã được kích hoạt và mật khẩu đúng.
- Mở file `src/core_app/db.properties` và sửa `db.password=` cho đúng mật khẩu SA của bạn.

### 3. ❌ Port 8080 đã bị chiếm
```
java.net.BindException: Address already in use
```
→ Tắt ứng dụng đang dùng port 8080, hoặc thay đổi port trong file:
`src/core_app/tomcat_dir/apache-tomcat-10.1.19/conf/server.xml` (tìm `Connector port="8080"`).

### 4. ❌ Build Maven thất bại
→ Kiểm tra:
- JDK 17 đã cài đúng (`java -version`).
- Có kết nối Internet (Maven cần tải dependencies lần đầu).
- Chạy `mvn clean package` để xem chi tiết lỗi.

### 5. ❌ Mobile App không kết nối được server
→ Kiểm tra:
- Điện thoại và máy tính **cùng mạng WiFi**.
- Đã đổi `API_BASE` trong `ShopeeApp/config.js` thành **IP LAN** của máy tính (không phải `localhost`).
- Server Tomcat đang chạy.

---

## 🔗 Thông Tin Bổ Sung

- **Công nghệ Backend**: Java 17 + Servlet/JSP + Apache Tomcat 10.1.19
- **Database**: SQL Server (mặc định) / MySQL (tùy chọn)
- **Frontend Web**: HTML5, CSS3, JavaScript (thuần)
- **Mobile App**: React Native + Expo SDK 55
- **Password Hashing**: Argon2 (thay thế MD5)
- **AI Chat**: Google Gemini 2.5 Flash API
- **Email Service**: Jakarta Mail API

---

> 📌 **Mọi thắc mắc**, vui lòng liên hệ người phát triển dự án hoặc tạo Issue trên GitHub.
