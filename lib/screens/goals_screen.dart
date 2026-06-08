import 'package:flutter/material.dart';
import '../models/app_user.dart';
import '../widgets/section_header.dart';

class GoalsScreen extends StatefulWidget {
  const GoalsScreen({super.key, required this.user});

  final AppUser user;

  @override
  State<GoalsScreen> createState() => _GoalsScreenState();
}

class _GoalsScreenState extends State<GoalsScreen> {
  late final List<GoalItem> goals;

  @override
  void initState() {
    super.initState();
    goals = _buildGoalsByUserGoal(widget.user.goal);
  }

  @override
  Widget build(BuildContext context) {
    final completedCount = goals.where((goal) => goal.done).length;
    final progress = goals.isEmpty ? 0.0 : completedCount / goals.length;

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const SectionHeader(
            title: 'Metas e evolução',
            subtitle: 'Acompanhe sua consistência semanal e seus objetivos principais.',
          ),
          const SizedBox(height: 18),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Progresso da semana',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(999),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 12,
                      backgroundColor: const Color(0xFFE5E7EB),
                      valueColor: const AlwaysStoppedAnimation(
                        Color(0xFF0F766E),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '${(progress * 100).round()}% das metas foram concluídas.',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '$completedCount de ${goals.length} metas concluídas no momento.',
                    style: const TextStyle(color: Colors.black54),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 18),

          Row(
            children: [
              Expanded(
                child: _infoCard(
                  title: 'Objetivo atual',
                  value: widget.user.goal,
                  icon: Icons.track_changes_rounded,
                  color: const Color(0xFF0F766E),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _infoCard(
                  title: 'Consistência',
                  value: _consistencyLabel(progress),
                  icon: Icons.local_fire_department_rounded,
                  color: const Color(0xFFF97316),
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Checklist da rotina',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 14),
                  ...goals.asMap().entries.map((entry) {
                    final index = entry.key;
                    final goal = entry.value;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: CheckboxListTile(
                        value: goal.done,
                        onChanged: (value) {
                          setState(() {
                            goals[index] = goal.copyWith(done: value ?? false);
                          });
                        },
                        controlAffinity: ListTileControlAffinity.leading,
                        activeColor: const Color(0xFF0F766E),
                        tileColor: const Color(0xFFF8FAFC),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        title: Text(
                          goal.title,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            decoration:
                                goal.done ? TextDecoration.lineThrough : null,
                            color: goal.done ? Colors.black45 : Colors.black87,
                          ),
                        ),
                        subtitle: Text(goal.subtitle),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),

          const SizedBox(height: 18),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Observação',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _feedbackByProgress(progress),
                    style: const TextStyle(
                      color: Colors.black54,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: color.withOpacity(.12),
              child: Icon(icon, color: color),
            ),
            const SizedBox(height: 18),
            Text(
              title,
              style: const TextStyle(
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<GoalItem> _buildGoalsByUserGoal(String goal) {
    final normalizedGoal = goal.toLowerCase();

    if (normalizedGoal.contains('hipertrof')) {
      return [
        GoalItem(
          title: 'Treinar 5x na semana',
          subtitle: 'Priorizar força e recuperação muscular.',
          done: true,
        ),
        GoalItem(
          title: 'Bater meta de proteína diária',
          subtitle: 'Distribuir proteína ao longo do dia.',
          done: true,
        ),
        GoalItem(
          title: 'Dormir pelo menos 8h',
          subtitle: 'Apoiar recuperação e crescimento muscular.',
          done: false,
        ),
        GoalItem(
          title: 'Atualizar medidas corporais',
          subtitle: 'Comparar evolução quinzenal.',
          done: false,
        ),
      ];
    }

    if (normalizedGoal.contains('emagrec')) {
      return [
        GoalItem(
          title: 'Manter treino 4x na semana',
          subtitle: 'Regularidade acima de intensidade isolada.',
          done: true,
        ),
        GoalItem(
          title: 'Beber 2L de água por dia',
          subtitle: 'Ajudar na saciedade e rotina saudável.',
          done: true,
        ),
        GoalItem(
          title: 'Evitar ultrapassar meta calórica',
          subtitle: 'Foco em consistência diária.',
          done: false,
        ),
        GoalItem(
          title: 'Registrar peso no fim da semana',
          subtitle: 'Acompanhar tendência com mais clareza.',
          done: false,
        ),
      ];
    }

    return [
      GoalItem(
        title: 'Treinar 4x na semana',
        subtitle: 'Criar regularidade na rotina.',
        done: true,
      ),
      GoalItem(
        title: 'Beber 2L de água',
        subtitle: 'Melhorar disposição ao longo do dia.',
        done: true,
      ),
      GoalItem(
        title: 'Dormir 8h por noite',
        subtitle: 'Apoiar recuperação e energia.',
        done: false,
      ),
      GoalItem(
        title: 'Atualizar medidas físicas',
        subtitle: 'Registrar evolução pessoal.',
        done: false,
      ),
    ];
  }

  String _consistencyLabel(double progress) {
    if (progress >= 0.75) return 'Alta';
    if (progress >= 0.5) return 'Boa';
    if (progress >= 0.25) return 'Moderada';
    return 'Baixa';
  }

  String _feedbackByProgress(double progress) {
    if (progress >= 0.75) {
      return 'Você está mantendo uma rotina forte e consistente. O próximo passo é sustentar esse ritmo e acompanhar sua evolução com registros frequentes.';
    }
    if (progress >= 0.5) {
      return 'Seu progresso está bom, mas ainda há espaço para consolidar hábitos. Pequenas ações diárias podem aumentar bastante sua consistência.';
    }
    return 'Seu foco agora deve ser simplificar a rotina e priorizar poucas metas por vez. Consistência vem antes de volume.';
  }
}

class GoalItem {
  final String title;
  final String subtitle;
  final bool done;

  GoalItem({
    required this.title,
    required this.subtitle,
    required this.done,
  });

  GoalItem copyWith({
    String? title,
    String? subtitle,
    bool? done,
  }) {
    return GoalItem(
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      done: done ?? this.done,
    );
  }
}