package dal;

import model.Admin;
import model.User;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class UserDAO extends DBContext {

    public User login(String email, String passHash) {
        String sql = "SELECT * FROM Users WHERE email = ? AND password_hash = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, email);
            ps.setString(2, passHash);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                String role = rs.getString("role");

                if ("admin".equalsIgnoreCase(role)) {

                    return new Admin(
                            rs.getInt("id"),
                            rs.getString("full_name"),
                            rs.getString("email"),
                            rs.getString("phone"),
                            rs.getDouble("wallet"),
                            rs.getString("password_hash"),
                            rs.getString("note"),
                            role,
                            1 
                    );
                } else {

                    return new User(
                            rs.getInt("id"),
                            rs.getString("full_name"),
                            rs.getString("email"),
                            rs.getString("phone"),
                            rs.getDouble("wallet"),
                            rs.getString("password_hash"),
                            rs.getString("note"),
                            role
                    );
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean checkEmailExist(String email) {
        String sql = "SELECT * FROM Users WHERE email = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return true;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public void signup(String email, String passHash, String fullName, String phone) {
        String sql = "INSERT INTO Users (email, password_hash, full_name, phone, role, wallet) VALUES (?, ?, ?, ?, 'user', 0)";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
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
