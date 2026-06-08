import 'package:flutter/material.dart';
import '../models/app_user.dart';
import 'dashboard_screen.dart';
import 'goals_screen.dart';
import 'nutrition_screen.dart';
import 'profile_screen.dart';
import 'workouts_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({
    super.key,
    required this.user,
    required this.onLogout,
  });

  final AppUser user;
  final VoidCallback onLogout;

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int currentIndex = 0;

  late final List<Widget> screens = [
    DashboardScreen(user: widget.user),
    WorkoutsScreen(user: widget.user),
    NutritionScreen(user: widget.user),
    GoalsScreen(user: widget.user),
    ProfileScreen(
      user: widget.user,
      onLogout: _confirmLogout,
    ),
  ];

  String get _currentTitle {
    switch (currentIndex) {
      case 0:
        return 'Início';
      case 1:
        return 'Treinos';
      case 2:
        return 'Plano alimentar';
      case 3:
        return 'Metas';
      case 4:
        return 'Perfil';
      default:
        return 'FitLife';
    }
  }

  Future<void> _confirmLogout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Sair da conta'),
          content: const Text(
            'Tem certeza que deseja encerrar sua sessão agora?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Sair'),
            ),
          ],
        );
      },
    );

    if (!mounted) return;

    if (confirm == true) {
      widget.onLogout();
    }
  }

  void _onDestinationSelected(int index) {
    if (index == currentIndex) return;

    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_currentTitle),
        centerTitle: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFE6F6F4),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  widget.user.role.label,
                  style: const TextStyle(
                    color: Color(0xFF0F766E),
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: IndexedStack(
        index: currentIndex,
        children: screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: _onDestinationSelected,
        height: 74,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.fitness_center_rounded),
            label: 'Treinos',
          ),
          NavigationDestination(
            icon: Icon(Icons.restaurant_rounded),
            label: 'Plano',
          ),
          NavigationDestination(
            icon: Icon(Icons.flag_rounded),
            label: 'Metas',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_rounded),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}