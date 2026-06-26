import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/Chefe_event.dart';
import '../models/damage_record.dart';

final ChefeBattleProvider = NotifierProvider<ChefeBattleNotifier, ChefeEvent?>(ChefeBattleNotifier.new);

class ChefeBattleNotifier extends Notifier<ChefeEvent?> {
  @override
  ChefeEvent? build() {
    return ChefeEvent(
      id: 'Chefe_1',
      name: 'O Rei Preguiça',
      description: 'Um gigante preguiçoso que quer te manter no sofá.',
      artworkUrl: 'assets/Chefees/sloth_king.png',
      maxHp: 10000,
      currentHp: 10000,
      timeLimit: DateTime.now().add(const Duration(days: 3)),
      Recompensas: [
        Recompensa(id: 'xp_potion', name: 'XP Potion', quantity: 1),
        Recompensa(id: 'gold', name: 'Gold Coins', quantity: 500),
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
