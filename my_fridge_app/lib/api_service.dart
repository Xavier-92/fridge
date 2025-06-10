// 我請GPT新增一個API服務類別，這個類別將會處理與後端的HTTP請求。
// 這個類別將會包含兩個方法：fetchItems()和addItem()。
// fetchItems()方法將會從後端獲取物品列表，addItem()方法將會向後端添加新物品。
// 這個類別將會使用http包來發送HTTP請求。
// my_fridge_app/lib/api_service.dart

import 'package:dio/dio.dart';

class ApiService {
  final String baseUrl;
  ApiService(this.baseUrl);

  Future<List<dynamic>> fetchItems() async {
    final response = await Dio().get('$baseUrl/fridge-items');
    if (response.statusCode == 200) {
      return response.data is List ? response.data : [];
    } else {
      throw Exception('Failed to load items');
    }
  }

  Future<void> addItem(String name, int quantity, String? purchaseDate, String? expiryDate) async {
    final body = {
      'name': name,
      'quantity': quantity,
    };
    if (purchaseDate != null && purchaseDate.isNotEmpty) body['purchaseDate'] = purchaseDate;
    if (expiryDate != null && expiryDate.isNotEmpty) body['expiryDate'] = expiryDate;
    final response = await Dio().post(
      '$baseUrl/fridge-items',
      data: body,
      options: Options(contentType: 'application/json'),
    );
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to add item: \\${response.data}');
    }
  }

  Future<void> deleteItem(int id) async {
    final response = await Dio().delete('$baseUrl/fridge-items/$id');
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to delete item');
    }
  }

  Future<List<dynamic>> fetchShoppingList() async {
    final response = await Dio().get('$baseUrl/shopping-list');
    if (response.statusCode == 200) {
      return response.data is List ? response.data : [];
    } else {
      throw Exception('Failed to load shopping list');
    }
  }

  Future<void> addToShoppingList(String name, int quantity) async {
    final response = await Dio().post(
      '$baseUrl/shopping-list',
      data: {'name': name, 'quantity': quantity, 'reminderDate': null},
      options: Options(contentType: 'application/json'),
    );
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to add to shopping list: \\${response.data}');
    }
  }

  Future<void> removeFromShoppingList(int id) async {
    final response = await Dio().delete('$baseUrl/shopping-list/$id');
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to remove from shopping list');
    }
  }

  /// 購買後加入冰箱並移除購物清單
  Future<void> purchaseAndAddToFridge({
    required int shoppingListId,
    required String name,
    required int quantity,
    required String expiryDate,
  }) async {
    // 取得今日日期
    final now = DateTime.now();
    final purchaseDate = "${now.year.toString().padLeft(4, '0')}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
    // 1. 加入冰箱
    await addItem(name, quantity, purchaseDate, expiryDate);
    // 2. 移除購物清單
    await removeFromShoppingList(shoppingListId);
  }
}