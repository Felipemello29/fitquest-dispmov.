import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/material.dart';
import '../../main.dart';
import '../models/achievement_model.dart';
import '../models/title_model.dart';

class AchievementService {
  static const String _achievementsBoxName = 'achievementsBox';
  static const String _titlesBoxName = 'titlesBox';

  late Box<Achievement> _achievementsBox;
  late Box<TitleModel> _titlesBox;

  // Pre-defined achievements
  final List<Achievement> _defaultAchievements = [
    Achievement(id: 'PASSOS_1000', name: 'A Thousand PASSOS', description: 'Take 1,000 PASSOS.', icon: '🚶'),
    Achievement(id: 'PASSOS_10000', name: 'Ten Thousand PASSOS', description: 'Take 10,000 PASSOS.', icon: '🏃'),
    Achievement(id: 'level_5', name: 'Getting Stronger', description: 'Reach level 5.', icon: '⭐'),
    Achievement(id: 'level_10', name: 'True Warrior', description: 'Reach level 10.', icon: '🌟'),
    Achievement(id: 'first_Chefe', name: 'Chefe Slayer', description: 'Defeat your first Chefe.', icon: '👾'),
  ];

  // Pre-defined titles
  final List<TitleModel> _defaultTitles = [
    TitleModel(id: 'title_novice', name: 'Novice'),
    TitleModel(id: 'title_walker', name: 'Walker'),
    TitleModel(id: 'title_runner', name: 'Runner'),
    TitleModel(id: 'title_warrior', name: 'Warrior'),
    TitleModel(id: 'title_hero', name: 'Hero'),
  ];

  Future<void> init() async {
    // Register adapters if not already registered (should be done in main.dart)
    if (!Hive.isAdapterRegistered(3)) {
      Hive.registerAdapter(AchievementAdapter());
    }
    if (!Hive.isAdapterRegistered(4)) {
      Hive.registerAdapter(TitleModelAdapter());
    }

    _achievementsBox = await Hive.openBox<Achievement>(_achievementsBoxName);
    _titlesBox = await Hive.openBox<TitleModel>(_titlesBoxName);

    _initializeDefaults();
  }

  void _initializeDefaults() {
    if (_achievementsBox.isEmpty) {
      for (var achievement in _defaultAchievements) {
        _achievementsBox.put(achievement.id, achievement);
      }
    }
    if (_titlesBox.isEmpty) {
      for (var title in _defaultTitles) {
        _titlesBox.put(title.id, title);
      }
    }
  }

  List<Achievement> get allAchievements => _achievementsBox.values.toList();
  List<TitleModel> get allTitles => _titlesBox.values.toList();

  Future<void> unlockAchievement(String id) async {
    final achievement = _achievementsBox.get(id);
    if (achievement != null && !achievement.isUnlocked) {
      final updated = achievement.copyWith(
        isUnlocked: true,
        unlockedAt: DateTime.now(),
      );
      await _achievementsBox.put(id, updated);
      
      rootScaffoldMessengerKey.currentState?.showSnackBar(
        SnackBar(
          content: Text('🏆 Achievement Unlocked: ${updated.name}!'),
          backgroundColor: Colors.amber[700],
          duration: const Duration(seconds: 4),
        ),
      );
    }
  }

  Future<void> unlockTitle(String id) async {
    final title = _titlesBox.get(id);
    if (title != null && !title.isUnlocked) {
      final updated = title.copyWith(isUnlocked: true);
      await _titlesBox.put(id, updated);
    }
  }

  // --- Checkers for Events ---

  Future<void> checkStepAchievements(int totalPASSOS) async {
    if (totalPASSOS >= 1000) await unlockAchievement('PASSOS_1000');
    if (totalPASSOS >= 1000) await unlockTitle('title_walker');

    if (totalPASSOS >= 10000) await unlockAchievement('PASSOS_10000');
    if (totalPASSOS >= 10000) await unlockTitle('title_runner');
  }

  Future<void> checkLevelAchievements(int level) async {
    if (level >= 5) await unlockAchievement('level_5');
    if (level >= 5) await unlockTitle('title_warrior');

    if (level >= 10) await unlockAchievement('level_10');
    if (level >= 10) await unlockTitle('title_hero');
  }

  Future<void> checkChefeDefeated() async {
    await unlockAchievement('first_Chefe');
  }
}
