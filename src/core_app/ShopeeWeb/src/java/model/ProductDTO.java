package model;

public class ProductDTO {

    private int id;
    private String name;
    private String shopName;
    private double minPrice;
    private String image;

    public ProductDTO() {
    }

    public ProductDTO(int id, String name, String shopName, double minPrice, String image) {
        this.id = id;
        this.name = name;
        this.shopName = shopName;
        this.minPrice = minPrice;
        this.image = image;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getShopName() {
        return shopName;
    }

    public void setShopName(String shopName) {
        this.shopName = shopName;
    }

    public double getMinPrice() {
        return minPrice;
    }

    public void setMinPrice(double minPrice) {
        this.minPrice = minPrice;
    }

    public String getImage() {
        return image;
    }

    public void setImage(String image) {
        this.image = image;
    }
    
}
