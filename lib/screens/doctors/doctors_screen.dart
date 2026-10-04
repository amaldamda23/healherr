// lib/screens/doctors/doctors_screen.dart
import 'package:flutter/material.dart';
import '../../utils/app_theme.dart';
import '../../widgets/common_widgets.dart';

class DoctorsScreen extends StatelessWidget {
  const DoctorsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Find Doctors')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBanner(),
            const SizedBox(height: 20),
            const SectionTitle(title: '🩺 Specialists for PCOS/PCOD'),
            const SizedBox(height: 12),
            _buildSpecialistTypes(),
            const SizedBox(height: 20),
            const SectionTitle(title: '📋 When to See a Doctor'),
            const SizedBox(height: 12),
            _buildWhenToSee(),
            const SizedBox(height: 20),
            const SectionTitle(title: '❓ Questions to Ask Your Doctor'),
            const SizedBox(height: 12),
            _buildQuestions(),
            const SizedBox(height: 20),
            const SectionTitle(title: '📞 Helplines & Support'),
            const SizedBox(height: 12),
            _buildHelplines(),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildBanner() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF85C4D5), Color(0xFF5AA0B5)],
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Professional Support 👩‍⚕️',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Early diagnosis and proper medical guidance can make a huge difference in managing PCOS/PCOD.',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          const Text('🏥', style: TextStyle(fontSize: 44)),
        ],
      ),
    );
  }

  Widget _buildSpecialistTypes() {
    final specialists = [
      {
        'title': 'Gynecologist / Obstetrician',
        'desc':
            'Primary specialist for PCOS/PCOD. Manages menstrual irregularities, hormonal balance, and reproductive health.',
        'when': 'First point of contact',
        'icon': '👩‍⚕️',
        'color': AppColors.primaryLight,
      },
      {
        'title': 'Endocrinologist',
        'desc':
            'Specialist in hormone disorders. Ideal for complex PCOS cases with insulin resistance, thyroid issues, or adrenal problems.',
        'when': 'Hormonal & metabolic issues',
        'icon': '🔬',
        'color': const Color(0xFFE3F2FD),
      },
      {
        'title': 'Reproductive Endocrinologist',
        'desc':
            'Expert in fertility and hormones. Consult if you\'re trying to conceive or facing fertility challenges due to PCOS.',
        'when': 'Fertility & conception',
        'icon': '🤰',
        'color': const Color(0xFFF3E5F5),
      },
      {
        'title': 'Dermatologist',
        'desc':
            'Manages skin and hair concerns related to PCOS — acne, hirsutism, hair thinning, and skin darkening.',
        'when': 'Skin, hair, and acne issues',
        'icon': '✨',
        'color': const Color(0xFFFFF3E0),
      },
      {
        'title': 'Nutritionist / Dietitian',
        'desc':
            'Creates personalized meal plans to manage weight, insulin resistance, and inflammation through diet.',
        'when': 'Weight & nutrition management',
        'icon': '🥗',
        'color': const Color(0xFFE8F5E9),
      },
      {
        'title': 'Mental Health Counselor',
        'desc':
            'Addresses anxiety, depression, and emotional well-being associated with PCOS. Cognitive behavioral therapy (CBT) is helpful.',
        'when': 'Anxiety, depression, mood issues',
        'icon': '💬',
        'color': const Color(0xFFFCE4EC),
      },
    ];

    return Column(
      children: specialists
          .map(
            (s) => HealHerCard(
              color: s['color'] as Color,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    s['icon'] as String,
                    style: const TextStyle(fontSize: 32),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          s['title'] as String,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          s['desc'] as String,
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.textMedium,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(
                              Icons.access_time,
                              size: 14,
                              color: AppColors.primaryDark,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              s['when'] as String,
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.primaryDark,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildWhenToSee() {
    final urgentSigns = [
      'Periods missing for 3+ months',
      'Severe pelvic pain or cramping',
      'Unable to conceive after 6-12 months of trying',
      'Sudden excessive weight gain',
      'Severe hair loss',
      'Very high androgen symptoms (thick facial hair)',
      'Signs of insulin resistance (darkening skin, fatigue)',
      'Depressive episodes or severe anxiety',
    ];

    return HealHerCard(
      color: const Color(0xFFFFF8E1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Text('⚠️', style: TextStyle(fontSize: 24)),
              SizedBox(width: 8),
              Text(
                'Seek Medical Help If You Experience:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...urgentSigns.map(
            (s) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.arrow_right,
                    color: AppColors.warning,
                    size: 20,
                  ),
                  Expanded(
                    child: Text(s, style: const TextStyle(fontSize: 13)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestions() {
    final questions = [
      'Do I have PCOS or PCOD? What is the difference in my case?',
      'What tests do I need? (ultrasound, blood work, hormone panel)',
      'What are my treatment options? (medical, lifestyle, natural)',
      'How will this affect my fertility and future pregnancy?',
      'What changes should I make to my diet and lifestyle?',
      'Should I start any supplements? (Inositol, Vitamin D, Omega-3)',
      'How often should I come for follow-up visits?',
      'Are there any warning signs I should watch out for?',
      'What is the risk of developing diabetes, thyroid issues?',
      'Can my condition improve or go away with lifestyle changes?',
    ];

    return HealHerCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Prepare these questions for your appointment:',
            style: TextStyle(fontSize: 13, color: AppColors.textMedium),
          ),
          const SizedBox(height: 12),
          ...questions.asMap().entries.map(
            (e) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Q${e.key + 1}. ',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryDark,
                      fontSize: 13,
                    ),
                  ),
                  Expanded(
                    child: Text(e.value, style: const TextStyle(fontSize: 13)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHelplines() {
    final resources = [
      {
        'name': 'iCall Helpline (India)',
        'number': '9152987821',
        'desc': 'Mental health support helpline',
        'icon': '📞',
      },
      {
        'name': 'PCOS Society of India',
        'number': 'pcossociety.org',
        'desc': 'PCOS education & specialist referrals',
        'icon': '🌐',
      },
      {
        'name': 'PCOS Challenge',
        'number': 'pcoschallenge.com',
        'desc': 'International PCOS support network',
        'icon': '🌐',
      },
      {
        'name': 'Vandrevala Foundation',
        'number': '1860-2662-345',
        'desc': '24/7 mental health helpline (India)',
        'icon': '📞',
      },
    ];

    return Column(
      children: resources
          .map(
            (r) => HealHerCard(
              child: Row(
                children: [
                  Text(r['icon']!, style: const TextStyle(fontSize: 28)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          r['name']!,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          r['number']!,
                          style: const TextStyle(
                            color: AppColors.primaryDark,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          r['desc']!,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textLight,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}
