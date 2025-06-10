import 'package:flutter/material.dart';
import 'api_service.dart';

/// 顯示即將過期品的頁面
class ExpiringItemsPage extends StatefulWidget {
  final String apiUrl;
  const ExpiringItemsPage({super.key, required this.apiUrl});

  @override
  State<ExpiringItemsPage> createState() => _ExpiringItemsPageState();
}

class _ExpiringItemsPageState extends State<ExpiringItemsPage> {
  late ApiService api;
  List items = [];
  bool loading = true;
  String? errorMsg;

  @override
  void initState() {
    super.initState();
    api = ApiService(widget.apiUrl);
    loadExpiringItems();
  }

  Future<void> loadExpiringItems() async {
    setState(() { loading = true; errorMsg = null; });
    try {
      final allItems = await api.fetchItems();
      final now = DateTime.now();
      final soon = now.add(const Duration(days: 3));
      // 過濾出有效日(expiryDate)在3天內的品項
      items = allItems.where((item) {
        final expiry = item['expiryDate'];
        if (expiry == null || expiry.isEmpty) return false;
        final date = DateTime.tryParse(expiry);
        if (date == null) return false;
        return date.isAfter(now) && date.isBefore(soon);
      }).toList();
      setState(() { loading = false; });
    } catch (e) {
      setState(() { loading = false; errorMsg = e.toString(); });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('即將過期品')),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : errorMsg != null
              ? Center(child: Text('載入失敗: $errorMsg'))
              : items.isEmpty
                  ? const Center(child: Text('沒有即將過期的品項'))
                  : ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final item = items[index];
                        return ListTile(
                          title: Text(item['name'] ?? ''),
                          subtitle: Text('數量: ${item['quantity']}\n有效日: ${item['expiryDate'] ?? ''}'),
                        );
                      },
                    ),
    );
  }
}
