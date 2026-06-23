import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../models/character_class.dart';
import '../providers/class_provider.dart';

class ClassDetailsScreen extends ConsumerWidget {
  const ClassDetailsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentClass = ref.watch(classProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Class & Perks'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Current Class Display
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: RPGTheme.paperBackground,
                border: Border.all(color: RPGTheme.graphiteDark, width: 3),
                boxShadow: [
                  BoxShadow(
                    color: RPGTheme.graphiteMedium.withOpacity(0.2),
                    offset: const Offset(4, 4),
                  )
                ],
              ),
              child: Column(
                children: [
                  Icon(
                    _getIconData(currentClass.iconName),
                    size: 80,
                    color: RPGTheme.graphiteDark,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    currentClass.name.toUpperCase(),
                    style: GoogleFonts.architectsDaughter(
                      color: RPGTheme.redPencil,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2.0,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    currentClass.description,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.patrickHand(
                      color: RPGTheme.graphiteDark,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            // Perks Section
            Text(
              'Active Perks',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            _buildPerkItem(
              icon: Icons.fitness_center,
              title: 'Dungeon (Strength) Multiplier',
              value: '${((currentClass.xpMultiplierDungeon - 1) * 100).toInt()}% Bonus XP',
              isActive: currentClass.xpMultiplierDungeon > 1.0,
            ),
            _buildPerkItem(
              icon: Icons.directions_run,
              title: 'Hero\'s March (Cardio) Multiplier',
              value: '${((currentClass.xpMultiplierHeroesMarch - 1) * 100).toInt()}% Bonus XP',
              isActive: currentClass.xpMultiplierHeroesMarch > 1.0,
            ),
            _buildPerkItem(
              icon: Icons.auto_awesome,
              title: 'General Activity Multiplier',
              value: '${((currentClass.xpMultiplierGeneral - 1) * 100).toInt()}% Bonus XP',
              isActive: currentClass.xpMultiplierGeneral > 1.0,
            ),
            
            const SizedBox(height: 32),
            // Explanation on how classes work
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: RPGTheme.graphiteLight, width: 1.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.info_outline, color: RPGTheme.graphiteDark),
                      const SizedBox(width: 8),
                      Text(
                        'How Classes Work',
                        style: GoogleFonts.architectsDaughter(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Your class is determined dynamically based on your workout habits and earned titles. Keep training in specific areas (e.g. Strength Training, Running) to unlock or maintain specialized classes like Warrior or Ranger!',
                    style: GoogleFonts.patrickHand(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        ref.read(classProvider.notifier).evaluateClass();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Class evaluation requested based on recent activity!')),
                        );
                      },
                      icon: const Icon(Icons.sync),
                      label: const Text('Evaluate Current Class'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: RPGTheme.graphiteDark,
                        side: const BorderSide(color: RPGTheme.graphiteDark, width: 2),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPerkItem({required IconData icon, required String title, required String value, required bool isActive}) {
    if (!isActive) return const SizedBox.shrink();
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: RPGTheme.paperBackground,
        border: Border.all(color: RPGTheme.graphiteDark, width: 1.5),
      ),
      child: Row(
        children: [
          Icon(icon, color: RPGTheme.graphiteDark, size: 28),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.architectsDaughter(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  value,
                  style: GoogleFonts.patrickHand(
                    color: RPGTheme.redPencil,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIconData(String name) {
    switch (name) {
      case 'fitness_center': return Icons.fitness_center;
      case 'directions_run': return Icons.directions_run;
      case 'self_improvement': return Icons.self_improvement;
      case 'person_outline':
      default:
        return Icons.person_outline;
    }
  }
}
