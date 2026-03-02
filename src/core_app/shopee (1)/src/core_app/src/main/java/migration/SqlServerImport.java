package migration;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.InputStreamReader;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.Statement;
import java.util.Properties;

public class SqlServerImport {
    private static final String DEFAULT_URL = "jdbc:sqlserver://localhost;databaseName=shopeeweb_lab211;encrypt=true;trustServerCertificate=true;";
    private static final String DEFAULT_USER = "sa";
    private static final String DEFAULT_PASSWORD = "zxczxc123";

    private static String URL;
    private static String USER;
    private static String PASSWORD;

    static {
        // Đọc cấu hình từ db.properties (nếu có)
        Properties props = new Properties();
        boolean loaded = false;

        // Thử 1: Đọc từ classpath
        try (InputStream is = SqlServerImport.class.getClassLoader().getResourceAsStream("db.properties")) {
            if (is != null) {
                props.load(is);
                loaded = true;
            }
        } catch (Exception e) {
            // ignore
        }

        // Thử 2: Đọc từ file db.properties ở thư mục gốc core_app
        if (!loaded) {
            String[] paths = {"db.properties", "../../db.properties", "src/core_app/db.properties", "src/main/resources/db.properties"};
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

        URL = props.getProperty("db.url", DEFAULT_URL);
        USER = props.getProperty("db.user", DEFAULT_USER);
        PASSWORD = props.getProperty("db.password", DEFAULT_PASSWORD);
    }

    // Tự động detect thư mục data (tương đối với thư mục chạy maven)
    private static String getDataDir() {
        // Khi chạy từ src/core_app, data nằm ở ../../data
        File f = new File("../../data");
        if (f.exists()) return f.getAbsolutePath();
        // Khi chạy từ thư mục gốc project
        f = new File("data");
        if (f.exists()) return f.getAbsolutePath();
        // Fallback
        return "../../data";
    }

    public static void main(String[] args) {
        System.out.println("Connecting to: " + URL);
        System.out.println("User: " + USER);

        Connection conn = null;
        try {
            conn = DriverManager.getConnection(URL, USER, PASSWORD);
        } catch (Exception e) {
            System.out.println("SQL Auth failed, falling back to Windows Authentication...");
            try {
                String winAuthUrl = URL;
                if (!winAuthUrl.toLowerCase().contains("integratedsecurity")) {
                    if (!winAuthUrl.endsWith(";")) winAuthUrl += ";";
                    winAuthUrl += "integratedSecurity=true;";
                }
                conn = DriverManager.getConnection(winAuthUrl);
            } catch (Exception ex) {
                ex.printStackTrace();
                return;
            }
        }

        try {
            System.out.println("Connected to SQL Server.");

            String[] clearCommands = {
                "DELETE FROM order_items",
                "DELETE FROM orders",
                "DELETE FROM product_reviews",
                "DELETE FROM cart_items",
                "DELETE FROM product_variants",
                "DELETE FROM products",
                "DELETE FROM shops",
                "SET IDENTITY_INSERT shops ON"
            };
            try (Statement stmt = conn.createStatement()) {
                for (String cmd : clearCommands) {
                    try {
                        stmt.execute(cmd);
                    } catch (Exception ex) {
                        // Bỏ qua lỗi nếu bảng không tồn tại hoặc lỗi khóa ngoại (nếu data rỗng)
                    }
                }
            }
            try (PreparedStatement pstmt = conn
                    .prepareStatement("INSERT INTO shops (id, owner_id, shop_name, rating) VALUES (?, ?, ?, ?)");
                    BufferedReader br = new BufferedReader(new InputStreamReader(
                            new FileInputStream(getDataDir() + "/shops.csv"), "UTF-8"))) {
                String line;
                br.readLine();
                int count = 0;
                while ((line = br.readLine()) != null) {
                    if (line.trim().isEmpty())
                        continue;
                    String[] data = line.split(",");
                    pstmt.setInt(1, Integer.parseInt(data[0]));
                    pstmt.setInt(2, 1);
                    pstmt.setString(3, data[1]);
                    pstmt.setDouble(4, Double.parseDouble(data[2]));
                    pstmt.addBatch();
                    if (++count % 1000 == 0)
                        pstmt.executeBatch();
                }
                pstmt.executeBatch();
                System.out.println("Imported shops: " + count);
            }
            try (Statement stmt = conn.createStatement()) {
                stmt.execute("SET IDENTITY_INSERT shops OFF");
                stmt.execute("SET IDENTITY_INSERT products ON");
            }

            try (PreparedStatement pstmt = conn.prepareStatement(
                    "INSERT INTO products (id, shop_id, name, description, price, image_url) VALUES (?, ?, ?, ?, ?, ?)");
                    BufferedReader br = new BufferedReader(new InputStreamReader(
                            new FileInputStream(getDataDir() + "/products.csv"),
                            "UTF-8"))) {
                String line;
                br.readLine();
                int count = 0;
                while ((line = br.readLine()) != null) {
                    if (line.trim().isEmpty())
                        continue;
                    String[] data = line.split(",(?=([^\"]*\"[^\"]*\")*[^\"]*$)");
                    pstmt.setInt(1, Integer.parseInt(data[0]));
                    pstmt.setInt(2, Integer.parseInt(data[1]));
                    pstmt.setString(3, data[2].replace("\"", ""));
                    pstmt.setString(4, data[3].replace("\"", ""));
                    pstmt.setDouble(5, Double.parseDouble(data[4]));
                    pstmt.setString(6, data[5]);
                    pstmt.addBatch();
                    if (++count % 1000 == 0)
                        pstmt.executeBatch();
                }
                pstmt.executeBatch();
                System.out.println("Imported products: " + count);
            }
            try (Statement stmt = conn.createStatement()) {
                stmt.execute("SET IDENTITY_INSERT products OFF");
                stmt.execute("SET IDENTITY_INSERT product_variants ON");
            }

            try (PreparedStatement pstmt = conn.prepareStatement(
                    "INSERT INTO product_variants (id, product_id, color, size, stock, price, note) VALUES (?, ?, ?, ?, ?, ?, ?)");
                    BufferedReader br = new BufferedReader(new InputStreamReader(
                            new FileInputStream(getDataDir() + "/product_variants.csv"),
                            "UTF-8"))) {
                String line;
                br.readLine();
                int count = 0;
                while ((line = br.readLine()) != null) {
                    if (line.trim().isEmpty())
                        continue;
                    String[] data = line.split(",");
                    pstmt.setInt(1, Integer.parseInt(data[0]));
                    pstmt.setInt(2, Integer.parseInt(data[1]));
                    pstmt.setString(3, data[2]);
                    pstmt.setString(4, data[3]);
                    pstmt.setInt(5, Integer.parseInt(data[4]));
                    pstmt.setDouble(6, Double.parseDouble(data[5]));
                    pstmt.setString(7, data.length > 6 ? data[6] : "");
                    pstmt.addBatch();
                    if (++count % 1000 == 0)
                        pstmt.executeBatch();
                }
                pstmt.executeBatch();
                System.out.println("Imported variants: " + count);
            }
            try (Statement stmt = conn.createStatement()) {
                stmt.execute("SET IDENTITY_INSERT product_variants OFF");
            }
            System.out.println("Import successful!");
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
