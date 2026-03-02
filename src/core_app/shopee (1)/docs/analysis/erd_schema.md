# Database ERD - E-Commerce Simulation (Shopee Model)

## 1. Entities & Relationships

Hệ thống có 4 thực thể chính có quan hệ chéo sâu sắc:
- `users`: Người dùng (có thể là người mua Customer, hoặc chủ Shop).
- `shops`: Cửa hàng, được quản lý bởi 1 user.
- `products`: Sản phẩm thuộc 1 shop.
- `product_variants`: Các biến thể của sản phẩm (màu sắc, size) với số lượng tồn kho (stock) riêng biệt.
- `orders`: Đơn hàng, một user mua nhiều variant khác nhau.
- `order_items`: Chi tiết mỗi variant trong order.

## 2. Table Schemas

### Table: `users`
- `id` (INT, PK, AUTO_INCREMENT)
- `username` (VARCHAR 50, UNIQUE)
- `password` (VARCHAR 255)
- `full_name` (VARCHAR 100)
- `role` (ENUM: 'CUSTOMER', 'SELLER', 'ADMIN')
- `created_at` (TIMESTAMP)

### Table: `shops`
- `id` (INT, PK, AUTO_INCREMENT)
- `owner_id` (INT, FK -> users.id)
- `shop_name` (VARCHAR 100)
- `rating` (DECIMAL 2,1)
- `created_at` (TIMESTAMP)

### Table: `products`
- `id` (INT, PK, AUTO_INCREMENT)
- `shop_id` (INT, FK -> shops.id)
- `name` (VARCHAR 255)
- `description` (TEXT)
- `price` (DECIMAL 10,2) - (Giá gốc dùng để hiển thị mức bé nhất)
- `image_url` (VARCHAR 255)
- `created_at` (TIMESTAMP)

### Table: `product_variants`
- `id` (INT, PK, AUTO_INCREMENT)
- `product_id` (INT, FK -> products.id)
- `color` (VARCHAR 50)
- `size` (VARCHAR 10)
- `stock` (INT) - **(Trường quan trọng nhất để Stress Test, phải xử lý kĩ thuật Khóa/Transaction)**
- `price` (DECIMAL 10,2)
- `note` (VARCHAR 255)

### Table: `orders`
- `id` (INT, PK, AUTO_INCREMENT)
- `user_id` (INT, FK -> users.id)
- `total_price` (DECIMAL 10,2)
- `status` (ENUM: 'PENDING', 'PAID', 'SHIPPED', 'COMPLETED', 'CANCELLED')
- `created_at` (TIMESTAMP)

### Table: `order_items`
- `id` (INT, PK, AUTO_INCREMENT)
- `order_id` (INT, FK -> orders.id)
- `variant_id` (INT, FK -> product_variants.id)
- `quantity` (INT)
- `price_at_purchase` (DECIMAL 10,2)

---
*Bản thiết kế này đáp ứng đủ 5 Tiêu chí sàn của LAB211: có >4 thực thể chéo, xử lý xung đột tồn kho (stock) qua Stress Test.*
