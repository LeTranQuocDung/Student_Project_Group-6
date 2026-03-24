package model;

import java.util.Date;

public class Shop {
    private int id;
    private int ownerId;
    private String shopName;
    private double rating;
    private Date createdAt;

    // Computed fields
    private int productCount;
    private int followerCount;
    private int followingCount;
    private String responseRate;
    private String responseTime;
    private String ownerAvatar;
    private String ownerName;
    private double totalRevenue;
    private String location;

    public Shop() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getOwnerId() { return ownerId; }
    public void setOwnerId(int ownerId) { this.ownerId = ownerId; }
    public String getShopName() { return shopName; }
    public void setShopName(String shopName) { this.shopName = shopName; }
    public double getRating() { return rating; }
    public void setRating(double rating) { this.rating = rating; }
    public Date getCreatedAt() { return createdAt; }
    public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }
    public int getProductCount() { return productCount; }
    public void setProductCount(int productCount) { this.productCount = productCount; }
    public int getFollowerCount() { return followerCount; }
    public void setFollowerCount(int followerCount) { this.followerCount = followerCount; }
    public int getFollowingCount() { return followingCount; }
    public void setFollowingCount(int followingCount) { this.followingCount = followingCount; }
    public String getResponseRate() { return responseRate; }
    public void setResponseRate(String responseRate) { this.responseRate = responseRate; }
    public String getResponseTime() { return responseTime; }
    public void setResponseTime(String responseTime) { this.responseTime = responseTime; }
    public String getOwnerAvatar() { return ownerAvatar; }
    public void setOwnerAvatar(String ownerAvatar) { this.ownerAvatar = ownerAvatar; }
    public String getOwnerName() { return ownerName; }
    public void setOwnerName(String ownerName) { this.ownerName = ownerName; }
    public double getTotalRevenue() { return totalRevenue; }
    public void setTotalRevenue(double totalRevenue) { this.totalRevenue = totalRevenue; }
    public String getLocation() { return location; }
    public void setLocation(String location) { this.location = location; }

    public String getJoinDuration() {
        if (createdAt == null) return "N/A";
        long diff = System.currentTimeMillis() - createdAt.getTime();
        long days = diff / (1000 * 60 * 60 * 24);
        if (days < 30) return days + " Ngày";
        long months = days / 30;
        if (months < 12) return months + " Tháng";
        long years = months / 12;
        return years + " Năm";
    }
}
