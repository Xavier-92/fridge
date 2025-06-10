
// filepath: /Users/xavier/Desktop/spring-demo/demo2/src/main/java/com/example/demo2/repository/FridgeItemRepository.java
package com.example.demo2.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import com.example.demo2.entity.FridgeItem;

public interface FridgeItemRepository extends JpaRepository<FridgeItem, Long> {
}