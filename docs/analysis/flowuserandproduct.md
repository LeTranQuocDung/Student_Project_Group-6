THIẾT KẾ HỆ THỐNG: MODULE USER & PRODUCT

```mermaid
## 1. Flowchart Quy trình Đăng nhập (Login Process)
    flowchart TD
    Start([Bắt đầu]) --> Input[/Người dùng nhập User & Pass/]
    Input --> CheckEmpty{Dữ liệu rỗng?}
    
    CheckEmpty -- Có --> Error1[Thông báo: Vui lòng nhập đủ]
    Error1 --> Input
    
    CheckEmpty -- Không --> QueryDB[(Query Database Users)]
    QueryDB --> CheckValid{User/Pass đúng?}
    
    CheckValid -- Sai --> Error2[Thông báo: Sai tài khoản]
    Error2 --> Input
    
    CheckValid -- Đúng --> CheckRole{Kiểm tra Role}
    
    CheckRole -- Admin --> RedirectAdmin[Chuyển hướng: Admin Dashboard]
    CheckRole -- Customer --> RedirectHome[Chuyển hướng: Trang chủ]
    
    RedirectAdmin --> End([Kết thúc])
    RedirectHome --> End

## 2. Flowchart Tìm kiếm & Xem Sản phẩm (User View)
    flowchart TD
    Start([Bắt đầu]) --> LoadAll[(Load toàn bộ SP từ DB)]
    LoadAll --> DisplayAll[Hiển thị danh sách SP]
    
    DisplayAll --> UserAction{Hành động User}
    
    %% Nhánh tìm kiếm
    UserAction -- Tìm kiếm --> InputSearch[/Nhập từ khóa vào ô Search/]
    InputSearch --> CheckNull{Từ khóa rỗng?}
    
    CheckNull -- Có (Rỗng) --> DisplayAll
    CheckNull -- Không (Có chữ) --> QuerySearch[(SELECT... WHERE Name LIKE %...%)]
    
    QuerySearch --> CheckResult{Có kết quả không?}
    CheckResult -- Không --> MsgEmpty[Hiện thông báo: Không tìm thấy]
    CheckResult -- Có --> DisplayFilter[Hiển thị danh sách đã lọc]
    
    MsgEmpty --> UserAction
    DisplayFilter --> UserAction
    
    %% Nhánh xem chi tiết
    UserAction -- Click ảnh SP --> ViewDetail[Chuyển sang trang Product Detail]
    ViewDetail --> End([Kết thúc])

## 3. Flowchart Quản lý Sản phẩm (Admin CRUD)
    flowchart TD
    Start([Start Admin]) --> ViewList[Xem danh sách Sản phẩm]
    ViewList --> Action{Chọn chức năng}
    
    %% Chức năng Thêm
    Action -- Thêm mới --> InputInfo[/Nhập: Tên, Giá, Ảnh, Tồn kho/]
    InputInfo --> Validate{Dữ liệu hợp lệ?}
    Validate -- Sai (Giá âm/Thiếu tên) --> ErrorMsg[Báo lỗi] --> InputInfo
    Validate -- Đúng --> InsertDB[(INSERT INTO Products)]
    InsertDB --> Success[Thông báo thành công]
    
    %% Chức năng Xóa
    Action -- Xóa --> SelectItem[Chọn SP cần xóa]
    SelectItem --> Confirm{Xác nhận xóa?}
    Confirm -- Không --> ViewList
    Confirm -- Có --> DeleteDB[(DELETE FROM Products)]
    DeleteDB --> Success
    
    Success --> ViewList

## 4.Class Diagram (Sơ đồ lớp - User & Product)
    classDiagram
    %% Class User đại diện cho bảng Users
    class User {
        -int userID
        -String username
        -String password
        -String fullName
        -String email
        -String role
        +boolean login(String user, String pass)
        +boolean register()
        +boolean isAdmin()
    }

    %% Class Product đại diện cho bảng Products
    class Product {
        -int productID
        -String productName
        -double price
        -int stockQuantity
        -String imageURL
        -String description
        +List~Product~ searchProduct(String keyword)
        +boolean checkStock()
    }

    %% Class Controller dùng để quản lý logic
    class ProductManagement {
        +void addProduct(Product p)
        +void updateProduct(Product p)
        +void deleteProduct(int id)
    }

    %% Quan hệ
    User ..> ProductManagement : uses (if Admin)
    ProductManagement --> Product : manages