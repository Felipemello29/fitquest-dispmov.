import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../core/models/quest_model.dart';
import 'package:intl/intl.dart';

final dailyQuestsProvider = NotifierProvider<DailyQuestsNotifier, List<Quest>>(DailyQuestsNotifier.new);

class DailyQuestsNotifier extends Notifier<List<Quest>> {
  late Box<Quest> _questsBox;
  late Box<String> _appStateBox;
  
  static const String _lastQuestDateKey = 'lastQuestDate';

  @override
  List<Quest> build() {
    _questsBox = Hive.box<Quest>('questsBox');
    _appStateBox = Hive.box<String>('appStateBox');
    return _initializeQuests();
  }

  List<Quest> _initializeQuests() {
    final todayStr = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final lastDateStr = _appStateBox.get(_lastQuestDateKey);

    if (lastDateStr != todayStr) {
      _generateDailyQuests();
      _appStateBox.put(_lastQuestDateKey, todayStr);
    }
    return _questsBox.values.toList();
  }

  void _generateDailyQuests() {
    // Clear old quests
    _questsBox.clear();

    final newQuests = [
      Quest(
        id: 'quest_steps',
        title: "Hero's March",
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
        // ref.read(levelingServiceProvider).addExperience(updatedQuest.xpReward); // TODO: implement XP addition
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
        // ref.read(levelingServiceProvider).addExperience(updatedQuest.xpReward); // TODO: implement XP addition
      }
    }
  }
}
