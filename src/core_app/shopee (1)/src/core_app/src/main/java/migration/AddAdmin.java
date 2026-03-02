package migration;

import util.PasswordService;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

/**
 * Thêm admin mới vào database.
 * Chạy: mvn compile exec:java -Dexec.mainClass="migration.AddAdmin"
 */
public class AddAdmin {
    public static void main(String[] args) {
        String url = "jdbc:sqlserver://localhost\\SQLEXPRESS;databaseName=shopeeweb_lab211;encrypt=true;trustServerCertificate=true";
        String user = "sa";
        String pass = "zxczxc123";

        // ═══ CẤU HÌNH ADMIN MỚI ═══
        String adminEmail = "thanhhtrung3110@gmail.com";
        String adminName = "Admin Trung";
        String adminUsername = "admintrung";
        String adminPhone = "0000000001";
        String adminPassword = "admin123";

        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            Connection conn = DriverManager.getConnection(url, user, pass);
            System.out.println(">> Connected to database!");

            // Kiểm tra email đã tồn tại chưa
            PreparedStatement check = conn.prepareStatement("SELECT COUNT(*) FROM Users WHERE email = ?");
            check.setString(1, adminEmail);
            ResultSet rs = check.executeQuery();
            rs.next();
            if (rs.getInt(1) > 0) {
                System.out.println(">> Email " + adminEmail + " đã tồn tại! Cập nhật role thành admin...");
                PreparedStatement update = conn
                        .prepareStatement("UPDATE Users SET role = 'ADMIN', password = ? WHERE email = ?");
                update.setString(1, PasswordService.hash(adminPassword));
                update.setString(2, adminEmail);
                update.executeUpdate();
                System.out.println(">> Đã cập nhật thành admin!");
            } else {
                // Hash password bằng Argon2
                String passHash = PasswordService.hash(adminPassword);

                String sql = "INSERT INTO Users (username, full_name, email, phone, wallet, password, note, role) VALUES (?,?,?,?,?,?,?,?)";
                PreparedStatement ps = conn.prepareStatement(sql);
                ps.setString(1, adminUsername);
                ps.setString(2, adminName);
                ps.setString(3, adminEmail);
                ps.setString(4, adminPhone);
                ps.setDouble(5, 0);
                ps.setString(6, passHash);
                ps.setString(7, "Tai khoan quan tri");
                ps.setString(8, "ADMIN");
                ps.executeUpdate();

                System.out.println("=========================================");
                System.out.println("  ADMIN ACCOUNT CREATED SUCCESSFULLY!");
                System.out.println("  Username: " + adminUsername);
                System.out.println("  Name:     " + adminName);
                System.out.println("  Email:    " + adminEmail);
                System.out.println("  Password: " + adminPassword);
                System.out.println("  Hash:     Argon2id");
                System.out.println("=========================================");
            }

            conn.close();
        } catch (Exception e) {
            System.out.println("ERROR: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
