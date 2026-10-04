// lib/screens/profile/edit_profile_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/firebase_service.dart';
import '../../services/app_provider.dart';
import '../../utils/app_theme.dart';
import '../../widgets/common_widgets.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameCtrl;
  late TextEditingController _ageCtrl;
  late TextEditingController _weightCtrl;
  late TextEditingController _heightCtrl;
  String _condition = 'PCOS';
  bool _isLoading = false;

  final List<String> _conditions = ['PCOS', 'PCOD', 'Suspected', 'None'];

  @override
  void initState() {
    super.initState();
    final user = context.read<AppProvider>().user;
    _nameCtrl = TextEditingController(text: user?.name ?? '');
    _ageCtrl = TextEditingController(
        text: user?.age != null && user!.age > 0 ? user.age.toString() : '');
    _weightCtrl = TextEditingController(
        text: user?.weight != null && user!.weight > 0
            ? user.weight.toString()
            : '');
    _heightCtrl = TextEditingController(
        text: user?.height != null && user!.height > 0
            ? user.height.toString()
            : '');
    _condition = user?.condition ?? 'PCOS';
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _ageCtrl.dispose();
    _weightCtrl.dispose();
    _heightCtrl.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      final uid = FirebaseService.uid;
      if (uid == null) return;
      await FirebaseService.updateUserProfile(uid, {
        'name': _nameCtrl.text.trim(),
        'age': int.tryParse(_ageCtrl.text.trim()) ?? 0,
        'weight': double.tryParse(_weightCtrl.text.trim()) ?? 0.0,
        'height': double.tryParse(_heightCtrl.text.trim()) ?? 0.0,
        'condition': _condition,
      });
      await context.read<AppProvider>().loadUser();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Profile updated successfully!'),
            backgroundColor: AppColors.success,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
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
                    Text('✏️', style: TextStyle(fontSize: 32)),
                    SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Personal Information',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold)),
                          Text('Update your health profile',
                              style: TextStyle(
                                  color: Colors.white70, fontSize: 12)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Name
              const Text('Full Name',
                  style: TextStyle(
                      fontWeight: FontWeight.w600, color: AppColors.textDark)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _nameCtrl,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  hintText: 'Enter your full name',
                  prefixIcon:
                      Icon(Icons.person_outline, color: AppColors.primary),
                ),
                validator: (v) => v!.isEmpty ? 'Please enter your name' : null,
              ),
              const SizedBox(height: 16),

              // Age
              const Text('Age',
                  style: TextStyle(
                      fontWeight: FontWeight.w600, color: AppColors.textDark)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _ageCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: 'Enter your age',
                  prefixIcon:
                      Icon(Icons.cake_outlined, color: AppColors.primary),
                  suffixText: 'years',
                ),
                validator: (v) => v!.isEmpty ? 'Please enter your age' : null,
              ),
              const SizedBox(height: 16),

              // Weight & Height
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Weight',
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: AppColors.textDark)),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _weightCtrl,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            hintText: 'kg',
                            prefixIcon: Icon(Icons.monitor_weight_outlined,
                                color: AppColors.primary),
                            suffixText: 'kg',
                          ),
                          validator: (v) => v!.isEmpty ? 'Required' : null,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Height',
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: AppColors.textDark)),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _heightCtrl,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            hintText: 'cm',
                            prefixIcon:
                                Icon(Icons.height, color: AppColors.primary),
                            suffixText: 'cm',
                          ),
                          validator: (v) => v!.isEmpty ? 'Required' : null,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Condition
              const Text('Your Condition',
                  style: TextStyle(
                      fontWeight: FontWeight.w600, color: AppColors.textDark)),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _conditions
                    .map((c) => ChoiceChip(
                          label: Text(c),
                          selected: _condition == c,
                          onSelected: (_) => setState(() => _condition = c),
                          selectedColor: AppColors.primaryDark,
                          labelStyle: TextStyle(
                            color: _condition == c
                                ? Colors.white
                                : AppColors.textDark,
                            fontWeight: FontWeight.w500,
                          ),
                        ))
                    .toList(),
              ),
              const SizedBox(height: 32),

              // Save Button
              GradientButton(
                text: 'Save Changes',
                icon: Icons.save_outlined,
                onPressed: _saveProfile,
                isLoading: _isLoading,
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
