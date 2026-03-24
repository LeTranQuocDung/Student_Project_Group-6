package model;

public class Permission {
    private String id; // Lấy làm khóa chính dạng mã (ví dụ: MANAGE_USERS)
    private String description;

    public Permission() {
    }

    public Permission(String id, String description) {
        this.id = id;
        this.description = description;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }
}
