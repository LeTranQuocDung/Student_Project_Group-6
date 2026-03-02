package migration;

import util.PasswordService;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

/**
 * 🔒 MIGRATION: Chuyển tất cả password từ MD5 → Argon2id
 * 
 * Vì MD5 không thể đảo ngược, script này sẽ:
 * - Admin: reset password về "admin123" → hash Argon2
 * - User thường: reset password về "123456" → hash Argon2
 * 
 * Chạy: mvn compile exec:java -Dexec.mainClass="migration.MigrateToArgon2"
 */
public class MigrateToArgon2 {
    public static void main(String[] args) {
        String url = "jdbc:sqlserver://localhost\\SQLEXPRESS;databaseName=shopeeweb_lab211;encrypt=true;trustServerCertificate=true";
        String user = "sa";
        String pass = "zxczxc123";

        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            Connection conn = DriverManager.getConnection(url, user, pass);
            System.out.println(">> Connected to database!");

            // 1. Hash password mặc định cho Admin
            String adminPassword = "admin123";
            String adminHash = PasswordService.hash(adminPassword);
            System.out.println(">> Admin Argon2 hash generated (length: " + adminHash.length() + ")");

            PreparedStatement psAdmin = conn.prepareStatement(
                    "UPDATE Users SET password = ? WHERE role = 'admin'");
            psAdmin.setString(1, adminHash);
            int adminRows = psAdmin.executeUpdate();

            // 2. Hash password mặc định cho User thường
            String userPassword = "123456";
            String userHash = PasswordService.hash(userPassword);
            System.out.println(">> User Argon2 hash generated (length: " + userHash.length() + ")");

            PreparedStatement psUser = conn.prepareStatement(
                    "UPDATE Users SET password = ? WHERE role != 'admin'");
            psUser.setString(1, userHash);
            int userRows = psUser.executeUpdate();

            System.out.println();
            System.out.println("==============================================");
            System.out.println("  MIGRATION MD5 → ARGON2 THÀNH CÔNG!");
            System.out.println("==============================================");
            System.out.println("  Admin accounts updated: " + adminRows);
            System.out.println("  Admin password: " + adminPassword);
            System.out.println("----------------------------------------------");
            System.out.println("  User accounts updated: " + userRows);
            System.out.println("  User password: " + userPassword);
            System.out.println("==============================================");

            // 3. Kiểm tra verify
            System.out.println();
            System.out.println(">> Verification test:");
            System.out.println("   Admin verify: " + PasswordService.verify(adminPassword, adminHash));
            System.out.println("   User verify:  " + PasswordService.verify(userPassword, userHash));

            conn.close();
        } catch (Exception e) {
            System.out.println("ERROR: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
