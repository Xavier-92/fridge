import 'package:flutter/material.dart';
import 'api_service.dart';
import 'package:url_launcher/url_launcher.dart';

class RecipePage extends StatefulWidget {
  final String apiUrl;
  const RecipePage({super.key, required this.apiUrl});

  @override
  State<RecipePage> createState() => _RecipePageState();
}

class _RecipePageState extends State<RecipePage> {
  late ApiService api;
  List items = [];
  Set<String> selected = {};
  bool loading = true;
  String? errorMsg;

  @override
  void initState() {
    super.initState();
    api = ApiService(widget.apiUrl);
    _loadItems();
  }

  Future<void> _loadItems() async {
    setState(() { loading = true; errorMsg = null; });
    try {
      items = await api.fetchItems();
      setState(() { loading = false; });
    } catch (e) {
      setState(() { loading = false; errorMsg = e.toString(); });
    }
  }

  Future<void> _searchRecipe() async {
    if (selected.isEmpty) return;
    final keywords = selected.join(' ');
    final url = Uri.parse('https://www.google.com/search?q=${Uri.encodeComponent('$keywords 食譜')}');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('無法開啟瀏覽器')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('冰箱食材選擇與食譜搜尋')),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : errorMsg != null
              ? Center(child: Text('載入失敗: $errorMsg'))
              : Column(
                  children: [
                    const SizedBox(height: 12),
                    const Text('請選擇要查詢的食材：'),
                    Expanded(
                      child: ListView.builder(
                        itemCount: items.length,
                        itemBuilder: (context, idx) {
                          final item = items[idx];
                          final name = item['name'] ?? '';
                          return CheckboxListTile(
                            title: Text(name),
                            value: selected.contains(name),
                            onChanged: (checked) {
                              setState(() {
                                if (checked == true) {
                                  selected.add(name);
                                } else {
                                  selected.remove(name);
                                }
                              });
                            },
                          );
                        },
                      ),
                    ),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.search),
                      label: const Text('搜尋食譜'),
                      onPressed: _searchRecipe,
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
    );
  }
}
