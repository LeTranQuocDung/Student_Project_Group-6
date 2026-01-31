package model;

public class Product {

    private int id;
    private int shopId;
    private String name;
    private String description;

    public Product() {
    }

    public Product(int id, int shopId, String name, String description) {
        this.id = id;
        this.shopId = shopId;
        this.name = name;
        this.description = description;
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
}
