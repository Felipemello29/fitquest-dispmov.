import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/boss_event.dart';
import '../models/damage_record.dart';

final bossBattleProvider = NotifierProvider<BossBattleNotifier, BossEvent?>(BossBattleNotifier.new);

class BossBattleNotifier extends Notifier<BossEvent?> {
  @override
  BossEvent? build() {
    return BossEvent(
      id: 'boss_1',
      name: 'The Sloth King',
      description: 'A lazy giant who wants to keep you on the couch.',
      artworkUrl: 'assets/bosses/sloth_king.png',
      maxHp: 10000,
      currentHp: 10000,
      timeLimit: DateTime.now().add(const Duration(days: 3)),
      rewards: [
        Reward(id: 'xp_potion', name: 'XP Potion', quantity: 1),
        Reward(id: 'gold', name: 'Gold Coins', quantity: 500),
      ],
    );
  }

  void dealDamage(DamageRecord record) {
    if (state == null) return;
    
    int newHp = state!.currentHp - record.damageDealt;
    if (newHp < 0) newHp = 0;
    
    state = state!.copyWith(currentHp: newHp);
  }
}
