// lib/screens/weight/weight_screen.dart
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';
import '../../services/firebase_service.dart';
import '../../models/models.dart';
import '../../utils/app_theme.dart';
import '../../widgets/common_widgets.dart';

class WeightScreen extends StatefulWidget {
  const WeightScreen({super.key});

  @override
  State<WeightScreen> createState() => _WeightScreenState();
}

class _WeightScreenState extends State<WeightScreen> {
  final _weightCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Weight Monitor')),
      body: StreamBuilder<List<WeightEntry>>(
        stream: FirebaseService.getWeightEntries(),
        builder: (context, snapshot) {
          final entries = snapshot.data ?? [];

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (entries.isNotEmpty) ...[
                  _buildCurrentWeight(entries),
                  const SizedBox(height: 16),
                  _buildChart(entries),
                  const SizedBox(height: 16),
                ],
                _buildLogWeight(),
                const SizedBox(height: 16),
                const SectionTitle(title: 'Weight History'),
                const SizedBox(height: 12),
                if (entries.isEmpty)
                  const EmptyState(
                    message:
                        'No weight entries yet.\nStart logging to track your progress!',
                    icon: Icons.monitor_weight_outlined,
                  )
                else
                  ...entries.reversed.take(10).map((e) => _buildWeightEntry(e)),
                const SizedBox(height: 80),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCurrentWeight(List<WeightEntry> entries) {
    final latest = entries.last;
    final first = entries.first;
    final diff = latest.weight - first.weight;
    final isLoss = diff < 0;

    return HealHerCard(
      color: AppColors.primaryLight,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Current Weight',
                  style: TextStyle(fontSize: 14, color: AppColors.textMedium),
                ),
                Text(
                  '${latest.weight.toStringAsFixed(1)} kg',
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryDark,
                  ),
                ),
                Row(
                  children: [
                    Icon(
                      isLoss ? Icons.arrow_downward : Icons.arrow_upward,
                      size: 16,
                      color: isLoss ? AppColors.success : AppColors.error,
                    ),
                    Text(
                      '${diff.abs().toStringAsFixed(1)} kg from start',
                      style: TextStyle(
                        color: isLoss ? AppColors.success : AppColors.error,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Text('⚖️', style: TextStyle(fontSize: 52)),
        ],
      ),
    );
  }

  Widget _buildChart(List<WeightEntry> entries) {
    final displayEntries = entries.length > 10
        ? entries.sublist(entries.length - 10)
        : entries;
    final spots = displayEntries.asMap().entries.map((e) {
      return FlSpot(e.key.toDouble(), e.value.weight);
    }).toList();

    final minY =
        displayEntries.map((e) => e.weight).reduce((a, b) => a < b ? a : b) - 2;
    final maxY =
        displayEntries.map((e) => e.weight).reduce((a, b) => a > b ? a : b) + 2;

    return HealHerCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Progress Chart',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          const Text(
            'Last 10 entries',
            style: TextStyle(fontSize: 12, color: AppColors.textLight),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 180,
            child: LineChart(
              LineChartData(
                minY: minY,
                maxY: maxY,
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (_) =>
                      const FlLine(color: AppColors.primaryLight, strokeWidth: 1),
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (v, _) => Text(
                        '${v.toInt()}',
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.textLight,
                        ),
                      ),
                    ),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    color: AppColors.primaryDark,
                    barWidth: 3,
                    belowBarData: BarAreaData(
                      show: true,
                      color: AppColors.primary.withOpacity(0.15),
                    ),
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (_, __, ___, ____) => FlDotCirclePainter(
                        radius: 5,
                        color: AppColors.primaryDark,
                        strokeWidth: 2,
                        strokeColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogWeight() {
    return HealHerCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Log Today\'s Weight',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _weightCtrl,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Weight (kg)',
                    prefixIcon: Icon(
                      Icons.monitor_weight_outlined,
                      color: AppColors.primary,
                    ),
                    suffixText: 'kg',
                  ),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: _logWeight,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                ),
                child: const Text('Save'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWeightEntry(WeightEntry entry) {
    return HealHerCard(
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.monitor_weight_outlined,
              color: AppColors.primaryDark,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${entry.weight.toStringAsFixed(1)} kg',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryDark,
                  ),
                ),
                Text(
                  DateFormat('MMM d, yyyy • h:mm a').format(entry.date),
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textLight,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: AppColors.textLight),
            onPressed: () => FirebaseService.deleteWeightEntry(entry.id),
          ),
        ],
      ),
    );
  }

  Future<void> _logWeight() async {
    final w = double.tryParse(_weightCtrl.text.trim());
    if (w == null || w <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid weight')),
      );
      return;
    }
    final entry = WeightEntry(
      id: const Uuid().v4(),
      date: DateTime.now(),
      weight: w,
    );
    await FirebaseService.saveWeightEntry(entry);
    _weightCtrl.clear();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Weight logged! ✓'),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }
}
