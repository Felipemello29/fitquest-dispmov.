import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../core/models/user_profile.dart';
import '../../../core/services/leveling_service.dart';
import '../../../core/theme/app_theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../auth/providers/auth_provider.dart';

class AvatarScreen extends ConsumerWidget {
  const AvatarScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authUser = ref.watch(authProvider);
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
                      child: const Center(
                        child: Icon(
                          Icons.person_outline,
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
                        Text(
                          'Hero of the Realm',
                          style: Theme.of(context).textTheme.titleLarge,
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
