// 我請GPT幫我寫一個冰箱管理的Flutter應用程式，這是主要的頁面代碼。
// Flutter UI
// 將 _FridgePageState 改為公開 FridgePageState。
// 在 async gap 後使用 context 前加上 if (!mounted) return; 修正 context 警告。

import 'package:flutter/material.dart';
import 'api_service.dart';

class FridgePage extends StatefulWidget {
  final String apiUrl;
  const FridgePage({super.key, required this.apiUrl});
  @override
  FridgePageState createState() => FridgePageState();
}

class FridgePageState extends State<FridgePage> {
  late String apiUrl;
  late ApiService api;
  List items = [];
  final TextEditingController nameController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController purchaseDateController = TextEditingController();
  final TextEditingController expiryDateController = TextEditingController();

  // 彈出日期選擇器並填入 controller
  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      controller.text = " ${picked.year.toString().padLeft(4, '0')}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
    }
  }

  @override
  void initState() {
    super.initState();
    apiUrl = widget.apiUrl;
    api = ApiService(apiUrl);
    loadItems();
  }

  Future<void> loadItems() async {
    try {
      items = await api.fetchItems();
      setState(() {});
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('載入失敗: $e')),
      );
    }
  }

  Future<void> addItem() async {
    final name = nameController.text.trim();
    final quantity = int.tryParse(quantityController.text.trim()) ?? 1;
    final purchaseDate = purchaseDateController.text.trim();
    final expiryDate = expiryDateController.text.trim();
    if (name.isEmpty) return;
    try {
      await api.addItem(name, quantity, purchaseDate, expiryDate);
      nameController.clear();
      quantityController.clear();
      purchaseDateController.clear();
      expiryDateController.clear();
      await loadItems();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('新增失敗: $e')),
      );
    }
  }

  Future<void> deleteItem(int id) async {
    try {
      await api.deleteItem(id);
      await loadItems();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('刪除失敗: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('家庭冰箱管理系統')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 物品名稱輸入
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: '物品名稱'),
                ),
                SizedBox(height: 8),
                // 數量輸入
                TextField(
                  controller: quantityController,
                  decoration: InputDecoration(labelText: '數量'),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 8),
                // 進貨日輸入（點擊彈出日期選擇器）
                TextField(
                  controller: purchaseDateController,
                  readOnly: true,
                  decoration: InputDecoration(labelText: '進貨日 yyyy-MM-dd'),
                  onTap: () => _selectDate(context, purchaseDateController),
                ),
                SizedBox(height: 8),
                // 有效日輸入（點擊彈出日期選擇器）
                TextField(
                  controller: expiryDateController,
                  readOnly: true,
                  decoration: InputDecoration(labelText: '有效日 yyyy-MM-dd'),
                  onTap: () => _selectDate(context, expiryDateController),
                ),
                SizedBox(height: 8),
                // 新增物品按鈕
                ElevatedButton.icon(
                  icon: Icon(Icons.add),
                  label: Text('新增物品'),
                  onPressed: addItem,
                ),
              ],
            ),
          ),
          // 冰箱物品清單
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return ListTile(
                  title: Text(item['name'] ?? ''),
                  subtitle: Text('數量: \t${item['quantity']}\n進貨日:\t ${item['purchaseDate'] ?? ''}  \n有效日:\t ${item['expiryDate'] ?? ''}'),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      if (item['id'] != null) {
                        deleteItem(item['id']);
                      }
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}