// lib/screens/profile/privacy_policy_screen.dart
import 'package:flutter/material.dart';
import '../../utils/app_theme.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primaryDark, AppColors.primary],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('🔒 Privacy Policy',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                  SizedBox(height: 6),
                  Text('Last updated: January 2025',
                      style: TextStyle(color: Colors.white70, fontSize: 12)),
                  SizedBox(height: 8),
                  Text(
                    'HealHer is committed to protecting your personal health information.',
                    style: TextStyle(
                        color: Colors.white, fontSize: 13, height: 1.5),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            _buildSection('📋 Information We Collect',
                'We collect information you provide when you register, including your name, email address, age, weight, height, and health condition (PCOS/PCOD). We also collect health data you log in the app such as period dates, symptoms, and weight entries.'),

            _buildSection('🔐 How We Use Your Information',
                'Your information is used solely to provide personalized health insights and recommendations. We do not sell, share, or disclose your personal health data to any third parties. All data is encrypted and stored securely in Firebase Cloud.'),

            _buildSection('☁️ Data Storage',
                'Your data is stored securely on Google Firebase servers. We use industry-standard encryption to protect your information. Only you can access your personal health data through your account.'),

            _buildSection('🗑️ Data Deletion',
                'You have the right to delete your account and all associated data at any time. Once deleted, your data cannot be recovered. Contact us if you wish to permanently delete your account.'),

            _buildSection('🍪 Cookies',
                'HealHer does not use tracking cookies. We only use essential technical cookies required for the app to function properly.'),

            _buildSection('📞 Contact Us',
                'If you have any questions about this Privacy Policy, please contact us at support@healher.app. We will respond to your query within 48 hours.'),

            _buildSection('🔄 Changes to Policy',
                'We may update this Privacy Policy from time to time. We will notify you of any significant changes through the app. Continued use of HealHer after changes constitutes acceptance of the updated policy.'),

            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Row(
                children: [
                  Text('💗', style: TextStyle(fontSize: 22)),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'HealHer — Made with love for women\'s health.\nBCA Project by Safia Amal Damda, 2025',
                      style: TextStyle(
                          fontSize: 12,
                          color: AppColors.primaryDark,
                          height: 1.5),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
              color: AppColors.primary.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 3))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryDark)),
          const SizedBox(height: 8),
          Text(content,
              style: const TextStyle(
                  fontSize: 13, color: AppColors.textMedium, height: 1.6)),
        ],
      ),
    );
  }
}
