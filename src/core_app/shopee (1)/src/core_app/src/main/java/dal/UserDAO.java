package dal;

import model.Admin; // Nhớ import Admin
import model.User;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class UserDAO extends DBContext {

    /**
     * Tìm user bằng email hoặc phone (KHÔNG kiểm tra password ở SQL)
     * Password sẽ được verify bằng Argon2 ở tầng Controller
     */
    public User findByEmailOrPhone(String loginIdentifier) {
        String sql = "SELECT * FROM Users WHERE email = ? OR phone = ? OR username = ?";
        try (Connection conn = getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, loginIdentifier);
            ps.setString(2, loginIdentifier);
            ps.setString(3, loginIdentifier);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return mapUserFromResultSet(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * [LEGACY] Giữ lại để tương thích ngược, nhưng không nên dùng nữa.
     * Dùng findByEmailOrPhone() + PasswordService.verify() thay thế.
     */
    public User login(String loginIdentifier, String passHash) {
        String sql = "SELECT * FROM Users WHERE (email = ? OR phone = ?) AND password = ?";
        try (Connection conn = getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, loginIdentifier);
            ps.setString(2, loginIdentifier);
            ps.setString(3, passHash);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return mapUserFromResultSet(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // 1. Kiểm tra email đã có người dùng chưa
    public boolean checkEmailExist(String email) {
        String sql = "SELECT * FROM Users WHERE email = ?";
        try (Connection conn = getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            if (rs.next())
                return true; // Đã tồn tại
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // 2. Lưu tài khoản mới (Mặc định role='user', wallet=0)
    public boolean signup(String email, String passHash, String fullName, String phone) {
        String sql = "INSERT INTO Users (username, email, password, full_name, phone, role, wallet) VALUES (?, ?, ?, ?, ?, 'CUSTOMER', 0)";
        try (Connection conn = getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email); // Dùng email làm username
            ps.setString(2, email);
            ps.setString(3, passHash);
            ps.setString(4, fullName);
            ps.setString(5, phone);
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // ===== ADMIN USER MANAGEMENT =====

    // 3. Lấy danh sách tất cả users (không gồm admin)
    public List<User> getAllUsers() {
        List<User> list = new ArrayList<>();
        String sql = "SELECT * FROM users WHERE role != 'admin' ORDER BY id DESC";
        try (Connection conn = getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapUserFromResultSet(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // 4. Lấy user theo ID
    public User getUserById(int id) {
        String sql = "SELECT * FROM users WHERE id = ?";
        try (Connection conn = getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapUserFromResultSet(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // 5. Xóa user
    public void deleteUser(int id) {
        String sql = "DELETE FROM users WHERE id = ? AND role != 'admin'";
        try (Connection conn = getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // ===== UPDATE PASSWORD (cho auto-migration MD5 → Argon2) =====

    /**
     * Cập nhật password hash cho user (dùng khi auto-migrate từ MD5 sang Argon2)
     */
    public boolean updatePassword(int userId, String newPasswordHash) {
        String sql = "UPDATE Users SET password = ? WHERE id = ?";
        try (Connection conn = getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, newPasswordHash);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // ===== SOCIAL LOGIN =====

    /**
     * Tìm user theo email (dùng cho Google/Facebook login)
     */
    public User findByEmail(String email) {
        String sql = "SELECT * FROM Users WHERE email = ?";
        try (Connection conn = getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapUserFromResultSet(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Tạo user mới từ social login (không cần password)
     * Trả về User object nếu thành công
     */
    public User signupSocial(String email, String fullName, String provider) {
        // Kiểm tra email đã tồn tại chưa
        User existing = findByEmail(email);
        if (existing != null) {
            System.out.println("[Social Login] User đã tồn tại: " + email + " (id=" + existing.getId() + ")");
            return existing; // Đã có → trả về user hiện tại
        }

        System.out.println("[Social Login] Tạo user mới: email=" + email + ", name=" + fullName + ", provider=" + provider);

        String sql = "INSERT INTO Users (username, email, password, full_name, phone, role, wallet, note) VALUES (?, ?, ?, ?, ?, 'CUSTOMER', 0, ?)";
        try (Connection conn = getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email); // Dùng email làm username
            ps.setString(2, email);
            ps.setString(3, "SOCIAL_LOGIN_" + provider.toUpperCase()); // Placeholder password
            ps.setString(4, fullName);
            ps.setString(5, ""); // Không có phone
            ps.setString(6, "Đăng ký qua " + provider);
            int rows = ps.executeUpdate();
            System.out.println("[Social Login] INSERT rows affected: " + rows);

            if (rows > 0) {
                // Lấy user vừa tạo bằng email
                User newUser = findByEmail(email);
                if (newUser != null) {
                    System.out.println("[Social Login] Tạo thành công user id=" + newUser.getId());
                }
                return newUser;
            }
        } catch (Exception e) {
            System.err.println("[Social Login] LỖI tạo user: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    // ===== HELPER: Map ResultSet to User/Admin =====

    private User mapUserFromResultSet(ResultSet rs) throws Exception {
        String role = rs.getString("role");
        User user;
        if ("admin".equalsIgnoreCase(role)) {
            user = new Admin(
                    rs.getInt("id"),
                    rs.getString("full_name"),
                    rs.getString("email"),
                    rs.getString("phone"),
                    rs.getDouble("wallet"),
                    rs.getString("password"),
                    rs.getString("note"),
                    role,
                    1);
        } else {
            user = new User(
                    rs.getInt("id"),
                    rs.getString("full_name"),
                    rs.getString("email"),
                    rs.getString("phone"),
                    rs.getDouble("wallet"),
                    rs.getString("password"),
                    rs.getString("note"),
                    role);
        }
        // Đọc thêm gender và date_of_birth (null-safe)
        try {
            user.setGender(rs.getString("gender"));
            java.sql.Date dob = rs.getDate("date_of_birth");
            if (dob != null) {
                user.setDateOfBirth(dob.toString()); // yyyy-MM-dd
            }
        } catch (Exception ignored) {
            // Cột chưa tồn tại trong DB → bỏ qua
        }
        return user;
    }

    // ===== UPDATE PROFILE =====

    public boolean updateProfile(int userId, String fullName, String phone, String gender, String dateOfBirth) {
        String sql = "UPDATE Users SET full_name = ?, phone = ?, gender = ?, date_of_birth = ? WHERE id = ?";
        try (Connection conn = getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, fullName);
            ps.setString(2, phone);
            ps.setString(3, gender);
            if (dateOfBirth != null && !dateOfBirth.isEmpty()) {
                ps.setDate(4, java.sql.Date.valueOf(dateOfBirth));
            } else {
                ps.setNull(4, java.sql.Types.DATE);
            }
            ps.setInt(5, userId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}