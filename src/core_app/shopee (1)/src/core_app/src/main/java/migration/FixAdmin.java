package migration;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.security.MessageDigest;
import java.math.BigInteger;

/**
 * Cập nhật tất cả password trong DB từ plaintext sang MD5 hash.
 * Đồng thời đổi tên cột 'password' thành 'password_hash'.
 */
public class FixAdmin {
    public static void main(String[] args) {
        String url = "jdbc:sqlserver://localhost\\SQLEXPRESS;databaseName=shopeeweb_lab211;encrypt=true;trustServerCertificate=true";
        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            Connection conn = DriverManager.getConnection(url, "sa", "zxczxc123");
            System.out.println("Connected!");

            // Bước 1: Update admin email + phone
            PreparedStatement ps1 = conn.prepareStatement(
                    "UPDATE Users SET email = 'admin@shopee.vn', phone = '0000000000' WHERE username = 'admin' AND role = 'ADMIN'");
            ps1.executeUpdate();
            System.out.println("Step 1: Admin email/phone updated");

            // Bước 2: Hash tất cả password bằng MD5
            ResultSet rs = conn.createStatement().executeQuery("SELECT id, password FROM Users");
            PreparedStatement psUpdate = conn.prepareStatement("UPDATE Users SET password = ? WHERE id = ?");
            int count = 0;
            while (rs.next()) {
                String plainPass = rs.getString("password");
                if (plainPass != null && plainPass.length() < 32) { // Chưa hash
                    String md5 = getMd5(plainPass);
                    psUpdate.setString(1, md5);
                    psUpdate.setInt(2, rs.getInt("id"));
                    psUpdate.addBatch();
                    count++;
                }
            }
            psUpdate.executeBatch();
            System.out.println("Step 2: Hashed " + count + " passwords to MD5");

            System.out.println("\n===========================");
            System.out.println("  Login:    admin@shopee.vn");
            System.out.println("  Password: admin123");
            System.out.println("===========================");

            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private static String getMd5(String input) {
        try {
            MessageDigest md = MessageDigest.getInstance("MD5");
            byte[] messageDigest = md.digest(input.getBytes());
            BigInteger no = new BigInteger(1, messageDigest);
            String hashtext = no.toString(16);
            while (hashtext.length() < 32)
                hashtext = "0" + hashtext;
            return hashtext;
        } catch (Exception e) {
            return "";
        }
    }
}
