package model;

import java.math.BigDecimal;
import java.sql.Timestamp;

public class Product {
    private int id;
    private int shopId;
    private String name;
    private String description;
    private BigDecimal price;
    private String imageUrl;
    private Timestamp createdAt;
    private int categoryId;
    private String shopName;

    public Product() {
    }

    public Product(int id, int shopId, String name, String description, BigDecimal price, String imageUrl,
            Timestamp createdAt, int categoryId) {
        this.id = id;
        this.shopId = shopId;
        this.name = name;
        this.description = description;
        this.price = price;
        this.imageUrl = imageUrl;
        this.createdAt = createdAt;
        this.categoryId = categoryId;
    }

    public Product(int id, int shopId, String name, String description, BigDecimal price, String imageUrl,
            Timestamp createdAt) {
        this.id = id;
        this.shopId = shopId;
        this.name = name;
        this.description = description;
        this.price = price;
        this.imageUrl = imageUrl;
        this.createdAt = createdAt;
        this.categoryId = 1; // Default
    }

    public int getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(int categoryId) {
        this.categoryId = categoryId;
    }

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

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }

    public String getImageUrl() {
        return util.ProductImageUtil.getRelevantImageUrl(this.name, this.imageUrl);
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public String getShopName() { return shopName; }
    public void setShopName(String shopName) { this.shopName = shopName; }
}
