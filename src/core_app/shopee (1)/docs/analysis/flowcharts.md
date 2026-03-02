# Business Flowcharts (Lược đồ thuật toán)

## 1. Checkout & Giảm Kho (Flash Sale Simulation)

Đây là thuật toán quan trọng nhất để xử lý xung đột trong Database khi Simulator gửi hàng nghìn request cùng lúc (Stress Test).

```mermaid
graph TD
    A[Simulator Gửi Request POST /checkout] --> B(Servlet: Nhận Request)
    B --> C{Bắt đầu Transaction JDBC}
    
    %% Kháo dòng trong Database để tránh Race Condition
    C -->|SELECT ... FOR UPDATE| D[Kiểm tra Stock hiện tại của Variant]
    
    D --> E{Stock >= Số lượng mua?}
    
    E -->|No| F[Rollback Transaction]
    F --> G[Trả về HTTP 400: Hết Hàng]
    
    E -->|Yes| H[Trừ Stock trong DB: UPDATE product_variants SET stock = stock - quantity]
    H --> I[Tạo Order mới: INSERT INTO orders]
    I --> J[Tạo Order Item: INSERT INTO order_items]
    
    J --> K{Commit Transaction}
    K --> L[Trả về HTTP 200: Đặt Hàng Thành Công]
```

## 2. Luồng Migration (ETL - Import Data)

```mermaid
graph TD
    A[Bắt đầu Import] --> B[Đọc file shops.csv]
    B --> C[Lưu List Shops vào đối tượng Java]
    
    C --> D[Đọc file products.csv]
    D --> E[Lưu List Products vào đối tượng Java]
    
    E --> F[Đọc file product_variants.csv]
    F --> G[Lưu List Variants]
    
    G --> H{Mở Connection DB dùng Batch Processing}
    H --> I[Execute Batch INSERT Shops]
    I --> J[Execute Batch INSERT Products]
    J --> K[Execute Batch INSERT Variants]
    
    K --> L[Kết thúc, báo cáo thành công]
```
