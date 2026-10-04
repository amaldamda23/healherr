// lib/screens/profile/personal_info_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/app_provider.dart';
import '../../utils/app_theme.dart';

class PersonalInfoScreen extends StatelessWidget {
  const PersonalInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appUser = context.watch<AppProvider>().user;
    final firebaseUser = FirebaseAuth.instance.currentUser;

    final String name =
        appUser?.name ?? firebaseUser?.displayName ?? 'HealHer User';
    final String email = appUser?.email ?? firebaseUser?.email ?? '-';
    final int age = appUser?.age ?? 0;
    final double weight = appUser?.weight ?? 0.0;
    final double height = appUser?.height ?? 0.0;
    final String condition = appUser?.condition ?? '-';
    final double bmi = appUser?.bmi ?? 0.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Personal Information'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Profile Avatar
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 52,
                    backgroundColor: AppColors.primaryDark,
                    child: Text(
                      name.isNotEmpty ? name[0].toUpperCase() : 'H',
                      style: const TextStyle(
                          fontSize: 44,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(name,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold)),
                  Text(email,
                      style: const TextStyle(
                          fontSize: 13, color: AppColors.textMedium)),
                ],
              ),
            ),
            const SizedBox(height: 28),

            // Info Cards
            _buildInfoCard('👤 Full Name', name),
            _buildInfoCard('📧 Email', email),
            _buildInfoCard('🎂 Age', age > 0 ? '$age years' : 'Not set'),
            _buildInfoCard('⚖️ Weight',
                weight > 0 ? '${weight.toStringAsFixed(1)} kg' : 'Not set'),
            _buildInfoCard('📏 Height',
                height > 0 ? '${height.toStringAsFixed(0)} cm' : 'Not set'),
            _buildInfoCard(
                '📈 BMI', bmi > 0 ? bmi.toStringAsFixed(1) : 'Not set'),
            _buildInfoCard('💗 Condition', condition),

            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Row(
                children: [
                  Text('ℹ️ ', style: TextStyle(fontSize: 18)),
                  Expanded(
                    child: Text(
                      'To update your information, please contact support or re-register.',
                      style:
                          TextStyle(fontSize: 13, color: AppColors.primaryDark),
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

  Widget _buildInfoCard(String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
              color: AppColors.primary.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 3))
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(
                        fontSize: 12, color: AppColors.textLight)),
                const SizedBox(height: 4),
                Text(value,
                    style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textDark)),
              ],
            ),
          ),
          const Icon(Icons.lock_outline_rounded,
              size: 16, color: AppColors.textLight),
        ],
      ),
    );
  }
}
