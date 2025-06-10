package com.example.demo2.repository;

import com.example.demo2.entity.ShoppingListItem;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ShoppingListItemRepository extends JpaRepository<ShoppingListItem, Long> {
    // 無 user 欄位，僅保留基礎 CRUD
}
