package model;

import java.sql.Timestamp;

public class AuditLog {
    private int id;
    private int adminId;
    private String adminName; // Lấy từ JOIN với bảng Users
    private String action;
    private String targetTable;
    private String targetId;
    private String details;
    private Timestamp createdAt;

    public AuditLog() {
    }

    public AuditLog(int id, int adminId, String adminName, String action, String targetTable, String targetId, String details, Timestamp createdAt) {
        this.id = id;
        this.adminId = adminId;
        this.adminName = adminName;
        this.action = action;
        this.targetTable = targetTable;
        this.targetId = targetId;
        this.details = details;
        this.createdAt = createdAt;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getAdminId() {
        return adminId;
    }

    public void setAdminId(int adminId) {
        this.adminId = adminId;
    }

    public String getAdminName() {
        return adminName;
    }

    public void setAdminName(String adminName) {
        this.adminName = adminName;
    }

    public String getAction() {
        return action;
    }

    public void setAction(String action) {
        this.action = action;
    }

    public String getTargetTable() {
        return targetTable;
    }

    public void setTargetTable(String targetTable) {
        this.targetTable = targetTable;
    }

    public String getTargetId() {
        return targetId;
    }

    public void setTargetId(String targetId) {
        this.targetId = targetId;
    }

    public String getDetails() {
        return details;
    }

    public void setDetails(String details) {
        this.details = details;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
}
