import 'package:flutter/material.dart';

class ErrorPage extends StatelessWidget {
  final String errorMessage;
  final VoidCallback? onRetry;

  const ErrorPage({
    super.key,
    this.errorMessage = '应用初始化失败',
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '初始化失败',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 80,
                color: Colors.red,
              ),
              const SizedBox(height: 20),
              Text(
                errorMessage,
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              const Text(
                '请检查设备存储和网络连接',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              if (onRetry != null) ...[
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: onRetry,
                  child: const Text('重新启动'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}