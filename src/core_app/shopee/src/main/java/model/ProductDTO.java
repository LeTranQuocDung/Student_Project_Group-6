package model;

import java.math.BigDecimal;

public class ProductDTO {

    private int id;
    private String name;
    private String shopName;
    private BigDecimal minPrice;
    private BigDecimal price;
    private String imageUrl;
    private int soldCount;
    private double rating;
    private String location;
    private int categoryId;

    public ProductDTO() {
    }

    public ProductDTO(int id, String name, String shopName, BigDecimal minPrice, String imageUrl) {
        this.id = id;
        this.name = name;
        this.shopName = shopName;
        this.minPrice = minPrice;
        this.imageUrl = imageUrl;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getShopName() { return shopName; }
    public void setShopName(String shopName) { this.shopName = shopName; }
    public BigDecimal getMinPrice() { return minPrice; }
    public void setMinPrice(BigDecimal minPrice) { this.minPrice = minPrice; }

    public BigDecimal getPrice() { return price; }
    public void setPrice(BigDecimal price) { this.price = price; }

    public int getSoldCount() { return soldCount; }
    public void setSoldCount(int soldCount) { this.soldCount = soldCount; }

    public String getImageUrl() {
        return util.ProductImageUtil.getRelevantImageUrl(this.name, this.imageUrl);
    }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }

    public double getRating() { return rating; }
    public void setRating(double rating) { this.rating = rating; }

    public String getLocation() { return location; }
    public void setLocation(String location) { this.location = location; }

    public int getCategoryId() { return categoryId; }
    public void setCategoryId(int categoryId) { this.categoryId = categoryId; }
}
