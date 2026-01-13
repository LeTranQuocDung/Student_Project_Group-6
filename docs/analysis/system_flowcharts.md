\# CÁC QUY TRÌNH HỆ THỐNG (SYSTEM FLOWCHARTS)



\## 1. Quy trình Đăng nhập (Login Process)

```mermaid

flowchart TD

&nbsp;   Start(\[Bắt đầu]) --> Input\[/Người dùng nhập User \& Pass/]

&nbsp;   Input --> CheckEmpty{Dữ liệu rỗng?}

&nbsp;   

&nbsp;   CheckEmpty -- Có --> Error1\[Thông báo: Vui lòng nhập đủ]

&nbsp;   Error1 --> Input

&nbsp;   

&nbsp;   CheckEmpty -- Không --> QueryDB\[(Query Database Users)]

&nbsp;   QueryDB --> CheckValid{User/Pass đúng?}

&nbsp;   

&nbsp;   CheckValid -- Sai --> Error2\[Thông báo: Sai tài khoản]

&nbsp;   Error2 --> Input

&nbsp;   

&nbsp;   CheckValid -- Đúng --> CheckRole{Kiểm tra Role}

&nbsp;   

&nbsp;   CheckRole -- Admin --> RedirectAdmin\[Chuyển hướng: Admin Dashboard]

&nbsp;   CheckRole -- Customer --> RedirectHome\[Chuyển hướng: Trang chủ]

&nbsp;   

&nbsp;   RedirectAdmin --> End(\[Kết thúc])

&nbsp;   RedirectHome --> End

flowchart TD

&nbsp;   Start(\[Bắt đầu]) --> LoadAll\[(Load toàn bộ SP từ DB)]

&nbsp;   LoadAll --> DisplayAll\[Hiển thị danh sách SP]

&nbsp;   

&nbsp;   DisplayAll --> UserAction{Hành động User}

&nbsp;   

&nbsp;   %% Nhánh tìm kiếm

&nbsp;   UserAction -- Tìm kiếm --> InputSearch\[/Nhập từ khóa vào ô Search/]

&nbsp;   InputSearch --> CheckNull{Từ khóa rỗng?}

&nbsp;   

&nbsp;   CheckNull -- Có (Rỗng) --> DisplayAll

&nbsp;   CheckNull -- Không (Có chữ) --> QuerySearch\[(SELECT... WHERE Name LIKE %...%)]

&nbsp;   

&nbsp;   QuerySearch --> CheckResult{Có kết quả không?}

&nbsp;   CheckResult -- Không --> MsgEmpty\[Hiện thông báo: Không tìm thấy]

&nbsp;   CheckResult -- Có --> DisplayFilter\[Hiển thị danh sách đã lọc]

&nbsp;   

&nbsp;   MsgEmpty --> UserAction

&nbsp;   DisplayFilter --> UserAction

&nbsp;   

&nbsp;   %% Nhánh xem chi tiết

&nbsp;   UserAction -- Click ảnh SP --> ViewDetail\[Chuyển sang trang Product Detail]

&nbsp;   ViewDetail --> End(\[Kết thúc])

flowchart TD

&nbsp;   Start(\[Start Admin]) --> ViewList\[Xem danh sách Sản phẩm]

&nbsp;   ViewList --> Action{Chọn chức năng}

&nbsp;   

&nbsp;   %% Chức năng Thêm

&nbsp;   Action -- Thêm mới --> InputInfo\[/Nhập: Tên, Giá, Ảnh, Tồn kho/]

&nbsp;   InputInfo --> Validate{Dữ liệu hợp lệ?}

&nbsp;   Validate -- Sai (Giá âm/Thiếu tên) --> ErrorMsg\[Báo lỗi] --> InputInfo

&nbsp;   Validate -- Đúng --> InsertDB\[(INSERT INTO Products)]

&nbsp;   InsertDB --> Success\[Thông báo thành công]

&nbsp;   

&nbsp;   %% Chức năng Xóa

&nbsp;   Action -- Xóa --> SelectItem\[Chọn SP cần xóa]

&nbsp;   SelectItem --> Confirm{Xác nhận xóa?}

&nbsp;   Confirm -- Không --> ViewList

&nbsp;   Confirm -- Có --> DeleteDB\[(DELETE FROM Products)]

&nbsp;   DeleteDB --> Success

&nbsp;   

&nbsp;   Success --> ViewList

