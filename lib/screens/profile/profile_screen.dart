// lib/screens/profile/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/firebase_service.dart';
import '../../services/app_provider.dart';
import '../../utils/app_theme.dart';
import '../auth/login_screen.dart';
import '../period/period_screen.dart';
import '../symptoms/symptoms_screen.dart';
import '../weight/weight_screen.dart';
import 'notifications_screen.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appUser = context.watch<AppProvider>().user;
    final firebaseUser = FirebaseAuth.instance.currentUser;

    final String displayName =
        appUser?.name ?? firebaseUser?.displayName ?? 'HealHer User';
    final String displayEmail =
        appUser?.email ?? firebaseUser?.email ?? 'No email';
    final String condition = appUser?.condition ?? 'PCOS/PCOD';
    final double weight = appUser?.weight ?? 0.0;
    final double height = appUser?.height ?? 0.0;
    final double bmi = appUser?.bmi ?? 0.0;
    final String bmiCategory = appUser?.bmiCategory ?? '-';
    final int age = appUser?.age ?? 0;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            backgroundColor: AppColors.primaryDark,
            actions: [
              IconButton(
                icon: const Icon(Icons.logout_rounded, color: Colors.white),
                onPressed: () => _showLogoutDialog(context),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: _buildProfileHeader(
                  displayName, displayEmail, condition, age),
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                if (weight > 0 && height > 0)
                  _buildHealthStatsSection(weight, height, bmi, bmiCategory),
                const SizedBox(height: 16),
                _buildMenuSection(context, displayName, displayEmail),
                const SizedBox(height: 16),
                _buildAboutSection(),
                const SizedBox(height: 16),
                _buildLogoutButton(context),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(
      String name, String email, String condition, int age) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primaryDark, AppColors.primary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 4),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 48,
                    backgroundColor: Colors.white,
                    child: Text(
                      name.isNotEmpty ? name[0].toUpperCase() : 'H',
                      style: const TextStyle(
                        fontSize: 42,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryDark,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 2,
                  right: 2,
                  child: Container(
                    width: 22,
                    height: 22,
                    decoration: const BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                      border: Border.fromBorderSide(
                        BorderSide(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              name,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              email,
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withOpacity(0.8),
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.25),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withOpacity(0.4)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('💗', style: TextStyle(fontSize: 14)),
                  const SizedBox(width: 6),
                  Text(
                    condition,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHealthStatsSection(
      double weight, double height, double bmi, String bmiCategory) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 4, bottom: 12),
            child: Text(
              '📊 Health Overview',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark),
            ),
          ),
          Row(
            children: [
              _buildStatCard('⚖️', 'Weight', '${weight.toStringAsFixed(1)} kg',
                  AppColors.primary),
              const SizedBox(width: 12),
              _buildStatCard('📏', 'Height', '${height.toStringAsFixed(0)} cm',
                  const Color(0xFF90C8A8)),
              const SizedBox(width: 12),
              _buildStatCard('📈', 'BMI', bmi.toStringAsFixed(1),
                  _getBmiColor(bmiCategory)),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                    color: AppColors.primary.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 3)),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: _getBmiColor(bmiCategory).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                      child: Text('🩺', style: TextStyle(fontSize: 22))),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('BMI Category',
                          style: TextStyle(
                              fontSize: 12, color: AppColors.textLight)),
                      Text(
                        bmiCategory,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: _getBmiColor(bmiCategory)),
                      ),
                    ],
                  ),
                ),
                Text(
                  _getBmiAdvice(bmiCategory),
                  style:
                      TextStyle(fontSize: 12, color: _getBmiColor(bmiCategory)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String emoji, String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
                color: AppColors.primary.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 3)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 6),
            Text(value,
                style: TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold, color: color)),
            Text(label,
                style:
                    const TextStyle(fontSize: 11, color: AppColors.textLight)),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuSection(BuildContext context, String name, String email) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 4, bottom: 12),
            child: Text(
              '⚙️ My Account',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                    color: AppColors.primary.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 3)),
              ],
            ),
            child: Column(
              children: [
                _buildMenuItem(
                  icon: Icons.person_outline_rounded,
                  label: 'Personal Information',
                  subtitle: name,
                  color: AppColors.primary,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const EditProfileScreen()),
                  ).then((_) => context.read<AppProvider>().loadUser()),
                ),
                _buildDivider(),
                _buildMenuItem(
                  icon: Icons.email_outlined,
                  label: 'Email Address',
                  subtitle: email,
                  color: const Color(0xFF90C8A8),
                  onTap: () => _showEmailDialog(context, email),
                ),
                _buildDivider(),
                _buildMenuItem(
                  icon: Icons.calendar_month_outlined,
                  label: 'Period History',
                  subtitle: 'View all logged periods',
                  color: const Color(0xFFE8A0B4),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const PeriodScreen()),
                  ),
                ),
                _buildDivider(),
                _buildMenuItem(
                  icon: Icons.healing_outlined,
                  label: 'Symptom Log',
                  subtitle: 'View all symptoms',
                  color: const Color(0xFFB8A0D8),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SymptomsScreen()),
                  ),
                ),
                _buildDivider(),
                _buildMenuItem(
                  icon: Icons.monitor_weight_outlined,
                  label: 'Weight History',
                  subtitle: 'Track your progress',
                  color: const Color(0xFF85C4D5),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const WeightScreen()),
                  ),
                ),
                _buildDivider(),
                _buildMenuItem(
                  icon: Icons.notifications_outlined,
                  label: 'Notifications',
                  subtitle: 'Manage reminders',
                  color: const Color(0xFFE8C070),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const NotificationsScreen()),
                  ),
                ),
                _buildDivider(),
                _buildMenuItem(
                  icon: Icons.privacy_tip_outlined,
                  label: 'Privacy Policy',
                  subtitle: 'Read our privacy policy',
                  color: AppColors.textMedium,
                  onTap: () => _showPrivacyPolicy(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String label,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textDark)),
                  Text(subtitle,
                      style: const TextStyle(
                          fontSize: 12, color: AppColors.textLight)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded,
                size: 14, color: AppColors.textLight),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(
        height: 1, indent: 72, endIndent: 16, color: Color(0xFFF0F0F0));
  }

  Widget _buildAboutSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primaryLight, Color(0xFFFFF0F5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
              color: AppColors.primary.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 3)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: AppColors.primaryDark,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                    child: Text('💗', style: TextStyle(fontSize: 22))),
              ),
              const SizedBox(width: 12),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('HealHer',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryDark)),
                  Text('Track. Care. Heal.',
                      style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textMedium,
                          fontStyle: FontStyle.italic)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Text(
            'HealHer is a compassionate health companion designed to support women managing PCOS and PCOD. Empowering you with awareness, tools, and guidance.',
            style: TextStyle(
                fontSize: 13, color: AppColors.textMedium, height: 1.6),
          ),
          const SizedBox(height: 14),
          const Divider(color: AppColors.primary, height: 1),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildAboutItem('Version', '1.0.0'),
              _buildAboutItem('Developer', 'Safia Amal'),
              _buildAboutItem('Year', '2025'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAboutItem(String label, String value) {
    return Column(
      children: [
        Text(value,
            style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryDark)),
        Text(label,
            style: const TextStyle(fontSize: 11, color: AppColors.textLight)),
      ],
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () => _showLogoutDialog(context),
        icon: const Icon(Icons.logout_rounded, color: Colors.white),
        label: const Text('Sign Out',
            style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold)),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.error,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 2,
        ),
      ),
    );
  }

  Color _getBmiColor(String cat) {
    switch (cat) {
      case 'Underweight':
        return Colors.blue;
      case 'Normal':
        return AppColors.success;
      case 'Overweight':
        return AppColors.warning;
      default:
        return AppColors.error;
    }
  }

  String _getBmiAdvice(String cat) {
    switch (cat) {
      case 'Underweight':
        return 'Eat more 🥗';
      case 'Normal':
        return 'Great job! 🌟';
      case 'Overweight':
        return 'Stay active 🏃';
      default:
        return 'See doctor 🩺';
    }
  }

  void _showEmailDialog(BuildContext context, String email) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.email_outlined, color: AppColors.primary),
            SizedBox(width: 8),
            Text('Email Address'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Your registered email address:',
                style: TextStyle(fontSize: 13, color: AppColors.textMedium)),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const Icon(Icons.mail_outline,
                      color: AppColors.primaryDark, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(email,
                        style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryDark)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              '⚠️ Email cannot be changed as it is linked to your account.',
              style: TextStyle(fontSize: 12, color: AppColors.textMedium),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryDark,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('OK', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showPrivacyPolicy(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const PrivacyPolicyScreen()),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Text('👋 ', style: TextStyle(fontSize: 24)),
            Text('Sign Out'),
          ],
        ),
        content: const Text('Are you sure you want to sign out of HealHer?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel',
                style: TextStyle(color: AppColors.textMedium)),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await FirebaseService.signOut();
              context.read<AppProvider>().clearUser();
              if (context.mounted) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (_) => false,
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child:
                const Text('Sign Out', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

// ── Privacy Policy Screen ──
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
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primaryDark, AppColors.primary],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Row(
                children: [
                  Text('🔒', style: TextStyle(fontSize: 32)),
                  SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Privacy Policy',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold)),
                        Text('Last updated: April 2025',
                            style:
                                TextStyle(color: Colors.white70, fontSize: 12)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _buildSection('1. Information We Collect',
                'HealHer collects personal health information including your name, email, age, weight, height, menstrual cycle data, symptoms, and other health-related information that you voluntarily provide.'),
            _buildSection('2. How We Use Your Information',
                'Your data is used solely to provide personalized health tracking, cycle predictions, symptom analysis, and wellness recommendations within the app. We do not sell or share your data with third parties.'),
            _buildSection('3. Data Storage & Security',
                'All your data is securely stored using Firebase (Google Cloud). We implement industry-standard security measures to protect your personal and health information.'),
            _buildSection('4. Data Sharing',
                'HealHer does not share your personal health information with any third parties, advertisers, or external services. Your health data is private and confidential.'),
            _buildSection('5. Your Rights',
                'You have the right to access, update, or delete your personal information at any time through the app settings. You can also request complete data deletion by contacting us.'),
            _buildSection('6. Children\'s Privacy',
                'HealHer is designed for users aged 13 and above. We do not knowingly collect information from children under 13.'),
            _buildSection('7. Changes to This Policy',
                'We may update this privacy policy from time to time. We will notify you of any significant changes through the app.'),
            _buildSection('8. Contact Us',
                'If you have any questions about this privacy policy or your data, please contact us at: healher.support@gmail.com'),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Row(
                children: [
                  Text('💗', style: TextStyle(fontSize: 24)),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'HealHer is committed to protecting your privacy and keeping your health data safe.',
                      style: TextStyle(
                          fontSize: 13,
                          color: AppColors.primaryDark,
                          fontWeight: FontWeight.w500),
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
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  fontSize: 15,
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
