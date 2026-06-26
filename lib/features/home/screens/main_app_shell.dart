import 'package:flutter/material.dart';
import '../../heroes_march/screens/heroes_march_screen.dart';
import '../../dungeon/screens/dungeon_screen.dart';
import '../../daily_quests/screens/daily_quests_screen.dart';
import '../../avatar/screens/avatar_screen.dart';
import '../../boss_battles/ui/boss_battle_screen.dart';


class MainAppShell extends StatefulWidget {
  const MainAppShell({super.key});

  @override
  State<MainAppShell> createState() => _MainAppShellState();
}

class _MainAppShellState extends State<MainAppShell> {
  int _currentIndex = 0;

  // Lista corrigida com os construtores de cada tela
  final List<Widget> _screens = [
    const HeroesMarchScreen(),
    const DungeonScreen(),
    const DailyQuestsScreen(), // Adicionado parênteses
    const AvatarScreen(),      // Corrigido para o nome correto do arquivo 'avatar_screen.dart'
    const BossBattleScreen(),  // Caminho correto da pasta ui/
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_run),
            label: 'Marcha do Herói',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Masmorra',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'Missões',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Herói',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sports_martial_arts),
            label: 'Chefe',
          ),
        ],
      ),
    );
  }
}