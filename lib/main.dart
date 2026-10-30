import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'api.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Web GitHub Pages',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final client = InterceptedClient.build(interceptors: [MockApiInterceptor()]);
  String _responseMessage = 'Test the API below.';

  Future<void> _sendPostWithTargetMb() async {
    try {
      final response = await client.post(
        Uri.parse('/api/get-ram'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"target_mb": 2048}), // Passing target_mb in body
      );
      setState(() {
        _responseMessage = 'POST (${response.statusCode}): ${response.body}';
      });
    } catch (e) {
      setState(() => _responseMessage = 'Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flutter Web Mock API')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton(
              onPressed: _sendPostWithTargetMb,
              child: const Text('Send POST with {"target_mb": 2048}'),
            ),
            const SizedBox(height: 20),
            Text(_responseMessage),
          ],
        ),
      ),
    );
  }
}
