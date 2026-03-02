# Môn học LAB211: Hệ Thống Web Giả Lập Doanh Nghiệp (Shopee Clone)

**Đề tài**: E-Commerce Simulation (Mô hình Shopee)
**Thời lượng dự án**: 10 Tuần
**Công nghệ sử dụng**:
- Ngôn ngữ: Java Web (Servlet/JSP)
- Server: Apache Tomcat
- Database: MySQL
- Giao diện (Front-end): HTML5, CSS3, JavaScript
- Simulator (Client Tool): Java Core (Gửi HTTP Request)

## Cấu trúc Repository (Theo chuẩn LAB211)
```
/ShopeeWeb_Lab211
├── /data            (Chứa thư mục gốc Crawler, cùng dữ liệu sinh tự động >10,000 dòng CSV)
├── /src
│   ├── /core_app    (Project A: Java Web App Tomcat)
│   └── /simulator   (Project B: Java Tool Giả lập Request HTTP Test)
├── /docs
│   ├── /analysis    (Chứa sơ đồ DB ERD, Flowchart)
│   └── /ai_logs     (Chứa nhật ký giao tiếp AI)
└── README.md
```

## Cách thiết lập nhanh
1. Import thư mục `/src/core_app` vào IDE (ví dụ: NetBeans hoặc Eclipse).
2. Chạy CSDL MySQL và tiến hành import theo script SQL (sẽ được thêm vào sau).
3. Đính kèm `Tomcat Server` trong cấu hình biên dịch của IDE.
4. Chạy `python data/shopee_scraper.py` để sinh mock data.

## Kịch bản Giả lập
Đội ngũ sẽ sử dụng công cụ bên trong thư mục `src/simulator` để sinh hàng ngàn (hoặc hàng chục ngàn) luồng dữ liệu giả mạo nhằm mua sản phẩm Flash Sale đồng thời để đánh giá và kiểm tra Transaction Database trên Local.
