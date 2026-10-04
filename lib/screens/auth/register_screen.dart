// lib/screens/auth/register_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/firebase_service.dart';
import '../../services/app_provider.dart';
import '../../models/models.dart';
import '../../utils/app_theme.dart';
import '../../widgets/common_widgets.dart';
import '../main_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _ageCtrl = TextEditingController();
  final _weightCtrl = TextEditingController();
  final _heightCtrl = TextEditingController();
  String _condition = 'PCOS';
  bool _isLoading = false;
  bool _obscure = true;
  int _step = 0;

  final List<String> _conditions = ['PCOS', 'PCOD', 'Suspected', 'None'];

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      final cred = await FirebaseService.signUp(
        _emailCtrl.text.trim(),
        _passCtrl.text.trim(),
      );
      final user = UserModel(
        uid: cred.user!.uid,
        name: _nameCtrl.text.trim(),
        email: _emailCtrl.text.trim(),
        age: int.parse(_ageCtrl.text),
        weight: double.parse(_weightCtrl.text),
        height: double.parse(_heightCtrl.text),
        condition: _condition,
        createdAt: DateTime.now(),
      );
      await FirebaseService.saveUserProfile(user);
      if (mounted) {
        context.read<AppProvider>().loadUser();
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const MainScreen()),
          (_) => false,
        );
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
        title: const Text('Create Account'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Progress
                Row(
                  children: List.generate(
                    2,
                    (i) => Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        height: 4,
                        decoration: BoxDecoration(
                          color: i <= _step
                              ? AppColors.primaryDark
                              : AppColors.primaryLight,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                if (_step == 0) ..._buildStep1() else ..._buildStep2(),
                const SizedBox(height: 32),
                if (_step == 0)
                  GradientButton(
                    text: 'Next',
                    icon: Icons.arrow_forward,
                    onPressed: () {
                      if (_nameCtrl.text.isNotEmpty &&
                          _emailCtrl.text.isNotEmpty &&
                          _passCtrl.text.isNotEmpty) {
                        setState(() => _step = 1);
                      }
                    },
                  )
                else
                  GradientButton(
                    text: 'Create Account',
                    icon: Icons.check,
                    onPressed: _register,
                    isLoading: _isLoading,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildStep1() => [
    const Text(
      'Personal Info',
      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
    ),
    const SizedBox(height: 6),
    const Text(
      'Tell us about yourself',
      style: TextStyle(color: AppColors.textMedium),
    ),
    const SizedBox(height: 24),
    TextFormField(
      controller: _nameCtrl,
      textCapitalization: TextCapitalization.words,
      decoration: const InputDecoration(
        labelText: 'Full Name',
        prefixIcon: Icon(Icons.person_outline, color: AppColors.primary),
      ),
      validator: (v) => v!.isEmpty ? 'Required' : null,
    ),
    const SizedBox(height: 16),
    TextFormField(
      controller: _emailCtrl,
      keyboardType: TextInputType.emailAddress,
      decoration: const InputDecoration(
        labelText: 'Email',
        prefixIcon: Icon(Icons.mail_outline, color: AppColors.primary),
      ),
      validator: (v) => v!.isEmpty ? 'Required' : null,
    ),
    const SizedBox(height: 16),
    TextFormField(
      controller: _passCtrl,
      obscureText: _obscure,
      decoration: InputDecoration(
        labelText: 'Password',
        prefixIcon: const Icon(Icons.lock_outline, color: AppColors.primary),
        suffixIcon: IconButton(
          icon: Icon(
            _obscure ? Icons.visibility_off : Icons.visibility,
            color: AppColors.textLight,
          ),
          onPressed: () => setState(() => _obscure = !_obscure),
        ),
      ),
      validator: (v) => v!.length < 6 ? 'Minimum 6 characters' : null,
    ),
  ];

  List<Widget> _buildStep2() => [
    const Text(
      'Health Details',
      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
    ),
    const SizedBox(height: 6),
    const Text(
      'Help us personalize your experience',
      style: TextStyle(color: AppColors.textMedium),
    ),
    const SizedBox(height: 24),
    Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: _ageCtrl,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Age',
              prefixIcon: Icon(Icons.cake_outlined, color: AppColors.primary),
            ),
            validator: (v) => v!.isEmpty ? 'Required' : null,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: TextFormField(
            controller: _heightCtrl,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Height (cm)',
              prefixIcon: Icon(Icons.height, color: AppColors.primary),
            ),
            validator: (v) => v!.isEmpty ? 'Required' : null,
          ),
        ),
      ],
    ),
    const SizedBox(height: 16),
    TextFormField(
      controller: _weightCtrl,
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(
        labelText: 'Current Weight (kg)',
        prefixIcon: Icon(
          Icons.monitor_weight_outlined,
          color: AppColors.primary,
        ),
      ),
      validator: (v) => v!.isEmpty ? 'Required' : null,
    ),
    const SizedBox(height: 20),
    const Text(
      'Your Condition',
      style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.textDark),
    ),
    const SizedBox(height: 10),
    Wrap(
      spacing: 8,
      children: _conditions
          .map(
            (c) => ChoiceChip(
              label: Text(c),
              selected: _condition == c,
              onSelected: (_) => setState(() => _condition = c),
              selectedColor: AppColors.primaryDark,
              labelStyle: TextStyle(
                color: _condition == c ? Colors.white : AppColors.textDark,
              ),
            ),
          )
          .toList(),
    ),
  ];
}
