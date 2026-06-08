import 'package:flutter/material.dart';
import '../models/app_user.dart';

class SelectRoleScreen extends StatefulWidget {
  const SelectRoleScreen({
    super.key,
    required this.selectedRole,
    required this.onBack,
    required this.onSelect,
  });

  final UserRole? selectedRole;
  final VoidCallback onBack;
  final ValueChanged<UserRole> onSelect;

  @override
  State<SelectRoleScreen> createState() => _SelectRoleScreenState();
}

class _SelectRoleScreenState extends State<SelectRoleScreen> {
  UserRole? localSelectedRole;

  @override
  void initState() {
    super.initState();
    localSelectedRole = widget.selectedRole;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          key: const ValueKey('role'),
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                onPressed: widget.onBack,
                icon: const Icon(Icons.arrow_back_ios_new_rounded),
              ),
              const SizedBox(height: 8),
              const Text(
                'Escolha seu perfil',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Selecione como você vai usar o FitLife. Isso define o tipo de cadastro, os campos exibidos e o dashboard inicial.',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.black54,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 24),

              Expanded(
                child: ListView.separated(
                  itemCount: UserRole.values.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final role = UserRole.values[index];
                    final active = localSelectedRole == role;

                    return InkWell(
                      borderRadius: BorderRadius.circular(24),
                      onTap: () {
                        setState(() {
                          localSelectedRole = role;
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 220),
                        curve: Curves.easeOut,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: active
                              ? const Color(0xFFE6F6F4)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: active
                                ? const Color(0xFF0F766E)
                                : Colors.black12,
                            width: active ? 1.6 : 1,
                          ),
                          boxShadow: active
                              ? [
                                  const Color(0xFF0F766E).withValues(alpha: 0.08) != null
                                      ? BoxShadow(
                                          color: const Color(0xFF0F766E)
                                              .withValues(alpha: 0.08),
                                          blurRadius: 18,
                                          offset: const Offset(0, 8),
                                        )
                                      : const BoxShadow(),
                                ]
                              : [],
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: 28,
                              backgroundColor: const Color(0xFF0F766E),
                              child: Icon(role.icon, color: Colors.white),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          role.label,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                      if (active)
                                        const Icon(
                                          Icons.check_circle_rounded,
                                          color: Color(0xFF0F766E),
                                        ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    role.description,
                                    style: const TextStyle(
                                      color: Colors.black54,
                                      height: 1.4,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    children: _roleTags(role)
                                        .map(
                                          (tag) => Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 6,
                                            ),
                                            decoration: BoxDecoration(
                                              color: active
                                                  ? Colors.white
                                                  : const Color(0xFFF4F7F8),
                                              borderRadius:
                                                  BorderRadius.circular(999),
                                            ),
                                            child: Text(
                                              tag,
                                              style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        )
                                        .toList(),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 16),

              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: localSelectedRole == null
                      ? null
                      : () => widget.onSelect(localSelectedRole!),
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF0F766E),
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  icon: const Icon(Icons.arrow_forward_rounded),
                  label: const Text('Continuar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<String> _roleTags(UserRole role) {
    switch (role) {
      case UserRole.aluno:
        return ['Treinos', 'Metas', 'Evolução'];
      case UserRole.personal:
        return ['Alunos', 'Fichas', 'Acompanhamento'];
      case UserRole.nutricionista:
        return ['Dietas', 'Consultas', 'Hábitos'];
      case UserRole.academia:
        return ['Equipe', 'Planos', 'Gestão'];
    }
  }
}