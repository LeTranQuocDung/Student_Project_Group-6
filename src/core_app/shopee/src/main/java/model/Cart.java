package model;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

public class Cart {

    private List<CartItem> items;

    public Cart() {
        items = new ArrayList<>();
    }

    public List<CartItem> getItems() {
        return items;
    }

    // 1. Thêm sản phẩm vào giỏ
    public void addItem(CartItem newItem) {
        // Kiểm tra xem món này đã có trong giỏ chưa
        for (CartItem item : items) {
            if (item.getProduct().getId() == newItem.getProduct().getId()) {
                // Nếu có rồi -> Cộng dồn số lượng
                item.setQuantity(item.getQuantity() + newItem.getQuantity());
                return;
            }
        }
        // Nếu chưa có -> Thêm mới
        items.add(newItem);
    }

    // 2. Xóa sản phẩm
    public void removeItem(int productId) {
        items.removeIf(item -> item.getProduct().getId() == productId);
    }

    // 2.5 Cập nhật số lượng
    public void updateQuantity(int productId, int quantity) {
        if (quantity <= 0) {
            removeItem(productId);
            return;
        }
        for (CartItem item : items) {
            if (item.getProduct().getId() == productId) {
                item.setQuantity(quantity);
                return;
            }
        }
    }

    // 3. Tính tổng tiền cả giỏ hàng
    public BigDecimal getTotalMoney() {
        BigDecimal total = BigDecimal.ZERO;
        for (CartItem item : items) {
            total = total.add(item.getTotalPrice());
        }
        return total;
    }

    // 4. Đếm tổng số lượng sản phẩm (để hiện lên cái icon giỏ hàng)
    public int getTotalQuantity() {
        int total = 0;
        for (CartItem item : items) {
            total += item.getQuantity();
        }
        return total;
    }
}
