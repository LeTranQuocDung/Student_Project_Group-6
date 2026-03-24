# AI Assistance Logs - Tuần 9 & 10: UI/UX & Defense Preparation

## Tuần 9: Nâng cấp Admin Dashboard & UI/UX (Shopee Concept)

Trong tuần này, trợ lý AI (tôi) đã đồng hành cùng developer để hoàn thành đại tu phần cứng và phần mềm cho trang Dashboard quản trị với tiến độ như sau:

1. **Rà soát & Sửa thuật toán thống kê (StatsDAO):**
   - Loại bỏ các câu lệnh T-SQL (như `TOP 7`) không tương thích MySQL.
   - Viết lại câu lệnh chuẩn `SELECT DATE(created_at)... LIMIT 7` để lọc doanh thu theo ngày chân thực nhất.
   - Tính tổng các cột `total_price` thay vì dữ liệu mẫu.

2. **Cập nhật Backend Controller (AdminServlet):**
   - Thay thế toàn bộ mã cứng (Mock Data) bằng dữ liệu Database thực. Mảng `revenueList` được Parse động sang String để khớp cấu trúc JavaScript cho Chart.js.

3. **Restyle Giao Diện `admin.jsp` (100% Shopee Concept):**
   - Áp dụng hệ màu `--shopee-primary: #ee4d2d`.
   - Viết lại Sidebar tĩnh kết hợp CSS Box Shadow cực hiện đại.
   - Tối ưu Chart.js từ dạng tĩnh (Bar) sang biểu đồ diện tích (Area Line) cực kỳ mượt mà có đổ bóng Gradient, mang lại trải nghiệm 5 sao cho người quản trị. 

4. **Nâng cấp trang `admin_import.jsp` (Reset Database):**
   - Áp mã màu Dark/Red nổi bật cho các Action rủi ro (Nút Delete All Database).
   - Xử lý lại đường dẫn forward (`AdminImportServlet`) tránh lỗi nhảy Form. Giao diện console log hiển thị ngầu và an toàn.

5. **Xử lý Fix Bug Tomcat `JasperException` trên môi trường Windows:**
   - Khi dán đè file `.war` lên thư mục chạy của Tomcat, `admin_jsp.class` bị khóa. AI đã hướng dẫn dùng Script PowerShell dọn rác System `Tomcat/work` và Restart thành công tránh dính Cache rác.

---

## Tuần 10: Defense Preparation (Đóng Gói Chấm Điểm)

1. **Tạo tài liệu Báo cáo Update (`docs/ai_logs/tuan9_10.md`):** Ghi lại chi tiết từng Commit/Action của hệ thống.
2. **Package Final version (Tạo file `.war` gốc):** Đảm bảo mọi module (từ Core Model, Service, DAO, Controller JS/JSP) được Build chuẩn qua Maven, tương thích phiên bản Servlet JDK 17 / Tomcat 10. Chạy Load Test không xuất hiện Bug Negative Stock.

Hệ thống Core Web "Clone Shopee" đã chính thức đi đến hồi kết 100% Function! Sẵn sàng bàn giao file nén bảo vệ đồ án.
