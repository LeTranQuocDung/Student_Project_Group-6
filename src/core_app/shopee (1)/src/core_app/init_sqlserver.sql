USE shopeeweb_lab211;
GO

-- Chỉ tạo bảng nếu CHƯA tồn tại (KHÔNG DROP để giữ dữ liệu cũ)

IF OBJECT_ID('dbo.users', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.users (
        id INT IDENTITY(1,1) PRIMARY KEY,
        username NVARCHAR(50) NOT NULL UNIQUE,
        password NVARCHAR(255) NOT NULL,
        full_name NVARCHAR(100) NOT NULL,
        role VARCHAR(20) DEFAULT 'CUSTOMER' CHECK(role IN ('CUSTOMER', 'SELLER', 'ADMIN')),
        created_at DATETIME DEFAULT GETDATE(),
        email NVARCHAR(100),
        phone NVARCHAR(20),
        wallet DECIMAL(10,2) DEFAULT 0,
        note NVARCHAR(MAX)
    );
    PRINT N'✅ Đã tạo bảng users';
END
ELSE
    PRINT N'✅ Bảng users đã tồn tại - giữ nguyên dữ liệu';
GO

IF OBJECT_ID('dbo.categories', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.categories (
        id INT IDENTITY(1,1) PRIMARY KEY,
        name NVARCHAR(100) NOT NULL,
        image_url NVARCHAR(255)
    );
    PRINT N'✅ Đã tạo bảng categories';
    
    -- Insert mock data array
    SET IDENTITY_INSERT dbo.categories ON;
    INSERT INTO dbo.categories (id, name, image_url) VALUES 
        (1, N'Thời Trang Nam', 'images/cat_thoi_trang_nam.webp'),
        (2, N'Điện Thoại & Phụ Kiện', 'images/cat_dien_thoai.webp'),
        (3, N'Thiết Bị Điện Tử', 'images/cat_thiet_bi_dien_tu.webp'),
        (4, N'Máy Tính & Laptop', 'images/cat_may_tinh_laptop.webp'),
        (5, N'Máy Ảnh & Máy Quay Phim', 'images/cat_may_anh.webp'),
        (6, N'Đồng Hồ', 'images/cat_dong_ho.webp'),
        (7, N'Giày Dép Nam', 'images/cat_giay_dep_nam.webp'),
        (8, N'Thiết Bị Điện Gia Dụng', 'images/cat_thiet_bi_gia_dung.webp'),
        (9, N'Thể Thao & Du Lịch', 'images/cat_the_thao.webp'),
        (10, N'Ô Tô & Xe Máy & Xe Đạp', 'images/cat_oto_xe_may.webp'),
        (11, N'Thời Trang Nữ', 'images/cat_thoi_trang_nu.webp'),
        (12, N'Mẹ & Bé', 'images/cat_me_be.webp'),
        (13, N'Nhà Cửa & Đời Sống', 'images/cat_nha_cua.webp'),
        (14, N'Sắc Đẹp', 'images/cat_sac_dep.webp'),
        (15, N'Sức Khỏe', 'images/cat_suc_khoe.webp'),
        (16, N'Giày Dép Nữ', 'images/cat_giay_dep_nu.webp'),
        (17, N'Túi Ví Nữ', 'images/cat_tui_vi_nu.webp'),
        (18, N'Phụ Kiện & Trang Sức Nữ', 'images/cat_phu_kien_nu.webp'),
        (19, N'Bách Hóa Online', 'images/cat_bach_hoa.webp'),
        (20, N'Nhà Sách Online', 'images/cat_nha_sach.webp');
    SET IDENTITY_INSERT dbo.categories OFF;
    PRINT N'✅ Đã thêm dữ liệu mẫu vào categories';
END
ELSE
    PRINT N'✅ Bảng categories đã tồn tại - giữ nguyên dữ liệu';
GO

IF OBJECT_ID('dbo.shops', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.shops (
        id INT IDENTITY(1,1) PRIMARY KEY,
        owner_id INT NOT NULL,
        shop_name NVARCHAR(100) NOT NULL,
        rating DECIMAL(2,1) DEFAULT 0.0,
        created_at DATETIME DEFAULT GETDATE(),
        FOREIGN KEY (owner_id) REFERENCES dbo.users(id) ON DELETE CASCADE
    );
    PRINT N'✅ Đã tạo bảng shops';
END
ELSE
    PRINT N'✅ Bảng shops đã tồn tại - giữ nguyên dữ liệu';
GO

IF OBJECT_ID('dbo.products', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.products (
        id INT IDENTITY(1,1) PRIMARY KEY,
        shop_id INT NOT NULL,
        name NVARCHAR(255) NOT NULL,
        description NVARCHAR(MAX),
        price DECIMAL(10,2) NOT NULL,
        image_url NVARCHAR(255),
        created_at DATETIME DEFAULT GETDATE(),
        FOREIGN KEY (shop_id) REFERENCES dbo.shops(id) ON DELETE CASCADE
    );
    PRINT N'✅ Đã tạo bảng products';
END
ELSE
    PRINT N'✅ Bảng products đã tồn tại - giữ nguyên dữ liệu';
GO

IF OBJECT_ID('dbo.product_variants', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.product_variants (
        id INT IDENTITY(1,1) PRIMARY KEY,
        product_id INT NOT NULL,
        color NVARCHAR(50),
        size NVARCHAR(10),
        stock INT NOT NULL DEFAULT 0,
        price DECIMAL(10,2) NOT NULL,
        note NVARCHAR(255),
        FOREIGN KEY (product_id) REFERENCES dbo.products(id) ON DELETE CASCADE
    );
    PRINT N'✅ Đã tạo bảng product_variants';
END
ELSE
    PRINT N'✅ Bảng product_variants đã tồn tại - giữ nguyên dữ liệu';
GO

IF OBJECT_ID('dbo.orders', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.orders (
        id INT IDENTITY(1,1) PRIMARY KEY,
        user_id INT NOT NULL,
        total_price DECIMAL(10,2) NOT NULL,
        status VARCHAR(20) DEFAULT 'PENDING' CHECK (status IN ('PENDING', 'PAID', 'SHIPPED', 'COMPLETED', 'CANCELLED')),
        created_at DATETIME DEFAULT GETDATE(),
        FOREIGN KEY (user_id) REFERENCES dbo.users(id) ON DELETE CASCADE
    );
    PRINT N'✅ Đã tạo bảng orders';
END
ELSE
    PRINT N'✅ Bảng orders đã tồn tại - giữ nguyên dữ liệu';
GO

IF OBJECT_ID('dbo.order_items', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.order_items (
        id INT IDENTITY(1,1) PRIMARY KEY,
        order_id INT NOT NULL,
        variant_id INT NOT NULL,
        quantity INT NOT NULL,
        price_at_purchase DECIMAL(10,2) NOT NULL,
        FOREIGN KEY (order_id) REFERENCES dbo.orders(id) ON DELETE CASCADE,
        FOREIGN KEY (variant_id) REFERENCES dbo.product_variants(id)
    );
    PRINT N'✅ Đã tạo bảng order_items';
END
ELSE
    PRINT N'✅ Bảng order_items đã tồn tại - giữ nguyên dữ liệu';
GO

-- Migration: Thêm cột gender và date_of_birth nếu chưa có
IF COL_LENGTH('dbo.users', 'gender') IS NULL
BEGIN
    ALTER TABLE dbo.users ADD gender NVARCHAR(10);
    PRINT N'✅ Đã thêm cột gender vào bảng users';
END
ELSE
    PRINT N'✅ Cột gender đã tồn tại - giữ nguyên';
GO

IF COL_LENGTH('dbo.users', 'date_of_birth') IS NULL
BEGIN
    ALTER TABLE dbo.users ADD date_of_birth DATE;
    PRINT N'✅ Đã thêm cột date_of_birth vào bảng users';
END
ELSE
    PRINT N'✅ Cột date_of_birth đã tồn tại - giữ nguyên';
GO

-- Chỉ thêm admin nếu chưa có
IF NOT EXISTS (SELECT 1 FROM dbo.users WHERE username = 'admin')
BEGIN
    INSERT INTO dbo.users (username, password, full_name, role) VALUES ('admin', 'admin123', 'System Admin', 'ADMIN');
    PRINT N'✅ Đã tạo tài khoản admin mặc định';
END
ELSE
    PRINT N'✅ Tài khoản admin đã tồn tại - giữ nguyên';
GO
