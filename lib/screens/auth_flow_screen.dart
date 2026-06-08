import 'package:flutter/material.dart';

import '../models/app_user.dart';
import '../services/user_service.dart';
import 'register_flow_screen.dart';
import 'select_role_screen.dart';

class AuthFlowScreen extends StatefulWidget {
  const AuthFlowScreen({
    super.key,
    required this.onFinish,
  });

  final ValueChanged<AppUser> onFinish;

  @override
  State<AuthFlowScreen> createState() => _AuthFlowScreenState();
}

class _AuthFlowScreenState extends State<AuthFlowScreen> {
  final UserService _userService = UserService();

  int step = 0;
  UserRole? selectedRole;

  final formKey = GlobalKey<FormState>();

  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final birthDateCtrl = TextEditingController();
  final weightCtrl = TextEditingController();
  final heightCtrl = TextEditingController();
  final goalCtrl = TextEditingController();
  final extraOneCtrl = TextEditingController();
  final extraTwoCtrl = TextEditingController();
  final extraThreeCtrl = TextEditingController();

  bool obscureRegisterPassword = true;
  bool isSubmitting = false;

  @override
  void dispose() {
    nameCtrl.dispose();
    emailCtrl.dispose();
    passwordCtrl.dispose();
    phoneCtrl.dispose();
    birthDateCtrl.dispose();
    weightCtrl.dispose();
    heightCtrl.dispose();
    goalCtrl.dispose();
    extraOneCtrl.dispose();
    extraTwoCtrl.dispose();
    extraThreeCtrl.dispose();
    super.dispose();
  }

  Future<void> submitRegister() async {
    if (!(formKey.currentState?.validate() ?? false) || selectedRole == null) {
      return;
    }

    final user = AppUser(
      id: null,
      name: nameCtrl.text.trim(),
      email: emailCtrl.text.trim(),
      password: passwordCtrl.text.trim(),
      role: selectedRole!,
      phone: phoneCtrl.text.trim(),
      goal: goalCtrl.text.trim(),
      weight: double.tryParse(weightCtrl.text.replaceAll(',', '.').trim()) ?? 0,
      height: double.tryParse(heightCtrl.text.replaceAll(',', '.').trim()) ?? 0,
      birthDate: birthDateCtrl.text.trim().isEmpty
          ? null
          : DateTime.tryParse(birthDateCtrl.text.trim()),
      extra1: extraOneCtrl.text.trim(),
      extra2: extraTwoCtrl.text.trim(),
      extra3: extraThreeCtrl.text.trim(),
      imc: null,
    );

    try {
      setState(() => isSubmitting = true);

      final createdUser = await _userService.registerUser(user);

      if (!mounted) return;
      widget.onFinish(createdUser);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceFirst('Exception: ', '')),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 260),
          child: switch (step) {
            0 => SelectRoleScreen(
                key: const ValueKey('select-role'),
                selectedRole: selectedRole,
                onBack: () => Navigator.of(context).pop(),
                onSelect: (role) {
                  setState(() {
                    selectedRole = role;
                    step = 1;
                  });
                },
              ),
            _ => RegisterFlowScreen(
                key: ValueKey('register-${selectedRole?.name ?? 'none'}'),
                role: selectedRole!,
                formKey: formKey,
                onBack: () => setState(() => step = 0),
                onSubmit: submitRegister,
                nameCtrl: nameCtrl,
                emailCtrl: emailCtrl,
                passwordCtrl: passwordCtrl,
                phoneCtrl: phoneCtrl,
                birthDateCtrl: birthDateCtrl,
                weightCtrl: weightCtrl,
                heightCtrl: heightCtrl,
                goalCtrl: goalCtrl,
                extraOneCtrl: extraOneCtrl,
                extraTwoCtrl: extraTwoCtrl,
                extraThreeCtrl: extraThreeCtrl,
                obscurePassword: obscureRegisterPassword,
                onTogglePassword: () {
                  setState(() {
                    obscureRegisterPassword = !obscureRegisterPassword;
                  });
                },
                isSubmitting: isSubmitting,
              ),
          },
        ),
      ),
    );
  }
}