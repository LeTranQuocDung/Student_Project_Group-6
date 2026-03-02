package migration;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.Statement;
import java.io.FileWriter;
import java.io.PrintWriter;

public class CheckAdmin {
    public static void main(String[] args) {
        try (PrintWriter pw = new PrintWriter(new FileWriter("admin_check_result.txt"))) {
            String[] cfg = {
                    "jdbc:sqlserver://localhost\\SQLEXPRESS;databaseName=shopeeweb_lab211;encrypt=true;trustServerCertificate=true",
                    "sa", "zxczxc123" };

            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            Connection conn = DriverManager.getConnection(cfg[0], cfg[1], cfg[2]);
            pw.println("Connected OK");

            Statement st = conn.createStatement();
            ResultSet rs = st.executeQuery("SELECT * FROM Users WHERE role = 'admin'");
            ResultSetMetaData meta = rs.getMetaData();
            int colCount = meta.getColumnCount();

            pw.println("Columns:");
            for (int i = 1; i <= colCount; i++) {
                pw.println("  " + meta.getColumnName(i));
            }

            if (rs.next()) {
                pw.println("\nADMIN FOUND:");
                for (int i = 1; i <= colCount; i++) {
                    pw.println("  " + meta.getColumnName(i) + " = " + rs.getString(i));
                }
            } else {
                pw.println("NO ADMIN!");
            }
            conn.close();
            pw.flush();
            System.out.println("Result saved to admin_check_result.txt");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
