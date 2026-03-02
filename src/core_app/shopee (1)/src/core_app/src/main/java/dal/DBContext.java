package dal;

import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

public class DBContext {
    private static final String DEFAULT_URL = "jdbc:sqlserver://localhost;databaseName=shopeeweb_lab211;encrypt=true;trustServerCertificate=true;";
    private static final String DEFAULT_USER = "sa";
    private static final String DEFAULT_PASS = "zxczxc123"; // <-- Mật khẩu mặc định, ưu tiên đọc từ db.properties

    private static String DB_URL;
    private static String USER;
    private static String PASS;

    static {
        // Đọc cấu hình từ db.properties (nếu có)
        Properties props = new Properties();
        boolean loaded = false;

        // Thử 1: Đọc từ classpath
        try (InputStream is = DBContext.class.getClassLoader().getResourceAsStream("db.properties")) {
            if (is != null) {
                props.load(is);
                loaded = true;
            }
        } catch (Exception e) {
            // ignore
        }

        // Thử 2: Đọc từ file db.properties ở thư mục gốc core_app
        if (!loaded) {
            String[] paths = {"db.properties", "../../db.properties", "src/core_app/db.properties"};
            for (String path : paths) {
                File f = new File(path);
                if (f.exists()) {
                    try (FileInputStream fis = new FileInputStream(f)) {
                        props.load(fis);
                        loaded = true;
                        break;
                    } catch (Exception e) {
                        // ignore
                    }
                }
            }
        }

        DB_URL = props.getProperty("db.url", DEFAULT_URL);
        USER = props.getProperty("db.user", DEFAULT_USER);
        PASS = props.getProperty("db.password", DEFAULT_PASS);
    }

    public Connection getConnection() {
        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            try {
                // Thử kết nối bằng Username/Password (SQL Authentication)
                return DriverManager.getConnection(DB_URL, USER, PASS);
            } catch (SQLException e) {
                // Nếu thất bại, thử kết nối bằng Windows Authentication
                System.out.println("SQL Auth failed, falling back to Windows Authentication...");
                String winAuthUrl = DB_URL;
                if (!winAuthUrl.toLowerCase().contains("integratedsecurity")) {
                    if (!winAuthUrl.endsWith(";")) winAuthUrl += ";";
                    winAuthUrl += "integratedSecurity=true;";
                }
                return DriverManager.getConnection(winAuthUrl);
            }
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
            return null;
        }
    }
}