import 'package:flutter/material.dart';
import '../models/app_user.dart';
import '../widgets/detail_card.dart';
import '../widgets/section_header.dart';

class NutritionScreen extends StatelessWidget {
  const NutritionScreen({super.key, required this.user});

  final AppUser user;

  @override
  Widget build(BuildContext context) {
    final effectiveGoal = _effectiveGoal(user.goal);
    final meals = _mealsByGoal(effectiveGoal);
    final dailyCalories = _dailyCalories(effectiveGoal);
    final focusMessage = _focusMessage(effectiveGoal);

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const SectionHeader(
            title: 'Plano alimentar',
            subtitle: 'Refeições, calorias e direcionamento conforme seu objetivo.',
          ),
          const SizedBox(height: 18),

          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF7ED),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(
                  backgroundColor: Color(0xFFF97316),
                  child: Icon(
                    Icons.local_dining_rounded,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Plano do dia',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        focusMessage,
                        style: const TextStyle(
                          color: Colors.black54,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          Row(
            children: [
              Expanded(
                child: _summaryCard(
                  title: 'Meta calórica',
                  value: '$dailyCalories kcal',
                  icon: Icons.local_fire_department_rounded,
                  color: const Color(0xFFFB923C),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _summaryCard(
                  title: 'Refeições',
                  value: '${meals.length}',
                  icon: Icons.restaurant_menu_rounded,
                  color: const Color(0xFF0F766E),
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Direção nutricional',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Objetivo atual: $effectiveGoal',
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Perfil ativo: ${user.role.label}',
                    style: const TextStyle(color: Colors.black54),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Essa área pode evoluir para dieta por dia, horário, substituições e observações profissionais.',
                    style: TextStyle(color: Colors.black54, height: 1.4),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 18),

          ...meals.map(
            (meal) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: DetailCard(
                icon: Icons.restaurant_menu_rounded,
                title: meal.$1,
                subtitle: meal.$2,
                trailing: meal.$3,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryCard({
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
              backgroundColor: color.withAlpha(30),
              child: Icon(icon, color: color),
            ),
            const SizedBox(height: 18),
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }

  String _effectiveGoal(String goal) {
    final clean = goal.trim();
    if (clean.isEmpty) {
      return 'Saúde e rotina';
    }
    return clean;
  }

  List<(String, String, String)> _mealsByGoal(String goal) {
    final normalizedGoal = goal.toLowerCase();

    if (normalizedGoal.contains('hipertrof') ||
        normalizedGoal.contains('massa') ||
        normalizedGoal.contains('ganhar')) {
      return [
        ('Café da manhã', 'Ovos, aveia, banana e pasta de amendoim', '520 kcal'),
        ('Almoço', 'Arroz, feijão, carne magra e legumes', '760 kcal'),
        ('Pré-treino', 'Iogurte, fruta e granola', '280 kcal'),
        ('Jantar', 'Frango, batata-doce e salada', '610 kcal'),
      ];
    }

    if (normalizedGoal.contains('emagrec') ||
        normalizedGoal.contains('perder') ||
        normalizedGoal.contains('defini')) {
      return [
        ('Café da manhã', 'Omelete com fruta e café sem açúcar', '320 kcal'),
        ('Almoço', 'Frango grelhado, arroz integral e salada', '480 kcal'),
        ('Lanche', 'Iogurte natural com chia', '180 kcal'),
        ('Jantar', 'Sopa de legumes com proteína magra', '350 kcal'),
      ];
    }

    return [
      ('Café da manhã', 'Ovos, tapioca e fruta', '420 kcal'),
      ('Almoço', 'Arroz, feijão, frango e salada', '640 kcal'),
      ('Lanche', 'Iogurte + castanhas', '210 kcal'),
      ('Jantar', 'Sopa proteica com legumes', '350 kcal'),
    ];
  }

  int _dailyCalories(String goal) {
    final normalizedGoal = goal.toLowerCase();

    if (normalizedGoal.contains('hipertrof') ||
        normalizedGoal.contains('massa') ||
        normalizedGoal.contains('ganhar')) {
      return 2800;
    }

    if (normalizedGoal.contains('emagrec') ||
        normalizedGoal.contains('perder') ||
        normalizedGoal.contains('defini')) {
      return 1800;
    }

    return 2200;
  }

  String _focusMessage(String goal) {
    final normalizedGoal = goal.toLowerCase();

    if (normalizedGoal.contains('hipertrof') ||
        normalizedGoal.contains('massa') ||
        normalizedGoal.contains('ganhar')) {
      return 'Seu plano prioriza aporte energético maior, proteína distribuída ao longo do dia e refeições estratégicas para melhor recuperação.';
    }

    if (normalizedGoal.contains('emagrec') ||
        normalizedGoal.contains('perder') ||
        normalizedGoal.contains('defini')) {
      return 'Seu plano prioriza saciedade, controle calórico e refeições mais equilibradas para sustentar consistência durante a rotina.';
    }

    return 'Seu plano está organizado para manter regularidade, equilíbrio nutricional e uma rotina alimentar mais fácil de seguir.';
  }
}