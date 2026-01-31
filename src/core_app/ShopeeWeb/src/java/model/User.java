package model;

public class User {

    // Sửa thành protected để con (Admin) dùng được
    protected int id;
    protected String fullName;
    protected String email;
    protected String phone;
    protected double wallet;
    protected String passwordHash;
    protected String note;
    protected String role; // <--- Cái ông đang thiếu đây

    public User() {
    }

    // Constructor 8 tham số (Bắt buộc phải có cái này thì Admin mới hết lỗi)
    public User(int id, String fullName, String email, String phone, double wallet, String passwordHash, String note, String role) {
        this.id = id;
        this.fullName = fullName;
        this.email = email;
        this.phone = phone;
        this.wallet = wallet;
        this.passwordHash = passwordHash;
        this.note = note;
        this.role = role;
    }

    // --- CÁC GETTER / SETTER ---
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public double getWallet() {
        return wallet;
    }

    public void setWallet(double wallet) {
        this.wallet = wallet;
    }

    public String getPasswordHash() {
        return passwordHash;
    }

    public void setPasswordHash(String passwordHash) {
        this.passwordHash = passwordHash;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }
}
