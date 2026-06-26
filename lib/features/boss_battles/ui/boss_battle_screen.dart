import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/Chefe_battle_provider.dart';
import '../models/damage_record.dart';
import 'dart:math';

class ChefeBattleScreen extends ConsumerStatefulWidget {
  const ChefeBattleScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ChefeBattleScreen> createState() => _ChefeBattleScreenState();
}

class _ChefeBattleScreenState extends ConsumerState<ChefeBattleScreen> with SingleTickerProviderStateMixin {
  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _shakeAnimation = Tween<double>(begin: 0, end: 10).chain(CurveTween(curve: Curves.elasticIn)).animate(_shakeController)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _shakeController.reverse();
        }
      });
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  void _dealSimulatedDamage() {
    ref.read(ChefeBattleProvider.notifier).dealDamage(
      DamageRecord(
        timestamp: DateTime.now(),
        activityType: 'PASSOS',
        amount: 500,
        damageDealt: 500,
      ),
    );
    _shakeController.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    final ChefeEvent = ref.watch(ChefeBattleProvider);

    if (ChefeEvent == null) {
      return const Scaffold(
        body: Center(child: Text('No active Chefe encounter')),
      );
    }

    final hpPercentage = ChefeEvent.currentHp / ChefeEvent.maxHp;
    final timeRemaining = ChefeEvent.timeLimit.difference(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chefe Battle'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              ChefeEvent.name,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              ChefeEvent.description,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            AnimatedBuilder(
              animation: _shakeAnimation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(sin(_shakeAnimation.value * pi) * 10, 0),
                  child: child,
                );
              },
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.red[100],
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.sports_martial_arts,
                  size: 100,
                  color: Colors.red,
                ),
              ),
            ),
            const SizedBox(height: 32),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('HP: ${ChefeEvent.currentHp} / ${ChefeEvent.maxHp}'),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: hpPercentage,
                  minHeight: 20,
                  color: hpPercentage > 0.5 ? Colors.green : (hpPercentage > 0.2 ? Colors.orange : Colors.red),
                  backgroundColor: Colors.grey[300],
                ),
              ],
            ),
            const SizedBox(height: 32),
            Text(
              'Tempo Restante: ${timeRemaining.inDays}d ${timeRemaining.inHours.remainder(24)}h',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const Spacer(),
            ElevatedButton.icon(
              onPressed: ChefeEvent.currentHp > 0 ? _dealSimulatedDamage : null,
              icon: const Icon(Icons.flash_on),
              label: const Text('Convert PASSOS to Damage (Simulate)'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
