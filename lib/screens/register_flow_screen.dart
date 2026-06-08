import 'package:flutter/material.dart';

import '../models/app_user.dart';

class RegisterFlowScreen extends StatefulWidget {
  const RegisterFlowScreen({
    super.key,
    required this.role,
    required this.formKey,
    required this.onBack,
    required this.onSubmit,
    required this.nameCtrl,
    required this.emailCtrl,
    required this.passwordCtrl,
    required this.phoneCtrl,
    required this.birthDateCtrl,
    required this.weightCtrl,
    required this.heightCtrl,
    required this.goalCtrl,
    required this.extraOneCtrl,
    required this.extraTwoCtrl,
    required this.extraThreeCtrl,
    required this.obscurePassword,
    required this.onTogglePassword,
    required this.isSubmitting,
  });

  final UserRole role;
  final GlobalKey<FormState> formKey;
  final VoidCallback onBack;
  final VoidCallback onSubmit;
  final TextEditingController nameCtrl;
  final TextEditingController emailCtrl;
  final TextEditingController passwordCtrl;
  final TextEditingController phoneCtrl;
  final TextEditingController birthDateCtrl;
  final TextEditingController weightCtrl;
  final TextEditingController heightCtrl;
  final TextEditingController goalCtrl;
  final TextEditingController extraOneCtrl;
  final TextEditingController extraTwoCtrl;
  final TextEditingController extraThreeCtrl;
  final bool obscurePassword;
  final VoidCallback onTogglePassword;
  final bool isSubmitting;

  @override
  State<RegisterFlowScreen> createState() => _RegisterFlowScreenState();
}

class _RegisterFlowScreenState extends State<RegisterFlowScreen> {
  String? selectedGoal;
  String? selectedLevel;
  String? selectedAttendanceMode;

  @override
  void initState() {
    super.initState();

    if (widget.goalCtrl.text.trim().isNotEmpty) {
      selectedGoal = widget.goalCtrl.text.trim();
    }

    if (widget.role == UserRole.aluno &&
        widget.extraOneCtrl.text.trim().isNotEmpty) {
      selectedLevel = widget.extraOneCtrl.text.trim();
    }

    if (widget.role == UserRole.nutricionista &&
        widget.extraThreeCtrl.text.trim().isNotEmpty) {
      selectedAttendanceMode = widget.extraThreeCtrl.text.trim();
    }
  }

  @override
  Widget build(BuildContext context) {
    final fields = roleFields(widget.role);
    final keyboardBottom = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: widget.isSubmitting ? null : widget.onBack,
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
        title: Text('Cadastro ${widget.role.label}'),
      ),
      body: SafeArea(
        child: Form(
          key: widget.formKey,
          child: ListView(
            padding: EdgeInsets.fromLTRB(24, 8, 24, 32 + keyboardBottom),
            children: [
              buildHeaderCard(),
              const SizedBox(height: 24),
              const Text(
                'Dados principais',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 14),
              field(
                widget.nameCtrl,
                'Nome completo',
                icon: Icons.person_outline_rounded,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 14),
              field(
                widget.emailCtrl,
                'E-mail',
                icon: Icons.email_outlined,
                type: TextInputType.emailAddress,
                validator: validateEmail,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 14),
              passwordField(),
              const SizedBox(height: 14),
              field(
                widget.phoneCtrl,
                'Telefone',
                icon: Icons.phone_outlined,
                type: TextInputType.phone,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 14),
              field(
                widget.birthDateCtrl,
                'Data de nascimento (AAAA-MM-DD)',
                icon: Icons.cake_outlined,
                type: TextInputType.datetime,
                validator: validateBirthDate,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 14),
              field(
                widget.weightCtrl,
                'Peso atual (kg)',
                icon: Icons.monitor_weight_outlined,
                type: const TextInputType.numberWithOptions(decimal: true),
                validator: validateWeight,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 14),
              field(
                widget.heightCtrl,
                'Altura (m)',
                icon: Icons.height_rounded,
                type: const TextInputType.numberWithOptions(decimal: true),
                validator: validateHeight,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 14),
              goalDropdown(),
              const SizedBox(height: 24),
              const Text(
                'Dados do perfil',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 6),
              Text(
                profileSectionHelperText(widget.role),
                style: const TextStyle(color: Colors.black54, height: 1.4),
              ),
              const SizedBox(height: 14),
              buildRoleSpecificFields(fields),
              const SizedBox(height: 28),
              FilledButton.icon(
                onPressed: widget.isSubmitting ? null : handleSubmit,
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF0F766E),
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                icon: widget.isSubmitting
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.check_circle_rounded),
                label: Text(
                  widget.isSubmitting
                      ? 'Cadastrando...'
                      : 'Finalizar cadastro',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildHeaderCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFE6F6F4),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: const Color(0xFF0F766E),
            child: Icon(widget.role.icon, color: Colors.white),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              widget.role.description,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget passwordField() {
    return TextFormField(
      controller: widget.passwordCtrl,
      obscureText: widget.obscurePassword,
      textInputAction: TextInputAction.next,
      validator: validatePassword,
      decoration: InputDecoration(
        labelText: 'Senha',
        prefixIcon: const Icon(Icons.lock_outline_rounded),
        suffixIcon: IconButton(
          onPressed: widget.onTogglePassword,
          icon: Icon(
            widget.obscurePassword ? Icons.visibility_off : Icons.visibility,
          ),
        ),
      ),
    );
  }

  Widget buildRoleSpecificFields((String, String, String) fields) {
    if (widget.role == UserRole.aluno) {
      return Column(
        children: [
          dropdownField(
            label: fields.$1,
            initialValue: selectedLevel,
            items: const ['Iniciante', 'Intermediário', 'Avançado'],
            onChanged: (value) {
              setState(() => selectedLevel = value);
              widget.extraOneCtrl.text = value ?? '';
            },
          ),
          const SizedBox(height: 14),
          field(
            widget.extraTwoCtrl,
            fields.$2,
            icon: Icons.accessibility_new_rounded,
            maxLines: 2,
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 14),
          field(
            widget.extraThreeCtrl,
            fields.$3,
            icon: Icons.calendar_today_outlined,
            textInputAction: TextInputAction.done,
          ),
        ],
      );
    }

    if (widget.role == UserRole.nutricionista) {
      return Column(
        children: [
          field(
            widget.extraOneCtrl,
            fields.$1,
            icon: Icons.restaurant_outlined,
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 14),
          field(
            widget.extraTwoCtrl,
            fields.$2,
            icon: Icons.medical_information_outlined,
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 14),
          dropdownField(
            label: fields.$3,
            initialValue: selectedAttendanceMode,
            items: const ['Online', 'Presencial', 'Híbrido'],
            onChanged: (value) {
              setState(() => selectedAttendanceMode = value);
              widget.extraThreeCtrl.text = value ?? '';
            },
          ),
        ],
      );
    }

    return Column(
      children: [
        field(
          widget.extraOneCtrl,
          fields.$1,
          icon: Icons.badge_outlined,
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: 14),
        field(
          widget.extraTwoCtrl,
          fields.$2,
          icon: Icons.work_outline_rounded,
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: 14),
        field(
          widget.extraThreeCtrl,
          fields.$3,
          icon: Icons.location_on_outlined,
          textInputAction: TextInputAction.done,
        ),
      ],
    );
  }

  Widget goalDropdown() {
    return DropdownButtonFormField<String>(
      initialValue: selectedGoal,
      decoration: InputDecoration(
        labelText: 'Objetivo principal',
        prefixIcon: const Icon(Icons.track_changes_rounded),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
      ),
      items: const [
        DropdownMenuItem(value: 'Emagrecimento', child: Text('Emagrecimento')),
        DropdownMenuItem(value: 'Hipertrofia', child: Text('Hipertrofia')),
        DropdownMenuItem(value: 'Condicionamento', child: Text('Condicionamento')),
        DropdownMenuItem(value: 'Saúde e rotina', child: Text('Saúde e rotina')),
      ],
      onChanged: (value) {
        setState(() => selectedGoal = value);
        widget.goalCtrl.text = value ?? '';
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Selecione um objetivo principal';
        }
        return null;
      },
    );
  }

  Widget dropdownField({
    required String label,
    required String? initialValue,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      initialValue: initialValue,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
      ),
      items: items
          .map((item) => DropdownMenuItem<String>(
                value: item,
                child: Text(item),
              ))
          .toList(),
      onChanged: onChanged,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Selecione $label';
        }
        return null;
      },
    );
  }

  Widget field(
    TextEditingController controller,
    String label, {
    TextInputType? type,
    String? Function(String?)? validator,
    IconData? icon,
    int maxLines = 1,
    TextInputAction? textInputAction,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: type,
      validator: validator ??
          (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Preencha $label';
            }
            return null;
          },
      maxLines: maxLines,
      textInputAction: textInputAction,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: icon != null ? Icon(icon) : null,
      ),
    );
  }

  (String, String, String) roleFields(UserRole role) {
    switch (role) {
      case UserRole.aluno:
        return ('Nível de treino', 'Restrições físicas', 'Disponibilidade semanal');
      case UserRole.personal:
        return ('Especialidade', 'Tempo de experiência', 'Quantidade de alunos');
      case UserRole.nutricionista:
        return ('Abordagem nutricional', 'Área de atuação', 'Formato de atendimento');
      case UserRole.academia:
        return ('Nome da unidade', 'Capacidade de alunos', 'Cidade / bairro');
    }
  }

  String profileSectionHelperText(UserRole role) {
    switch (role) {
      case UserRole.aluno:
        return 'Preencha dados que ajudem a personalizar treino, rotina e acompanhamento.';
      case UserRole.personal:
        return 'Informe sua atuação profissional para organizar melhor seu painel e atendimentos.';
      case UserRole.nutricionista:
        return 'Esses dados ajudam a adaptar o perfil profissional e o formato de atendimento.';
      case UserRole.academia:
        return 'Essas informações ajudam a estruturar a gestão da unidade no sistema.';
    }
  }

  String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) return 'Preencha o e-mail';
    final email = value.trim();
    final regex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!regex.hasMatch(email)) return 'Digite um e-mail válido';
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.trim().isEmpty) return 'Preencha a senha';
    if (value.trim().length < 6) return 'A senha deve ter pelo menos 6 caracteres';
    return null;
  }

  String? validateBirthDate(String? value) {
    if (value == null || value.trim().isEmpty) return 'Preencha a data de nascimento';
    final date = DateTime.tryParse(value.trim());
    if (date == null) return 'Use o formato AAAA-MM-DD';
    if (date.isAfter(DateTime.now())) return 'A data não pode ser futura';
    return null;
  }

  String? validateWeight(String? value) {
    if (value == null || value.trim().isEmpty) return 'Preencha o peso';
    final weight = double.tryParse(value.replaceAll(',', '.'));
    if (weight == null || weight < 20 || weight > 400) {
      return 'Informe um peso válido';
    }
    return null;
  }

  String? validateHeight(String? value) {
    if (value == null || value.trim().isEmpty) return 'Preencha a altura';
    final height = double.tryParse(value.replaceAll(',', '.'));
    if (height == null || height < 1.0 || height > 2.5) {
      return 'Informe uma altura válida';
    }
    return null;
  }

  void handleSubmit() {
    if (widget.formKey.currentState?.validate() ?? false) {
      widget.onSubmit();
    }
  }
}