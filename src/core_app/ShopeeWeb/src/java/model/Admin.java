package model;

public class Admin extends User {

    // Thuộc tính riêng chỉ Admin mới có (Ví dụ: Cấp độ quản lý)
    private int level;

    public Admin() {
        super();
    }

    // Constructor đầy đủ (Phải khớp với thứ tự bên User cha)
    public Admin(int id, String fullName, String email, String phone, double wallet, String passwordHash, String note, String role, int level) {

        // Gọi constructor của User (Cha) để lưu mấy thông tin cơ bản
        // Lưu ý: Phải truyền đúng thứ tự tham số như bên User.java
        super(id, fullName, email, phone, wallet, passwordHash, note, role);

        // Lưu thuộc tính riêng của Admin
        this.level = level;
    }

    // Getter & Setter riêng cho Level
    public int getLevel() {
        return level;
    }

    public void setLevel(int level) {
        this.level = level;
    }
}
