package dal;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;

import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.Properties;

public class DBContext {
    private static final String DEFAULT_URL = "jdbc:sqlserver://localhost\\SQLEXPRESS;databaseName=shopeeweb_lab211;encrypt=true;trustServerCertificate=true;";
    private static final String DEFAULT_USER = "sa";
    private static final String DEFAULT_PASS = "zxczxc123";

    // ===== HikariCP Connection Pool (Singleton) =====
    private static final HikariDataSource dataSource;

    static {
        Properties props = new Properties();
        boolean loaded = false;

        // Thử 1: Đọc từ classpath
        try (InputStream is = DBContext.class.getClassLoader().getResourceAsStream("db.properties")) {
            if (is != null) {
                props.load(is);
                loaded = true;
            }
        } catch (Exception e) { /* ignore */ }

        // Thử 2: Đọc từ file trên disk
        if (!loaded) {
            String[] paths = {"db.properties", "../../db.properties", "src/core_app/db.properties"};
            for (String path : paths) {
                File f = new File(path);
                if (f.exists()) {
                    try (FileInputStream fis = new FileInputStream(f)) {
                        props.load(fis);
                        loaded = true;
                        break;
                    } catch (Exception e) { /* ignore */ }
                }
            }
        }

        String dbUrl = props.getProperty("db.url", DEFAULT_URL);
        String user = props.getProperty("db.user", DEFAULT_USER);
        String pass = props.getProperty("db.password", DEFAULT_PASS);

        // Cấu hình HikariCP
        HikariConfig config = new HikariConfig();
        config.setDriverClassName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        config.setJdbcUrl(dbUrl);
        config.setUsername(user);
        config.setPassword(pass);

        // Pool tuning
        config.setMaximumPoolSize(10);       // Tối đa 10 kết nối cùng lúc
        config.setMinimumIdle(3);            // Luôn giữ sẵn 3 kết nối chờ
        config.setIdleTimeout(30000);        // Kết nối idle bị thu hồi sau 30 giây
        config.setMaxLifetime(1800000);      // Mỗi kết nối sống tối đa 30 phút
        config.setConnectionTimeout(10000);  // Chờ lấy connection tối đa 10 giây
        config.setPoolName("ShopeeWebPool");

        // Validation
        config.setConnectionTestQuery("SELECT 1");

        HikariDataSource ds = null;
        try {
            ds = new HikariDataSource(config);
        } catch (Exception e) {
            try {
                // Fallback: Windows Authentication
                String winAuthUrl = dbUrl;
                if (!winAuthUrl.toLowerCase().contains("integratedsecurity")) {
                    if (!winAuthUrl.endsWith(";")) winAuthUrl += ";";
                    winAuthUrl += "integratedSecurity=true;";
                }
                HikariConfig winConfig = new HikariConfig();
                winConfig.setDriverClassName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
                winConfig.setJdbcUrl(winAuthUrl);
                winConfig.setMaximumPoolSize(10);
                winConfig.setMinimumIdle(3);
                winConfig.setIdleTimeout(30000);
                winConfig.setMaxLifetime(1800000);
                winConfig.setConnectionTimeout(10000);
                winConfig.setPoolName("ShopeeWebPool-WinAuth");
                winConfig.setConnectionTestQuery("SELECT 1");
                ds = new HikariDataSource(winConfig);
            } catch (Exception ex) {
                System.err.println("FATAL: Cannot create connection pool: " + ex.getMessage());
                ex.printStackTrace();
            }
        }
        dataSource = ds;
    }

    /**
     * Lấy Connection từ Pool (cực nhanh, ~0.1ms thay vì ~400ms).
     * QUAN TRỌNG: Luôn đóng connection sau khi dùng xong (try-with-resources)
     * để trả lại cho pool, KHÔNG phải đóng thật sự.
     */
    public Connection getConnection() {
        try {
            if (dataSource != null) {
                return dataSource.getConnection();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
}
