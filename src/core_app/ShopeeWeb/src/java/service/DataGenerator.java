package service;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileOutputStream; // Sửa import
import java.io.OutputStreamWriter; // Sửa import
import java.nio.charset.StandardCharsets; // Sửa import
import java.text.Normalizer; // Thêm Normalizer
import java.util.Random;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.regex.Pattern;

public class DataGenerator {

    private static final String FOLDER = "C:/data/";
    private static final Random rand = new Random();

    // CẤU HÌNH SỐ LƯỢNG (Giữ nguyên)
    private static final int TOTAL_USERS = 10000;
    private static final int TOTAL_SHOPS = 200;
    private static final int TOTAL_PRODUCTS = 5000;
    private static final int TOTAL_VARIANTS = 12000;
    private static final int TOTAL_ORDERS = 15000;
    private static final int TOTAL_ITEMS = 40000;

    // DATA POOL (Giữ nguyên)
    private static final String[] HO = {"Nguyen", "Tran", "Le", "Pham", "Hoang", "Huynh", "Phan", "Vu", "Vo", "Dang", "Bui", "Do", "Ho", "Ngo", "Duong", "Ly"};
    private static final String[] DEM = {"Van", "Thi", "Minh", "Duc", "My", "Ngoc", "Quang", "Tuan", "Anh", "Hong", "Xuan", "Thu", "Gia", "Thanh"};
    private static final String[] TEN = {"Anh", "Tuan", "Dung", "Hung", "Long", "Diep", "Lan", "Mai", "Hoa", "Cuong", "Manh", "Kien", "Trang", "Linh", "Phuong", "Thao", "Vy", "Tu", "Dat", "Son", "Khanh", "Huyen"};
    
    // DATA SP (Giữ nguyên)
    private static final String[] PROD_TYPE = {"Dien thoai", "Laptop", "Ao thun", "Quan Jean", "Giay Sneaker", "Tai nghe", "Son moi", "Kem chong nang", "Dong ho"};
    private static final String[] BRANDS = {"Samsung", "iPhone", "Xiaomi", "Oppo", "Dell", "Macbook", "Asus", "Coolmate", "Zara", "Gucci", "Nike", "Adidas", "Sony", "JBL", "Casio", "Rolex"};
    private static final String[] ADJECTIVES = {"Cao cap", "Gia re", "Chinh hang", "Sieu ben", "Moi 100%", "Fullbox", "Xach tay", "Giam gia soc", "Limited Edition"};

    private static final SimpleDateFormat dfStd = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
    private static final SimpleDateFormat dfErr = new SimpleDateFormat("dd/MM/yyyy HH:mm");

    public static void main(String[] args) {
        new File(FOLDER).mkdirs();
        System.out.println("Dang tao data rac...");

        genUsers(TOTAL_USERS);
        genShops(TOTAL_SHOPS);
        genProducts(TOTAL_PRODUCTS);
        genVariants(TOTAL_VARIANTS);
        genVouchers(100);
        genOrders(TOTAL_ORDERS);
        genOrderItems(TOTAL_ITEMS);

        System.out.println("✅ Da tao xong tai: " + FOLDER);
    }

    // --- HÀM GHI FILE UTF-8 (QUAN TRỌNG) ---
    private static BufferedWriter getWriter(String filename) throws Exception {
        return new BufferedWriter(new OutputStreamWriter(new FileOutputStream(FOLDER + filename), StandardCharsets.UTF_8));
    }

    // 1. GEN USER
    private static void genUsers(int count) {
        try (BufferedWriter bw = getWriter("users.csv")) {
            bw.write("id,full_name,email,phone,wallet,password_hash,note");
            bw.newLine();
            for (int i = 1; i <= count; i++) {
                String ho = getRandom(HO);
                String dem = getRandom(DEM);
                String ten = getRandom(TEN);
                String fullName = ho + " " + dem + " " + ten;

                // Xử lý email chuẩn hơn: Đạt -> dat
                String cleanTen = removeAccent(ten).toLowerCase(); 
                String cleanHo = removeAccent(ho).toLowerCase();
                int randomNum = rand.nextInt(9999);
                String email = cleanTen + "." + cleanHo + randomNum + "@gmail.com";
                
                String phone = "09" + String.format("%08d", rand.nextInt(100000000));
                String rawPass = "Pass" + i;
                String passHash = getMd5(rawPass);
                String note = "";

                // Logic tạo lỗi giả (Dirty Data)
                if (rand.nextDouble() < 0.1) {
                    int type = rand.nextInt(3);
                    switch (type) {
                        case 0 -> { email = email.replace("@", ""); note = "Loi Email"; }
                        case 1 -> { phone = phone.substring(1); note = "Loi Phone"; }
                        default -> { fullName = fullName.toLowerCase(); note = "Loi Ten"; }
                    }
                }
                bw.write(i + "," + fullName + "," + email + "," + phone + "," + (rand.nextInt(500) * 10000) + "," + passHash + "," + note);
                bw.newLine();
            }
        } catch (Exception e) { e.printStackTrace(); }
    }

    // 2. GEN PRODUCTS
    private static void genProducts(int count) {
        try (BufferedWriter bw = getWriter("products.csv")) {
            bw.write("id,shop_id,name,description");
            bw.newLine();
            for (int i = 1; i <= count; i++) {
                String name = getRandom(PROD_TYPE) + " " + getRandom(BRANDS) + " " + getRandom(ADJECTIVES) + " - Ma " + i;
                bw.write(i + "," + (rand.nextInt(TOTAL_SHOPS) + 1) + "," + name + ",Mo ta chi tiet san pham " + i);
                bw.newLine();
            }
        } catch (Exception e) { e.printStackTrace(); }
    }

    // 3. GEN VARIANTS
    private static void genVariants(int count) {
        try (BufferedWriter bw = getWriter("product_variants.csv")) {
            bw.write("id,product_id,color,size,stock,price");
            bw.newLine();
            String[] colors = {"Den", "Trang", "Xanh", "Do", "Vang"};
            String[] sizes = {"S", "M", "L", "XL", "29", "30", "31", "32"};

            for (int i = 1; i <= count; i++) {
                int stock = rand.nextInt(50) + 1;
                double price = (rand.nextInt(100) + 1) * 10000;

                // Tỷ lệ lỗi 15%
                if (rand.nextDouble() < 0.15) {
                    if (rand.nextBoolean()) stock = -1 * rand.nextInt(10); // Âm kho
                    else price = 0; // Giá 0
                }
                bw.write(i + "," + (rand.nextInt(TOTAL_PRODUCTS) + 1) + "," + getRandom(colors) + "," + getRandom(sizes) + "," + stock + "," + price);
                bw.newLine();
            }
        } catch (Exception e) { e.printStackTrace(); }
    }

    // 4. GEN ORDERS (ĐÃ SỬA NGÀY THÁNG RANDOM)
    private static void genOrders(int count) {
        try (BufferedWriter bw = getWriter("orders.csv")) {
            bw.write("id,user_id,total_amount,created_at");
            bw.newLine();
            long now = System.currentTimeMillis();
            
            for (int i = 1; i <= count; i++) {
                // Random thời gian lùi về quá khứ tối đa 365 ngày
                long randomTime = now - (long)(rand.nextDouble() * 365L * 24 * 60 * 60 * 1000);
                Date randomDate = new Date(randomTime);
                
                // 10% cơ hội bị sai format ngày
                String dateStr = (rand.nextDouble() < 0.1) ? dfErr.format(randomDate) : dfStd.format(randomDate);
                
                bw.write(i + "," + (rand.nextInt(TOTAL_USERS) + 1) + "," + ((rand.nextInt(50) + 1) * 10000) + "," + dateStr);
                bw.newLine();
            }
        } catch (Exception e) { e.printStackTrace(); }
    }

    // CÁC HÀM PHỤ KHÁC
    private static void genShops(int c) {
        try (BufferedWriter w = getWriter("shops.csv")) {
            w.write("id,shop_name,rating\n");
            for (int i = 1; i <= c; i++) w.write(i + ",Shop " + getRandom(HO) + " Official," + String.format("%.1f", (3 + rand.nextDouble() * 2)) + "\n");
        } catch (Exception e) {}
    }

    private static void genOrderItems(int c) {
        try (BufferedWriter w = getWriter("order_items.csv")) {
            w.write("id,order_id,variant_id,quantity,price_at_purchase\n");
            for (int i = 1; i <= c; i++) w.write(i + "," + (rand.nextInt(TOTAL_ORDERS) + 1) + "," + (rand.nextInt(TOTAL_VARIANTS) + 1) + ",1,100000\n");
        } catch (Exception e) {}
    }

    private static void genVouchers(int c) {
        try (BufferedWriter w = getWriter("vouchers.csv")) {
            w.write("code,value,min_order,start_date,end_date\n");
            for (int i = 1; i <= c; i++) w.write("VOUCHER" + i + ",10000,50000,2026-01-01,2026-12-31\n");
        } catch (Exception e) {}
    }

    private static String getRandom(String[] arr) { return arr[rand.nextInt(arr.length)]; }

    // --- SỬA HÀM NÀY ĐỂ TẠO EMAIL CHUẨN ---
    private static String removeAccent(String s) {
        String temp = Normalizer.normalize(s, Normalizer.Form.NFD);
        Pattern pattern = Pattern.compile("\\p{InCombiningDiacriticalMarks}+");
        return pattern.matcher(temp).replaceAll("").replace('đ', 'd').replace('Đ', 'D');
    }

    private static String getMd5(String input) {
        try {
            java.security.MessageDigest md = java.security.MessageDigest.getInstance("MD5");
            byte[] messageDigest = md.digest(input.getBytes());
            java.math.BigInteger no = new java.math.BigInteger(1, messageDigest);
            String hashtext = no.toString(16);
            while (hashtext.length() < 32) hashtext = "0" + hashtext;
            return hashtext;
        } catch (Exception e) { return ""; }
    }
}