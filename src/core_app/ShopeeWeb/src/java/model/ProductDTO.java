package model;

public class ProductDTO {
    private int id;
    private String name;
    private String shopName;
    private double minPrice;
    private String image;

    public ProductDTO(int id, String name, String shopName, double minPrice) {
        this.id = id;
        this.name = name;
        this.shopName = shopName;
        this.minPrice = minPrice;
        // Random ảnh giả lập để nhìn cho giống thật
        this.image = "https://placehold.co/300x300/orange/white?text=" + name.replaceAll(" ", "+");
    }

    public int getId() { return id; }
    public String getName() { return name; }
    public String getShopName() { return shopName; }
    public double getMinPrice() { return minPrice; }
    public String getImage() { return image; }
}