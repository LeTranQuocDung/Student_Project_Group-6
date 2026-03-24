# Project Proposal: ShopeeWeb (E-Commerce Simulation)

## 1. Tóm tắt dự án (Project Overview)
**ShopeeWeb** là một hệ thống mô phỏng ứng dụng thương mại điện tử (Shopee Clone) được phát triển nhằm mục tiêu học tập và nghiên cứu kiến trúc hệ thống phân tán, xử lý tải cao (high-concurrency) và thiết kế cơ sở dữ liệu cho mô hình sàn giao dịch thương mại điện tử.

Dự án không chỉ dừng lại ở một ứng dụng Web bán hàng cơ bản mà còn mở rộng với nền tảng Mobile App và công cụ giả lập kiểm tra sức chịu tải của hệ thống (mô phỏng sự kiện Flash Sale).

## 2. Kiến trúc hệ thống (System Architecture)
Hệ thống bao gồm 3 thành phần (module) chính:

1. **Project A - Core Web Application (Admin & User Portal)**
   - **Vai trò:** Xử lý nghiệp vụ chính, quản lý dữ liệu người dùng, cửa hàng, sản phẩm, đơn hàng, giỏ hàng và thanh toán.
   - **Công nghệ:** Java Web (Servlet/JSP), Apache Tomcat 10, MySQL/SQL Server.
   - **Giao diện:** HTML5, CSS3, JavaScript (hoạt động độc lập bằng Vanilla JS/CSS).

2. **Project B - Simulator (Stress Testing Tool)**
   - **Vai trò:** Công cụ tự động hóa gửi hàng ngàn HTTP requests đồng thời để giả lập hành vi mua hàng tranh giành (Race Condition) trong các sự kiện Flash Sale.
   - **Công nghệ:** Python, Thư viện `requests` và `threading`/`multiprocessing`.

3. **ShopeeApp - Mobile Application (Cross-platform)**
   - **Vai trò:** Ứng dụng mua sắm trên thiết bị di động dành cho người dùng cuối.
   - **Công nghệ:** React Native, Expo SDK.
   - **Kết nối:** Giao tiếp với Core Web Application thông qua RESTful APIs.

## 3. Các tính năng chính (Key Features)

### 3.1. Dành cho Khách hàng (Buyer/User)
- **Xác thực & Bảo mật:** Đăng nhập/Đăng ký qua Form truyền thống (mã hóa Argon2) hoặc qua OAuth2 (Google, Facebook).
- **Mua sắm & Tìm kiếm:** Tích hợp bộ máy tìm kiếm (Full-text search), lọc theo danh mục, mức giá.
- **Giỏ hàng & Thanh toán:** Quản lý giỏ hàng (`Cart`, `CartItem`), thanh toán nội bộ thông qua ví ảo (`Wallet`).
- **Đánh giá sản phẩm:** Chức năng Review sản phẩm, đánh giá sao, và tùy chọn tải lên hình ảnh minh chứng.
- **AI Chatbot (Shopee AI):** Tích hợp Google Gemini 2.5 Flash API để tư vấn sản phẩm trực tiếp.

### 3.2. Dành cho Người bán (Seller/Shop)
- **Quản lý Cửa hàng (`Shop`):** Đăng ký mở shop, xem chi tiết thống kê lượt theo dõi (Followers), tỉ lệ phản hồi (Response Rate).
- **Quản lý Sản phẩm (`Product`):** Thêm, sửa, xóa các sản phẩm thuộc shop. Quản lý danh mục (`Category`).

### 3.3. Dành cho Quản trị viên (Admin/Super Admin)
- **Phân quyền nâng cao (RBAC):** Quản lý quyền truy cập dựa trên Role và Permissions (Quản lý User, Quản lý Sản phẩm, Quản lý Hệ thống).
- **Audit Logs:** Theo dõi các hoạt động quan trọng trong hệ thống để phục hồi hoặc đối soát.

## 4. Công nghệ & Công cụ (Tech Stack)
- **Backend:** Java 17, Servlet 5.0, JSP, JDBC, Jakarta Mail, Argon2 Password Hashing.
- **Frontend Web:** HTML5, CSS3, JS thuần, Cart UI Components.
- **Mobile Frontend:** React Native, Expo.
- **Database:** MS SQL Server 2019+ / MySQL.
- **AI Integration:** Google Generative AI (Gemini 2.5 Flash API).
- **Testing/Tooling:** Python 3.8, Maven 3.8+, Bash Script (Tự động hóa triển khai).

## 5. Mục tiêu và Kết quả kỳ vọng (Expected Outcomes)
- Xây dựng thành công một hệ thống mô phỏng có khả năng chạy độc lập với cơ sở dữ liệu chứa hơn 10.000+ sản phẩm dòng.
- Xử lý tốt các bài toán về Concurrency Control (Race condition) khi trừ số lượng tồn kho (Inventory) trong lúc Flash Sale qua công cụ Simulator.
- Cung cấp trải nghiệm đa nền tảng nhất quán giữa Web và Mobile App.

## 6. Giới hạn đề tài (Out of scope)
- **Thanh toán:** Hệ thống sử dụng ví điện tử nội bộ giả lập (`Wallet`). Không tích hợp trực tiếp với các cổng thanh toán bên ngoài (VNPay, Momo, PayPal, Stripe, v.v.).
- **Vận chuyển:** Không tích hợp API của các đơn vị vận chuyển thực tế (Giao Hàng Nhanh, J&T, Viettel Post). Quá trình cập nhật trạng thái đơn hàng (Đang giao, Đã giao) sẽ được giả lập và quản lý thử nghiệm qua Admin/Shop portal.
- **Xác thực danh tính thực:** Không yêu cầu eKYC cho người bán. Xác thực dựa trên email hoặc OAuth2 cơ bản.

## 7. Lộ trình phát triển (Timeline & Milestones)
- **Phase 1 (Core Web & DB):** Xây dựng kiến trúc CSDL, hệ thống Backend Java Web, và các tính năng cơ bản (Auth, Products, Giỏ hàng, Đặt hàng).
- **Phase 2 (Mobile App):** Xây dựng ứng dụng mua sắm trên thiết bị di động bằng React Native kết nối với Core API.
- **Phase 3 (Flash Sale & Simulator):** Hoàn thiện tính năng Flash Sale, khóa bi quan/lạc quan (Pessimistic/Optimistic Locking) cho Hàng tồn kho, và chạy script Simulator (Python) bắn tải kiểm thử.
- **Phase 4 (AI Integration & Polish):** Tích hợp Shopbot AI (Gemini), hoàn thiện các tính năng thống kê, audit log và kiểm tra bảo mật cuối cùng.
