package model;

import java.math.BigDecimal;

public class ProductDTO {

    private int id;
    private String name;
    private String shopName;
    private BigDecimal minPrice;
    private String imageUrl;

    public ProductDTO() {
    }

    public ProductDTO(int id, String name, String shopName, BigDecimal minPrice, String imageUrl) {
        this.id = id;
        this.name = name;
        this.shopName = shopName;
        this.minPrice = minPrice;
        this.imageUrl = imageUrl;
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

    public BigDecimal getMinPrice() {
        return minPrice;
    }

    public void setMinPrice(BigDecimal minPrice) {
        this.minPrice = minPrice;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }
}
