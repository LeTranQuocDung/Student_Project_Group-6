package model;

public class Product {

    private int id;
    private int shopId;
    private String name;
    private String description;
    private double price;  
    private String image;   

    public Product() {
    }

    
    public Product(int id, int shopId, String name, String description, double price, String image) {
        this.id = id;
        this.shopId = shopId;
        this.name = name;
        this.description = description;
        this.price = price;
        this.image = image;
    }

  
   
    public Product(int id, int shopId, String name, String description) {
        this.id = id;
        this.shopId = shopId;
        this.name = name;
        this.description = description;
        this.price = 0; // Giá mặc định
        this.image = "https://placehold.co/300"; 
    }

    // Getter & Setter
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getShopId() {
        return shopId;
    }

    public void setShopId(int shopId) {
        this.shopId = shopId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public String getImage() {
        return image;
    }

    public void setImage(String image) {
        this.image = image;
    }
}
