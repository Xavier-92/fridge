package com.example.demo2.entity;
/*
 * {
 * "name": "牛奶",
 * "quantity": 2,
 * "purchaseDate": "2023-10-01",
 * "expiryDate": "2023-10-15"
 * }
 */
// 匯入 JPA 相關註解，讓這個類別可以對應到資料庫的資料表
import java.time.LocalDate;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id; // 新增這行

// 標記這是一個 JPA Entity，會對應到資料庫中的一個資料表
@Entity
public class FridgeItem {
    // 主鍵欄位，對應資料表的 id 欄位，並自動產生值
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    // 物品名稱
    private String name;
    // 物品數量
    private Integer quantity;

    // 新增進貨日
    private LocalDate purchaseDate;
    // 新增過期日
    private LocalDate expiryDate;

    // Getter & Setter 方法，讓 Spring/JPA 可以存取欄位
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public Integer getQuantity() { return quantity; }
    public void setQuantity(Integer quantity) { this.quantity = quantity; }

    public LocalDate getPurchaseDate() { return purchaseDate; }
    public void setPurchaseDate(LocalDate purchaseDate) { this.purchaseDate = purchaseDate; }

    public LocalDate getExpiryDate() { return expiryDate; }
    public void setExpiryDate(LocalDate expiryDate) { this.expiryDate = expiryDate; }

}
