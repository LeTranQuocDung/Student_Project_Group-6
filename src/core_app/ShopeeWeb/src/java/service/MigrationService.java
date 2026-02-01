package service;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.FileOutputStream;
import java.io.OutputStreamWriter;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
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

public class MigrationService {

    // CẤU HÌNH DB
    static final String DB_URL = "jdbc:sqlserver://localhost:1433;databaseName=ShopeeDB;encrypt=true;trustServerCertificate=true";
    static final String USER = "sa";
    static final String PASS = "123456";
    static final String FOLDER = "C:/data/"; // Đảm bảo thư mục này đúng

    private static final DateTimeFormatter FMT_STD = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
    private static final DateTimeFormatter FMT_LEGACY = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
    private static final DateTimeFormatter FMT_DATE_ONLY = DateTimeFormatter.ofPattern("yyyy-MM-dd");

    private StringBuilder logs = new StringBuilder();

    public String startMigration() {
        logs.setLength(0);
        log("🚀 BẮT ĐẦU IMPORT & CLEAN DATA ...");

        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        } catch (ClassNotFoundException e) {
        }

        try (Connection conn = DriverManager.getConnection(DB_URL, USER, PASS)) {
            conn.setAutoCommit(false);

            // 1. DỌN SẠCH DB
            cleanDatabase(conn);

            // 2. IMPORT (Thứ tự quan trọng: Cha trước -> Con sau)
            // Dùng hàm importWithID để ép SQL nhận ID từ CSV
            importUsers(conn);
            importShops(conn);
            importProducts(conn);       // Products cần ShopID -> Shop phải có trước
            importVariants(conn);       // Variants cần ProductID -> Product phải có trước
            importVouchers(conn);
            importOrders(conn);         // Orders cần UserID
            importOrderItems(conn);     // Items cần OrderID và VariantID

            conn.commit();
            log("<h2 style='color:green'>✅ IMPORT THÀNH CÔNG!</h2>");

            // 3. XUẤT NGƯỢC RA CSV (Backup)
            exportCleanData(conn);

        } catch (Exception e) {
            e.printStackTrace();
            log("<h2 style='color:red'>❌ LỖI: " + e.getMessage() + "</h2>");
        }
        return logs.toString();
    }

    // --- CÁC HÀM IMPORT (ĐÃ SỬA: ÉP ID TỪ CSV VÀO DB) ---
    private void importUsers(Connection c) throws Exception {
        // Bật chế độ nhét ID thủ công
        try (Statement st = c.createStatement()) {
            st.execute("SET IDENTITY_INSERT Users ON");
        }

        String sql = "INSERT INTO Users (id, full_name, email, phone, wallet, password_hash, note, role) VALUES (?,?,?,?,?,?,?,?)";
        readAndInsert(c, "users.csv", sql, 7, (ps, d) -> {
            ps.setInt(1, Integer.parseInt(d[0])); // ÉP ID (d[0])

            String email = d[2];
            String phone = d[3];
            if (!email.contains("@")) {
                email = email.replace("gmail.com", "@gmail.com");
            }
            if (!phone.startsWith("0")) {
                phone = "0" + phone;
            }

            ps.setString(2, d[1]);
            ps.setString(3, email);
            ps.setString(4, phone);
            ps.setDouble(5, Double.parseDouble(d[4]));
            ps.setString(6, d[5]);
            ps.setString(7, d[6]);
            ps.setString(8, "user");
        });

        // Tắt chế độ nhét ID
        try (Statement st = c.createStatement()) {
            st.execute("SET IDENTITY_INSERT Users OFF");
        }
    }

    private void importShops(Connection c) throws Exception {
        try (Statement st = c.createStatement()) {
            st.execute("SET IDENTITY_INSERT Shops ON");
        }

        String sql = "INSERT INTO Shops (id, shop_name, rating) VALUES (?,?,?)";
        readAndInsert(c, "shops.csv", sql, 3, (ps, d) -> {
            ps.setInt(1, Integer.parseInt(d[0])); // ÉP ID
            ps.setString(2, d[1]);
            ps.setDouble(3, Double.parseDouble(d[2]));
        });

        try (Statement st = c.createStatement()) {
            st.execute("SET IDENTITY_INSERT Shops OFF");
        }
    }

    private void importProducts(Connection c) throws Exception {
        try (Statement st = c.createStatement()) {
            st.execute("SET IDENTITY_INSERT Products ON");
        }

        String sql = "INSERT INTO Products (id, shop_id, name, description, price, image_url) VALUES (?,?,?,?,?,?)";
        readAndInsert(c, "products.csv", sql, 6, (ps, d) -> {
            ps.setInt(1, Integer.parseInt(d[0])); // ÉP ID
            ps.setInt(2, Integer.parseInt(d[1])); // shop_id
            ps.setString(3, d[2]);
            ps.setString(4, d[3]);
            ps.setDouble(5, Double.parseDouble(d[4]));
            ps.setString(6, d[5]);
        });

        try (Statement st = c.createStatement()) {
            st.execute("SET IDENTITY_INSERT Products OFF");
        }
    }

    private void importVariants(Connection c) throws Exception {
        try (Statement st = c.createStatement()) {
            st.execute("SET IDENTITY_INSERT ProductVariants ON");
        }

        String sql = "INSERT INTO ProductVariants (id, product_id, color, size, stock, price, note) VALUES (?,?,?,?,?,?,?)";
        readAndInsert(c, "product_variants.csv", sql, 6, (ps, d) -> {
            ps.setInt(1, Integer.parseInt(d[0])); // ÉP ID
            ps.setInt(2, Integer.parseInt(d[1])); // product_id
            ps.setString(3, d[2]);
            ps.setString(4, d[3]);

            int stock = Integer.parseInt(d[4]);
            double price = Double.parseDouble(d[5]);
            String note = "";
            if (stock < 0) {
                stock = 0;
                note = "Fix Stock Am";
            }
            if (price <= 0) {
                price = 50000;
                note = "Fix Gia 0";
            }

            ps.setInt(5, stock);
            ps.setDouble(6, price);
            ps.setString(7, note);
        });

        try (Statement st = c.createStatement()) {
            st.execute("SET IDENTITY_INSERT ProductVariants OFF");
        }
    }

    private void importVouchers(Connection c) throws Exception {
        try (Statement st = c.createStatement()) {
            st.execute("SET IDENTITY_INSERT Vouchers ON");
        }
        // Vouchers trong CSV có code là d[0] nhưng bảng có ID, ta giả định CSV chưa có ID
        // Nhưng DataGenerator nãy code là code,value... k có ID số.
        // Riêng bảng này ta để tự tăng (vì DataGenerator không sinh ID số cho Voucher)
        // -> KHÔNG ÉP ID CHO VOUCHER ĐỂ TRÁNH LỖI, VÌ CSV KHÔNG CÓ CỘT ID SỐ
        try (Statement st = c.createStatement()) {
            st.execute("SET IDENTITY_INSERT Vouchers OFF");
        }

        String sql = "INSERT INTO Vouchers (code, value, min_order, start_date, end_date) VALUES (?,?,?,?,?)";
        readAndInsert(c, "vouchers.csv", sql, 5, (ps, d) -> {
            ps.setString(1, d[0]);
            ps.setDouble(2, Double.parseDouble(d[1]));
            ps.setDouble(3, Double.parseDouble(d[2]));
            ps.setDate(4, parseDateSafe(d[3]));
            ps.setDate(5, parseDateSafe(d[4]));
        });
    }

    private void importOrders(Connection c) throws Exception {
        try (Statement st = c.createStatement()) {
            st.execute("SET IDENTITY_INSERT Orders ON");
        }

        String sql = "INSERT INTO Orders (id, user_id, total_amount, created_at, note) VALUES (?,?,?,?,?)";
        readAndInsert(c, "orders.csv", sql, 4, (ps, d) -> {
            ps.setInt(1, Integer.parseInt(d[0])); // ÉP ID
            ps.setInt(2, Integer.parseInt(d[1])); // user_id
            ps.setDouble(3, Double.parseDouble(d[2]));

            String rawDate = d[3];
            Timestamp t = parseTimestampSafe(rawDate);
            String note = "";
            if (rawDate.contains("/")) {
                note = "Fix Format Date";
            }

            ps.setTimestamp(4, t);
            ps.setString(5, note);
        });

        try (Statement st = c.createStatement()) {
            st.execute("SET IDENTITY_INSERT Orders OFF");
        }
    }

    private void importOrderItems(Connection c) throws Exception {
        try (Statement st = c.createStatement()) {
            st.execute("SET IDENTITY_INSERT OrderItems ON");
        }

        String sql = "INSERT INTO OrderItems (id, order_id, variant_id, quantity, price_at_purchase) VALUES (?,?,?,?,?)";
        readAndInsert(c, "order_items.csv", sql, 5, (ps, d) -> {
            ps.setInt(1, Integer.parseInt(d[0])); // ÉP ID
            ps.setInt(2, Integer.parseInt(d[1]));
            ps.setInt(3, Integer.parseInt(d[2]));
            ps.setInt(4, Integer.parseInt(d[3]));
            ps.setDouble(5, Double.parseDouble(d[4]));
        });

        try (Statement st = c.createStatement()) {
            st.execute("SET IDENTITY_INSERT OrderItems OFF");
        }
    }

    // --- CLEAN DATABASE ---
    private void cleanDatabase(Connection conn) throws Exception {
        try (Statement st = conn.createStatement()) {
            st.execute("sp_MSforeachtable 'ALTER TABLE ? NOCHECK CONSTRAINT ALL'");
            String[] tables = {"OrderItems", "Orders", "ProductVariants", "Products", "Vouchers", "Shops", "Users"};
            for (String t : tables) {
                st.execute("DELETE FROM " + t);
                // Vì ta dùng ép ID (IDENTITY_INSERT) nên việc reseed không quá quan trọng nhưng cứ để cho sạch
                try {
                    st.execute("DBCC CHECKIDENT ('" + t + "', RESEED, 0)");
                } catch (Exception e) {
                }
            }
            st.execute("sp_MSforeachtable 'ALTER TABLE ? CHECK CONSTRAINT ALL'");
            log("🧹 Đã dọn sạch DB.");
        }
    }

    // --- HELPER (GIỮ NGUYÊN) ---
    private interface CsvRowProcessor {

        void process(PreparedStatement ps, String[] data) throws Exception;
    }

    private void readAndInsert(Connection c, String fileName, String query, int minCols, CsvRowProcessor processor) throws Exception {
        try (BufferedReader br = Files.newBufferedReader(Paths.get(FOLDER + fileName), StandardCharsets.UTF_8); PreparedStatement ps = c.prepareStatement(query)) {
            String line = br.readLine();
            int count = 0;
            while ((line = br.readLine()) != null) {
                String[] data = line.split(",");
                if (data.length < minCols) {
                    continue;
                }
                try {
                    processor.process(ps, data);
                    ps.addBatch();
                    if (++count % 1000 == 0) {
                        ps.executeBatch();
                    }
                } catch (Exception e) {
                }
            }
            ps.executeBatch();
            log("-> Xong " + fileName + " (" + count + ")");
        }
    }

    // Copy lại đoạn Export và ParseDate ở code cũ vào đây (không thay đổi)
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
        // ... Code export cũ giữ nguyên ...
        try {
            log("⏳ Đang xuất dữ liệu sạch...");
            String[] tables = {"Users", "Shops", "Products", "ProductVariants", "Orders", "OrderItems", "Vouchers"};
            String[] files = {"users_clean.csv", "shops_clean.csv", "products_clean.csv", "product_variants_clean.csv", "orders_clean.csv", "order_items_clean.csv", "vouchers_clean.csv"};

            for (int i = 0; i < tables.length; i++) {
                exportTable(conn, tables[i], files[i]);
            }
            log("<h3 style='color:blue'>📂 ĐÃ XUẤT FILE SẠCH TẠI: " + FOLDER + "</h3>");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void exportTable(Connection conn, String tableName, String fileName) throws Exception {
        String path = FOLDER + fileName;
        try (BufferedWriter bw = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(path), StandardCharsets.UTF_8)); Statement stmt = conn.createStatement(); ResultSet rs = stmt.executeQuery("SELECT * FROM " + tableName)) {

            int colCount = rs.getMetaData().getColumnCount();
            for (int i = 1; i <= colCount; i++) {
                bw.write(rs.getMetaData().getColumnName(i));
                if (i < colCount) {
                    bw.write(",");
                }
            }
            bw.newLine();

            while (rs.next()) {
                for (int i = 1; i <= colCount; i++) {
                    String val = rs.getString(i);
                    if (val == null) {
                        val = "";
                    }
                    if (val.contains(",")) {
                        val = "\"" + val + "\"";
                    }
                    bw.write(val);
                    if (i < colCount) {
                        bw.write(",");
                    }
                }
                bw.newLine();
            }
        }
    }

    private void log(String m) {
        logs.append(m).append("<br>");
    }
}
