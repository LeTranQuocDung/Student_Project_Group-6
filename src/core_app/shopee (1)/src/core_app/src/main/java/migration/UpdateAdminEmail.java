package migration;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;

/**
 * Cập nhật email admin thành email thật.
 * Chạy: mvn compile exec:java -Dexec.mainClass="migration.UpdateAdminEmail"
 */
public class UpdateAdminEmail {
    public static void main(String[] args) {
        String url = "jdbc:sqlserver://localhost\\SQLEXPRESS;databaseName=shopeeweb_lab211;encrypt=true;trustServerCertificate=true";
        String user = "sa";
        String pass = "zxczxc123";

        String newEmail = "phucvantran012@gmail.com";

        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            Connection conn = DriverManager.getConnection(url, user, pass);
            System.out.println(">> Connected to database!");

            // Cập nhật email cho tất cả admin
            String sql = "UPDATE Users SET email = ? WHERE role = 'admin'";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, newEmail);
            int rows = ps.executeUpdate();

            System.out.println("=========================================");
            System.out.println("  ADMIN EMAIL UPDATED SUCCESSFULLY!");
            System.out.println("  New Email: " + newEmail);
            System.out.println("  Rows affected: " + rows);
            System.out.println("=========================================");

            conn.close();
        } catch (Exception e) {
            System.out.println("ERROR: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
