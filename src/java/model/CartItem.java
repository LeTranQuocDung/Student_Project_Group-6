package model;

public class CartItem {

    private Product product;
    private int quantity;
    private double price; // Giá tại thời điểm mua

    public CartItem() {
    }

    public CartItem(Product product, int quantity, double price) {
        this.product = product;
        this.quantity = quantity;
        this.price = price;
    }

    // Getter & Setter
    public Product getProduct() {
        return product;
    }

    public void setProduct(Product product) {
        this.product = product;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    // Tính tổng tiền của item này (Giá x Số lượng)
    public double getTotalPrice() {
        return price * quantity;
    }
}
