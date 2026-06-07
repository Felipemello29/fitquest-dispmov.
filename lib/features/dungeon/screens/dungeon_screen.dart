import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../providers/dungeon_provider.dart';

class DungeonScreen extends ConsumerStatefulWidget {
  const DungeonScreen({super.key});

  @override
  ConsumerState<DungeonScreen> createState() => _DungeonScreenState();
}

class _DungeonScreenState extends ConsumerState<DungeonScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(dungeonNotifierProvider.notifier).refresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(dungeonNotifierProvider);
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dungeon Map'),
      ),
      // Adding a grid background to look like mapping paper
      body: CustomPaint(
        painter: GridPaperPainter(),
        child: state.isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: RPGTheme.graphiteDark,
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (state.error != null)
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: RPGTheme.redPencil.withOpacity(0.1),
                          border: Border.all(color: RPGTheme.redPencil, width: 2),
                        ),
                        child: Text(
                          state.error!,
                          style: const TextStyle(color: RPGTheme.redPencil),
                        ),
                      ),
                    if (state.checkedInGym != null)
                      Container(
                        padding: const EdgeInsets.all(24),
                        margin: const EdgeInsets.only(bottom: 24),
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
                            Image.asset(
                              'assets/images/dungeon.png',
                              height: 120,
                              fit: BoxFit.contain,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Entered Dungeon:',
                              style: GoogleFonts.architectsDaughter(
                                color: RPGTheme.graphiteMedium,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              state.checkedInGym!.name,
                              style: GoogleFonts.architectsDaughter(
                                color: RPGTheme.redPencil,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Ready your weapons, Hero.',
                              style: GoogleFonts.patrickHand(
                                color: RPGTheme.graphiteDark,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                    Text(
                      'Nearby Dungeons',
                      style: textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: state.nearbyGyms.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'assets/images/monster.png',
                                    height: 120,
                                    fit: BoxFit.contain,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'No dungeons mapped nearby...',
                                    style: GoogleFonts.architectsDaughter(
                                      color: RPGTheme.graphiteMedium,
                                      fontSize: 22,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : ListView.builder(
                              itemCount: state.nearbyGyms.length,
                              itemBuilder: (context, index) {
                                final gym = state.nearbyGyms[index];
                                final isCheckedIn = state.checkedInGym?.id == gym.id;

                                return Container(
                                  margin: const EdgeInsets.only(bottom: 16),
                                  decoration: BoxDecoration(
                                    color: RPGTheme.paperBackground.withOpacity(0.9),
                                    border: Border.all(
                                      color: isCheckedIn ? RPGTheme.redPencil : RPGTheme.graphiteMedium,
                                      width: isCheckedIn ? 3 : 1.5,
                                    ),
                                  ),
                                  child: ListTile(
                                    contentPadding: const EdgeInsets.all(16),
                                    leading: Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: RPGTheme.graphiteDark,
                                          width: 1.5,
                                        ),
                                      ),
                                      child: Icon(
                                        Icons.map,
                                        color: RPGTheme.graphiteDark,
                                      ),
                                    ),
                                    title: Text(
                                      gym.name,
                                      style: GoogleFonts.architectsDaughter(
                                        fontWeight: FontWeight.bold,
                                        color: RPGTheme.graphiteDark,
                                        fontSize: 20,
                                      ),
                                    ),
                                    subtitle: Text(
                                      gym.vicinity,
                                      style: GoogleFonts.patrickHand(
                                        color: RPGTheme.graphiteMedium,
                                        fontSize: 16,
                                      ),
                                    ),
                                    trailing: isCheckedIn
                                        ? const Icon(Icons.close, color: RPGTheme.redPencil, size: 36)
                                        : OutlinedButton(
                                            style: OutlinedButton.styleFrom(
                                              foregroundColor: RPGTheme.graphiteDark,
                                              side: const BorderSide(color: RPGTheme.graphiteDark, width: 2),
                                              textStyle: GoogleFonts.architectsDaughter(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            onPressed: () {
                                              ref.read(dungeonNotifierProvider.notifier).checkIn(gym);
                                            },
                                            child: const Text('Enter'),
                                          ),
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: RPGTheme.paperBackground,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: RPGTheme.graphiteDark, width: 2),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.refresh, color: RPGTheme.graphiteDark),
        onPressed: () {
          ref.read(dungeonNotifierProvider.notifier).refresh();
        },
      ),
    );
  }
}

// Custom painter to draw light grid lines typical of D&D mapping paper
class GridPaperPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = RPGTheme.graphiteLight.withOpacity(0.2)
      ..strokeWidth = 1;

    const double gridSize = 30.0;

    for (double i = 0; i < size.width; i += gridSize) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }

    for (double i = 0; i < size.height; i += gridSize) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
