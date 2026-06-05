import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/step_provider.dart';
import '../../../core/theme/app_theme.dart';

class HeroesMarchScreen extends ConsumerWidget {
  const HeroesMarchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(heroesMarchNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('THE HERO\'S MARCH'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Adventure Status Banner
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.explore,
                        color: RPGTheme.primaryGold,
                        size: 28,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'CURRENT LOCATION',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: RPGTheme.primaryGold,
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                                letterSpacing: 1.5,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'The Whispering Woods (Floor 1)',
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (state.isSimulated)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: RPGTheme.accentCrimson.withOpacity(0.2),
                            border: Border.all(color: RPGTheme.accentCrimson),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'SIMULATION',
                            style: TextStyle(
                              color: RPGTheme.accentCrimson,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Main Circular Progress for Step Tracking
              Center(
                child: Container(
                  width: 250,
                  height: 250,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF1F1B16),
                    border: Border.all(
                      color: const Color(0xFF42372A),
                      width: 4,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Circular Progress Indicator
                      SizedBox(
                        width: 220,
                        height: 220,
                        child: CircularProgressIndicator(
                          value: state.progress,
                          strokeWidth: 8,
                          backgroundColor: const Color(0xFF2C251E),
                          valueColor: const AlwaysStoppedAnimation<Color>(RPGTheme.primaryGold),
                        ),
                      ),
                      // Step Count Details
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.directions_run,
                            color: RPGTheme.primaryGold,
                            size: 40,
                          ),
                          const SizedBox(height: 8),
                          TweenAnimationBuilder<int>(
                            tween: IntTween(begin: 0, end: state.steps),
                            duration: const Duration(milliseconds: 500),
                            builder: (context, value, child) {
                              return Text(
                                '$value',
                                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                                  fontSize: 36,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            },
                          ),
                          Text(
                            '/ ${state.goal} STEPS',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: RPGTheme.inkLight.withOpacity(0.6),
                              letterSpacing: 1.0,
                            ),
                          ),
                          const SizedBox(height: 8),
                          // Progress Percentage
                          Text(
                            '${(state.progress * 100).toInt()}% COMPLETED',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: RPGTheme.primaryGold,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Evolution Points Card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'EVOLUTION POINTS (XP)',
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: RPGTheme.primaryGold,
                            ),
                          ),
                          Row(
                            children: [
                              const Icon(Icons.star, color: RPGTheme.primaryGold, size: 20),
                              const SizedBox(width: 4),
                              Text(
                                '+${state.evolutionPoints} XP',
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: RPGTheme.primaryGold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const LinearProgressIndicator(
                        value: 0.65, // Example level progress
                        backgroundColor: Color(0xFF2C251E),
                        valueColor: AlwaysStoppedAnimation<Color>(RPGTheme.forestGreen),
                        minHeight: 8,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'LEVEL 4 HERO',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '325 / 500 XP to next tier',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontSize: 12,
                              color: RPGTheme.inkLight.withOpacity(0.6),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Statistics & Log grid
              Row(
                children: [
                  Expanded(
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          children: [
                            const Icon(Icons.local_fire_department, color: RPGTheme.accentCrimson, size: 28),
                            const SizedBox(height: 6),
                            Text(
                              'CALORIES',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 10, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${(state.steps * 0.04).toStringAsFixed(1)} kcal',
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          children: [
                            const Icon(Icons.explore, color: RPGTheme.forestGreen, size: 28),
                            const SizedBox(height: 6),
                            Text(
                              'DISTANCE',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 10, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${(state.steps * 0.0008).toStringAsFixed(2)} km',
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
