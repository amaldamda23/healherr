// lib/screens/period/period_screen.dart
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // ADDED
import 'package:firebase_auth/firebase_auth.dart'; // ADDED
import 'package:flutter_local_notifications/flutter_local_notifications.dart'; // ADDED
import 'package:timezone/timezone.dart' as tz; // ADDED
import '../../main.dart'; // ADDED (to access flutterLocalNotificationsPlugin)
import '../../services/firebase_service.dart';
import '../../models/models.dart';
import '../../utils/app_theme.dart';
import '../../widgets/common_widgets.dart';

class PeriodScreen extends StatefulWidget {
  const PeriodScreen({super.key});

  @override
  State<PeriodScreen> createState() => _PeriodScreenState();
}

class _PeriodScreenState extends State<PeriodScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  CalendarFormat _calendarFormat = CalendarFormat.month;

  final List<String> _allSymptoms = [
    'Cramps',
    'Bloating',
    'Back Pain',
    'Mood Swings',
    'Headache',
    'Fatigue',
    'Nausea',
    'Acne',
    'Breast Tenderness',
    'Spotting',
  ];

  // ADDED: schedules phone notification 3 days before next period
  Future<void> _schedulePeriodReminder(
      DateTime startDate, int cycleLength) async {
    // cancel old reminders first
    await flutterLocalNotificationsPlugin.cancel(101);
    await flutterLocalNotificationsPlugin.cancel(102);

    final nextPeriod = startDate.add(Duration(days: cycleLength));

    // reminder 3 days before at 9 AM
    final threeDayReminder = DateTime(
      nextPeriod.year,
      nextPeriod.month,
      nextPeriod.day - 3,
      9,
      0,
      0,
    );

    if (threeDayReminder.isAfter(DateTime.now())) {
      await flutterLocalNotificationsPlugin.zonedSchedule(
        101,
        '🌸 HealHer Period Reminder',
        'Your period is expected in 3 days. Stay prepared!',
        tz.TZDateTime.from(threeDayReminder, tz.local),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'healher_period_channel',
            'Period Reminders',
            channelDescription: 'Reminds you before your next period',
            importance: Importance.high,
            priority: Priority.high,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
    }

    // reminder on the day of period at 9 AM
    final dayOfReminder = DateTime(
      nextPeriod.year,
      nextPeriod.month,
      nextPeriod.day,
      9,
      0,
      0,
    );

    if (dayOfReminder.isAfter(DateTime.now())) {
      await flutterLocalNotificationsPlugin.zonedSchedule(
        102,
        '🌸 HealHer - Period Expected Today',
        'Your period may start today. Take care of yourself!',
        tz.TZDateTime.from(dayOfReminder, tz.local),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'healher_period_channel',
            'Period Reminders',
            channelDescription: 'Reminds you before your next period',
            importance: Importance.high,
            priority: Priority.high,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
    }
  }

  // ADDED: saves last period date + cycle length to Firestore user doc
  Future<void> _savePeriodForReminder(
      DateTime startDate, int cycleLength) async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) return;
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'last_period_date': startDate.toIso8601String(),
        'cycle_length': cycleLength,
      }, SetOptions(merge: true));
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Period Tracker')),
      body: StreamBuilder<List<PeriodEntry>>(
        stream: FirebaseService.getPeriodEntries(),
        builder: (context, snapshot) {
          final entries = snapshot.data ?? [];
          final periodDays = _getPeriodDays(entries);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HealHerCard(
                  padding: const EdgeInsets.all(0),
                  child: TableCalendar(
                    firstDay: DateTime(2020),
                    lastDay: DateTime(2030),
                    focusedDay: _focusedDay,
                    calendarFormat: _calendarFormat,
                    selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                    onDaySelected: (selected, focused) {
                      setState(() {
                        _selectedDay = selected;
                        _focusedDay = focused;
                      });
                    },
                    onFormatChanged: (format) =>
                        setState(() => _calendarFormat = format),
                    calendarStyle: CalendarStyle(
                      selectedDecoration: const BoxDecoration(
                        color: AppColors.primaryDark,
                        shape: BoxShape.circle,
                      ),
                      todayDecoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.6),
                        shape: BoxShape.circle,
                      ),
                      markerDecoration: const BoxDecoration(
                        color: AppColors.accent,
                        shape: BoxShape.circle,
                      ),
                    ),
                    calendarBuilders: CalendarBuilders(
                      defaultBuilder: (ctx, day, focusedDay) {
                        if (periodDays.any((d) => isSameDay(d, day))) {
                          return Container(
                            margin: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.4),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text('${day.day}',
                                  style: const TextStyle(
                                    color: AppColors.primaryDark,
                                    fontWeight: FontWeight.bold,
                                  )),
                            ),
                          );
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                _buildStats(entries),
                const SizedBox(height: 16),
                const SectionTitle(title: 'Period History'),
                const SizedBox(height: 12),
                if (entries.isEmpty)
                  const EmptyState(
                    message:
                        'No periods logged yet.\nTap the + button to add your first entry.',
                    icon: Icons.calendar_today_outlined,
                  )
                else
                  ...entries.map((e) => _buildEntryCard(e)),
                const SizedBox(height: 80),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddPeriodDialog(context),
        backgroundColor: AppColors.primaryDark,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Log Period', style: TextStyle(color: Colors.white)),
      ),
    );
  }

  Set<DateTime> _getPeriodDays(List<PeriodEntry> entries) {
    final days = <DateTime>{};
    for (final e in entries) {
      var date = e.startDate;
      final end = e.endDate ?? e.startDate;
      while (!date.isAfter(end)) {
        days.add(DateTime(date.year, date.month, date.day));
        date = date.add(const Duration(days: 1));
      }
    }
    return days;
  }

  Widget _buildStats(List<PeriodEntry> entries) {
    if (entries.isEmpty) return const SizedBox.shrink();

    final avgCycle = _calculateAvgCycle(entries);
    final avgDuration = entries
            .where((e) => e.duration != null)
            .fold<double>(0, (sum, e) => sum + e.duration!) /
        (entries
            .where((e) => e.duration != null)
            .length
            .clamp(1, double.infinity));

    return Row(
      children: [
        _buildStatChip(
            'Avg. Cycle', '${avgCycle.toStringAsFixed(0)} days', Icons.loop),
        const SizedBox(width: 12),
        _buildStatChip('Avg. Duration',
            '${avgDuration.toStringAsFixed(0)} days', Icons.timelapse),
        const SizedBox(width: 12),
        _buildStatChip('Total Logged', '${entries.length}', Icons.history),
      ],
    );
  }

  double _calculateAvgCycle(List<PeriodEntry> entries) {
    if (entries.length < 2) return 28;
    double total = 0;
    for (int i = 0; i < entries.length - 1; i++) {
      total += entries[i]
          .startDate
          .difference(entries[i + 1].startDate)
          .inDays
          .abs();
    }
    return total / (entries.length - 1);
  }

  Widget _buildStatChip(String label, String value, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.primaryLight,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            Icon(icon, size: 18, color: AppColors.primaryDark),
            const SizedBox(height: 4),
            Text(value,
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryDark)),
            Text(label,
                style:
                    const TextStyle(fontSize: 11, color: AppColors.textMedium),
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  Widget _buildEntryCard(PeriodEntry entry) {
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
            child: const Icon(Icons.water_drop,
                color: AppColors.primaryDark, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Started: ${DateFormat('MMM d, yyyy').format(entry.startDate)}',
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 14),
                ),
                if (entry.endDate != null)
                  Text(
                    'Ended: ${DateFormat('MMM d, yyyy').format(entry.endDate!)}',
                    style: const TextStyle(
                        fontSize: 13, color: AppColors.textMedium),
                  ),
                if (entry.duration != null)
                  Text('Duration: ${entry.duration} days',
                      style: const TextStyle(
                          fontSize: 13, color: AppColors.textLight)),
                if (entry.symptoms.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 4,
                    children: entry.symptoms
                        .take(3)
                        .map((s) => InfoChip(label: s))
                        .toList(),
                  ),
                ],
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: AppColors.textLight),
            onPressed: () => FirebaseService.deletePeriodEntry(entry.id),
          ),
        ],
      ),
    );
  }

  void _showAddPeriodDialog(BuildContext context) {
    DateTime? startDate = DateTime.now();
    DateTime? endDate;
    List<String> selectedSymptoms = [];
    int flowLevel = 3;
    int cycleLength = 28; // ADDED

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          padding: EdgeInsets.fromLTRB(
            24,
            16,
            24,
            MediaQuery.of(ctx).viewInsets.bottom + 24,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text('Log Period',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: _dateButton('Start Date', startDate, () async {
                        final d = await showDatePicker(
                          context: ctx,
                          initialDate: startDate ?? DateTime.now(),
                          firstDate: DateTime(2020),
                          lastDate: DateTime.now(),
                        );
                        if (d != null) setModalState(() => startDate = d);
                      }),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _dateButton('End Date', endDate, () async {
                        final d = await showDatePicker(
                          context: ctx,
                          initialDate: endDate ?? DateTime.now(),
                          firstDate: DateTime(2020),
                          lastDate: DateTime.now(),
                        );
                        if (d != null) setModalState(() => endDate = d);
                      }),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text('Flow Level',
                    style: TextStyle(fontWeight: FontWeight.w600)),
                Slider(
                  value: flowLevel.toDouble(),
                  min: 1,
                  max: 5,
                  divisions: 4,
                  activeColor: AppColors.primaryDark,
                  label: [
                    'Very Light',
                    'Light',
                    'Medium',
                    'Heavy',
                    'Very Heavy'
                  ][flowLevel - 1],
                  onChanged: (v) => setModalState(() => flowLevel = v.round()),
                ),

                // ADDED: cycle length slider
                const Text('Cycle Length',
                    style: TextStyle(fontWeight: FontWeight.w600)),
                Row(
                  children: [
                    Expanded(
                      child: Slider(
                        value: cycleLength.toDouble(),
                        min: 21,
                        max: 35,
                        divisions: 14,
                        activeColor: AppColors.primaryDark,
                        label: '$cycleLength days',
                        onChanged: (v) =>
                            setModalState(() => cycleLength = v.round()),
                      ),
                    ),
                    Text('$cycleLength days',
                        style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryDark)),
                  ],
                ),
                // END ADDED

                const Text('Symptoms',
                    style: TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: _allSymptoms
                      .map((s) => FilterChip(
                            label:
                                Text(s, style: const TextStyle(fontSize: 12)),
                            selected: selectedSymptoms.contains(s),
                            onSelected: (v) => setModalState(() => v
                                ? selectedSymptoms.add(s)
                                : selectedSymptoms.remove(s)),
                            selectedColor: AppColors.primaryLight,
                            checkmarkColor: AppColors.primaryDark,
                          ))
                      .toList(),
                ),
                const SizedBox(height: 20),
                GradientButton(
                  text: 'Save Entry',
                  onPressed: () async {
                    if (startDate == null) return;

                    final entry = PeriodEntry(
                      id: const Uuid().v4(),
                      startDate: startDate!,
                      endDate: endDate,
                      flowLevel: flowLevel,
                      symptoms: selectedSymptoms,
                    );

                    // save period entry
                    await FirebaseService.savePeriodEntry(entry);

                    // ADDED: save to user doc for popup check
                    await _savePeriodForReminder(startDate!, cycleLength);

                    // ADDED: schedule phone notification
                    await _schedulePeriodReminder(startDate!, cycleLength);

                    if (ctx.mounted) {
                      Navigator.pop(ctx);
                      // ADDED: confirmation snackbar
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              '✅ Saved! Reminder set 3 days before your next period.'),
                          backgroundColor: AppColors.primaryDark,
                          duration: Duration(seconds: 3),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _dateButton(String label, DateTime? date, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.primary.withOpacity(0.4)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style:
                    const TextStyle(fontSize: 12, color: AppColors.textLight)),
            const SizedBox(height: 4),
            Text(
              date != null ? DateFormat('MMM d, yyyy').format(date) : 'Select',
              style: const TextStyle(
                  fontWeight: FontWeight.w600, color: AppColors.textDark),
            ),
          ],
        ),
      ),
    );
  }
}
