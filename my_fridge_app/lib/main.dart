import 'package:flutter/material.dart';
import 'home_page.dart';

// Flutter 應用程式進入點
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // 這是應用程式的根 widget
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '冰箱管理',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ApiUrlPage(),
    );
  }
}

class ApiUrlPage extends StatefulWidget {
  const ApiUrlPage({super.key});

  @override
  State<ApiUrlPage> createState() => _ApiUrlPageState();
}

class _ApiUrlPageState extends State<ApiUrlPage> {
  final TextEditingController apiUrlController = TextEditingController(text: '140.125.218.130:8080');

  void _goToHomePage() {
    String url = apiUrlController.text.trim();
    if (url.isEmpty) return;
    // 自動補 http://
    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      url = 'http://$url';
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HomePage(apiUrl: url),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('設定伺服器 API URL')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: apiUrlController,
              decoration: const InputDecoration(
                labelText: 'API URL',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _goToHomePage,
              child: const Text('進入冰箱管理'),
            ),
          ],
        ),
      ),
    );
  }
}
