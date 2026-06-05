import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../core/models/user_profile.dart';
import '../../../core/services/leveling_service.dart';
import '../../../core/theme/app_theme.dart';
import 'package:google_fonts/google_fonts.dart';

class AvatarScreen extends StatelessWidget {
  const AvatarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hero Profile'),
        centerTitle: true,
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
                // Avatar Frame
                Container(
                  width: 160,
                  height: 160,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: RPGTheme.primaryGold,
                      width: 4,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: RPGTheme.primaryGold.withOpacity(0.3),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                    gradient: const LinearGradient(
                      colors: [RPGTheme.darkParchment, RPGTheme.inkDark],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.person,
                      size: 80,
                      color: RPGTheme.inkLight,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                
                // Level Display
                Text(
                  'Level $currentLevel',
                  style: GoogleFonts.cinzel(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: RPGTheme.primaryGold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Hero of the Realm',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: RPGTheme.inkLight.withOpacity(0.8),
                    fontStyle: FontStyle.italic,
                  ),
                ),
                
                const SizedBox(height: 40),
                
                // Experience Bar Container
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF15120E),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: RPGTheme.inkDark,
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
                            style: GoogleFonts.specialElite(
                              fontSize: 16,
                              color: RPGTheme.primaryGold,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // XP Bar
                      Stack(
                        children: [
                          Container(
                            height: 20,
                            decoration: BoxDecoration(
                              color: RPGTheme.darkParchment,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: RPGTheme.inkDark),
                            ),
                          ),
                          LayoutBuilder(
                            builder: (context, constraints) {
                              return Container(
                                width: constraints.maxWidth * progress,
                                height: 20,
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [RPGTheme.manaBlue, Color(0xFF457B9D)],
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: RPGTheme.manaBlue.withOpacity(0.5),
                                      blurRadius: 10,
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Level $currentLevel',
                            style: GoogleFonts.specialElite(
                              color: RPGTheme.inkLight.withOpacity(0.6),
                            ),
                          ),
                          Text(
                            'Level ${currentLevel + 1}',
                            style: GoogleFonts.specialElite(
                              color: RPGTheme.inkLight.withOpacity(0.6),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 30),
                // Add XP Button for testing
                ElevatedButton.icon(
                  onPressed: () {
                    final box = Hive.box<UserProfile>('userProfileBox');
                    var profile = box.get(0) ?? UserProfile();
                    profile.evolutionPoints += 50;
                    box.put(0, profile);
                  },
                  icon: const Icon(Icons.add_circle_outline),
                  label: const Text('Train (Add 50 XP)'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: RPGTheme.forestGreen,
                    foregroundColor: RPGTheme.lightParchment,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    textStyle: GoogleFonts.cinzel(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
