// lib/screens/awareness/awareness_screen.dart
import 'package:flutter/material.dart';
import '../../utils/app_theme.dart';
import '../../widgets/common_widgets.dart';

class AwarenessScreen extends StatelessWidget {
  const AwarenessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Awareness Hub')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBanner(),
            const SizedBox(height: 20),
            const SectionTitle(title: 'Understanding PCOS & PCOD'),
            const SizedBox(height: 12),
            _buildDifferenceCard(),
            const SizedBox(height: 20),
            const SectionTitle(title: '🔍 Common Symptoms'),
            const SizedBox(height: 12),
            _buildSymptomsCard(),
            const SizedBox(height: 20),
            const SectionTitle(title: '🧠 Causes & Risk Factors'),
            const SizedBox(height: 12),
            _buildCausesCard(),
            const SizedBox(height: 20),
            const SectionTitle(title: '💊 Diagnosis & Treatment'),
            const SizedBox(height: 12),
            _buildTreatmentCard(),
            const SizedBox(height: 20),
            const SectionTitle(title: '🌟 Lifestyle Management'),
            const SizedBox(height: 12),
            _buildLifestyleCard(),
            const SizedBox(height: 20),
            const SectionTitle(title: '📊 Facts & Statistics'),
            const SizedBox(height: 12),
            _buildFactsCard(),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildBanner() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primaryDark, Color(0xFFE8709A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Know Your Body 💪',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Understanding PCOD and PCOS is the first step towards healing.',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          const Text('🌸', style: TextStyle(fontSize: 48)),
        ],
      ),
    );
  }

  Widget _buildDifferenceCard() {
    return Column(
      children: [
        _buildInfoCard(
          title: 'What is PCOS?',
          content:
              'Polycystic Ovary Syndrome (PCOS) is a hormonal disorder that affects women of reproductive age. It involves multiple cysts forming on the ovaries, elevated androgen (male hormone) levels, and irregular or absent menstrual periods. PCOS is a complex endocrine disorder that can affect overall health.',
          icon: '🔬',
          color: AppColors.primaryLight,
        ),
        _buildInfoCard(
          title: 'What is PCOD?',
          content:
              'Polycystic Ovarian Disease (PCOD) is a condition where the ovaries contain immature or partially mature eggs that form cysts. It is less severe than PCOS and is mainly characterized by hormonal imbalance. With lifestyle changes, PCOD can be reversed, unlike PCOS which requires ongoing management.',
          icon: '🔍',
          color: const Color(0xFFE8F5E9),
        ),
        _buildInfoCard(
          title: 'Key Difference',
          content:
              'PCOS is a metabolic disorder while PCOD is a hormonal condition. PCOS has more severe consequences including infertility risks and metabolic issues, while PCOD is more manageable. Both conditions require medical attention and lifestyle management.',
          icon: '⚖️',
          color: const Color(0xFFFFF3E0),
        ),
      ],
    );
  }

  Widget _buildSymptomsCard() {
    final symptoms = {
      'Menstrual': [
        'Irregular periods',
        'Missed periods',
        'Heavy bleeding',
        'Painful periods',
        'Spotting between periods',
      ],
      'Hormonal': [
        'Acne (especially jawline)',
        'Excess hair growth (hirsutism)',
        'Hair thinning/loss',
        'Oily skin',
        'Darkening of skin (acanthosis)',
      ],
      'Physical': [
        'Weight gain (especially belly)',
        'Fatigue',
        'Pelvic pain',
        'Bloating',
        'Headaches',
      ],
      'Fertility': [
        'Difficulty conceiving',
        'Multiple miscarriages',
        'Prolonged TTC journey',
        'Low AMH levels',
      ],
    };

    return Column(
      children: symptoms.entries
          .map((e) => _buildSymptomGroup(e.key, e.value))
          .toList(),
    );
  }

  Widget _buildSymptomGroup(String category, List<String> items) {
    return HealHerCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            category,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryDark,
            ),
          ),
          const SizedBox(height: 8),
          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Row(
                children: [
                  const Icon(
                    Icons.fiber_manual_record,
                    size: 8,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    item,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textDark,
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

  Widget _buildCausesCard() {
    final causes = [
      {
        'title': 'Insulin Resistance',
        'desc':
            'High insulin levels trigger excess androgen production, disrupting ovulation.',
        'icon': '🩸',
      },
      {
        'title': 'Genetic Factors',
        'desc':
            'Family history of PCOS/PCOD increases your risk significantly.',
        'icon': '🧬',
      },
      {
        'title': 'Inflammation',
        'desc':
            'Low-grade chronic inflammation stimulates the ovaries to produce androgens.',
        'icon': '🔥',
      },
      {
        'title': 'Hormonal Imbalance',
        'desc':
            'Elevated LH (luteinizing hormone) relative to FSH affects ovulation.',
        'icon': '⚗️',
      },
      {
        'title': 'Lifestyle Factors',
        'desc':
            'Poor diet, sedentary lifestyle, stress, and sleep deprivation worsen symptoms.',
        'icon': '🍟',
      },
    ];

    return Column(
      children: causes
          .map((c) => _buildInfoItem(c['icon']!, c['title']!, c['desc']!))
          .toList(),
    );
  }

  Widget _buildTreatmentCard() {
    return Column(
      children: [
        _buildInfoCard(
          title: '🏥 Medical Treatments',
          content:
              '• Birth control pills (regulate periods & hormones)\n• Metformin (improves insulin resistance)\n• Clomiphene (fertility medication)\n• Anti-androgens (reduce hair growth & acne)\n• Progesterone therapy\n• Ovarian drilling (laparoscopic surgery)',
          color: const Color(0xFFE3F2FD),
        ),
        _buildInfoCard(
          title: '🔬 Diagnostic Tests',
          content:
              '• Pelvic ultrasound (detect ovarian cysts)\n• Blood tests (hormone levels, glucose, lipids)\n• Pelvic exam\n• AMH (Anti-Müllerian hormone) levels\n• Thyroid function tests\n• Prolactin levels',
          color: const Color(0xFFF3E5F5),
        ),
      ],
    );
  }

  Widget _buildLifestyleCard() {
    final tips = [
      {
        'icon': '🥗',
        'tip':
            'Eat a low-GI diet rich in fiber, lean protein, and healthy fats.',
      },
      {
        'icon': '🏃',
        'tip': 'Exercise 30 mins daily — yoga, walking, swimming, or cycling.',
      },
      {
        'icon': '😴',
        'tip': 'Aim for 7-9 hours of quality sleep to regulate hormones.',
      },
      {
        'icon': '🧘',
        'tip':
            'Practice stress management through meditation or deep breathing.',
      },
      {
        'icon': '💊',
        'tip': 'Take prescribed supplements: Inositol, Vitamin D, Omega-3.',
      },
      {
        'icon': '🚭',
        'tip':
            'Avoid smoking and limit alcohol as they worsen hormonal imbalance.',
      },
      {
        'icon': '🍬',
        'tip':
            'Reduce sugar and processed foods to improve insulin sensitivity.',
      },
      {
        'icon': '👩‍⚕️',
        'tip': 'Get regular check-ups and track your cycle and symptoms.',
      },
    ];

    return Column(
      children: tips
          .map(
            (t) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Text(t['icon']!, style: const TextStyle(fontSize: 24)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      t['tip']!,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textDark,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildFactsCard() {
    final facts = [
      {
        'stat': '1 in 10',
        'desc': 'Women of reproductive age are affected by PCOS worldwide',
        'icon': '👩',
      },
      {
        'stat': '70%',
        'desc': 'Women with PCOS go undiagnosed for years',
        'icon': '📊',
      },
      {
        'stat': '35-80%',
        'desc': 'Of PCOS cases involve insulin resistance',
        'icon': '🩸',
      },
      {
        'stat': '2-7x',
        'desc': 'Higher risk of developing Type 2 diabetes with PCOS',
        'icon': '⚠️',
      },
    ];

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: 1.4,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      children: facts
          .map(
            (f) => Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(f['icon']!, style: const TextStyle(fontSize: 24)),
                  const SizedBox(height: 4),
                  Text(
                    f['stat']!,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryDark,
                    ),
                  ),
                  Text(
                    f['desc']!,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textMedium,
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required String content,
    String? icon,
    required Color color,
  }) {
    return HealHerCard(
      color: color,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (icon != null)
                Text(icon, style: const TextStyle(fontSize: 22)),
              if (icon != null) const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textMedium,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String icon, String title, String desc) {
    return HealHerCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(icon, style: const TextStyle(fontSize: 28)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  desc,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textMedium,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
