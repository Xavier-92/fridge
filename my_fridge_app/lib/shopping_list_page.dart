import 'package:flutter/material.dart';
import 'api_service.dart';

class ShoppingListPage extends StatefulWidget {
  final String apiUrl;
  const ShoppingListPage({super.key, required this.apiUrl});

  @override
  State<ShoppingListPage> createState() => _ShoppingListPageState();
}

class _ShoppingListPageState extends State<ShoppingListPage> {
  late ApiService api;
  List shoppingList = [];
  final TextEditingController addNameController = TextEditingController();
  final TextEditingController addQuantityController = TextEditingController();
  final TextEditingController expiryController = TextEditingController();
  String? selectedItem;
  bool loading = true;
  String? errorMsg;

  @override
  void initState() {
    super.initState();
    api = ApiService(widget.apiUrl);
    _loadShoppingList();
    addNameController.text = '';
    addQuantityController.text = '1';
  }

  Future<void> _loadShoppingList() async {
    setState(() { loading = true; errorMsg = null; });
    try {
      shoppingList = await api.fetchShoppingList();
      if (!mounted) return;
      setState(() { loading = false; });
    } catch (e) {
      if (!mounted) return;
      setState(() { loading = false; errorMsg = e.toString(); });
    }
  }

  Future<void> _addToShoppingList() async {
    final name = addNameController.text.trim();
    final quantity = int.tryParse(addQuantityController.text.trim()) ?? 1;
    if (name.isEmpty) return;
    try {
      await api.addToShoppingList(name, quantity);
      addNameController.clear();
      addQuantityController.text = '1';
      if (!mounted) return;
      _loadShoppingList();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('已新增至購物清單')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('新增失敗: \\${e.toString()}')),
      );
    }
  }

  Future<void> _addToFridgeDialog(int id, String name, int quantity) async {
    expiryController.clear();
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('購買/加入冰箱：$name'),
        content: InkWell(
          onTap: () async {
            final now = DateTime.now();
            final picked = await showDatePicker(
              context: context,
              initialDate: now,
              firstDate: now,
              lastDate: DateTime(now.year + 5),
            );
            if (picked != null) {
              expiryController.text = "${picked.year.toString().padLeft(4, '0')}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
            }
          },
          child: IgnorePointer(
            child: TextField(
              controller: expiryController,
              decoration: const InputDecoration(labelText: '請選擇有效日期'),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () async {
              final expiryDate = expiryController.text.trim();
              if (expiryDate.isEmpty) return;
              Navigator.pop(context);
              await api.purchaseAndAddToFridge(
                shoppingListId: id,
                name: name,
                quantity: quantity,
                expiryDate: expiryDate,
              );
              if (!mounted) return;
              setState(() { selectedItem = null; });
              _loadShoppingList();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('已加入冰箱並從購物清單移除')),
              );
            },
            child: const Text('確定購買'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('購物清單提醒')),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : errorMsg != null
              ? Center(child: Text('載入失敗: $errorMsg'))
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: TextField(
                              controller: addNameController,
                              decoration: const InputDecoration(labelText: '名稱'),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            flex: 1,
                            child: TextField(
                              controller: addQuantityController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(labelText: '數量'),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: _addToShoppingList,
                          ),
                        ],
                      ),
                    ),
                    const Divider(),
                    const Text('購物清單：'),
                    Expanded(
                      child: ListView.builder(
                        itemCount: shoppingList.length,
                        itemBuilder: (context, idx) {
                          final item = shoppingList[idx];
                          final id = item['id'] as int?;
                          final name = item['name'] ?? '';
                          final quantity = item['quantity'] ?? 1;
                          return ListTile(
                            title: Text('$name (x$quantity)'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ElevatedButton(
                                  onPressed: id == null ? null : () => _addToFridgeDialog(id, name, quantity),
                                  child: const Text('購買/加入冰箱'),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: id == null ? null : () async {
                                    await api.removeFromShoppingList(id);
                                    _loadShoppingList();
                                  },
                                ),
                              ],
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
