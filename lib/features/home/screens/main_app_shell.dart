import 'package:flutter/material.dart';
import '../../avatar/screens/avatar_screen.dart';
import '../../dungeon/screens/dungeon_screen.dart';
import '../../heroes_march/screens/heroes_march_screen.dart';

import '../../daily_quests/screens/daily_quests_screen.dart';

class MainAppShell extends StatefulWidget {
  const MainAppShell({super.key});

  @override
  State<MainAppShell> createState() => _MainAppShellState();
}

class _MainAppShellState extends State<MainAppShell> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HeroesMarchScreen(),
    const DungeonScreen(),
    const DailyQuestsScreen(),
    const AvatarScreen(),
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
            label: 'Hero\'s March',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Dungeon',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'Quests',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Avatar',
          ),
        ],
      ),
    );
  }
}
