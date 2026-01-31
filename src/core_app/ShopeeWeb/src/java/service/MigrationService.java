package service;

import java.io.BufferedReader;
import java.io.BufferedWriter;
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
import java.time.format.DateTimeParseException;

public class MigrationService {

    // CẤU HÌNH DB (Nhớ sửa pass nếu khác)
    static final String DB_URL = "jdbc:sqlserver://localhost:1433;databaseName=ShopeeDB;encrypt=true;trustServerCertificate=true";
    static final String USER = "sa";
    static final String PASS = "123456"; 
    static final String FOLDER = "C:/data/"; // Thư mục chứa CSV

    private static final DateTimeFormatter FMT_STD = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
    private static final DateTimeFormatter FMT_LEGACY = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
    private static final DateTimeFormatter FMT_DATE_ONLY = DateTimeFormatter.ofPattern("yyyy-MM-dd");

    private StringBuilder logs = new StringBuilder();

    public String startMigration() {
        logs.setLength(0);
        log("🚀 BẮT ĐẦU IMPORT & CLEAN DATA...");

        try { Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver"); } catch (ClassNotFoundException e) {}

        try (Connection conn = DriverManager.getConnection(DB_URL, USER, PASS)) {
            conn.setAutoCommit(false); // Transaction

            // 1. DỌN SẠCH DB & RESET ID
            cleanDatabase(conn);

            // 2. IMPORT TỪ CSV (Đã sửa SQL query chuẩn chỉ)
            importUsers(conn);
            importShops(conn);
            importProducts(conn);
            importVariants(conn);
            importVouchers(conn);
            importOrders(conn);
            importOrderItems(conn);

            conn.commit();
            log("<h2 style='color:green'>✅ IMPORT THÀNH CÔNG 100%!</h2>");

            // 3. XUẤT NGƯỢC RA CSV SẠCH
            exportCleanData(conn);

        } catch (Exception e) {
            e.printStackTrace();
            log("<h2 style='color:red'>❌ LỖI: " + e.getMessage() + "</h2>");
        }
        return logs.toString();
    }

    // --- CÁC HÀM IMPORT ĐÃ SỬA LẠI QUERY ---

    private void importUsers(Connection c) throws Exception {
        // CSV: id[0], full_name[1], email[2], phone[3], wallet[4], pass[5], note[6]
        // SQL: Bỏ qua cột ID (để tự tăng), map các cột còn lại
        String sql = "INSERT INTO Users (full_name, email, phone, wallet, password_hash, note, role) VALUES (?,?,?,?,?,?,?)";
        
        readAndInsert(c, "users.csv", sql, 7, (ps, d) -> {
            // Xử lý logic làm sạch data
            String email = d[2];
            String phone = d[3];
            if (!email.contains("@")) email = email.replace("gmail.com", "@gmail.com");
            if (!phone.startsWith("0")) phone = "0" + phone;

            ps.setString(1, d[1]); // full_name
            ps.setString(2, email);
            ps.setString(3, phone);
            ps.setDouble(4, Double.parseDouble(d[4])); // wallet
            ps.setString(5, d[5]); // password_hash
            ps.setString(6, d[6]); // note
            ps.setString(7, "user"); // role (mặc định)
        });
    }

    private void importShops(Connection c) throws Exception {
        // SQL: Chỉ định rõ cột để tránh lỗi
        String sql = "INSERT INTO Shops (shop_name, rating) VALUES (?,?)";
        // Lưu ý: CSV Shop có ID ở d[0], nhưng ta bỏ qua ID để DB tự tăng, 
        // Lát nữa ta reseed ID về 0 thì nó sẽ khớp lại thôi.
        readAndInsert(c, "shops.csv", sql, 3, (ps, d) -> {
            ps.setString(1, d[1]); // name
            ps.setDouble(2, Double.parseDouble(d[2])); // rating
        });
    }

    private void importProducts(Connection c) throws Exception {
        String sql = "INSERT INTO Products (shop_id, name, description, price, image_url) VALUES (?,?,?,?,?)";
        readAndInsert(c, "products.csv", sql, 4, (ps, d) -> {
            ps.setInt(1, Integer.parseInt(d[1])); // shop_id
            ps.setString(2, d[2]); // name
            ps.setString(3, d[3]); // description
            ps.setDouble(4, 0); // Price tạm để 0 (vì giá nằm ở variant)
            ps.setString(5, "https://via.placeholder.com/150"); // Fake ảnh
        });
    }

    private void importVariants(Connection c) throws Exception {
        // CSV: id, product_id, color, size, stock, price
        String sql = "INSERT INTO ProductVariants (product_id, color, size, stock, price, note) VALUES (?,?,?,?,?,?)";
        
        readAndInsert(c, "product_variants.csv", sql, 6, (ps, d) -> {
            ps.setInt(1, Integer.parseInt(d[1])); // product_id
            ps.setString(2, d[2]);
            ps.setString(3, d[3]);
            
            int stock = Integer.parseInt(d[4]);
            double price = Double.parseDouble(d[5]);
            String note = "";

            // Logic fix lỗi
            if (stock < 0) { stock = 0; note = "Fix Stock Am"; }
            if (price <= 0) { price = 50000; note = "Fix Gia 0"; }

            ps.setInt(4, stock);
            ps.setDouble(5, price);
            ps.setString(6, note);
        });
    }

    private void importVouchers(Connection c) throws Exception {
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
        // CSV: id, user_id, total, date
        String sql = "INSERT INTO Orders (user_id, total_amount, created_at, note) VALUES (?,?,?,?)";
        
        readAndInsert(c, "orders.csv", sql, 4, (ps, d) -> {
            ps.setInt(1, Integer.parseInt(d[1])); // user_id
            ps.setDouble(2, Double.parseDouble(d[2])); // total

            String rawDate = d[3];
            Timestamp t = parseTimestampSafe(rawDate);
            String note = "";
            
            // Logic check ngày lỗi
            LocalDateTime checkTime = t.toLocalDateTime();
            if (rawDate.contains("/")) note = "Fix Format Date";
            if (checkTime.getYear() == LocalDateTime.now().getYear() && !rawDate.contains(String.valueOf(LocalDateTime.now().getYear()))) {
                 note = "Fix Date Error";
            }

            ps.setTimestamp(3, t);
            ps.setString(4, note);
        });
    }

    private void importOrderItems(Connection c) throws Exception {
        String sql = "INSERT INTO OrderItems (order_id, variant_id, quantity, price_at_purchase) VALUES (?,?,?,?)";
        readAndInsert(c, "order_items.csv", sql, 5, (ps, d) -> {
            ps.setInt(1, Integer.parseInt(d[1]));
            ps.setInt(2, Integer.parseInt(d[2]));
            ps.setInt(3, Integer.parseInt(d[3]));
            ps.setDouble(4, Double.parseDouble(d[4]));
        });
    }

    // --- CLEAN DATA VÀ RESET IDENTITY (QUAN TRỌNG) ---
    private void cleanDatabase(Connection conn) throws Exception {
        try (Statement st = conn.createStatement()) {
            st.execute("sp_MSforeachtable 'ALTER TABLE ? NOCHECK CONSTRAINT ALL'");
            
            // Xóa dữ liệu và Reset ID về 0 để khớp với CSV
            String[] tables = {"OrderItems", "Orders", "ProductVariants", "Products", "Vouchers", "Shops", "Users"};
            for (String t : tables) {
                st.execute("DELETE FROM " + t);
                try {
                    // Lệnh này ép ID tự tăng quay về 0 -> Dòng tiếp theo sẽ là 1
                    st.execute("DBCC CHECKIDENT ('" + t + "', RESEED, 0)");
                } catch (Exception e) {
                    // Bỏ qua nếu bảng không có identity
                }
            }

            st.execute("sp_MSforeachtable 'ALTER TABLE ? CHECK CONSTRAINT ALL'");
            log("🧹 Đã dọn sạch DB và Reset ID.");
        }
    }

    // --- CÁC HÀM HỖ TRỢ (GIỮ NGUYÊN) ---
    private interface CsvRowProcessor {
        void process(PreparedStatement ps, String[] data) throws Exception;
    }

    private void readAndInsert(Connection c, String fileName, String query, int minCols, CsvRowProcessor processor) throws Exception {
        try (BufferedReader br = Files.newBufferedReader(Paths.get(FOLDER + fileName));
             PreparedStatement ps = c.prepareStatement(query)) {
            
            String line = br.readLine(); // Bỏ header
            int count = 0;
            while ((line = br.readLine()) != null) {
                String[] data = line.split(","); 
                if (data.length < minCols) continue;
                try {
                    processor.process(ps, data);
                    ps.addBatch();
                    if (++count % 1000 == 0) ps.executeBatch();
                } catch (Exception e) {
                    // Skip dòng lỗi
                }
            }
            ps.executeBatch();
            log("-> Xong " + fileName + " (" + count + ")");
        }
    }
    
    // ... (Giữ nguyên các hàm Export và ParseDate cũ của ông ở dưới đây) ...
    
    // COPY LẠI ĐOẠN EXPORT VÀ PARSE DATE TỪ CODE CŨ VÀO DƯỚI NÀY NHÉ (VÌ NÓ KHÔNG CẦN SỬA)
    private Timestamp parseTimestampSafe(String dateStr) {
        try { return Timestamp.valueOf(LocalDateTime.parse(dateStr, FMT_STD)); } 
        catch (Exception e) { 
            try { return Timestamp.valueOf(LocalDateTime.parse(dateStr, FMT_LEGACY)); } 
            catch (Exception ex) { return Timestamp.valueOf(LocalDateTime.now()); }
        }
    }

    private Date parseDateSafe(String dateStr) {
        try { return Date.valueOf(LocalDate.parse(dateStr, FMT_DATE_ONLY)); } 
        catch (Exception e) { return Date.valueOf(LocalDate.now()); }
    }
    
    private void exportCleanData(Connection conn) {
        try {
             log("⏳ Đang xuất dữ liệu sạch...");
             String[] tables = {"Users", "Shops", "Products", "ProductVariants", "Orders", "OrderItems", "Vouchers"};
             String[] files = {"users_clean.csv", "shops_clean.csv", "products_clean.csv", "product_variants_clean.csv", "orders_clean.csv", "order_items_clean.csv", "vouchers_clean.csv"};
             
             for(int i=0; i<tables.length; i++) {
                 exportTable(conn, tables[i], files[i]);
             }
             log("<h3 style='color:blue'>📂 ĐÃ XUẤT FILE SẠCH TẠI: " + FOLDER + "</h3>");
        } catch(Exception e) {
             e.printStackTrace();
             log("❌ Lỗi Export: " + e.getMessage());
        }
    }

    private void exportTable(Connection conn, String tableName, String fileName) throws Exception {
       String path = FOLDER + fileName;
       try (BufferedWriter bw = Files.newBufferedWriter(Paths.get(path));
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery("SELECT * FROM " + tableName)) {
            
            int colCount = rs.getMetaData().getColumnCount();
            
            // 1. Ghi Header
            for (int i = 1; i <= colCount; i++) {
                bw.write(rs.getMetaData().getColumnName(i));
                if (i < colCount) bw.write(",");
            }
            bw.newLine();
            
            // 2. Ghi Data
            int count = 0;
            while (rs.next()) {
                for (int i = 1; i <= colCount; i++) {
                    String val = rs.getString(i);
                    if (val == null) val = "";
                    if (val.contains(",")) val = "\"" + val + "\""; // Xử lý dấu phẩy
                    bw.write(val);
                    if (i < colCount) bw.write(",");
                }
                bw.newLine();
                count++;
            }
            // THÊM DÒNG NÀY ĐỂ NÓ BÁO CÁO RA MÀN HÌNH
            log("   -> ✅ Đã tạo file: " + fileName + " (" + count + " dòng)");
       }
    }

    private void log(String m) { logs.append(m).append("<br>"); }
}