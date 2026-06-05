import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
      backgroundColor: RPGTheme.darkParchment,
      appBar: AppBar(
        title: Text(
          'Dungeon Exploration',
          style: textTheme.headlineMedium?.copyWith(color: RPGTheme.darkParchment),
        ),
        backgroundColor: RPGTheme.primaryGold,
        elevation: 0,
      ),
      body: state.isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: RPGTheme.primaryGold,
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
                        color: Colors.red.withValues(alpha: 0.1),
                        border: Border.all(color: Colors.red),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        state.error!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  if (state.checkedInGym != null)
                    Container(
                      padding: const EdgeInsets.all(24),
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: RPGTheme.primaryGold,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: RPGTheme.primaryGold, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.5),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          )
                        ],
                      ),
                      child: Column(
                        children: [
                          const Icon(Icons.castle, size: 48, color: RPGTheme.primaryGold),
                          const SizedBox(height: 16),
                          Text(
                            'Entered Dungeon:',
                            style: textTheme.bodyMedium?.copyWith(color: Colors.white70),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            state.checkedInGym!.name,
                            style: textTheme.headlineMedium?.copyWith(color: RPGTheme.primaryGold, fontSize: 24),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Ready your weapons, Hero.',
                            style: textTheme.bodyMedium?.copyWith(color: Colors.white, fontStyle: FontStyle.italic),
                          ),
                        ],
                      ),
                    ),
                  Text(
                    'Nearby Dungeons (Gyms)',
                    style: textTheme.headlineMedium!,
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: state.nearbyGyms.isEmpty
                        ? Center(
                            child: Text(
                              'No dungeons detected nearby.',
                              style: textTheme.bodyMedium?.copyWith(color: Colors.white70),
                            ),
                          )
                        : ListView.builder(
                            itemCount: state.nearbyGyms.length,
                            itemBuilder: (context, index) {
                              final gym = state.nearbyGyms[index];
                              final isCheckedIn = state.checkedInGym?.id == gym.id;

                              return Card(
                                color: RPGTheme.inkDark.withValues(alpha: 0.3),
                                margin: const EdgeInsets.only(bottom: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  side: BorderSide(color: RPGTheme.primaryGold.withValues(alpha: 0.5)),
                                ),
                                child: ListTile(
                                  contentPadding: const EdgeInsets.all(16),
                                  leading: CircleAvatar(
                                    backgroundColor: isCheckedIn ? RPGTheme.primaryGold : RPGTheme.primaryGold,
                                    child: Icon(
                                      Icons.fitness_center,
                                      color: isCheckedIn ? RPGTheme.primaryGold : RPGTheme.primaryGold,
                                    ),
                                  ),
                                  title: Text(
                                    gym.name,
                                    style: textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: isCheckedIn ? RPGTheme.primaryGold : Colors.white,
                                    ),
                                  ),
                                  subtitle: Text(
                                    gym.vicinity,
                                    style: textTheme.bodyMedium?.copyWith(color: Colors.white70, fontSize: 12),
                                  ),
                                  trailing: isCheckedIn
                                      ? const Icon(Icons.check_circle, color: RPGTheme.primaryGold)
                                      : ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: RPGTheme.primaryGold,
                                            foregroundColor: RPGTheme.primaryGold,
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: RPGTheme.primaryGold,
        child: const Icon(Icons.refresh, color: RPGTheme.primaryGold),
        onPressed: () {
          ref.read(dungeonNotifierProvider.notifier).refresh();
        },
      ),
    );
  }
}
