import 'package:flutter/material.dart';
import 'package:kline_trainer/theme/app_theme.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bg,
      appBar: AppBar(title: const Text('自选管理'), backgroundColor: AppTheme.surface),
      body: ListView(
        children: [
          const SizedBox(height: 12),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(color: AppTheme.surface, borderRadius: BorderRadius.circular(18)),
            child: Column(
              children: [
                _FavoriteItem(name: '贵州茅台', code: '600519.SH', price: 1850.00, change: 1.20),
                _FavoriteItem(name: '比亚迪', code: '002594.SZ', price: 268.50, change: 2.30),
                _FavoriteItem(name: '宁德时代', code: '300750.SZ', price: 188.00, change: -1.50),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: AppTheme.accent,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _FavoriteItem extends StatelessWidget {
  final String name;
  final String code;
  final double price;
  final double change;

  const _FavoriteItem({
    required this.name,
    required this.code,
    required this.price,
    required this.change,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(
        children: [
          const Icon(Icons.star, color: Colors.yellow, size: 16),
          const SizedBox(width: 8),
          Text(name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        ],
      ),
      subtitle: Text(code, style: TextStyle(color: AppTheme.muted)),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('¥${price.toStringAsFixed(2)}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          Text(
            '${change >= 0 ? '+' : ''}${change.toStringAsFixed(2)}%',
            style: TextStyle(
              color: change >= 0 ? AppTheme.red : AppTheme.green,
              fontSize: 12,
            ),
          ),
        ],
      ),
      onTap: () {},
    );
  }
}