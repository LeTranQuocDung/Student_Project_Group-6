package service;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.util.Random;
import java.text.SimpleDateFormat;
import java.util.Date;

public class DataGenerator {

   private static final String FOLDER = "D:\\data\\";

    private static final Random rand = new Random();
    
  
    private static final int TOTAL_USERS = 10000;
    private static final int TOTAL_SHOPS = 200;
    private static final int TOTAL_PRODUCTS = 5000;
    private static final int TOTAL_VARIANTS = 12000;
    private static final int TOTAL_ORDERS = 15000;
    private static final int TOTAL_ITEMS = 40000;

 
    private static final String[] HO = {"Nguyen", "Tran", "Le", "Pham", "Hoang", "Huynh", "Phan", "Vu", "Vo", "Dang", "Bui", "Do", "Ho", "Ngo", "Duong", "Ly"};
    private static final String[] DEM = {"Van", "Thi", "Minh", "Duc", "My", "Ngoc", "Quang", "Tuan", "Anh", "Hong", "Xuan", "Thu", "Gia", "Thanh"};
    private static final String[] TEN = {"Anh", "Tuan", "Dung", "Hung", "Long", "Diep", "Lan", "Mai", "Hoa", "Cuong", "Manh", "Kien", "Trang", "Linh", "Phuong", "Thao", "Vy", "Tu", "Dat", "Son", "Khanh", "Huyen"};
    
   
    private static final String[] PROD_TYPE = {"Dien thoai", "Laptop", "Ao thun", "Quan Jean", "Giay Sneaker", "Tai nghe", "Son moi", "Kem chong nang", "Dong ho"};
    private static final String[] BRANDS = {"Samsung", "iPhone", "Xiaomi", "Oppo", "Dell", "Macbook", "Asus", "Coolmate", "Zara", "Gucci", "Nike", "Adidas", "Sony", "JBL", "Casio", "Rolex"};
    private static final String[] ADJECTIVES = {"Cao cap", "Gia re", "Chinh hang", "Sieu ben", "Moi 100%", "Fullbox", "Xach tay", "Giam gia soc", "Limited Edition"};

  
    private static final SimpleDateFormat dfStd = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
    private static final SimpleDateFormat dfErr = new SimpleDateFormat("dd/MM/yyyy HH:mm");

    public static void main(String[] args) {
        new File(FOLDER).mkdirs();
        System.out.println("Dang tao data rac");
        
        genUsers(TOTAL_USERS);
        genShops(TOTAL_SHOPS);
        genProducts(TOTAL_PRODUCTS);
        genVariants(TOTAL_VARIANTS); 
        genVouchers(100);
        genOrders(TOTAL_ORDERS);     
        genOrderItems(TOTAL_ITEMS);

        System.out.println("Done");
    }

    
    private static void genUsers(int count) {
        try(BufferedWriter bw = new BufferedWriter(new FileWriter(FOLDER + "users.csv"))){
            bw.write("id,full_name,email,phone,wallet,note"); bw.newLine();
            for(int i=1; i<=count; i++) {
                String ho = getRandom(HO);
                String dem = getRandom(DEM);
                String ten = getRandom(TEN);
                String fullName = ho + " " + dem + " " + ten;
                
               
                String email = removeAccent(ten).toLowerCase() + "." + removeAccent(ho).toLowerCase() + i + "@gmail.com";
                String phone = "09" + String.format("%08d", rand.nextInt(100000000));
                String note = "";

                
                if(rand.nextDouble() < 0.1) {
                    int type = rand.nextInt(3);
                    if(type==0) { email = email.replace("@", ""); note="Loi Email"; } 
                    else if(type==1) { phone = phone.substring(1); note="Loi Phone"; } 
                    else { fullName = fullName.toLowerCase(); note="Loi Ten"; } 
                }
                bw.write(i + "," + fullName + "," + email + "," + phone + "," + (rand.nextInt(500)*10000) + "," + note);
                bw.newLine();
            }
        } catch(Exception e){}
    }

  
    private static void genProducts(int count) {
        try(BufferedWriter bw = new BufferedWriter(new FileWriter(FOLDER + "products.csv"))){
            bw.write("id,shop_id,name,description"); bw.newLine();
            for(int i=1; i<=count; i++) {
                String type = getRandom(PROD_TYPE);
                String brand = getRandom(BRANDS);
                String adj = getRandom(ADJECTIVES);
                String name = type + " " + brand + " " + adj + " - Ma " + i; // Thêm mã để chắc chắn unique
                
                bw.write(i + "," + (rand.nextInt(TOTAL_SHOPS)+1) + "," + name + ",Mo ta chi tiet cho san pham " + name);
                bw.newLine();
            }
        } catch(Exception e){}
    }

    
    private static void genVariants(int count) {
        try(BufferedWriter bw = new BufferedWriter(new FileWriter(FOLDER + "product_variants.csv"))){
            bw.write("id,product_id,color,size,stock,price"); bw.newLine();
            String[] colors = {"Den", "Trang", "Xanh", "Do", "Vang", "Bac", "Hong", "Xam"};
            String[] sizes = {"S", "M", "L", "XL", "29", "30", "31", "32", "128GB", "256GB"};

            for(int i=1; i<=count; i++) {
                int stock = rand.nextInt(50) + 1;
                double price = (rand.nextInt(100) + 1) * 10000;

             
                if(rand.nextDouble() < 0.15) {
                    if(rand.nextBoolean()) stock = -1 * rand.nextInt(10); 
                    else price = 0; 
                }
                bw.write(i + "," + (rand.nextInt(TOTAL_PRODUCTS)+1) + "," + getRandom(colors) + "," + getRandom(sizes) + "," + stock + "," + price);
                bw.newLine();
            }
        } catch(Exception e){}
    }

   
    private static void genOrders(int count) {
        try(BufferedWriter bw = new BufferedWriter(new FileWriter(FOLDER + "orders.csv"))){
            bw.write("id,user_id,total_amount,created_at"); bw.newLine();
            for(int i=1; i<=count; i++) {
                String dateStr = (rand.nextDouble() < 0.1) ? dfErr.format(new Date()) : dfStd.format(new Date());
                bw.write(i + "," + (rand.nextInt(TOTAL_USERS)+1) + "," + ((rand.nextInt(50)+1)*10000) + "," + dateStr);
                bw.newLine();
            }
        } catch(Exception e){}
    }

   
    private static void genShops(int c) { try(BufferedWriter w=new BufferedWriter(new FileWriter(FOLDER+"shops.csv"))){w.write("id,shop_name,rating\n");for(int i=1;i<=c;i++)w.write(i+",Shop "+getRandom(HO)+" Official,"+ (3+rand.nextDouble()*2) +"\n");}catch(Exception e){} }
    private static void genOrderItems(int c) { try(BufferedWriter w=new BufferedWriter(new FileWriter(FOLDER+"order_items.csv"))){w.write("id,order_id,variant_id,quantity,price_at_purchase\n");for(int i=1;i<=c;i++)w.write(i+","+(rand.nextInt(TOTAL_ORDERS)+1)+","+(rand.nextInt(TOTAL_VARIANTS)+1)+",1,100000\n");}catch(Exception e){} }
    private static void genVouchers(int c) { try(BufferedWriter w=new BufferedWriter(new FileWriter(FOLDER+"vouchers.csv"))){w.write("code,value,min_order,start_date,end_date\n");for(int i=1;i<=c;i++)w.write("VOUCHER"+i+",10000,50000,2026-01-01,2026-12-31\n");}catch(Exception e){} }
    
    
    private static String getRandom(String[] arr) { return arr[rand.nextInt(arr.length)]; }
    private static String removeAccent(String s) { return s.replaceAll("[^a-zA-Z0-9]", ""); } // Đơn giản hóa
}