import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../core/models/quest_model.dart';
import 'package:intl/intl.dart';
import '../../../core/services/leveling_service.dart';
import '../../../core/models/user_profile.dart';

final dailyQuestsProvider = StateNotifierProvider<DailyQuestsNotifier, List<Quest>>((ref) {
  return DailyQuestsNotifier(ref);
});

class DailyQuestsNotifier extends StateNotifier<List<Quest>> {
  final Ref _ref;
  final Box<Quest> _questsBox = Hive.box<Quest>('questsBox');
  final Box<String> _appStateBox = Hive.box<String>('appStateBox');
  
  static const String _lastQuestDateKey = 'lastQuestDate';

  DailyQuestsNotifier(this._ref) : super([]) {
    _initializeQuests();
  }

  void _initializeQuests() {
    final todayStr = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final lastDateStr = _appStateBox.get(_lastQuestDateKey);

    if (lastDateStr != todayStr) {
      _generateDailyQuests();
      _appStateBox.put(_lastQuestDateKey, todayStr);
    } else {
      state = _questsBox.values.toList();
    }
  }

  void _generateDailyQuests() {
    // Clear old quests
    _questsBox.clear();

    final newQuests = [
      Quest(
        id: 'quest_steps',
        title: 'Hero\\'s March',
        description: 'Walk 10,000 steps today.',
        targetValue: 10000,
        xpReward: 50,
      ),
      Quest(
        id: 'quest_dungeon',
        title: 'Dungeon Explorer',
        description: 'Complete 1 Dungeon Check-in.',
        targetValue: 1,
        xpReward: 30,
      ),
      Quest(
        id: 'quest_hydration',
        title: 'Elixir of Life',
        description: 'Drink 8 glasses of water.',
        targetValue: 8,
        xpReward: 20,
      ),
    ];

    for (var quest in newQuests) {
      _questsBox.put(quest.id, quest);
    }

    state = newQuests;
  }

  void updateQuestProgress(String id, int addedValue) {
    final questIndex = state.indexWhere((q) => q.id == id);
    if (questIndex != -1) {
      final quest = state[questIndex];
      if (quest.isCompleted) return; // already completed

      final newValue = quest.currentValue + addedValue;
      final isCompleted = newValue >= quest.targetValue;

      final updatedQuest = quest.copyWith(
        currentValue: newValue,
        isCompleted: isCompleted,
      );

      _questsBox.put(id, updatedQuest);
      
      state = [
        for (final q in state)
          if (q.id == id) updatedQuest else q
      ];

      if (isCompleted) {
        _ref.read(levelingServiceProvider).addExperience(updatedQuest.xpReward);
      }
    }
  }

  void setQuestProgress(String id, int newValue) {
    final questIndex = state.indexWhere((q) => q.id == id);
    if (questIndex != -1) {
      final quest = state[questIndex];
      if (quest.isCompleted) return;

      final isCompleted = newValue >= quest.targetValue;

      final updatedQuest = quest.copyWith(
        currentValue: newValue,
        isCompleted: isCompleted,
      );

      _questsBox.put(id, updatedQuest);
      
      state = [
        for (final q in state)
          if (q.id == id) updatedQuest else q
      ];

      if (isCompleted) {
        _ref.read(levelingServiceProvider).addExperience(updatedQuest.xpReward);
      }
    }
  }
}
