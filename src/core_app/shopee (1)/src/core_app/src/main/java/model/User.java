package model;

public class User {

    protected int id;
    protected String fullName;
    protected String email;
    protected String phone;
    protected double wallet;      // Thêm ví tiền
    protected String passwordHash;
    protected String note;        // Thêm ghi chú
    protected String role;        // Thêm vai trò
    protected String gender;      // Giới tính
    protected String dateOfBirth; // Ngày sinh

    public User() {
    }

    // Constructor ĐẦY ĐỦ 8 tham số (Khớp với UserDAO)
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

    // Getter & Setter
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

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    public String getDateOfBirth() {
        return dateOfBirth;
    }

    public void setDateOfBirth(String dateOfBirth) {
        this.dateOfBirth = dateOfBirth;
    }
}
