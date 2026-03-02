package migration;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

/**
 * Script tạo tài khoản Admin mặc định.
 * Chạy: mvn compile exec:java -Dexec.mainClass="migration.CreateAdmin"
 */
public class CreateAdmin {
    public static void main(String[] args) {
        // Thử cả 2 config DB
        String[][] configs = {
                { "jdbc:sqlserver://localhost\\SQLEXPRESS;databaseName=ShopeeDB;encrypt=true;trustServerCertificate=true",
                        "sa", "123456" },
                { "jdbc:sqlserver://localhost\\SQLEXPRESS;databaseName=shopeeweb_lab211;encrypt=true;trustServerCertificate=true",
                        "sa", "zxczxc123" }
        };

        for (String[] cfg : configs) {
            try {
                Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
                Connection conn = DriverManager.getConnection(cfg[0], cfg[1], cfg[2]);
                System.out.println(">> Connected to: " + cfg[0]);

                // Kiểm tra admin đã tồn tại chưa
                PreparedStatement check = conn.prepareStatement("SELECT COUNT(*) FROM Users WHERE role = 'admin'");
                ResultSet rs = check.executeQuery();
                rs.next();
                if (rs.getInt(1) > 0) {
                    System.out.println(">> Admin account already exists! Skipping.");
                    conn.close();
                    return;
                }

                // Tạo admin: admin@shopee.vn / admin123
                String sql = "INSERT INTO Users (full_name, email, phone, wallet, password_hash, note, role) VALUES (?,?,?,?,?,?,?)";
                PreparedStatement ps = conn.prepareStatement(sql);
                ps.setString(1, "Super Admin");
                ps.setString(2, "admin@shopee.vn");
                ps.setString(3, "0000000000");
                ps.setDouble(4, 0);
                ps.setString(5, "0192023a7bbd73250516f069df18b500"); // MD5 of "admin123"
                ps.setString(6, "Tai khoan quan tri");
                ps.setString(7, "admin");
                ps.executeUpdate();

                System.out.println("=========================================");
                System.out.println("  ADMIN ACCOUNT CREATED SUCCESSFULLY!");
                System.out.println("  Email:    admin@shopee.vn");
                System.out.println("  Password: admin123");
                System.out.println("=========================================");

                conn.close();
                return;
            } catch (Exception e) {
                System.out.println(">> Config failed: " + cfg[0] + " -> " + e.getMessage());
            }
        }
        System.out.println("ERROR: Could not connect to any database!");
    }
}
