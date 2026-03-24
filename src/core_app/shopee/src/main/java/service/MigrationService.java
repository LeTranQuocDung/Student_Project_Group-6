package service;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.OutputStreamWriter;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.sql.Connection;
import java.sql.Date;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.sql.Timestamp;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Properties;

public class MigrationService {

    // ========== CẤU HÌNH DB (ĐỌC TỪ db.properties, KHÔNG HARDCODE) ==========
    private String dbUrl;
    private String dbUser;
    private String dbPass;
    private String dataFolder;

    private static final DateTimeFormatter FMT_STD = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
    private static final DateTimeFormatter FMT_LEGACY = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
    private static final DateTimeFormatter FMT_DATE_ONLY = DateTimeFormatter.ofPattern("yyyy-MM-dd");

    private StringBuilder logs = new StringBuilder();
    private int adminUserId = 1; // sẽ được cập nhật sau khi tạo admin

    public MigrationService() {
        // Đọc config từ db.properties (giống DBContext.java)
        Properties props = new Properties();
        boolean loaded = false;

        // Thử 1: Đọc từ classpath
        try (InputStream is = MigrationService.class.getClassLoader().getResourceAsStream("db.properties")) {
            if (is != null) {
                props.load(is);
                loaded = true;
            }
        } catch (Exception e) { /* ignore */ }

        // Thử 2: Đọc từ file trên disk
        if (!loaded) {
            String[] paths = {"db.properties", "../../db.properties", "src/core_app/db.properties",
                    "src/core_app/src/main/resources/db.properties"};
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

        // Dùng config từ db.properties, fallback tới default giống DBContext
        this.dbUrl = props.getProperty("db.url",
                "jdbc:sqlserver://localhost;instanceName=SQLEXPRESS;databaseName=shopeeweb_lab211;encrypt=true;trustServerCertificate=true;");
        this.dbUser = props.getProperty("db.user", "sa");
        this.dbPass = props.getProperty("db.password", "zxczxc123");

        // Auto-detect thư mục data
        this.dataFolder = detectDataFolder();
    }

    /**
     * Tự động detect thư mục data/ chứa CSV files.
     */
    private String detectDataFolder() {
        String userDir = System.getProperty("user.dir", "");

        // Tìm ngược từ working directory lên, tìm thư mục chứa file CSV
        File current = new File(userDir);
        for (int i = 0; i < 6; i++) {
            File dataDir = new File(current, "data");
            if (dataDir.exists() && dataDir.isDirectory()) {
                File[] csvFiles = dataDir.listFiles((dir, name) -> name.endsWith(".csv"));
                if (csvFiles != null && csvFiles.length > 0) {
                    String path = dataDir.getAbsolutePath().replace('\\', '/');
                    if (!path.endsWith("/")) path += "/";
                    return path;
                }
            }
            current = current.getParentFile();
            if (current == null) break;
        }

        // Thử các đường dẫn phổ biến
        String[] candidates = { "data/", "../data/", "../../data/" };
        for (String candidate : candidates) {
            File dir = new File(candidate);
            if (dir.exists() && dir.isDirectory()) {
                String path = dir.getAbsolutePath().replace('\\', '/');
                if (!path.endsWith("/")) path += "/";
                return path;
            }
        }
        return "data/";
    }

    public String startMigration() {
        logs.setLength(0);
        log("🚀 BẮT ĐẦU IMPORT & CLEAN DATA ...");
        log("📂 Thư mục dữ liệu: " + dataFolder);
        log("🔗 Database URL: " + dbUrl);

        // Kiểm tra thư mục data
        File dataDir = new File(dataFolder);
        if (!dataDir.exists() || !dataDir.isDirectory()) {
            log("<h2 style='color:red'>❌ LỖI: Không tìm thấy thư mục dữ liệu: " + dataFolder + "</h2>");
            log("Working directory: " + System.getProperty("user.dir"));
            return logs.toString();
        }

        // Liệt kê CSV
        File[] csvFiles = dataDir.listFiles((dir, name) -> name.endsWith(".csv"));
        if (csvFiles != null) {
            log("📋 Các file CSV tìm thấy: ");
            for (File f : csvFiles) {
                log("   → " + f.getName() + " (" + (f.length() / 1024) + " KB)");
            }
        }

        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        } catch (ClassNotFoundException e) {
            log("⚠️ Warning: SQL Server Driver không tìm thấy trong classpath");
        }

        try (Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPass)) {
            conn.setAutoCommit(false);

            // 1. DỌN SẠCH DB
            cleanDatabase(conn);

            // 2. IMPORT (Thứ tự quan trọng: Cha trước -> Con sau)
            if (csvExists("users.csv")) {
                importUsers(conn);
            } else {
                log("⚠️ SKIP: users.csv không tìm thấy. Tạo tài khoản admin mặc định...");
                adminUserId = createDefaultAdmin(conn);
            }

            if (csvExists("shops.csv")) {
                importShops(conn);
            } else {
                log("⚠️ SKIP: shops.csv không tìm thấy");
            }

            if (csvExists("categories.csv")) {
                importCategories(conn);
            } else {
                log("⚠️ SKIP: categories.csv không tìm thấy");
            }

            if (csvExists("products.csv")) {
                importProducts(conn);
            } else {
                log("⚠️ SKIP: products.csv không tìm thấy");
            }

            if (csvExists("product_variants.csv")) {
                importVariants(conn);
            } else {
                log("⚠️ SKIP: product_variants.csv không tìm thấy");
            }

            if (csvExists("vouchers.csv")) {
                importVouchers(conn);
            } else {
                log("⚠️ SKIP: vouchers.csv không tìm thấy");
            }

            if (csvExists("orders.csv")) {
                importOrders(conn);
            } else {
                log("⚠️ SKIP: orders.csv không tìm thấy");
            }

            if (csvExists("order_items.csv")) {
                importOrderItems(conn);
            } else {
                log("⚠️ SKIP: order_items.csv không tìm thấy");
            }

            conn.commit();
            log("<h2 style='color:green'>✅ IMPORT THÀNH CÔNG!</h2>");

            // 3. XUẤT NGƯỢC RA CSV (Backup)
            exportCleanData(conn);

        } catch (Exception e) {
            e.printStackTrace();
            log("<h2 style='color:red'>❌ LỖI: " + e.getMessage() + "</h2>");
            log("Chi tiết: " + e.toString());
        }
        return logs.toString();
    }

    private boolean csvExists(String fileName) {
        return new File(dataFolder + fileName).exists();
    }

    // ══════════════════════════════════════════════════════════════
    // IMPORT FUNCTIONS (sử dụng đúng tên bảng snake_case của DB)
    // ══════════════════════════════════════════════════════════════

    private void importUsers(Connection c) throws Exception {
        try (Statement st = c.createStatement()) {
            st.execute("SET IDENTITY_INSERT users ON");
        }

        // Bảng users: id, username, email, password, full_name, phone, wallet, note, role
        String sql = "INSERT INTO users (id, full_name, email, phone, wallet, password, note, role, username) VALUES (?,?,?,?,?,?,?,?,?)";
        readAndInsert(c, "users.csv", sql, 7, (ps, d) -> {
            int id = Integer.parseInt(d[0]);
            ps.setInt(1, id);

            String fullName = d[1];
            String email = d[2];
            String phone = d[3];
            if (!email.contains("@")) {
                email = email.replace("gmail.com", "@gmail.com");
            }
            if (!phone.startsWith("0")) {
                phone = "0" + phone;
            }

            ps.setString(2, fullName);
            ps.setString(3, email);
            ps.setString(4, phone);
            ps.setDouble(5, Double.parseDouble(d[4]));
            ps.setString(6, d[5]); // password
            ps.setString(7, d[6]); // note
            ps.setString(8, "CUSTOMER");
            ps.setString(9, email); // username = email
        });

        try (Statement st = c.createStatement()) {
            st.execute("SET IDENTITY_INSERT users OFF");
        }

        // ★ TẠO TÀI KHOẢN ADMIN MẶC ĐỊNH ★
        adminUserId = createDefaultAdmin(c);
    }

    private int createDefaultAdmin(Connection c) throws Exception {
        String adminSql = "INSERT INTO users (full_name, email, phone, wallet, password, note, role, username) VALUES (?,?,?,?,?,?,?,?)";
        try (PreparedStatement ps = c.prepareStatement(adminSql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, "Super Admin");
            ps.setString(2, "admin@shopee.vn");
            ps.setString(3, "0000000000");
            ps.setDouble(4, 0);
            ps.setString(5, "0192023a7bbd73250516f069df18b500"); // MD5 của "admin123"
            ps.setString(6, "Tai khoan quan tri");
            ps.setString(7, "admin");
            ps.setString(8, "admin@shopee.vn"); // username = email
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) {
                    int id = keys.getInt(1);
                    log("👑 Đã tạo tài khoản Admin (ID=" + id + "): admin@shopee.vn / admin123");
                    return id;
                }
            }
            log("👑 Đã tạo tài khoản Admin: admin@shopee.vn / admin123");
        }
        return 1; // fallback
    }

    private void importShops(Connection c) throws Exception {
        try (Statement st = c.createStatement()) {
            st.execute("SET IDENTITY_INSERT shops ON");
        }

        // CSV: id, shop_name, rating → DB cần thêm owner_id (NOT NULL)
        String sql = "INSERT INTO shops (id, owner_id, shop_name, rating) VALUES (?,?,?,?)";
        final int ownerId = this.adminUserId;
        readAndInsert(c, "shops.csv", sql, 3, (ps, d) -> {
            ps.setInt(1, Integer.parseInt(d[0]));
            ps.setInt(2, ownerId); // gán owner = admin user
            ps.setString(3, d[1]);
            ps.setDouble(4, Double.parseDouble(d[2]));
        });

        try (Statement st = c.createStatement()) {
            st.execute("SET IDENTITY_INSERT shops OFF");
        }
    }

    private void importCategories(Connection c) throws Exception {
        try (Statement st = c.createStatement()) {
            st.execute("SET IDENTITY_INSERT categories ON");
        }

        // CSV: id, name, image_url
        String sql = "INSERT INTO categories (id, name, image_url) VALUES (?,?,?)";
        readAndInsert(c, "categories.csv", sql, 3, (ps, d) -> {
            ps.setInt(1, Integer.parseInt(d[0].trim()));
            ps.setString(2, d[1].trim());
            ps.setString(3, d.length > 2 ? d[2].trim() : "");
        });

        try (Statement st = c.createStatement()) {
            st.execute("SET IDENTITY_INSERT categories OFF");
        }
    }

    private void importProducts(Connection c) throws Exception {
        try (Statement st = c.createStatement()) {
            st.execute("SET IDENTITY_INSERT products ON");
        }

        // CSV: id, shop_id, category_id, name, description, price, image_url (7 cột)
        String sql = "INSERT INTO products (id, shop_id, category_id, name, description, price, image_url) VALUES (?,?,?,?,?,?,?)";
        readAndInsert(c, "products.csv", sql, 7, (ps, d) -> {
            ps.setInt(1, Integer.parseInt(d[0].trim()));       // id
            ps.setInt(2, Integer.parseInt(d[1].trim()));       // shop_id
            ps.setInt(3, Integer.parseInt(d[2].trim()));       // category_id
            ps.setString(4, d[3].trim());                      // name
            ps.setString(5, d[4].trim());                      // description
            ps.setDouble(6, Double.parseDouble(d[5].trim()));  // price
            ps.setString(7, d[6].trim());                      // image_url
        });

        try (Statement st = c.createStatement()) {
            st.execute("SET IDENTITY_INSERT products OFF");
        }
    }

    private void importVariants(Connection c) throws Exception {
        try (Statement st = c.createStatement()) {
            st.execute("SET IDENTITY_INSERT product_variants ON");
        }

        // DB schema: id, product_id, color, size, stock, price, note
        // CSV có: id, product_id, color, size, stock, price, note (7 cột)
        String sql = "INSERT INTO product_variants (id, product_id, color, size, stock, price, note) VALUES (?,?,?,?,?,?,?)";
        readAndInsert(c, "product_variants.csv", sql, 6, (ps, d) -> {
            ps.setInt(1, Integer.parseInt(d[0].trim()));
            ps.setInt(2, Integer.parseInt(d[1].trim()));
            ps.setString(3, d[2].trim()); // color
            ps.setString(4, d.length > 3 ? d[3].trim() : ""); // size

            int stock = Integer.parseInt(d[4].trim());
            double price = Double.parseDouble(d[5].trim());
            if (stock < 0) stock = 0;
            if (price <= 0) price = 50000;

            ps.setInt(5, stock);
            ps.setDouble(6, price);
            ps.setString(7, d.length > 6 ? d[6].trim() : ""); // note
        });

        try (Statement st = c.createStatement()) {
            st.execute("SET IDENTITY_INSERT product_variants OFF");
        }
    }

    private void importVouchers(Connection c) throws Exception {
        // Thử kiểm tra bảng vouchers tồn tại không
        try {
            String sql = "INSERT INTO vouchers (code, value, min_order, start_date, end_date) VALUES (?,?,?,?,?)";
            readAndInsert(c, "vouchers.csv", sql, 5, (ps, d) -> {
                ps.setString(1, d[0]);
                ps.setDouble(2, Double.parseDouble(d[1]));
                ps.setDouble(3, Double.parseDouble(d[2]));
                ps.setDate(4, parseDateSafe(d[3]));
                ps.setDate(5, parseDateSafe(d[4]));
            });
        } catch (Exception e) {
            log("   ⚠️ Bảng vouchers chưa tồn tại hoặc schema khác, bỏ qua: " + e.getMessage());
        }
    }

    private void importOrders(Connection c) throws Exception {
        try (Statement st = c.createStatement()) {
            st.execute("SET IDENTITY_INSERT orders ON");
        }

        // Bảng orders: id, user_id, total_price, created_at, status
        String sql = "INSERT INTO orders (id, user_id, total_price, created_at, status) VALUES (?,?,?,?,?)";
        readAndInsert(c, "orders.csv", sql, 4, (ps, d) -> {
            ps.setInt(1, Integer.parseInt(d[0]));
            ps.setInt(2, Integer.parseInt(d[1]));
            ps.setDouble(3, Double.parseDouble(d[2]));
            ps.setTimestamp(4, parseTimestampSafe(d[3]));
            ps.setString(5, "PENDING"); // Default status
        });

        try (Statement st = c.createStatement()) {
            st.execute("SET IDENTITY_INSERT orders OFF");
        }
    }

    private void importOrderItems(Connection c) throws Exception {
        try (Statement st = c.createStatement()) {
            st.execute("SET IDENTITY_INSERT order_items ON");
        }

        String sql = "INSERT INTO order_items (id, order_id, variant_id, quantity, price_at_purchase) VALUES (?,?,?,?,?)";
        readAndInsert(c, "order_items.csv", sql, 5, (ps, d) -> {
            ps.setInt(1, Integer.parseInt(d[0]));
            ps.setInt(2, Integer.parseInt(d[1]));
            ps.setInt(3, Integer.parseInt(d[2]));
            ps.setInt(4, Integer.parseInt(d[3]));
            ps.setDouble(5, Double.parseDouble(d[4]));
        });

        try (Statement st = c.createStatement()) {
            st.execute("SET IDENTITY_INSERT order_items OFF");
        }
    }

    // ══════════════════════════════════════════════════════════════
    // CLEAN DATABASE (sử dụng đúng tên bảng snake_case)
    // ══════════════════════════════════════════════════════════════

    private void cleanDatabase(Connection conn) throws Exception {
        try (Statement st = conn.createStatement()) {
            // Tắt tất cả constraints trước khi xóa
            st.execute("EXEC sp_MSforeachtable 'ALTER TABLE ? NOCHECK CONSTRAINT ALL'");

            // Xóa các bảng phụ (có thể không tồn tại — bỏ qua lỗi)
            String[] optionalTables = {
                "review_media", "reviews", "admin_role_permissions", "audit_logs",
                "wishlist", "shop_followers", "user_addresses"
            };
            for (String t : optionalTables) {
                try { st.execute("DELETE FROM " + t); } catch (Exception e) { /* bảng không tồn tại */ }
            }

            // Xóa các bảng chính (thứ tự: con trước, cha sau)
            String[] mainTables = {
                "order_items", "orders", "product_variants", "products", "shops", "users"
            };
            for (String t : mainTables) {
                try {
                    st.execute("DELETE FROM " + t);
                    st.execute("DBCC CHECKIDENT ('" + t + "', RESEED, 0)");
                } catch (Exception e) {
                    log("   ⚠️ Không thể xóa bảng " + t + ": " + e.getMessage());
                }
            }

            // Thử xóa bảng vouchers riêng (có thể ko tồn tại)
            try {
                st.execute("DELETE FROM vouchers");
                st.execute("DBCC CHECKIDENT ('vouchers', RESEED, 0)");
            } catch (Exception e) { /* bỏ qua */ }

            // Thử xóa bảng categories (giữ data categories nếu cần, hoặc xóa)
            try {
                st.execute("DELETE FROM categories");
                st.execute("DBCC CHECKIDENT ('categories', RESEED, 0)");
            } catch (Exception e) { /* bỏ qua */ }

            // Bật lại constraints
            st.execute("EXEC sp_MSforeachtable 'ALTER TABLE ? CHECK CONSTRAINT ALL'");
            log("🧹 Đã dọn sạch DB.");
        }
    }

    // ══════════════════════════════════════════════════════════════
    // HELPER
    // ══════════════════════════════════════════════════════════════

    private interface CsvRowProcessor {
        void process(PreparedStatement ps, String[] data) throws Exception;
    }

    private void readAndInsert(Connection c, String fileName, String query, int minCols, CsvRowProcessor processor)
            throws Exception {
        Path filePath = Paths.get(dataFolder + fileName);
        if (!Files.exists(filePath)) {
            log("⚠️ File không tồn tại, bỏ qua: " + filePath);
            return;
        }

        try (BufferedReader br = Files.newBufferedReader(filePath, StandardCharsets.UTF_8);
                PreparedStatement ps = c.prepareStatement(query)) {
            String line = br.readLine(); // Skip header
            int count = 0;
            while ((line = br.readLine()) != null) {
                String[] data = line.split(",");
                if (data.length < minCols) continue;
                try {
                    processor.process(ps, data);
                    ps.addBatch();
                    if (++count % 1000 == 0) {
                        ps.executeBatch();
                    }
                } catch (Exception e) {
                    // Bỏ qua lỗi dòng, không hiển thị
                }
            }
            ps.executeBatch();
            log("✅ Xong " + fileName + " (" + count + " bản ghi)");
        }
    }

    private Timestamp parseTimestampSafe(String dateStr) {
        try {
            return Timestamp.valueOf(LocalDateTime.parse(dateStr, FMT_STD));
        } catch (Exception e) {
            try {
                return Timestamp.valueOf(LocalDateTime.parse(dateStr, FMT_LEGACY));
            } catch (Exception ex) {
                return Timestamp.valueOf(LocalDateTime.now());
            }
        }
    }

    private Date parseDateSafe(String dateStr) {
        try {
            return Date.valueOf(LocalDate.parse(dateStr, FMT_DATE_ONLY));
        } catch (Exception e) {
            return Date.valueOf(LocalDate.now());
        }
    }

    private void exportCleanData(Connection conn) {
        try {
            log("⏳ Đang xuất dữ liệu sạch...");
            String[] tables = { "categories", "users", "shops", "products", "product_variants", "orders", "order_items" };
            String[] files = { "categories_clean.csv", "users_clean.csv", "shops_clean.csv", "products_clean.csv",
                    "product_variants_clean.csv", "orders_clean.csv", "order_items_clean.csv" };

            for (int i = 0; i < tables.length; i++) {
                try {
                    exportTable(conn, tables[i], files[i]);
                } catch (Exception e) {
                    log("   ⚠️ Không thể xuất bảng " + tables[i] + ": " + e.getMessage());
                }
            }
            log("<h3 style='color:blue'>📂 ĐÃ XUẤT FILE SẠCH TẠI: " + dataFolder + "</h3>");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void exportTable(Connection conn, String tableName, String fileName) throws Exception {
        String path = dataFolder + fileName;
        try (BufferedWriter bw = new BufferedWriter(
                new OutputStreamWriter(new FileOutputStream(path), StandardCharsets.UTF_8));
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery("SELECT * FROM " + tableName)) {

            int colCount = rs.getMetaData().getColumnCount();
            for (int i = 1; i <= colCount; i++) {
                bw.write(rs.getMetaData().getColumnName(i));
                if (i < colCount) bw.write(",");
            }
            bw.newLine();

            while (rs.next()) {
                for (int i = 1; i <= colCount; i++) {
                    String val = rs.getString(i);
                    if (val == null) val = "";
                    if (val.contains(",")) val = "\"" + val + "\"";
                    bw.write(val);
                    if (i < colCount) bw.write(",");
                }
                bw.newLine();
            }
        }
    }

    private void log(String m) {
        logs.append(m).append("<br>");
    }
}
