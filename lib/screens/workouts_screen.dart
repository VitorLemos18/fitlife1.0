import 'package:flutter/material.dart';
import '../models/app_user.dart';
import '../widgets/section_header.dart';

class WorkoutsScreen extends StatefulWidget {
  const WorkoutsScreen({super.key, required this.user});

  final AppUser user;

  @override
  State<WorkoutsScreen> createState() => _WorkoutsScreenState();
}

class _WorkoutsScreenState extends State<WorkoutsScreen> {
  String selectedFilter = 'Hoje';

  late List<WorkoutItem> workouts;

  @override
  void initState() {
    super.initState();
    workouts = _buildWorkoutsByRole(widget.user);
  }

  @override
  Widget build(BuildContext context) {
    final filteredWorkouts = workouts.where((workout) {
      switch (selectedFilter) {
        case 'Hoje':
          return workout.period == WorkoutPeriod.today;
        case 'Semana':
          return workout.period == WorkoutPeriod.week;
        case 'Favoritos':
          return workout.isFavorite;
        default:
          return true;
      }
    }).toList();

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const SectionHeader(
            title: 'Treinos',
            subtitle: 'Planejamento interativo com filtros, favoritos e ações rápidas.',
          ),
          const SizedBox(height: 18),

          _buildSummaryCard(),
          const SizedBox(height: 18),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildFilterChip('Hoje'),
              _buildFilterChip('Semana'),
              _buildFilterChip('Favoritos'),
            ],
          ),

          const SizedBox(height: 18),

          if (filteredWorkouts.isEmpty)
            _buildEmptyState()
          else
            ...filteredWorkouts.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final originalIndex = workouts.indexOf(item);

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _WorkoutCard(
                  item: item,
                  onToggleFavorite: () {
                    setState(() {
                      workouts[originalIndex] = item.copyWith(
                        isFavorite: !item.isFavorite,
                      );
                    });
                  },
                  onToggleDone: () {
                    setState(() {
                      workouts[originalIndex] = item.copyWith(
                        isDone: !item.isDone,
                      );
                    });
                  },
                  onDetails: () {
                    _showWorkoutDetails(item);
                  },
                ),
              );
            }),
        ],
      ),
    );
  }

  Widget _buildSummaryCard() {
    final doneCount = workouts.where((w) => w.isDone).length;
    final favoriteCount = workouts.where((w) => w.isFavorite).length;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Expanded(
              child: _summaryItem(
                icon: Icons.fitness_center_rounded,
                label: 'Treinos',
                value: '${workouts.length}',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _summaryItem(
                icon: Icons.check_circle_rounded,
                label: 'Concluídos',
                value: '$doneCount',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _summaryItem(
                icon: Icons.favorite_rounded,
                label: 'Favoritos',
                value: '$favoriteCount',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _summaryItem({
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
        children: [
          Icon(icon, color: const Color(0xFF0F766E)),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.black54,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    final selected = selectedFilter == label;

    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) {
        setState(() {
          selectedFilter = label;
        });
      },
      selectedColor: const Color(0xFFE6F6F4),
      labelStyle: TextStyle(
        color: selected ? const Color(0xFF0F766E) : Colors.black87,
        fontWeight: FontWeight.w700,
      ),
      side: BorderSide(
        color: selected ? const Color(0xFF0F766E) : Colors.black12,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(999),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          children: const [
            Icon(
              Icons.search_off_rounded,
              size: 42,
              color: Colors.black38,
            ),
            SizedBox(height: 12),
            Text(
              'Nenhum treino encontrado',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Tente alterar o filtro para visualizar outros treinos disponíveis.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black54,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showWorkoutDetails(WorkoutItem item) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                item.description,
                style: const TextStyle(
                  color: Colors.black54,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 16),
              _detailLine('Duração', item.duration),
              _detailLine('Intensidade', item.intensity),
              _detailLine('Exercícios', item.exercises),
              _detailLine(
                'Status',
                item.isDone ? 'Concluído' : 'Pendente',
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.check_rounded),
                  label: const Text('Fechar detalhes'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _detailLine(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          SizedBox(
            width: 90,
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.black54,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }

  List<WorkoutItem> _buildWorkoutsByRole(AppUser user) {
    switch (user.role) {
      case UserRole.aluno:
        return [
          WorkoutItem(
            title: 'Peito e tríceps',
            description: 'Treino focado em força de empurrão e estabilidade.',
            duration: '45 min',
            intensity: 'Intermediário',
            exercises: '8 exercícios',
            period: WorkoutPeriod.today,
          ),
          WorkoutItem(
            title: 'Pernas completas',
            description: 'Sessão com foco em força, resistência e volume.',
            duration: '60 min',
            intensity: 'Alta',
            exercises: '10 exercícios',
            period: WorkoutPeriod.week,
            isFavorite: true,
          ),
          WorkoutItem(
            title: 'Costas e bíceps',
            description: 'Treino progressivo para dorsais e puxadas.',
            duration: '50 min',
            intensity: 'Progressivo',
            exercises: '7 exercícios',
            period: WorkoutPeriod.week,
          ),
          WorkoutItem(
            title: 'Mobilidade e core',
            description: 'Sessão leve para recuperação e estabilidade central.',
            duration: '30 min',
            intensity: 'Recuperação',
            exercises: '6 exercícios',
            period: WorkoutPeriod.today,
          ),
        ];

      case UserRole.personal:
        return [
          WorkoutItem(
            title: 'Treino aluno • João',
            description: 'Ficha A com progressão de carga.',
            duration: '50 min',
            intensity: 'Moderada',
            exercises: '9 exercícios',
            period: WorkoutPeriod.today,
          ),
          WorkoutItem(
            title: 'Treino aluno • Marina',
            description: 'Ênfase em inferiores e mobilidade.',
            duration: '55 min',
            intensity: 'Alta',
            exercises: '8 exercícios',
            period: WorkoutPeriod.week,
            isFavorite: true,
          ),
          WorkoutItem(
            title: 'Revisão de ficha • Carlos',
            description: 'Ajuste de volume e intervalo de descanso.',
            duration: '25 min',
            intensity: 'Técnica',
            exercises: '5 exercícios',
            period: WorkoutPeriod.today,
          ),
        ];

      case UserRole.nutricionista:
        return [
          WorkoutItem(
            title: 'Rotina associada • Paciente Ana',
            description: 'Treino leve alinhado ao plano nutricional.',
            duration: '35 min',
            intensity: 'Leve',
            exercises: '5 exercícios',
            period: WorkoutPeriod.today,
          ),
          WorkoutItem(
            title: 'Checklist de rotina ativa',
            description: 'Acompanhamento de adesão ao plano semanal.',
            duration: '20 min',
            intensity: 'Monitoramento',
            exercises: '4 ações',
            period: WorkoutPeriod.week,
            isFavorite: true,
          ),
        ];

      case UserRole.academia:
        return [
          WorkoutItem(
            title: 'Grade funcional da manhã',
            description: 'Aula coletiva com circuito de condicionamento.',
            duration: '40 min',
            intensity: 'Moderada',
            exercises: '6 estações',
            period: WorkoutPeriod.today,
          ),
          WorkoutItem(
            title: 'Agenda de musculação',
            description: 'Distribuição de treinos da unidade no dia.',
            duration: 'Dia inteiro',
            intensity: 'Operacional',
            exercises: '12 blocos',
            period: WorkoutPeriod.week,
            isFavorite: true,
          ),
        ];
    }
  }
}

class _WorkoutCard extends StatelessWidget {
  const _WorkoutCard({
    required this.item,
    required this.onToggleFavorite,
    required this.onToggleDone,
    required this.onDetails,
  });

  final WorkoutItem item;
  final VoidCallback onToggleFavorite;
  final VoidCallback onToggleDone;
  final VoidCallback onDetails;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundColor: const Color(0xFFE6F6F4),
                  child: Icon(
                    Icons.fitness_center_rounded,
                    color: const Color(0xFF0F766E),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${item.duration} • ${item.intensity}',
                        style: const TextStyle(
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: onToggleFavorite,
                  icon: Icon(
                    item.isFavorite
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_rounded,
                    color: item.isFavorite
                        ? Colors.redAccent
                        : Colors.black45,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              item.description,
              style: const TextStyle(
                color: Colors.black54,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _tag(item.exercises),
                _tag(item.period == WorkoutPeriod.today ? 'Hoje' : 'Semana'),
                _tag(item.isDone ? 'Concluído' : 'Pendente'),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onDetails,
                    icon: const Icon(Icons.visibility_rounded),
                    label: const Text('Detalhes'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: onToggleDone,
                    icon: Icon(
                      item.isDone
                          ? Icons.check_circle_rounded
                          : Icons.play_arrow_rounded,
                    ),
                    label: Text(item.isDone ? 'Concluído' : 'Marcar'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _tag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F7F8),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

enum WorkoutPeriod { today, week }

class WorkoutItem {
  final String title;
  final String description;
  final String duration;
  final String intensity;
  final String exercises;
  final WorkoutPeriod period;
  final bool isFavorite;
  final bool isDone;

  WorkoutItem({
    required this.title,
    required this.description,
    required this.duration,
    required this.intensity,
    required this.exercises,
    required this.period,
    this.isFavorite = false,
    this.isDone = false,
  });

  WorkoutItem copyWith({
    String? title,
    String? description,
    String? duration,
    String? intensity,
    String? exercises,
    WorkoutPeriod? period,
    bool? isFavorite,
    bool? isDone,
  }) {
    return WorkoutItem(
      title: title ?? this.title,
      description: description ?? this.description,
      duration: duration ?? this.duration,
      intensity: intensity ?? this.intensity,
      exercises: exercises ?? this.exercises,
      period: period ?? this.period,
      isFavorite: isFavorite ?? this.isFavorite,
      isDone: isDone ?? this.isDone,
    );
  }
}