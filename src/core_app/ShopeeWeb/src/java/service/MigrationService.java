package service;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.FileReader;
import java.io.FileWriter;     
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;     
import java.sql.Statement;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.Date;

public class MigrationService {

    
    static final String DB_URL =      
 "jdbc:sqlserver://localhost:1433;"
+ "databaseName=ShopeeDB;"
+ "encrypt=true;"
+ "trustServerCertificate=true;";

String user = "sa";
String pass = "123456";

    static final String FOLDER = "D:\\data\\";

    
    SimpleDateFormat dfStd = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss"); 
    SimpleDateFormat dfLegacy = new SimpleDateFormat("dd/MM/yyyy HH:mm"); 

    private StringBuilder logs = new StringBuilder();

    public String startMigration() {
        logs.setLength(0);
        log("🚀 BẮT ĐẦU IMPORT & CLEAN DATA...");

        try { Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver"); } catch(Exception e){}

        try (Connection conn = DriverManager.getConnection(DB_URL,user,pass)) {
            conn.setAutoCommit(false);
            
           
            cleanDatabase(conn);

            
            importUsers(conn);
            importShops(conn);
            importProducts(conn);
            importVariants(conn);   
            importVouchers(conn);
            importOrders(conn);     
            importOrderItems(conn);

            conn.commit(); 
            log("<h2 style='color:green'>✅ IMPORT THÀNH CÔNG! Dữ liệu trong DB đã sạch.</h2>");

            
            exportCleanData(conn);
            log("<h2 style='color:blue'>📂 ĐÃ XUẤT 7 FILE CSV SẠCH TẠI: " + FOLDER + "</h2>");

        } catch (Exception e) {
            log("<h2 style='color:red'>❌ LỖI: " + e.getMessage() + "</h2>");
            e.printStackTrace();
        }
        return logs.toString();
    }

   
    private void exportCleanData(Connection conn) {
        try {
            log("⏳ Đang xuất dữ liệu sạch ra CSV...");
            exportTable(conn, "Users", "users_clean.csv");
            exportTable(conn, "Shops", "shops_clean.csv");
            exportTable(conn, "Products", "products_clean.csv");
            exportTable(conn, "ProductVariants", "product_variants_clean.csv");
            exportTable(conn, "Orders", "orders_clean.csv");
            exportTable(conn, "OrderItems", "order_items_clean.csv");
            exportTable(conn, "Vouchers", "vouchers_clean.csv");
        } catch (Exception e) {
            log("❌ Lỗi Export: " + e.getMessage());
        }
    }

    private void exportTable(Connection conn, String tableName, String fileName) throws Exception {
        String path = FOLDER + fileName;
        try (BufferedWriter bw = new BufferedWriter(new FileWriter(path));
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery("SELECT * FROM " + tableName)) {
            
            int colCount = rs.getMetaData().getColumnCount();
            
            // Ghi Header
            for (int i = 1; i <= colCount; i++) {
                bw.write(rs.getMetaData().getColumnName(i));
                if (i < colCount) bw.write(",");
            }
            bw.newLine();
            
            // Ghi Data
            while (rs.next()) {
                for (int i = 1; i <= colCount; i++) {
                    String val = rs.getString(i);
                    if (val == null) val = "";
                    // Xử lý dấu phẩy nếu có trong data để tránh lỗi CSV
                    if (val.contains(",")) val = "\"" + val + "\""; 
                    bw.write(val);
                    if (i < colCount) bw.write(",");
                }
                bw.newLine();
            }
            log("   -> Đã tạo file: " + fileName);
        }
    }

    
    private void importOrders(Connection conn) throws Exception {
        log("📦 Orders (Đang xử lý format ngày tháng)...");
        readAndInsert(conn, "orders.csv", "INSERT INTO Orders VALUES (?,?,?,?,?)", 4, (ps, d) -> {
            ps.setInt(1, Integer.parseInt(d[0]));
            ps.setInt(2, Integer.parseInt(d[1]));
            ps.setDouble(3, Double.parseDouble(d[2]));
            
            Timestamp t;
            String note = "";
            String rawDate = d[3];

            try {
                t = Timestamp.valueOf(rawDate); 
            } catch (Exception e) {
                try {
                    Date parsedDate = dfLegacy.parse(rawDate);
                    t = new Timestamp(parsedDate.getTime());
                    note = "Format Cu (" + rawDate + ") -> Fix: Chuan SQL";
                } catch (Exception ex) {
                    t = new Timestamp(System.currentTimeMillis());
                    note = "Date Error -> Fix: Now";
                }
            }
            
            ps.setTimestamp(4, t);
            ps.setString(5, note);
        });
    }

    private void cleanDatabase(Connection conn) throws Exception {
        try (Statement st = conn.createStatement()) {
             st.execute("ALTER TABLE OrderItems NOCHECK CONSTRAINT ALL");
             st.execute("ALTER TABLE Orders NOCHECK CONSTRAINT ALL");
             st.execute("ALTER TABLE ProductVariants NOCHECK CONSTRAINT ALL");
             st.execute("DELETE FROM OrderItems"); st.execute("DELETE FROM Orders");
             st.execute("DELETE FROM ProductVariants"); st.execute("DELETE FROM Products");
             st.execute("DELETE FROM Vouchers"); st.execute("DELETE FROM Shops"); st.execute("DELETE FROM Users");
             st.execute("ALTER TABLE OrderItems CHECK CONSTRAINT ALL");
             st.execute("ALTER TABLE Orders CHECK CONSTRAINT ALL");
             st.execute("ALTER TABLE ProductVariants CHECK CONSTRAINT ALL");
        }
    }
    
    private void importUsers(Connection c) throws Exception { readAndInsert(c,"users.csv","INSERT INTO Users VALUES(?,?,?,?,?,?)",5,(p,d)->{
        p.setInt(1,Integer.parseInt(d[0])); 
        String name=d[1], email=d[2], phone=d[3];
        if(!email.contains("@")) email = email.replace("gmail.com", "@gmail.com");
        if(!phone.startsWith("0")) phone = "0" + phone;
        p.setString(2,name); p.setString(3,email); p.setString(4,phone); 
        p.setDouble(5,Double.parseDouble(d[4])); p.setString(6,"");
    });}
    
    private void importShops(Connection c) throws Exception { readAndInsert(c,"shops.csv","INSERT INTO Shops VALUES(?,?,?)",3,(p,d)->{p.setInt(1,Integer.parseInt(d[0]));p.setString(2,d[1]);p.setDouble(3,Double.parseDouble(d[2]));}); }
    
    private void importProducts(Connection c) throws Exception { readAndInsert(c,"products.csv","INSERT INTO Products VALUES(?,?,?,?)",4,(p,d)->{p.setInt(1,Integer.parseInt(d[0]));p.setInt(2,Integer.parseInt(d[1]));p.setString(3,d[2]);p.setString(4,d[3]);}); }
    
    private void importVariants(Connection c) throws Exception { readAndInsert(c,"product_variants.csv","INSERT INTO ProductVariants VALUES(?,?,?,?,?,?,?)",6,(p,d)->{
        p.setInt(1,Integer.parseInt(d[0])); p.setInt(2,Integer.parseInt(d[1])); p.setString(3,d[2]); p.setString(4,d[3]);
        int stock=Integer.parseInt(d[4]); double price=Double.parseDouble(d[5]); String note="";
        if(stock<0){ stock=0; note="Loi Stock -> Fix: 0"; } 
        if(price<=0){ price=50000; note+=" | Loi Gia -> Fix"; }
        p.setInt(5,stock); p.setDouble(6,price); p.setString(7,note);
    }); }
    
    private void importVouchers(Connection c) throws Exception { 
        readAndInsert(c,"vouchers.csv","INSERT INTO Vouchers VALUES(?,?,?,?,?)",5,(p,d)->{
            p.setString(1,d[0]); p.setDouble(2,Double.parseDouble(d[1])); p.setDouble(3,Double.parseDouble(d[2]));
            try { p.setDate(4,java.sql.Date.valueOf(d[3])); } catch(Exception e){ p.setDate(4,new java.sql.Date(System.currentTimeMillis())); }
            try { p.setDate(5,java.sql.Date.valueOf(d[4])); } catch(Exception e){ p.setDate(5,new java.sql.Date(System.currentTimeMillis())); }
        }); 
    }
    
    private void importOrderItems(Connection c) throws Exception { readAndInsert(c,"order_items.csv","INSERT INTO OrderItems VALUES(?,?,?,?,?)",5,(p,d)->{p.setInt(1,Integer.parseInt(d[0]));p.setInt(2,Integer.parseInt(d[1]));p.setInt(3,Integer.parseInt(d[2]));p.setInt(4,Integer.parseInt(d[3]));p.setDouble(5,Double.parseDouble(d[4]));}); }

    private interface S { void s(PreparedStatement p, String[] d) throws Exception; }
    private void readAndInsert(Connection c, String f, String q, int l, S s) throws Exception {
        try(BufferedReader br=new BufferedReader(new FileReader(FOLDER+f)); PreparedStatement ps=c.prepareStatement(q)){
            String line=br.readLine(); int count=0;
            while((line=br.readLine())!=null){
                String[] d=line.split(","); if(d.length<l)continue;
                s.s(ps,d); ps.addBatch(); if(++count%1000==0) ps.executeBatch();
            } ps.executeBatch(); log("-> Xong "+f);
        }
    }
    private void log(String m) { logs.append(m).append("<br>"); }
}