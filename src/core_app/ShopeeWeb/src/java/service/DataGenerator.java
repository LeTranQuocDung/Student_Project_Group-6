package service;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileOutputStream;
import java.io.OutputStreamWriter;
import java.nio.charset.StandardCharsets;
import java.util.Random;
import java.text.SimpleDateFormat;
import java.util.Date;

public class DataGenerator {

    private static final String FOLDER = "C:/data/";
    private static final Random rand = new Random();

    private static final int TOTAL_USERS = 5000;
    private static final int TOTAL_SHOPS = 200;
    private static final int TOTAL_PRODUCTS = 2000;
    private static final int TOTAL_VARIANTS = 10000;
    private static final int TOTAL_ORDERS = 15000;
    private static final int TOTAL_ITEMS = 30000;

    private static final String[] HO = {"Nguyen", "Tran", "Le", "Pham", "Hoang", "Huynh", "Phan", "Vu", "Vo", "Dang", "Bui", "Do", "Ho", "Ngo", "Duong", "Ly"};
    private static final String[] DEM = {"Van", "Thi", "Minh", "Duc", "My", "Ngoc", "Quang", "Tuan", "Anh", "Hong", "Xuan", "Thu", "Gia", "Thanh"};
    private static final String[] TEN = {"Anh", "Tuan", "Dung", "Hung", "Long", "Diep", "Lan", "Mai", "Hoa", "Cuong", "Manh", "Kien", "Trang", "Linh", "Phuong", "Thao", "Vy", "Tu", "Dat", "Son", "Khanh", "Huyen"};

    private static final String[] PROD_TYPE = {"Dien thoai", "Laptop", "Ao thun", "Quan Jean", "Giay Sneaker", "Tai nghe", "Son moi", "Kem chong nang", "Dong ho"};
    private static final String[] BRANDS = {"Samsung", "iPhone", "Xiaomi", "Oppo", "Dell", "Macbook", "Asus", "Coolmate", "Zara", "Gucci", "Nike", "Adidas", "Sony", "JBL", "Casio", "Rolex"};
    private static final String[] ADJECTIVES = {"Cao cap", "Gia re", "Chinh hang", "Sieu ben", "Moi 100%", "Fullbox", "Xach tay", "Giam gia soc", "Limited Edition"};

    private static final String[] IMAGES = {
        "https://down-vn.img.susercontent.com/file/vn-11134207-7r98o-ll1rvl5558973e",
        "https://down-vn.img.susercontent.com/file/sg-11134201-22100-s6q7y2y2mhivda",
        "https://down-vn.img.susercontent.com/file/vn-11134207-7qukw-ljz6j5j5j5j5j5",
        "https://down-vn.img.susercontent.com/file/vn-11134207-7qukw-lk3z5x5x5x5x5x"
    };

    private static final SimpleDateFormat dfStd = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

    public static void main(String[] args) {
        new File(FOLDER).mkdirs();
        System.out.println("Dang tao data rac");

        genUsers(TOTAL_USERS);
        genShops(TOTAL_SHOPS);
        genProducts(TOTAL_PRODUCTS);
        genVariants(TOTAL_VARIANTS);
        genVouchers(100);
        genOrders(TOTAL_ORDERS, TOTAL_USERS);
        genOrderItems(TOTAL_ITEMS, TOTAL_ORDERS, TOTAL_VARIANTS);

        System.out.println("DA TAO XONG! Vao thu muc: " + FOLDER + " de lay file CSV import vao SQL.");
    }

    private static BufferedWriter getWriter(String filename) throws Exception {
        return new BufferedWriter(new OutputStreamWriter(new FileOutputStream(FOLDER + filename), StandardCharsets.UTF_8));
    }

    private static void genUsers(int count) {
        try (BufferedWriter bw = getWriter("users.csv")) {
            bw.write("id,full_name,email,phone,wallet,password_hash,note");
            bw.newLine();
            for (int i = 1; i <= count; i++) {
                String ho = getRandom(HO);
                String dem = getRandom(DEM);
                String ten = getRandom(TEN);
                String fullName = ho + " " + dem + " " + ten;
                String emailPrefix = (ho + dem + ten).toLowerCase().replaceAll("\\s+", "");

                int randomNum = rand.nextInt(90000) + 10000;
                String email = emailPrefix + randomNum + "@gmail.com";

                String phone = "09" + String.format("%08d", rand.nextInt(100000000));

                bw.write(i + "," + fullName + "," + email + "," + phone + "," + (rand.nextInt(500) * 10000) + ",123456,Khach moi");
                bw.newLine();
            }
        } catch (Exception e) {
        }
    }

    private static void genProducts(int count) {
        try (BufferedWriter bw = getWriter("products.csv")) {
            bw.write("id,shop_id,name,description,price,image_url");
            bw.newLine();
            for (int i = 1; i <= count; i++) {
                String name = getRandom(PROD_TYPE) + " " + getRandom(BRANDS) + " " + getRandom(ADJECTIVES) + " - Ma " + i;
                double price = (rand.nextInt(200) + 10) * 10000;
                String img = getRandom(IMAGES);
                int shopId = rand.nextInt(TOTAL_SHOPS) + 1;

                bw.write(i + "," + shopId + "," + name + ",Mo ta san pham " + i + "," + price + "," + img);
                bw.newLine();
            }
        } catch (Exception e) {
        }
    }

    private static void genVariants(int count) {
        try (BufferedWriter bw = getWriter("product_variants.csv")) {
            bw.write("id,product_id,color,size,stock,price,note");
            bw.newLine();
            String[] colors = {"Den", "Trang", "Xanh", "Do"};
            String[] sizes = {"S", "M", "L", "XL"};

            for (int i = 1; i <= count; i++) {
                int prodId = rand.nextInt(TOTAL_PRODUCTS) + 1;
                int stock = rand.nextInt(50) + 1;
                double price = (rand.nextInt(100) + 1) * 10000;

                bw.write(i + "," + prodId + "," + getRandom(colors) + "," + getRandom(sizes) + "," + stock + "," + price + ",");
                bw.newLine();
            }
        } catch (Exception e) {
        }
    }

    private static void genOrders(int count, int maxUserId) {
        try (BufferedWriter bw = getWriter("orders.csv")) {
            bw.write("id,user_id,total_amount,created_at");
            bw.newLine();
            long now = System.currentTimeMillis();

            for (int i = 1; i <= count; i++) {
                int userId = rand.nextInt(maxUserId) + 1;
                long randomTime = now - (long) (rand.nextDouble() * 30L * 24 * 60 * 60 * 1000);
                String dateStr = dfStd.format(new Date(randomTime));

                bw.write(i + "," + userId + "," + ((rand.nextInt(50) + 1) * 10000) + "," + dateStr);
                bw.newLine();
            }
        } catch (Exception e) {
        }
    }

    private static void genOrderItems(int count, int maxOrderId, int maxVariantId) {
        try (BufferedWriter bw = getWriter("order_items.csv")) {
            bw.write("id,order_id,variant_id,quantity,price_at_purchase");
            bw.newLine();
            for (int i = 1; i <= count; i++) {
                int orderId = rand.nextInt(maxOrderId) + 1;
                int variantId = rand.nextInt(maxVariantId) + 1;

                bw.write(i + "," + orderId + "," + variantId + ",1,100000");
                bw.newLine();
            }
        } catch (Exception e) {
        }
    }

    private static void genShops(int c) {
        try (BufferedWriter w = getWriter("shops.csv")) {
            w.write("id,shop_name,rating\n");
            for (int i = 1; i <= c; i++) {
                w.write(i + ",Shop " + i + " Official," + String.format("%.1f", (3 + rand.nextDouble() * 2)) + "\n");
            }
        } catch (Exception e) {
        }
    }

    private static void genVouchers(int c) {
        try (BufferedWriter w = getWriter("vouchers.csv")) {
            w.write("code,value,min_order,start_date,end_date\n");
            for (int i = 1; i <= c; i++) {
                w.write("VOUCHER" + i + ",10000,50000,2026-01-01,2026-12-31\n");
            }
        } catch (Exception e) {
        }
    }

    private static String getRandom(String[] arr) {
        return arr[rand.nextInt(arr.length)];
    }
}
