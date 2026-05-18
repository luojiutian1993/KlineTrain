import 'package:flutter/material.dart';

class TrainingDateDisplay extends StatelessWidget {
  final DateTime? startDate;
  final int trainingDays;
  final VoidCallback onRegenerate;

  const TrainingDateDisplay({
    super.key,
    this.startDate,
    this.trainingDays = 150,
    required this.onRegenerate,
  });

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final endDate = startDate?.add(Duration(days: trainingDays));

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '训练时间范围',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: onRegenerate,
                  child: const Text('重新生成'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (startDate != null) ...[
              _buildDateRow('训练起始时间', _formatDate(startDate!)),
              const SizedBox(height: 4),
              _buildDateRow('训练结束时间', endDate != null ? _formatDate(endDate) : '-'),
              const SizedBox(height: 4),
              _buildDateRow('训练周期', '$trainingDays天'),
            ] else ...[
              const Center(
                child: CircularProgressIndicator(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDateRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            '$label：',
            style: const TextStyle(color: Colors.grey),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }
}
