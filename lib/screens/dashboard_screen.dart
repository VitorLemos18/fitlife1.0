import 'package:flutter/material.dart';
import '../models/app_user.dart';
import '../widgets/metric_card.dart';
import '../widgets/shortcut_tile.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key, required this.user});

  final AppUser user;

  @override
  Widget build(BuildContext context) {
    final metrics = _buildMetrics(user);
    final shortcuts = _buildShortcuts(user);
    final firstName = _firstName(user.name);

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
        children: [
          _buildHeader(context, firstName),
          const SizedBox(height: 20),
          _buildHeroCard(context),
          const SizedBox(height: 20),
          _buildTodayPanel(),
          const SizedBox(height: 20),
          _buildMetricsSection(metrics),
          const SizedBox(height: 20),
          _buildQuickActionsSection(context, shortcuts),
          const SizedBox(height: 20),
          _buildProgressSection(),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, String firstName) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Olá, $firstName',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Painel personalizado para ${user.role.label.toLowerCase()}.',
                style: const TextStyle(
                  color: Colors.black54,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
        Row(
          children: [
            _circleAction(
              icon: Icons.search_rounded,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Busca em breve.')),
                );
              },
            ),
            const SizedBox(width: 10),
            _circleAction(
              icon: Icons.notifications_none_rounded,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Notificações em breve.')),
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildHeroCard(BuildContext context) {
    final age = _calculateAge(user.birthDate);

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF0F766E),
            Color(0xFF115E59),
          ],
        ),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            user.goal.isEmpty ? 'Seu objetivo principal' : user.goal,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w800,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _roleHighlightMessage(user),
            style: const TextStyle(
              color: Colors.white70,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 18),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              if (user.weight > 0)
                _pill('Peso ${user.weight.toStringAsFixed(1)} kg'),
              if (user.height > 0)
                _pill('Altura ${user.height.toStringAsFixed(2)} m'),
              if (age != null)
                _pill('Idade $age anos'),
              if (user.imc != null)
                _pill('IMC ${user.imc!.toStringAsFixed(1)}'),
              _pill(user.role.label),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(_primaryActionMessage())),
                    );
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF0F766E),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  icon: const Icon(Icons.play_arrow_rounded),
                  label: Text(_primaryActionLabel()),
                ),
              ),
              const SizedBox(width: 10),
              OutlinedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Resumo expandido em breve.')),
                  );
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Colors.white30),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
                child: const Text('Resumo'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTodayPanel() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Hoje',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _todayMessage(),
              style: const TextStyle(
                color: Colors.black54,
                height: 1.45,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _miniPanel(
                    icon: Icons.track_changes_rounded,
                    label: 'Foco',
                    value: _focusLabel(),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _miniPanel(
                    icon: Icons.auto_graph_rounded,
                    label: 'Status',
                    value: _statusLabel(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricsSection(List<_DashboardMetric> metrics) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Visão geral',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 12),
        LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final crossAxisCount = width >= 950
                ? 4
                : width >= 650
                    ? 3
                    : 2;

            final childAspectRatio = width >= 950
                ? 1.35
                : width >= 650
                    ? 1.18
                    : 1.02;

            return GridView.builder(
              itemCount: metrics.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: childAspectRatio,
              ),
              itemBuilder: (context, index) {
                final item = metrics[index];
                return InkWell(
                  borderRadius: BorderRadius.circular(24),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${item.title}: ${item.value}')),
                    );
                  },
                  child: MetricCard(
                    title: item.title,
                    value: item.value,
                    subtitle: item.subtitle,
                    icon: item.icon,
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildQuickActionsSection(
    BuildContext context,
    List<_DashboardShortcut> shortcuts,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Atalhos rápidos',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 12),
        ...shortcuts.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: InkWell(
              borderRadius: BorderRadius.circular(22),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${item.title} em breve.')),
                );
              },
              child: ShortcutTile(
                icon: item.icon,
                title: item.title,
                subtitle: item.subtitle,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProgressSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Resumo de progresso',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _progressMessage(),
              style: const TextStyle(
                color: Colors.black54,
                height: 1.45,
              ),
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: LinearProgressIndicator(
                minHeight: 10,
                value: _progressValue(),
                backgroundColor: const Color(0xFFE5E7EB),
                valueColor: const AlwaysStoppedAnimation(Color(0xFF0F766E)),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              '${(_progressValue() * 100).round()}% do foco atual concluído',
              style: const TextStyle(
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _miniPanel({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F7F8),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFF0F766E)),
          const SizedBox(height: 10),
          Text(
            label,
            style: const TextStyle(
              color: Colors.black54,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _circleAction({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: SizedBox(
          width: 46,
          height: 46,
          child: Icon(
            icon,
            color: const Color(0xFF0F766E),
          ),
        ),
      ),
    );
  }

  Widget _pill(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.14),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  String _firstName(String fullName) {
    final clean = fullName.trim();
    if (clean.isEmpty) return 'usuário';
    return clean.split(' ').first;
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

  String _primaryActionLabel() {
    switch (user.role) {
      case UserRole.aluno:
        return 'Continuar rotina';
      case UserRole.personal:
        return 'Abrir agenda';
      case UserRole.nutricionista:
        return 'Ver pacientes';
      case UserRole.academia:
        return 'Abrir gestão';
    }
  }

  String _primaryActionMessage() {
    switch (user.role) {
      case UserRole.aluno:
        return 'Abrindo sua rotina do dia.';
      case UserRole.personal:
        return 'Abrindo agenda e acompanhamentos.';
      case UserRole.nutricionista:
        return 'Abrindo painel de pacientes.';
      case UserRole.academia:
        return 'Abrindo gestão da unidade.';
    }
  }

  String _todayMessage() {
    switch (user.role) {
      case UserRole.aluno:
        return 'Seu foco de hoje é manter consistência no treino, alimentação e registro da evolução.';
      case UserRole.personal:
        return 'Priorize alunos com ficha pendente, sessões do dia e acompanhamento rápido.';
      case UserRole.nutricionista:
        return 'Revise consultas, adesão aos planos e ajustes nutricionais necessários.';
      case UserRole.academia:
        return 'Acompanhe check-ins, movimentação da equipe e operação da unidade.';
    }
  }

  String _focusLabel() {
    switch (user.role) {
      case UserRole.aluno:
        return 'Execução';
      case UserRole.personal:
        return 'Acompanhamento';
      case UserRole.nutricionista:
        return 'Planejamento';
      case UserRole.academia:
        return 'Operação';
    }
  }

  String _statusLabel() {
    switch (user.role) {
      case UserRole.aluno:
        return 'Em progresso';
      case UserRole.personal:
        return 'Agenda ativa';
      case UserRole.nutricionista:
        return 'Consultas abertas';
      case UserRole.academia:
        return 'Fluxo estável';
    }
  }

  double _progressValue() {
    switch (user.role) {
      case UserRole.aluno:
        return 0.76;
      case UserRole.personal:
        return 0.68;
      case UserRole.nutricionista:
        return 0.72;
      case UserRole.academia:
        return 0.81;
    }
  }

  List<_DashboardMetric> _buildMetrics(AppUser user) {
    switch (user.role) {
      case UserRole.aluno:
        return const [
          _DashboardMetric(
            title: 'Treinos',
            value: '18',
            subtitle: 'no mês',
            icon: Icons.bolt_rounded,
          ),
          _DashboardMetric(
            title: 'Metas',
            value: '76%',
            subtitle: 'concluídas',
            icon: Icons.flag_rounded,
          ),
          _DashboardMetric(
            title: 'Check-ins',
            value: '12',
            subtitle: 'esta semana',
            icon: Icons.calendar_month_rounded,
          ),
          _DashboardMetric(
            title: 'Rotina',
            value: 'Alta',
            subtitle: 'consistência',
            icon: Icons.local_fire_department_rounded,
          ),
        ];

      case UserRole.personal:
        return const [
          _DashboardMetric(
            title: 'Alunos',
            value: '24',
            subtitle: 'ativos',
            icon: Icons.groups_rounded,
          ),
          _DashboardMetric(
            title: 'Treinos',
            value: '14',
            subtitle: 'atualizados',
            icon: Icons.fitness_center_rounded,
          ),
          _DashboardMetric(
            title: 'Avaliações',
            value: '8',
            subtitle: 'na semana',
            icon: Icons.assignment_rounded,
          ),
          _DashboardMetric(
            title: 'Agenda',
            value: 'Cheia',
            subtitle: 'hoje',
            icon: Icons.event_available_rounded,
          ),
        ];

      case UserRole.nutricionista:
        return const [
          _DashboardMetric(
            title: 'Pacientes',
            value: '31',
            subtitle: 'em acompanhamento',
            icon: Icons.groups_2_rounded,
          ),
          _DashboardMetric(
            title: 'Planos',
            value: '11',
            subtitle: 'revisados',
            icon: Icons.restaurant_menu_rounded,
          ),
          _DashboardMetric(
            title: 'Consultas',
            value: '6',
            subtitle: 'hoje',
            icon: Icons.medical_services_rounded,
          ),
          _DashboardMetric(
            title: 'Adesão',
            value: 'Boa',
            subtitle: 'na semana',
            icon: Icons.insights_rounded,
          ),
        ];

      case UserRole.academia:
        return const [
          _DashboardMetric(
            title: 'Unidade',
            value: '124',
            subtitle: 'alunos ativos',
            icon: Icons.apartment_rounded,
          ),
          _DashboardMetric(
            title: 'Equipe',
            value: '9',
            subtitle: 'profissionais',
            icon: Icons.badge_rounded,
          ),
          _DashboardMetric(
            title: 'Check-ins',
            value: '87',
            subtitle: 'no dia',
            icon: Icons.qr_code_scanner_rounded,
          ),
          _DashboardMetric(
            title: 'Ocupação',
            value: '78%',
            subtitle: 'média',
            icon: Icons.bar_chart_rounded,
          ),
        ];
    }
  }

  List<_DashboardShortcut> _buildShortcuts(AppUser user) {
    switch (user.role) {
      case UserRole.aluno:
        return const [
          _DashboardShortcut(
            icon: Icons.add_chart_rounded,
            title: 'Registrar progresso',
            subtitle: 'Atualize peso, medidas e evolução.',
          ),
          _DashboardShortcut(
            icon: Icons.assignment_rounded,
            title: 'Plano da semana',
            subtitle: 'Veja tarefas, alimentação e treino.',
          ),
          _DashboardShortcut(
            icon: Icons.person_rounded,
            title: 'Meu perfil',
            subtitle: 'Revise dados e preferências pessoais.',
          ),
        ];

      case UserRole.personal:
        return const [
          _DashboardShortcut(
            icon: Icons.group_add_rounded,
            title: 'Adicionar aluno',
            subtitle: 'Cadastre um novo acompanhamento.',
          ),
          _DashboardShortcut(
            icon: Icons.edit_note_rounded,
            title: 'Atualizar ficha',
            subtitle: 'Revise treinos e observações.',
          ),
          _DashboardShortcut(
            icon: Icons.calendar_today_rounded,
            title: 'Agenda do dia',
            subtitle: 'Veja sessões e horários confirmados.',
          ),
        ];

      case UserRole.nutricionista:
        return const [
          _DashboardShortcut(
            icon: Icons.post_add_rounded,
            title: 'Novo plano alimentar',
            subtitle: 'Monte uma nova estratégia nutricional.',
          ),
          _DashboardShortcut(
            icon: Icons.history_edu_rounded,
            title: 'Evolução dos pacientes',
            subtitle: 'Acompanhe adesão e ajustes recentes.',
          ),
          _DashboardShortcut(
            icon: Icons.video_call_rounded,
            title: 'Consultas',
            subtitle: 'Organize atendimentos do dia.',
          ),
        ];

      case UserRole.academia:
        return const [
          _DashboardShortcut(
            icon: Icons.person_add_alt_1_rounded,
            title: 'Novo cadastro',
            subtitle: 'Adicione alunos ou profissionais.',
          ),
          _DashboardShortcut(
            icon: Icons.analytics_rounded,
            title: 'Indicadores da unidade',
            subtitle: 'Veja desempenho e operação.',
          ),
          _DashboardShortcut(
            icon: Icons.manage_accounts_rounded,
            title: 'Gerenciar equipe',
            subtitle: 'Controle perfis e acessos.',
          ),
        ];
    }
  }

  String _roleHighlightMessage(AppUser user) {
    switch (user.role) {
      case UserRole.aluno:
        return 'Seu fluxo prioriza progresso, metas e acompanhamento da rotina de treino e alimentação.';
      case UserRole.personal:
        return 'Seu painel destaca alunos, fichas e agenda para facilitar o acompanhamento diário.';
      case UserRole.nutricionista:
        return 'Seu painel foi organizado para acompanhar pacientes, planos e evolução alimentar.';
      case UserRole.academia:
        return 'Seu fluxo centraliza gestão da unidade, equipe, operação e visão geral da academia.';
    }
  }

  String _progressMessage() {
    switch (user.role) {
      case UserRole.aluno:
        return 'Você está mantendo uma boa frequência e evolução nas metas principais.';
      case UserRole.personal:
        return 'Seu acompanhamento semanal está consistente e com boa organização da agenda.';
      case UserRole.nutricionista:
        return 'Os atendimentos e revisões estão avançando dentro do ritmo planejado.';
      case UserRole.academia:
        return 'A operação da unidade segue estável com boa ocupação e controle da equipe.';
    }
  }
}

class _DashboardMetric {
  const _DashboardMetric({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
  });

  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
}

class _DashboardShortcut {
  const _DashboardShortcut({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;
}