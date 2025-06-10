package com.example.demo2.controller;

import com.example.demo2.entity.ShoppingListItem;
import com.example.demo2.repository.ShoppingListItemRepository;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@CrossOrigin
@RestController
@RequestMapping("/shopping-list")
public class ShoppingListController {
    private final ShoppingListItemRepository shoppingListItemRepository;

    public ShoppingListController(ShoppingListItemRepository shoppingListItemRepository) {
        this.shoppingListItemRepository = shoppingListItemRepository;
    }

    // 查詢所有購物清單
    @GetMapping
    public List<ShoppingListItem> getShoppingList() {
        return shoppingListItemRepository.findAll();
    }

    // 新增購物清單項目
    @PostMapping
    public ShoppingListItem addToShoppingList(@RequestBody ShoppingListItem item) {
        // 若 reminderDate 為 null，避免資料庫錯誤
        if (item.getReminderDate() == null) {
            item.setReminderDate(null); // 可省略，保險起見
        }
        return shoppingListItemRepository.save(item);
    }

    // 刪除購物清單項目
    @DeleteMapping("/{id}")
    public void removeFromShoppingList(@PathVariable Long id) {
        shoppingListItemRepository.deleteById(id);
    }
}
