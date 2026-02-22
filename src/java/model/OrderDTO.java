/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;
import java.sql.Timestamp;

public class OrderDTO {
    private int id;
    private String customerName;
    private double totalAmount;
    private Timestamp createdAt;
    private String note;

    // Chuột phải chọn Insert Code -> Generate Constructor đầy đủ và Getter/Setter là xong
    public OrderDTO(int id, String customerName, double totalAmount, Timestamp createdAt, String note) {
        this.id = id;
        this.customerName = customerName;
        this.totalAmount = totalAmount;
        this.createdAt = createdAt;
        this.note = note;
    }
    // ... Thêm các Getter/Setter ở đây ...
    public int getId() { return id; }
    public String getCustomerName() { return customerName; }
    public double getTotalAmount() { return totalAmount; }
    public Timestamp getCreatedAt() { return createdAt; }
    public String getNote() { return note; }
}