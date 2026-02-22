package model;

public class Admin extends User {

    private int level;

    public Admin() {
    }

    public Admin(int id, String fullName, String email, String phone, double wallet, String passwordHash, String note, String role, int level) {

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
