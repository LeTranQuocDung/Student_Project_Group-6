package model;

public class Admin extends User {

    private int level;

    public Admin() {
    }

    // Constructor khớp với UserDAO (9 tham số)
    public Admin(int id, String fullName, String email, String phone, double wallet, String passwordHash, String note, String role, int level) {
        // Gọi constructor của cha (User)
        super(id, fullName, email, phone, wallet, passwordHash, note, role);
        this.level = level;
    }

    public int getLevel() {
        return level;
    }

    public void setLevel(int level) {
        this.level = level;
    }
}
