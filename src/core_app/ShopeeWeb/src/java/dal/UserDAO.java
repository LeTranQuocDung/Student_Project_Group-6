package dal;

import model.Admin; // Nhớ import Admin
import model.User;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class UserDAO extends DBContext {

    // Hàm kiểm tra đăng nhập
    public User login(String email, String passHash) {
        String sql = "SELECT * FROM Users WHERE email = ? AND password_hash = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, email);
            ps.setString(2, passHash);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                // 1. Lấy vai trò (role) từ Database ra
                String role = rs.getString("role");

                // 2. Logic phân loại: Admin hay User?
                if ("admin".equalsIgnoreCase(role)) {
                    // Nếu là Admin -> Tạo object Admin (Có thêm level)
                    return new Admin(
                        rs.getInt("id"),
                        rs.getString("full_name"),
                        rs.getString("email"),
                        rs.getString("phone"),
                        rs.getDouble("wallet"),
                        rs.getString("password_hash"),
                        rs.getString("note"),
                        role, 
                        1 // Level mặc định là 1 (vì DB chưa có cột level)
                    );
                } else {
                    // Nếu là User thường -> Tạo object User (Đủ 8 tham số)
                    return new User(
                        rs.getInt("id"),
                        rs.getString("full_name"),
                        rs.getString("email"),
                        rs.getString("phone"),
                        rs.getDouble("wallet"),
                        rs.getString("password_hash"),
                        rs.getString("note"),
                        role // <-- Phải truyền role vào đây thì mới hết lỗi
                    );
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null; // Không tìm thấy hoặc sai pass
    }
    // 1. Kiểm tra email đã có người dùng chưa
    public boolean checkEmailExist(String email) {
        String sql = "SELECT * FROM Users WHERE email = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return true; // Đã tồn tại
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // 2. Lưu tài khoản mới (Mặc định role='user', wallet=0)
    public void signup(String email, String passHash, String fullName, String phone) {
        String sql = "INSERT INTO Users (email, password_hash, full_name, phone, role, wallet) VALUES (?, ?, ?, ?, 'user', 0)";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ps.setString(2, passHash);
            ps.setString(3, fullName);
            ps.setString(4, phone);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}