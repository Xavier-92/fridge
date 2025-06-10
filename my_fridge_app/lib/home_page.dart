import 'package:flutter/material.dart';
import 'fridge_page.dart';
import 'expiring_items_page.dart';
import 'recipe_page.dart';
import 'shopping_list_page.dart';

/// 首頁：可輸入 API URL 並選擇功能
class HomePage extends StatefulWidget {
  final String apiUrl;
  const HomePage({super.key, required this.apiUrl});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('冰箱管理選單')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 32),
            ElevatedButton.icon(
              icon: const Icon(Icons.kitchen),
              label: const Text('查看冰箱'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FridgePage(apiUrl: widget.apiUrl),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.warning),
              label: const Text('即將過期食物'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ExpiringItemsPage(apiUrl: widget.apiUrl),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: Icon(Icons.restaurant_menu),
              label: Text('食譜搜尋'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RecipePage(apiUrl: widget.apiUrl),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: Icon(Icons.shopping_cart),
              label: Text('購物清單'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ShoppingListPage(apiUrl: widget.apiUrl),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
