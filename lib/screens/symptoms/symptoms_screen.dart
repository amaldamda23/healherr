// lib/screens/symptoms/symptoms_screen.dart
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';
import '../../services/firebase_service.dart';
import '../../models/models.dart';
import '../../utils/app_theme.dart';
import '../../widgets/common_widgets.dart';

class SymptomsScreen extends StatefulWidget {
  const SymptomsScreen({super.key});

  @override
  State<SymptomsScreen> createState() => _SymptomsScreenState();
}

class _SymptomsScreenState extends State<SymptomsScreen> {
  final List<Map<String, dynamic>> _symptomCategories = [
    {
      'category': 'Hormonal',
      'symptoms': [
        'Irregular periods',
        'Acne breakout',
        'Hair loss',
        'Excess facial hair',
        'Weight gain',
      ],
      'color': AppColors.primary,
    },
    {
      'category': 'Physical',
      'symptoms': [
        'Cramps',
        'Bloating',
        'Pelvic pain',
        'Back pain',
        'Fatigue',
        'Headache',
      ],
      'color': const Color(0xFF90C8A8),
    },
    {
      'category': 'Mental',
      'symptoms': [
        'Mood swings',
        'Anxiety',
        'Depression',
        'Brain fog',
        'Irritability',
        'Stress',
      ],
      'color': const Color(0xFFB8A0D8),
    },
    {
      'category': 'Digestive',
      'symptoms': [
        'Nausea',
        'Constipation',
        'Diarrhea',
        'Indigestion',
        'Appetite changes',
      ],
      'color': const Color(0xFF85C4D5),
    },
  ];

  List<String> _selectedSymptoms = [];
  int _severity = 3;
  final _notesCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Symptom Tracker')),
      body: StreamBuilder<List<SymptomEntry>>(
        stream: FirebaseService.getSymptomEntries(),
        builder: (context, snapshot) {
          final entries = snapshot.data ?? [];

          return DefaultTabController(
            length: 2,
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TabBar(
                    labelColor: Colors.white,
                    unselectedLabelColor: AppColors.primaryDark,
                    indicator: BoxDecoration(
                      color: AppColors.primaryDark,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    tabs: const [
                      Tab(text: 'Log Symptoms'),
                      Tab(text: 'History'),
                    ],
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    children: [_buildLogTab(), _buildHistoryTab(entries)],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildLogTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HealHerCard(
            color: AppColors.primaryLight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Today\'s Date',
                  style: TextStyle(fontSize: 12, color: AppColors.textMedium),
                ),
                Text(
                  DateFormat('EEEE, MMMM d, yyyy').format(DateTime.now()),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryDark,
                  ),
                ),
              ],
            ),
          ),
          ..._symptomCategories.map((cat) => _buildCategorySection(cat)),
          const SizedBox(height: 16),
          const Text(
            'Severity',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Text('Mild', style: TextStyle(color: AppColors.textLight)),
              Expanded(
                child: Slider(
                  value: _severity.toDouble(),
                  min: 1,
                  max: 5,
                  divisions: 4,
                  activeColor: AppColors.primaryDark,
                  label: _getSeverityLabel(_severity),
                  onChanged: (v) => setState(() => _severity = v.round()),
                ),
              ),
              const Text(
                'Severe',
                style: TextStyle(color: AppColors.textLight),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primaryLight.withOpacity(0.5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'Severity: ${_getSeverityLabel(_severity)}',
              style: const TextStyle(
                color: AppColors.primaryDark,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _notesCtrl,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'Additional Notes (optional)',
              hintText: 'Describe how you\'re feeling...',
              prefixIcon: Icon(Icons.notes_outlined, color: AppColors.primary),
            ),
          ),
          const SizedBox(height: 24),
          GradientButton(
            text: 'Save Symptoms',
            icon: Icons.save_outlined,
            onPressed: _saveSymptoms,
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildCategorySection(Map<String, dynamic> cat) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Row(
          children: [
            Container(
              width: 4,
              height: 18,
              decoration: BoxDecoration(
                color: cat['color'] as Color,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              cat['category'] as String,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 6,
          children: (cat['symptoms'] as List<String>).map((s) {
            final selected = _selectedSymptoms.contains(s);
            return FilterChip(
              label: Text(
                s,
                style: TextStyle(
                  fontSize: 13,
                  color: selected ? Colors.white : AppColors.textDark,
                ),
              ),
              selected: selected,
              onSelected: (v) => setState(
                () =>
                    v ? _selectedSymptoms.add(s) : _selectedSymptoms.remove(s),
              ),
              backgroundColor: Colors.white,
              selectedColor: (cat['color'] as Color),
              checkmarkColor: Colors.white,
              side: BorderSide(color: (cat['color'] as Color).withOpacity(0.4)),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildHistoryTab(List<SymptomEntry> entries) {
    if (entries.isEmpty) {
      return const EmptyState(
        message: 'No symptoms logged yet.\nStart tracking to see patterns.',
        icon: Icons.healing_outlined,
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: entries.length,
      itemBuilder: (ctx, i) {
        final e = entries[i];
        return HealHerCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.calendar_today_outlined,
                    size: 16,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    DateFormat('MMM d, yyyy').format(e.date),
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _getSeverityColor(e.severity).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _getSeverityLabel(e.severity),
                      style: TextStyle(
                        fontSize: 12,
                        color: _getSeverityColor(e.severity),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 6,
                runSpacing: 4,
                children: e.symptoms.map((s) => InfoChip(label: s)).toList(),
              ),
              if (e.notes != null && e.notes!.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  e.notes!,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textMedium,
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  String _getSeverityLabel(int s) =>
      ['', 'Mild', 'Light', 'Moderate', 'Severe', 'Very Severe'][s.clamp(1, 5)];

  Color _getSeverityColor(int s) {
    switch (s) {
      case 1:
        return AppColors.success;
      case 2:
        return const Color(0xFF8BC34A);
      case 3:
        return AppColors.warning;
      case 4:
        return Colors.deepOrange;
      default:
        return AppColors.error;
    }
  }

  Future<void> _saveSymptoms() async {
    if (_selectedSymptoms.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one symptom')),
      );
      return;
    }
    final entry = SymptomEntry(
      id: const Uuid().v4(),
      date: DateTime.now(),
      symptoms: _selectedSymptoms,
      severity: _severity,
      notes: _notesCtrl.text.trim().isEmpty ? null : _notesCtrl.text.trim(),
    );
    await FirebaseService.saveSymptomEntry(entry);
    setState(() {
      _selectedSymptoms = [];
      _severity = 3;
      _notesCtrl.clear();
    });
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Symptoms saved! ✓'),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }
}
