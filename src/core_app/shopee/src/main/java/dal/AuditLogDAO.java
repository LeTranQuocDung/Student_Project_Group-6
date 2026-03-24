package dal;

import model.AuditLog;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class AuditLogDAO extends DBContext {

    public void insertLog(int adminId, String action, String targetTable, String targetId, String details) {
        String sql = "INSERT INTO audit_logs (admin_id, action, target_table, target_id, details, created_at) VALUES (?, ?, ?, ?, ?, GETDATE())";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, adminId);
            ps.setString(2, action);
            ps.setString(3, targetTable);
            ps.setString(4, targetId);
            ps.setString(5, details);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public List<AuditLog> getLogs(int page, int pageSize) {
        List<AuditLog> list = new ArrayList<>();
        // Lấy logs kèm tên người thực hiện (JOIN bảng users)
        String sql = "SELECT a.*, u.full_name as admin_name FROM audit_logs a LEFT JOIN users u ON a.admin_id = u.id ORDER BY a.created_at DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            int offset = (page - 1) * pageSize;
            ps.setInt(1, offset);
            ps.setInt(2, pageSize);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new AuditLog(
                        rs.getInt("id"),
                        rs.getInt("admin_id"),
                        rs.getString("admin_name"),
                        rs.getString("action"),
                        rs.getString("target_table"),
                        rs.getString("target_id"),
                        rs.getString("details"),
                        rs.getTimestamp("created_at")
                ));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public int countLogs() {
        String sql = "SELECT COUNT(*) FROM audit_logs";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }
}
