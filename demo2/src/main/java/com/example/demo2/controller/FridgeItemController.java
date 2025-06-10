package com.example.demo2.controller;

import java.util.List;

import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.PathVariable;

import com.example.demo2.entity.FridgeItem;
import com.example.demo2.repository.FridgeItemRepository;


@CrossOrigin
@RestController
@RequestMapping("/fridge-items")
public class FridgeItemController {

    private final FridgeItemRepository repository;

    public FridgeItemController(FridgeItemRepository repository) {
        this.repository = repository;
    }
    // 獲取所有冰箱物品
    // 使用 @GetMapping 註解來處理 GET 請求
    // 這個方法會回傳冰箱物品的列表
    // 返回類型是 List<FridgeItem>，表示這個方法會返回一個 FridgeItem 的列表
    // 這個方法會從資料庫中獲取所有的冰箱物品
    // repository.findAll() 會調用 JPA 的方法來獲取所有的 FridgeItem
    // 這個方法會被映射到 /fridge-items 路徑
    // 當客戶端發送 GET 請求到 /fridge-items 時，這個方法會被調用
    @GetMapping     
    public List<FridgeItem> getAll() {
        return repository.findAll();
    }

    @PostMapping
    public FridgeItem add(@RequestBody FridgeItem item) {
        return repository.save(item);
    }
    // 新增刪除功能（吃掉物品）
    @DeleteMapping("/{id}")
    public void delete(@PathVariable Long id) {
        repository.deleteById(id);
    }
}
