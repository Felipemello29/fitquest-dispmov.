import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../core/models/user_profile.dart';
import '../../../core/models/title_model.dart';
import '../../../core/services/leveling_service.dart';
import '../../../core/theme/app_theme.dart';
import '../../achievements/screens/achievements_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../auth/providers/auth_provider.dart';
import '../../classes/providers/class_provider.dart';
import '../../classes/screens/class_details_screen.dart';

class AvatarScreen extends ConsumerWidget {
  const AvatarScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authUser = ref.watch(authProvider);
    final currentClass = ref.watch(classProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Character Sheet'),
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<UserProfile>('userProfileBox').listenable(),
        builder: (context, Box<UserProfile> box, _) {
          final userProfile = box.get(0) ?? UserProfile();
          final currentLevel = LevelingService.calculateLevel(userProfile.evolutionPoints);
          final progress = LevelingService.getProgressToNextLevel(userProfile.evolutionPoints);
          final xpForCurrent = LevelingService.getXpForCurrentLevel(userProfile.evolutionPoints);
          final xpRequired = LevelingService.getXpRequiredForNextLevel(userProfile.evolutionPoints);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                // Sketchy Avatar Portrait
                Container(
                  width: 160,
                  height: 160,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: RPGTheme.graphiteDark,
                      width: 2,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: RPGTheme.graphiteMedium,
                          width: 1,
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          _getIconData(currentClass.iconName),
                          size: 80,
                          color: RPGTheme.graphiteDark,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                
                // Name & Class sketch
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Text(
                      '___________________________',
                      style: TextStyle(color: RPGTheme.graphiteLight, fontSize: 20),
                    ),
                    Column(
                      children: [
                        GestureDetector(
                          onTap: () => _showTitleSelection(context, userProfile, Hive.box<TitleModel>('titlesBox')),
                          child: Text(
                            _getSelectedTitleName(userProfile, Hive.box<TitleModel>('titlesBox')),
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              decoration: TextDecoration.underline,
                              decorationStyle: TextDecorationStyle.dotted,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const ClassDetailsScreen()),
                            );
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Class: ${currentClass.name}',
                                style: GoogleFonts.architectsDaughter(
                                  color: RPGTheme.redPencil,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                  decorationStyle: TextDecorationStyle.dotted,
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Icon(Icons.info_outline, size: 16, color: RPGTheme.redPencil),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 30),

                // Level Display
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'LVL: ',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    Text(
                      '$currentLevel',
                      style: GoogleFonts.architectsDaughter(
                        fontSize: 42,
                        fontWeight: FontWeight.bold,
                        color: RPGTheme.redPencil,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 30),
                
                // Experience Bar Container (Sketch style)
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border.all(
                      color: RPGTheme.graphiteDark,
                      width: 2,
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Evolution Points',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          Text(
                            '$xpForCurrent / $xpRequired XP',
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // XP Bar
                      Stack(
                        children: [
                          Container(
                            height: 24,
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              border: Border.all(color: RPGTheme.graphiteDark, width: 2),
                            ),
                            // Sketchy hatch pattern simulation with borders
                            child: CustomPaint(
                              painter: HatchPainter(),
                            ),
                          ),
                          LayoutBuilder(
                            builder: (context, constraints) {
                              return Container(
                                width: constraints.maxWidth * progress,
                                height: 24,
                                decoration: BoxDecoration(
                                  color: RPGTheme.graphiteMedium.withOpacity(0.3),
                                  border: Border(
                                    right: BorderSide(color: RPGTheme.graphiteDark, width: 2),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 30),
                // Add XP Button for testing
                OutlinedButton.icon(
                  onPressed: () {
                    final box = Hive.box<UserProfile>('userProfileBox');
                    var profile = box.get(0) ?? UserProfile();
                    profile.evolutionPoints += 50;
                    box.put(0, profile);
                  },
                  icon: const Icon(Icons.fitness_center),
                  label: const Text('Train (Add 50 XP)'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: RPGTheme.graphiteDark,
                    side: const BorderSide(color: RPGTheme.graphiteDark, width: 2),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    textStyle: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AchievementsScreen()),
                    );
                  },
                  icon: const Icon(Icons.emoji_events),
                  label: const Text('View Achievements'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: RPGTheme.graphiteDark,
                    foregroundColor: RPGTheme.paperBackground,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  ),
                ),
                if (authUser != null) ...[
                  const SizedBox(height: 30),
                  Text(
                    'Logged in as: ${authUser.email}',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  Text(
                    'Account Level: ${authUser.accountLevel.name.toUpperCase()}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      ref.read(authProvider.notifier).logout();
                    },
                    icon: const Icon(Icons.logout),
                    label: const Text('Logout'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: RPGTheme.redPencil,
                      foregroundColor: RPGTheme.paperBackground,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  String _getSelectedTitleName(UserProfile profile, Box<TitleModel> titlesBox) {
    if (profile.selectedTitleId == null) return 'No Title Selected';
    final title = titlesBox.get(profile.selectedTitleId);
    return title?.name ?? 'Unknown Title';
  }

  void _showTitleSelection(BuildContext context, UserProfile profile, Box<TitleModel> titlesBox) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        final unlockedTitles = titlesBox.values.where((t) => t.isUnlocked).toList();
        if (unlockedTitles.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(24.0),
            child: Text('No titles unlocked yet. Keep training!'),
          );
        }
        return ListView.builder(
          itemCount: unlockedTitles.length,
          itemBuilder: (context, index) {
            final title = unlockedTitles[index];
            return ListTile(
              title: Text(title.name, style: Theme.of(context).textTheme.titleMedium),
              trailing: profile.selectedTitleId == title.id ? const Icon(Icons.check, color: Colors.green) : null,
              onTap: () {
                final box = Hive.box<UserProfile>('userProfileBox');
                box.put(0, profile.copyWith(selectedTitleId: title.id));
                Navigator.pop(context);
              },
            );
          },
        );
      },
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

class HatchPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = RPGTheme.graphiteLight.withOpacity(0.5)
      ..strokeWidth = 1;
    for (double i = 0; i < size.width + size.height; i += 8) {
      canvas.drawLine(Offset(i, 0), Offset(i - size.height, size.height), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
