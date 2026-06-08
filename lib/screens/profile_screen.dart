import 'package:flutter/material.dart';
import '../models/app_user.dart';
import '../widgets/info_row.dart';
import '../widgets/section_header.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({
    super.key,
    required this.user,
    required this.onLogout,
  });

  final AppUser user;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    final extraLabels = _extraLabels(user.role);
    final age = _calculateAge(user.birthDate);

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const SectionHeader(
            title: 'Perfil',
            subtitle: 'Resumo da conta com informações organizadas por tipo de usuário.',
          ),
          const SizedBox(height: 18),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 42,
                    backgroundColor: const Color(0xFF0F766E),
                    child: Icon(
                      user.role.icon,
                      size: 36,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    user.name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user.email,
                    style: const TextStyle(color: Colors.black54),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE6F6F4),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      user.role.label,
                      style: const TextStyle(
                        color: Color(0xFF0F766E),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 18),

          _sectionCard(
            title: 'Informações principais',
            children: [
              InfoRow(label: 'Telefone', value: _safeValue(user.phone)),
              InfoRow(label: 'Objetivo', value: _safeValue(user.goal)),
              InfoRow(
                label: 'Data de nascimento',
                value: _formatBirthDate(user.birthDate),
              ),
              InfoRow(
                label: 'Idade',
                value: age != null ? '$age anos' : '-',
              ),
              InfoRow(
                label: 'Peso',
                value: user.weight > 0
                    ? '${user.weight.toStringAsFixed(1)} kg'
                    : '-',
              ),
              InfoRow(
                label: 'Altura',
                value: user.height > 0
                    ? '${user.height.toStringAsFixed(2)} m'
                    : '-',
              ),
              InfoRow(
                label: 'IMC',
                value: user.imc != null
                    ? user.imc!.toStringAsFixed(1)
                    : '-',
              ),
            ],
          ),

          const SizedBox(height: 18),

          _sectionCard(
            title: 'Detalhes do perfil',
            children: [
              InfoRow(
                label: extraLabels.$1,
                value: _safeValue(user.extra1),
              ),
              InfoRow(
                label: extraLabels.$2,
                value: _safeValue(user.extra2),
              ),
              InfoRow(
                label: extraLabels.$3,
                value: _safeValue(user.extra3),
              ),
            ],
          ),

          const SizedBox(height: 18),

          _sectionCard(
            title: 'Ações da conta',
            children: [
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Edição de perfil será a próxima etapa.'),
                      ),
                    );
                  },
                  icon: const Icon(Icons.edit_rounded),
                  label: const Text('Editar perfil'),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: onLogout,
                  icon: const Icon(Icons.logout_rounded),
                  label: const Text('Sair da conta'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _sectionCard({
    required String title,
    required List<Widget> children,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 14),
            ...children,
          ],
        ),
      ),
    );
  }

  (String, String, String) _extraLabels(UserRole role) {
    switch (role) {
      case UserRole.aluno:
        return (
          'Nível de treino',
          'Restrições físicas',
          'Disponibilidade semanal',
        );
      case UserRole.personal:
        return (
          'Especialidade',
          'Tempo de experiência',
          'Quantidade de alunos',
        );
      case UserRole.nutricionista:
        return (
          'Abordagem nutricional',
          'Área de atuação',
          'Formato de atendimento',
        );
      case UserRole.academia:
        return (
          'Nome da unidade',
          'Capacidade de alunos',
          'Cidade / bairro',
        );
    }
  }

  String _safeValue(String value) {
    final clean = value.trim();
    return clean.isEmpty ? '-' : clean;
  }

  String _formatBirthDate(DateTime? date) {
    if (date == null) return '-';

    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();

    return '$day/$month/$year';
  }

  int? _calculateAge(DateTime? birthDate) {
    if (birthDate == null) return null;

    final today = DateTime.now();
    int age = today.year - birthDate.year;

    final hasNotHadBirthdayYet =
        today.month < birthDate.month ||
        (today.month == birthDate.month && today.day < birthDate.day);

    if (hasNotHadBirthdayYet) {
      age--;
    }

    return age >= 0 ? age : null;
  }
}