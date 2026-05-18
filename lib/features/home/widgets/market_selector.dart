import 'package:flutter/material.dart';

class MarketSelector extends StatelessWidget {
  final String selectedMarket;
  final List<String> selectedSubMarkets;
  final ValueChanged<String> onMarketChanged;
  final ValueChanged<List<String>> onSubMarketsChanged;

  const MarketSelector({
    super.key,
    required this.selectedMarket,
    required this.selectedSubMarkets,
    required this.onMarketChanged,
    required this.onSubMarketsChanged,
  });

  static const marketOptions = [
    {'code': 'CN', 'label': 'A股', 'icon': '🇨🇳'},
    {'code': 'HK', 'label': '港股', 'icon': '🇭🇰'},
    {'code': 'US', 'label': '美股', 'icon': '🇺🇸'},
    {'code': 'FUT', 'label': '期货', 'icon': '📈'},
  ];

  static const subMarketOptions = [
    {'code': 'XSHG', 'label': '上证'},
    {'code': 'XSHE', 'label': '深证'},
    {'code': 'SSE', 'label': '上交所'},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '市场选择',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedMarket,
              isExpanded: true,
              items: marketOptions.map((option) {
                return DropdownMenuItem<String>(
                  value: option['code']!,
                  child: Row(
                    children: [
                      Text(option['icon']!),
                      const SizedBox(width: 8),
                      Text(option['label']!),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  onMarketChanged(value);
                  if (value != 'CN') {
                    onSubMarketsChanged([]);
                  }
                }
              },
            ),
          ),
        ),

        if (selectedMarket == 'CN') ...[
          const SizedBox(height: 12),
          const Text(
            '子板块（多选）',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: subMarketOptions.map((option) {
              final isSelected = selectedSubMarkets.contains(option['code']);
              return FilterChip(
                label: Text(option['label']!),
                selected: isSelected,
                onSelected: (selected) {
                  final newSubMarkets = List<String>.from(selectedSubMarkets);
                  if (selected) {
                    newSubMarkets.add(option['code']!);
                  } else {
                    newSubMarkets.remove(option['code']!);
                  }
                  onSubMarketsChanged(newSubMarkets);
                },
                selectedColor: Colors.blue[100],
                checkmarkColor: Colors.blue,
              );
            }).toList(),
          ),
        ],

        const SizedBox(height: 12),
        const Divider(),
      ],
    );
  }
}
