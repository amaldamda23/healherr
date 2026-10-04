// lib/screens/exercise/exercise_screen.dart
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../utils/app_theme.dart';
import '../../widgets/common_widgets.dart';

class ExerciseScreen extends StatefulWidget {
  const ExerciseScreen({super.key});

  @override
  State<ExerciseScreen> createState() => _ExerciseScreenState();
}

class _ExerciseScreenState extends State<ExerciseScreen> {
  final List<Map<String, dynamic>> yogaPoses = [];

  final List<Map<String, dynamic>> cardioExercises = [
    {
      'type': 'Brisk Walking',
      'detail': '30-45 min daily. Best beginner exercise for PCOS.',
      'cal': '150-200 cal',
      'image':
          'https://images.unsplash.com/photo-1476480862126-209bfaa8edc8?w=400',
      'icon': '🚶',
      'videoId': 'njeZ29umqVE',
    },
    {
      'type': 'Low Impact HIIT',
      'detail': 'Low-impact HIIT. 20-25 min. Great for PCOS.',
      'cal': '250-350 cal',
      'image':
          'https://images.unsplash.com/photo-1434682881908-b43d0467b798?w=400',
      'icon': '⚡',
      'videoId': 'ml6cT4AZdqI',
    },
    {
      'type': 'Strength Training',
      'detail': 'Full body strength workout. 40 min. 3x per week.',
      'cal': '200-300 cal',
      'image':
          'https://images.unsplash.com/photo-1581009146145-b5ef050c2e1e?w=400',
      'icon': '💪',
      'videoId': 'UBMk30rjy0o',
    },
  ];

  Future<void> _openYoutube(String videoId) async {
    final Uri url = Uri.parse('https://www.youtube.com/watch?v=$videoId');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open YouTube')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Exercise Plans')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBanner(),
            const SizedBox(height: 20),
            const SectionTitle(title: '📅 Weekly Exercise Plan'),
            const SizedBox(height: 12),
            _buildWeeklyPlan(),
            const SizedBox(height: 20),
            const SectionTitle(title: '🧘 Yoga for PCOS'),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Row(
                children: [
                  Text('▶️ ', style: TextStyle(fontSize: 16)),
                  Expanded(
                    child: Text(
                      'Tap the play button to watch tutorial on YouTube!',
                      style:
                          TextStyle(fontSize: 13, color: AppColors.primaryDark),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            ...yogaPoses.map((p) => _buildExerciseCard(p, isCardio: false)),
            const SizedBox(height: 20),
            const SectionTitle(title: '🏃 Cardio & Workouts'),
            const SizedBox(height: 12),
            ...cardioExercises
                .map((c) => _buildExerciseCard(c, isCardio: true)),
            const SizedBox(height: 20),
            _buildExerciseTips(),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildBanner() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: Stack(
        children: [
          Image.network(
            'https://images.unsplash.com/photo-1571019614242-c5c5dee9f50b?w=800',
            height: 180,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (ctx, _, __) => Container(
              height: 180,
              color: AppColors.primaryLight,
              child: const Center(
                  child: Text('🏃‍♀️', style: TextStyle(fontSize: 64))),
            ),
          ),
          Container(
            height: 180,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.black.withOpacity(0.6), Colors.transparent],
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
              ),
            ),
            padding: const EdgeInsets.all(18),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Move to Heal 💜',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  'Watch tutorials on YouTube and follow along!',
                  style: TextStyle(
                      color: Colors.white.withOpacity(0.9), fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyPlan() {
    final plan = [
      {
        'day': 'Monday',
        'workout': 'Yoga + Light Walk',
        'duration': '45 min',
        'intensity': 'Low',
        'color': const Color(0xFF90C8A8),
        'image':
            'https://images.unsplash.com/photo-1506126613408-eca07ce68773?w=300',
        'icon': '🧘',
      },
      {
        'day': 'Tuesday',
        'workout': 'HIIT (Low-Impact)',
        'duration': '30 min',
        'intensity': 'Medium',
        'color': AppColors.primary,
        'image':
            'https://images.unsplash.com/photo-1434682881908-b43d0467b798?w=300',
        'icon': '⚡',
      },
      {
        'day': 'Wednesday',
        'workout': 'Strength Training',
        'duration': '40 min',
        'intensity': 'Medium',
        'color': const Color(0xFFB8A0D8),
        'image':
            'https://images.unsplash.com/photo-1581009146145-b5ef050c2e1e?w=300',
        'icon': '💪',
      },
      {
        'day': 'Thursday',
        'workout': 'Rest or Gentle Yoga',
        'duration': '20-30 min',
        'intensity': 'Very Low',
        'color': const Color(0xFF85C4D5),
        'image':
            'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?w=300',
        'icon': '🌿',
      },
      {
        'day': 'Friday',
        'workout': 'Cardio (Cycling/Swimming)',
        'duration': '40 min',
        'intensity': 'Medium',
        'color': const Color(0xFF90C8A8),
        'image':
            'https://images.unsplash.com/photo-1476480862126-209bfaa8edc8?w=300',
        'icon': '🚴',
      },
      {
        'day': 'Saturday',
        'workout': 'Full Body Workout',
        'duration': '45 min',
        'intensity': 'Medium-High',
        'color': AppColors.primary,
        'image':
            'https://images.unsplash.com/photo-1571019614242-c5c5dee9f50b?w=300',
        'icon': '🏋️',
      },
      {
        'day': 'Sunday',
        'workout': 'Rest + Stretching',
        'duration': '15-20 min',
        'intensity': 'Very Low',
        'color': const Color(0xFFE8A0B4),
        'image':
            'https://images.unsplash.com/photo-1552196563-55cd4e45efb3?w=300',
        'icon': '😌',
      },
    ];

    return Column(
      children: plan
          .map((d) => Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.horizontal(
                          left: Radius.circular(16)),
                      child: Image.network(
                        d['image'] as String,
                        width: 90,
                        height: 90,
                        fit: BoxFit.cover,
                        errorBuilder: (ctx, _, __) => Container(
                          width: 90,
                          height: 90,
                          color: (d['color'] as Color).withOpacity(0.2),
                          child: Center(
                            child: Text(d['icon'] as String,
                                style: const TextStyle(fontSize: 32)),
                          ),
                        ),
                        loadingBuilder: (ctx, child, progress) {
                          if (progress == null) return child;
                          return Container(
                            width: 90,
                            height: 90,
                            color: (d['color'] as Color).withOpacity(0.15),
                            child: Center(
                              child: Text(d['icon'] as String,
                                  style: const TextStyle(fontSize: 32)),
                            ),
                          );
                        },
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color:
                                        (d['color'] as Color).withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    d['day'] as String,
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: d['color'] as Color,
                                    ),
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  d['duration'] as String,
                                  style: const TextStyle(
                                      fontSize: 12,
                                      color: AppColors.textMedium),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              d['workout'] as String,
                              style: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 4),
                            InfoChip(
                              label: d['intensity'] as String,
                              color: (d['color'] as Color).withOpacity(0.15),
                              textColor: d['color'] as Color,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ))
          .toList(),
    );
  }

  Widget _buildExerciseCard(Map<String, dynamic> exercise,
      {required bool isCardio}) {
    final videoId = exercise['videoId'] as String;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
              color: AppColors.primary.withOpacity(0.12),
              blurRadius: 10,
              offset: const Offset(0, 4))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Real image on top with play button overlay
          GestureDetector(
            onTap: () => _openYoutube(videoId),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(18)),
                  child: Image.network(
                    exercise['image'] as String,
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (ctx, _, __) => Container(
                      height: 180,
                      color: AppColors.primaryLight,
                      child: Center(
                          child: Text(exercise['icon'] as String,
                              style: const TextStyle(fontSize: 64))),
                    ),
                    loadingBuilder: (ctx, child, progress) {
                      if (progress == null) return child;
                      return Container(
                        height: 180,
                        color: AppColors.primaryLight,
                        child: const Center(child: CircularProgressIndicator()),
                      );
                    },
                  ),
                ),
                // Dark overlay
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(18)),
                      color: Colors.black.withOpacity(0.3),
                    ),
                  ),
                ),
                // Play button
                Positioned.fill(
                  child: Center(
                    child: Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.red.withOpacity(0.4),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.play_arrow_rounded,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                // YouTube badge
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.play_circle_fill,
                            color: Colors.white, size: 14),
                        SizedBox(width: 4),
                        Text('YouTube',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
                // Tap to watch label
                Positioned(
                  bottom: 10,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'Tap to Watch on YouTube',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Info section
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(exercise['icon'] as String,
                        style: const TextStyle(fontSize: 22)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isCardio
                                ? exercise['type'] as String
                                : exercise['name'] as String,
                            style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textDark),
                          ),
                          if (!isCardio)
                            Text(
                              exercise['sanskrit'] as String,
                              style: const TextStyle(
                                  fontSize: 11,
                                  color: AppColors.primaryDark,
                                  fontStyle: FontStyle.italic),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  isCardio
                      ? exercise['detail'] as String
                      : exercise['benefit'] as String,
                  style: const TextStyle(
                      fontSize: 13, color: AppColors.textMedium, height: 1.4),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    InfoChip(
                      label: isCardio
                          ? '🔥 ${exercise['cal']}'
                          : '⏱ ${exercise['duration']}',
                      color: AppColors.primaryLight,
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () => _openYoutube(videoId),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFEBEE),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.play_circle_outline,
                                color: Colors.red, size: 16),
                            SizedBox(width: 4),
                            Text(
                              'Watch on YouTube',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExerciseTips() {
    return HealHerCard(
      color: const Color(0xFFFFF8E1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('💡 Exercise Tips for PCOS',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 12),
          ...[
            '⚠️ Avoid excessive high-intensity exercise — it can worsen cortisol levels',
            '✅ Consistency beats intensity. 30 mins daily is better than 2 hours once a week',
            '✅ Exercise in the morning to regulate circadian rhythm and hormones',
            '✅ Always warm up for 5-10 minutes before exercising',
            '✅ Stay hydrated — drink water before, during, and after exercise',
            '⚠️ If you have severe symptoms, consult your doctor before starting',
          ].map((t) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text(t, style: const TextStyle(fontSize: 13)),
              )),
        ],
      ),
    );
  }
}
