// lib/screens/home/home_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/app_provider.dart';
import '../../utils/app_theme.dart';
import '../../widgets/common_widgets.dart';
import '../../models/models.dart';
import '../awareness/awareness_screen.dart';
import '../diet/diet_screen.dart';
import '../exercise/exercise_screen.dart';
import '../doctors/doctors_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _glassesToday = 0;
  int _dailyGoal = 8;
  bool _waterLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkPeriodReminder();
      context.read<AppProvider>().loadUser();
      _loadTodayWater();
    });
  }

  Future<void> _loadTodayWater() async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) return;
      final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('water')
          .doc(today)
          .get();
      if (doc.exists && mounted) {
        setState(() {
          _glassesToday = (doc.data()?['glasses'] ?? 0) as int;
          _dailyGoal = (doc.data()?['goal'] ?? 8) as int;
        });
      } else {
        // load saved goal even if no entry today
        final userDoc =
            await FirebaseFirestore.instance.collection('users').doc(uid).get();
        if (userDoc.exists && mounted) {
          setState(() {
            _dailyGoal = (userDoc.data()?['water_goal'] ?? 8) as int;
          });
        }
      }
    } catch (_) {}
  }

  Future<void> _addGlass() async {
    setState(() {
      _glassesToday++;
      _waterLoading = true;
    });
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) return;
      final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('water')
          .doc(today)
          .set({
        'glasses': _glassesToday,
        'goal': _dailyGoal,
        'date': today,
        'updatedAt': DateTime.now().toIso8601String(),
      });
    } catch (_) {
    } finally {
      if (mounted) setState(() => _waterLoading = false);
    }
  }

  Future<void> _removeGlass() async {
    if (_glassesToday <= 0) return;
    setState(() {
      _glassesToday--;
      _waterLoading = true;
    });
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) return;
      final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('water')
          .doc(today)
          .set({
        'glasses': _glassesToday,
        'goal': _dailyGoal,
        'date': today,
        'updatedAt': DateTime.now().toIso8601String(),
      });
    } catch (_) {
    } finally {
      if (mounted) setState(() => _waterLoading = false);
    }
  }

  // ── Set custom goal ──
  void _showSetGoalDialog() {
    int tempGoal = _dailyGoal;
    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text(
            '💧 Set Daily Water Goal',
            style: TextStyle(
                color: Color(0xFF0288D1), fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$tempGoal glasses',
                style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0288D1)),
              ),
              const Text('(1 glass = 250ml)',
                  style: TextStyle(fontSize: 12, color: Colors.grey)),
              Slider(
                value: tempGoal.toDouble(),
                min: 1,
                max: 20,
                divisions: 19,
                activeColor: const Color(0xFF29B6F6),
                label: '$tempGoal glasses',
                onChanged: (v) => setDialogState(() => tempGoal = v.round()),
              ),
              Text(
                'Total: ${tempGoal * 250}ml',
                style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF0288D1),
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                setState(() => _dailyGoal = tempGoal);
                Navigator.pop(ctx);
                // save goal to user doc
                try {
                  final uid = FirebaseAuth.instance.currentUser?.uid;
                  if (uid == null) return;
                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(uid)
                      .set({'water_goal': tempGoal}, SetOptions(merge: true));
                } catch (_) {}
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF29B6F6),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Save Goal'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _checkPeriodReminder() async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) return;
      final doc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (!doc.exists) return;
      final data = doc.data();
      if (data == null) return;
      final lastPeriodStr = data['last_period_date'] as String?;
      if (lastPeriodStr == null) return;
      final cycleLength = (data['cycle_length'] as int?) ?? 28;
      final lastPeriod = DateTime.parse(lastPeriodStr);
      final nextPeriod = lastPeriod.add(Duration(days: cycleLength));
      final daysLeft = nextPeriod.difference(DateTime.now()).inDays;
      if (daysLeft >= 0 && daysLeft <= 5 && mounted) {
        _showPeriodPopup(daysLeft);
      }
    } catch (_) {}
  }

  void _showPeriodPopup(int daysLeft) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFFFFE4EC),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          '🌸 HealHer Reminder',
          style: TextStyle(
              color: AppColors.primaryDark,
              fontSize: 18,
              fontWeight: FontWeight.bold),
        ),
        content: Text(
          daysLeft == 0
              ? 'Your period may start today. Take care! 💕'
              : 'Your period is expected in $daysLeft day${daysLeft == 1 ? '' : 's'}. Stay prepared!',
          style: const TextStyle(fontSize: 15, color: AppColors.textDark),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK, Got it!',
                style: TextStyle(
                    color: AppColors.primaryDark, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AppProvider>().user;

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(user),
                    const SizedBox(height: 20),
                    _buildStatsRow(user),
                    const SizedBox(height: 24),
                    const SectionTitle(title: '💧 Water Intake'),
                    const SizedBox(height: 14),
                    _buildWaterCard(),
                    const SizedBox(height: 24),
                    const SectionTitle(title: '✨ Quick Actions'),
                    const SizedBox(height: 14),
                    _buildQuickActions(context),
                    const SizedBox(height: 24),
                    const SectionTitle(title: '💡 Daily Tips'),
                    const SizedBox(height: 14),
                    _buildTipCard(),
                    const SizedBox(height: 24),
                    _buildAwarenessCard(context),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWaterCard() {
    final progress = _dailyGoal > 0 ? _glassesToday / _dailyGoal : 0.0;
    final remaining = _dailyGoal - _glassesToday;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF4FC3F7).withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(0.08),
              spreadRadius: 2,
              blurRadius: 8,
              offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row
          Row(
            children: [
              const Text('💧', style: TextStyle(fontSize: 24)),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$_glassesToday / $_dailyGoal glasses',
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0288D1)),
                  ),
                  Text(
                    _glassesToday >= _dailyGoal
                        ? '🎉 Daily goal achieved!'
                        : '$remaining more glass${remaining == 1 ? '' : 'es'} to go',
                    style: TextStyle(
                        fontSize: 12,
                        color: _glassesToday >= _dailyGoal
                            ? AppColors.success
                            : AppColors.textMedium),
                  ),
                ],
              ),
              const Spacer(),
              // Set Goal button
              GestureDetector(
                onTap: _showSetGoalDialog,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE3F2FD),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    'Set Goal',
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF0288D1)),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '${(_glassesToday * 250)}ml / ${(_dailyGoal * 250)}ml',
            style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF0288D1),
                fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 14),

          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress.clamp(0.0, 1.0),
              minHeight: 10,
              backgroundColor: const Color(0xFFE3F2FD),
              valueColor:
                  const AlwaysStoppedAnimation<Color>(Color(0xFF29B6F6)),
            ),
          ),
          const SizedBox(height: 14),

          // Glass icons (max 10 shown)
          Wrap(
            spacing: 4,
            runSpacing: 4,
            children: List.generate(_dailyGoal.clamp(1, 12), (i) {
              final filled = i < _glassesToday;
              return Text(
                filled ? '🥤' : '🫙',
                style: const TextStyle(fontSize: 20),
              );
            }),
          ),
          const SizedBox(height: 14),

          // Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _waterLoading ? null : _removeGlass,
                  icon: const Icon(Icons.remove, size: 18),
                  label: const Text('Remove'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF0288D1),
                    side: const BorderSide(color: Color(0xFF29B6F6)),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _waterLoading ? null : _addGlass,
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Add Glass'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF29B6F6),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(UserModel? user) {
    final greeting = _getGreeting();
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('$greeting 👋',
                  style: const TextStyle(
                      fontSize: 14, color: AppColors.textMedium)),
              Text(user?.name ?? 'Welcome',
                  style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark)),
              Text(DateFormat('EEEE, MMMM d').format(DateTime.now()),
                  style: const TextStyle(
                      fontSize: 13, color: AppColors.textLight)),
            ],
          ),
        ),
        CircleAvatar(
          radius: 28,
          backgroundColor: AppColors.primaryLight,
          child: Text(
            user?.name.isNotEmpty == true ? user!.name[0].toUpperCase() : 'H',
            style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.primary),
          ),
        ),
      ],
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  Widget _buildStatsRow(UserModel? user) {
    final bmi = user?.bmi.toStringAsFixed(1) ?? '--';
    final bmiCat = user?.bmiCategory ?? '--';
    final weight = user?.weight != null && user!.weight > 0
        ? '${user.weight.toStringAsFixed(1)} kg'
        : '--';
    final condition = user?.condition != null && user!.condition != 'None'
        ? user.condition
        : '--';

    return Row(
      children: [
        _buildStatCard(
            'BMI', bmi, bmiCat, Icons.analytics_outlined, AppColors.primary),
        const SizedBox(width: 12),
        _buildStatCard('Weight', weight, 'Current',
            Icons.monitor_weight_outlined, AppColors.primary.withOpacity(0.8)),
        const SizedBox(width: 12),
        _buildStatCard(
            'Status',
            condition,
            'Condition',
            Icons.medical_information_outlined,
            AppColors.primary.withOpacity(0.6)),
      ],
    );
  }

  Widget _buildStatCard(
      String title, String value, String subtitle, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.2)),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.05),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, 2)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 20, color: color),
            const SizedBox(height: 8),
            Text(value,
                style: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold, color: color)),
            Text(subtitle,
                style:
                    const TextStyle(fontSize: 11, color: AppColors.textLight)),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    final actions = [
      {
        'icon': Icons.menu_book_outlined,
        'label': 'Awareness',
        'color': AppColors.primary,
        'screen': const AwarenessScreen(),
      },
      {
        'icon': Icons.restaurant_outlined,
        'label': 'Diet Plan',
        'color': AppColors.primary.withOpacity(0.85),
        'screen': const DietScreen(),
      },
      {
        'icon': Icons.fitness_center_outlined,
        'label': 'Exercise',
        'color': AppColors.primary.withOpacity(0.7),
        'screen': const ExerciseScreen(),
      },
      {
        'icon': Icons.local_hospital_outlined,
        'label': 'Doctors',
        'color': AppColors.primary.withOpacity(0.55),
        'screen': const DoctorsScreen(),
      },
    ];

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 4,
      childAspectRatio: 0.75,
      crossAxisSpacing: 12,
      children: actions
          .map((a) => GestureDetector(
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => a['screen'] as Widget)),
                child: Column(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                            color: (a['color'] as Color).withOpacity(0.3)),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.withOpacity(0.05),
                              spreadRadius: 1,
                              blurRadius: 3,
                              offset: const Offset(0, 1)),
                        ],
                      ),
                      child: Icon(a['icon'] as IconData,
                          color: a['color'] as Color, size: 26),
                    ),
                    const SizedBox(height: 8),
                    Text(a['label'] as String,
                        style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textDark),
                        textAlign: TextAlign.center),
                  ],
                ),
              ))
          .toList(),
    );
  }

  Widget _buildTipCard() {
    final tips = [
      {
        'tip':
            'Stay hydrated! Drinking 8-10 glasses of water daily helps manage PCOS symptoms and reduces bloating.',
        'icon': '💧'
      },
      {
        'tip':
            'Regular low-impact exercise like yoga or walking for 30 minutes can improve insulin sensitivity in PCOS.',
        'icon': '🧘'
      },
      {
        'tip':
            'Choose whole grains over refined carbs. They help maintain stable blood sugar levels.',
        'icon': '🌾'
      },
      {
        'tip':
            'Getting 7-9 hours of sleep is crucial for hormone regulation in PCOD management.',
        'icon': '😴'
      },
      {
        'tip':
            'Include anti-inflammatory foods like turmeric, berries, and leafy greens in your diet.',
        'icon': '🥗'
      },
    ];
    final tip = tips[DateTime.now().day % tips.length];

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.primary.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(0.08),
              spreadRadius: 2,
              blurRadius: 8,
              offset: const Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          Text(tip['icon']!, style: const TextStyle(fontSize: 36)),
          const SizedBox(width: 14),
          Expanded(
            child: Text(tip['tip']!,
                style: const TextStyle(
                    fontSize: 13, color: AppColors.textDark, height: 1.5)),
          ),
        ],
      ),
    );
  }

  Widget _buildAwarenessCard(BuildContext context) {
    return HealHerCard(
      color: Colors.white,
      onTap: () => Navigator.push(
          context, MaterialPageRoute(builder: (_) => const AwarenessScreen())),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.primary.withOpacity(0.2)),
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('📚 Learn about PCOS & PCOD',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark)),
                  const SizedBox(height: 6),
                  const Text(
                      'Understand symptoms, causes, and how to manage your condition.',
                      style:
                          TextStyle(fontSize: 13, color: AppColors.textMedium)),
                  const SizedBox(height: 12),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(20)),
                    child: const Text('Explore Now →',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            const Text('🌸', style: TextStyle(fontSize: 52)),
          ],
        ),
      ),
    );
  }
}
