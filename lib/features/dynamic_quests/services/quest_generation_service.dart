library quest_generation_service;

import 'dart:math';
import '../models/dynamic_quest_model.dart';
import '../../../core/constants/enums.dart';
import '../../../core/models/user_profile.dart';
import '../../../core/repositories/repository_interfaces.dart';

/// Service responsible for generating dynamic, personalized quests
class QuestGenerationService {
  final UserProfileRepository _userProfileRepository;
  final Random _random = Random();

  QuestGenerationService(this._userProfileRepository);

  /// Generate daily quests based on user behavior and progress
  Future<List<DynamicQuest>> generateDailyQuests({
    int count = 3,
    bool includePersonalized = true,
  }) async {
    final user = await _userProfileRepository.getProfile();
    final userStats = await _analyzeUserBehavior(user);
    
    final quests = <DynamicQuest>[];
    final now = DateTime.now();
    final tomorrow = DateTime(now.year, now.month, now.day + 1);

    // Generate one quest from each priority category
    final categories = _selectDailyCategories(userStats, count);
    
    for (int i = 0; i < count && i < categories.length; i++) {
      final category = categories[i];
      final quest = _generateQuestForCategory(
        category,
        QuestType.daily,
        userStats,
        now,
        tomorrow,
        isPersonalized: includePersonalized,
      );
      
      quests.add(quest);
    }

    return quests;
  }

  /// Generate weekly quests with longer-term goals
  Future<List<DynamicQuest>> generateWeeklyQuests({
    int count = 2,
  }) async {
    final user = await _userProfileRepository.getProfile();
    final userStats = await _analyzeUserBehavior(user);
    
    final quests = <DynamicQuest>[];
    final now = DateTime.now();
    final nextWeek = now.add(const Duration(days: 7));

    // Weekly quests focus on consistency and bigger goals
    final categories = [
      QuestCategory.consistency,
      QuestCategory.achievement,
      QuestCategory.endurance,
    ];

    for (int i = 0; i < count && i < categories.length; i++) {
      final quest = _generateQuestForCategory(
        categories[i],
        QuestType.weekly,
        userStats,
        now,
        nextWeek,
        isPersonalized: true,
      );
      
      quests.add(quest);
    }

    return quests;
  }

  /// Generate special event quests
  Future<List<DynamicQuest>> generateSpecialQuests({
    required String eventTheme,
    int count = 1,
    Duration? duration,
  }) async {
    final user = await _userProfileRepository.getProfile();
    final userStats = await _analyzeUserBehavior(user);
    
    final now = DateTime.now();
    final expiry = now.add(duration ?? const Duration(days: 3));

    final quest = DynamicQuest(
      id: 'special_${eventTheme}_${now.millisecondsSinceEpoch}',
      title: _getSpecialQuestTitle(eventTheme),
      description: _getSpecialQuestDescription(eventTheme, userStats),
      type: QuestType.special,
      category: QuestCategory.special,
      targetValue: _calculateSpecialTargetValue(eventTheme, userStats),
      xpReward: _calculateXpReward(QuestDifficulty.epic, QuestCategory.special),
      difficulty: QuestDifficulty.epic,
      createdAt: now,
      expiresAt: expiry,
      isPersonalized: true,
      rewards: [
        QuestReward(
          type: 'title',
          value: '${eventTheme} Champion',
          description: 'Exclusive title for completing this special event',
        ),
      ],
    );

    return [quest];
  }

  /// Analyze user behavior to create personalized quests
  Future<UserBehaviorStats> _analyzeUserBehavior(UserProfile? user) async {
    if (user == null) {
      return UserBehaviorStats.defaultStats();
    }

    return UserBehaviorStats(
      averageDailySteps: _calculateAverageDailySteps(user),
      currentLevel: user.level,
      characterClass: user.characterClass,
      preferredDifficulty: _inferPreferredDifficulty(user),
      weeklyGymVisits: 2, // TODO: Implement gym visit tracking
      completedQuestsCount: 0, // TODO: Implement quest history
      currentStreak: 0, // TODO: Implement streak tracking
      strongCategories: _identifyStrongCategories(user),
      improvementAreas: _identifyImprovementAreas(user),
    );
  }

  /// Select categories for daily quests based on user behavior
  List<QuestCategory> _selectDailyCategories(UserBehaviorStats stats, int count) {
    final allCategories = QuestCategory.values.where(
      (c) => c != QuestCategory.special, // Special is only for events
    ).toList();

    // Prioritize improvement areas and mix with strong areas
    final improvementAreas = stats.improvementAreas;
    final strongAreas = stats.strongCategories;
    
    final selected = <QuestCategory>[];
    
    // Add improvement areas first (but not too many to avoid discouragement)
    if (improvementAreas.isNotEmpty && selected.length < count) {
      selected.add(improvementAreas[_random.nextInt(improvementAreas.length)]);
    }

    // Add strong areas for motivation
    for (final category in strongAreas) {
      if (selected.length >= count) break;
      if (!selected.contains(category)) {
        selected.add(category);
      }
    }

    // Fill remaining with random categories
    allCategories.shuffle(_random);
    for (final category in allCategories) {
      if (selected.length >= count) break;
      if (!selected.contains(category)) {
        selected.add(category);
      }
    }

    return selected.take(count).toList();
  }

  /// Generate a quest for a specific category
  DynamicQuest _generateQuestForCategory(
    QuestCategory category,
    QuestType type,
    UserBehaviorStats stats,
    DateTime createdAt,
    DateTime expiresAt, {
    bool isPersonalized = false,
  }) {
    final questId = '${type.id}_${category.name}_${createdAt.millisecondsSinceEpoch}';
    final difficulty = _selectDifficultyForQuest(category, stats, isPersonalized);
    
    final questTemplate = _getQuestTemplate(category, type, stats, difficulty);
    
    return DynamicQuest(
      id: questId,
      title: questTemplate.title,
      description: questTemplate.description,
      type: type,
      category: category,
      targetValue: questTemplate.targetValue,
      xpReward: _calculateXpReward(difficulty, category),
      difficulty: difficulty,
      createdAt: createdAt,
      expiresAt: expiresAt,
      isPersonalized: isPersonalized,
      requirements: questTemplate.requirements,
      rewards: questTemplate.rewards,
    );
  }

  /// Get quest template based on category and user stats
  QuestTemplate _getQuestTemplate(
    QuestCategory category,
    QuestType type,
    UserBehaviorStats stats,
    QuestDifficulty difficulty,
  ) {
    switch (category) {
      case QuestCategory.movement:
        return _generateMovementQuest(type, stats, difficulty);
      case QuestCategory.strength:
        return _generateStrengthQuest(type, stats, difficulty);
      case QuestCategory.endurance:
        return _generateEnduranceQuest(type, stats, difficulty);
      case QuestCategory.consistency:
        return _generateConsistencyQuest(type, stats, difficulty);
      case QuestCategory.social:
        return _generateSocialQuest(type, stats, difficulty);
      case QuestCategory.exploration:
        return _generateExplorationQuest(type, stats, difficulty);
      case QuestCategory.achievement:
        return _generateAchievementQuest(type, stats, difficulty);
      case QuestCategory.special:
        return _generateSpecialQuest(type, stats, difficulty);
    }
  }

  /// Generate movement-based quest
  QuestTemplate _generateMovementQuest(
    QuestType type,
    UserBehaviorStats stats,
    QuestDifficulty difficulty,
  ) {
    final baseSteps = stats.averageDailySteps;
    final multiplier = _getDifficultyMultiplier(difficulty);
    final target = (baseSteps * multiplier * _getTypeMultiplier(type)).round();

    final questVariations = [
      QuestTemplate(
        title: "The Explorer's Journey",
        description: "Take $target steps and discover new paths",
        targetValue: target,
        requirements: [],
        rewards: [],
      ),
      QuestTemplate(
        title: "March of the ${stats.characterClass.displayName}",
        description: "Walk $target steps like a true ${stats.characterClass.displayName}",
        targetValue: target,
        requirements: [],
        rewards: [],
      ),
      QuestTemplate(
        title: "Wanderer's Path",
        description: "Embark on a journey of $target steps through the realm",
        targetValue: target,
        requirements: [],
        rewards: [],
      ),
    ];

    return questVariations[_random.nextInt(questVariations.length)];
  }

  /// Generate strength-based quest
  QuestTemplate _generateStrengthQuest(
    QuestType type,
    UserBehaviorStats stats,
    QuestDifficulty difficulty,
  ) {
    final questVariations = [
      QuestTemplate(
        title: "Warrior's Training",
        description: "Visit the gym and complete a strength training session",
        targetValue: type == QuestType.daily ? 1 : 3,
        requirements: [],
        rewards: [],
      ),
      QuestTemplate(
        title: "Forge of Champions",
        description: "Train like a champion - complete ${type == QuestType.daily ? 1 : 5} workout sessions",
        targetValue: type == QuestType.daily ? 1 : 5,
        requirements: [],
        rewards: [],
      ),
    ];

    return questVariations[_random.nextInt(questVariations.length)];
  }

  /// Generate endurance quest
  QuestTemplate _generateEnduranceQuest(
    QuestType type,
    UserBehaviorStats stats,
    QuestDifficulty difficulty,
  ) {
    final multiplier = _getDifficultyMultiplier(difficulty);
    final baseTarget = type == QuestType.daily ? 15000 : 80000; // steps
    final target = (baseTarget * multiplier).round();

    return QuestTemplate(
      title: "Trial of Endurance", 
      description: "Push your limits - achieve $target steps in ${type == QuestType.daily ? 'one day' : 'one week'}",
      targetValue: target,
      requirements: [
        QuestRequirement(
          type: 'level',
          minValue: 3,
          description: 'Requires level 3 or higher',
        ),
      ],
      rewards: [
        QuestReward(
          type: 'title',
          value: 'Endurance Master',
          description: 'Proves your incredible stamina',
        ),
      ],
    );
  }

  /// Generate consistency quest
  QuestTemplate _generateConsistencyQuest(
    QuestType type,
    UserBehaviorStats stats,
    QuestDifficulty difficulty,
  ) {
    final target = type == QuestType.daily ? 1 : 5;
    
    return QuestTemplate(
      title: "Guardian's Devotion",
      description: "Maintain your training streak - exercise for $target consecutive day${target == 1 ? '' : 's'}",
      targetValue: target,
      requirements: [],
      rewards: [
        QuestReward(
          type: 'bonus_xp',
          value: '50',
          description: 'Bonus XP for consistency',
        ),
      ],
    );
  }

  /// Generate social quest
  QuestTemplate _generateSocialQuest(
    QuestType type,
    UserBehaviorStats stats,
    QuestDifficulty difficulty,
  ) {
    return QuestTemplate(
      title: "Fellowship of Fitness",
      description: "Share your progress or encourage a fellow adventurer",
      targetValue: 1,
      requirements: [],
      rewards: [
        QuestReward(
          type: 'title',
          value: 'Motivator',
          description: 'Awarded for inspiring others',
        ),
      ],
    );
  }

  /// Generate exploration quest
  QuestTemplate _generateExplorationQuest(
    QuestType type,
    UserBehaviorStats stats,
    QuestDifficulty difficulty,
  ) {
    final target = type == QuestType.daily ? 1 : 3;
    
    return QuestTemplate(
      title: "Cartographer's Journey",
      description: "Discover new territories - visit $target new gym${target == 1 ? '' : 's'} or location${target == 1 ? '' : 's'}",
      targetValue: target,
      requirements: [],
      rewards: [
        QuestReward(
          type: 'title',
          value: 'Explorer',
          description: 'For those who seek new horizons',
        ),
      ],
    );
  }

  /// Generate achievement quest
  QuestTemplate _generateAchievementQuest(
    QuestType type,
    UserBehaviorStats stats,
    QuestDifficulty difficulty,
  ) {
    return QuestTemplate(
      title: "Champion's Ascension",
      description: "Prove your worth - unlock a new achievement or reach the next level",
      targetValue: 1,
      requirements: [
        QuestRequirement(
          type: 'level',
          minValue: stats.currentLevel,
          description: 'Current level: ${stats.currentLevel}',
        ),
      ],
      rewards: [
        QuestReward(
          type: 'bonus_xp',
          value: '100',
          description: 'Achievement bonus',
        ),
      ],
    );
  }

  /// Generate special event quest
  QuestTemplate _generateSpecialQuest(
    QuestType type,
    UserBehaviorStats stats,
    QuestDifficulty difficulty,
  ) {
    return QuestTemplate(
      title: "Legendary Challenge",
      description: "A rare challenge has appeared! Complete this epic quest for legendary rewards",
      targetValue: 50000, // Epic step challenge
      requirements: [
        QuestRequirement(
          type: 'level',
          minValue: 5,
          description: 'Only experienced adventurers may attempt this',
        ),
      ],
      rewards: [
        QuestReward(
          type: 'title',
          value: 'Legend',
          description: 'Exclusive legendary title',
        ),
      ],
    );
  }

  /// Helper methods
  int _calculateAverageDailySteps(UserProfile user) {
    // TODO: Implement actual step history analysis
    return max(8000, user.stepCount); // Default minimum with current steps
  }

  QuestDifficulty _inferPreferredDifficulty(UserProfile user) {
    // Base difficulty on user level
    if (user.level >= 10) return QuestDifficulty.hard;
    if (user.level >= 5) return QuestDifficulty.medium;
    return QuestDifficulty.easy;
  }

  List<QuestCategory> _identifyStrongCategories(UserProfile user) {
    final categories = <QuestCategory>[];
    
    // Analyze user's character class for strengths
    switch (user.characterClass) {
      case CharacterClass.warrior:
        categories.addAll([QuestCategory.strength, QuestCategory.achievement]);
        break;
      case CharacterClass.ranger:
        categories.addAll([QuestCategory.movement, QuestCategory.endurance]);
        break;
      case CharacterClass.mage:
        categories.addAll([QuestCategory.consistency, QuestCategory.exploration]);
        break;
      case CharacterClass.novice:
      default:
        categories.add(QuestCategory.movement);
        break;
    }
    
    return categories;
  }

  List<QuestCategory> _identifyImprovementAreas(UserProfile user) {
    // Areas that complement the user's strong areas
    final allCategories = QuestCategory.values.where(
      (c) => c != QuestCategory.special,
    ).toList();
    
    final strongAreas = _identifyStrongCategories(user);
    return allCategories.where((c) => !strongAreas.contains(c)).take(2).toList();
  }

  QuestDifficulty _selectDifficultyForQuest(
    QuestCategory category,
    UserBehaviorStats stats,
    bool isPersonalized,
  ) {
    if (!isPersonalized) {
      return QuestDifficulty.easy; // Default quests are easy
    }

    // Adjust difficulty based on user's strong/weak categories
    if (stats.strongCategories.contains(category)) {
      return _upgradeDifficulty(stats.preferredDifficulty);
    } else {
      return stats.preferredDifficulty;
    }
  }

  QuestDifficulty _upgradeDifficulty(QuestDifficulty current) {
    switch (current) {
      case QuestDifficulty.easy:
        return QuestDifficulty.medium;
      case QuestDifficulty.medium:
        return QuestDifficulty.hard;
      case QuestDifficulty.hard:
        return QuestDifficulty.epic;
      case QuestDifficulty.epic:
      case QuestDifficulty.legendary:
        return current; // Already at high difficulty
    }
  }

  double _getDifficultyMultiplier(QuestDifficulty difficulty) {
    switch (difficulty) {
      case QuestDifficulty.easy:
        return 0.8;
      case QuestDifficulty.medium:
        return 1.0;
      case QuestDifficulty.hard:
        return 1.3;
      case QuestDifficulty.epic:
        return 1.7;
      case QuestDifficulty.legendary:
        return 2.5;
    }
  }

  double _getTypeMultiplier(QuestType type) {
    switch (type) {
      case QuestType.daily:
        return 1.0;
      case QuestType.weekly:
        return 6.0; // More than daily × 7 to make it challenging
      case QuestType.special:
        return 2.0;
    }
  }

  int _calculateXpReward(QuestDifficulty difficulty, QuestCategory category) {
    final baseReward = 50;
    final difficultyMultiplier = difficulty.xpMultiplier;
    
    // Some categories give bonus XP
    final categoryMultiplier = switch (category) {
      QuestCategory.endurance => 1.2,
      QuestCategory.achievement => 1.3,
      QuestCategory.special => 1.5,
      _ => 1.0,
    };

    return (baseReward * difficultyMultiplier * categoryMultiplier).round();
  }

  String _getSpecialQuestTitle(String eventTheme) {
    return "Epic $eventTheme Challenge";
  }

  String _getSpecialQuestDescription(String eventTheme, UserBehaviorStats stats) {
    return "A legendary $eventTheme event has begun! Complete this epic challenge within the time limit for exclusive rewards.";
  }

  int _calculateSpecialTargetValue(String eventTheme, UserBehaviorStats stats) {
    return (stats.averageDailySteps * 3).round(); // Special events are 3x normal
  }
}

/// User behavior analysis data
class UserBehaviorStats {
  final int averageDailySteps;
  final int currentLevel;
  final CharacterClass characterClass;
  final QuestDifficulty preferredDifficulty;
  final int weeklyGymVisits;
  final int completedQuestsCount;
  final int currentStreak;
  final List<QuestCategory> strongCategories;
  final List<QuestCategory> improvementAreas;

  UserBehaviorStats({
    required this.averageDailySteps,
    required this.currentLevel,
    required this.characterClass,
    required this.preferredDifficulty,
    required this.weeklyGymVisits,
    required this.completedQuestsCount,
    required this.currentStreak,
    required this.strongCategories,
    required this.improvementAreas,
  });

  factory UserBehaviorStats.defaultStats() {
    return UserBehaviorStats(
      averageDailySteps: 8000,
      currentLevel: 1,
      characterClass: CharacterClass.novice,
      preferredDifficulty: QuestDifficulty.easy,
      weeklyGymVisits: 2,
      completedQuestsCount: 0,
      currentStreak: 0,
      strongCategories: [QuestCategory.movement],
      improvementAreas: [QuestCategory.consistency, QuestCategory.strength],
    );
  }
}

/// Quest template for generation
class QuestTemplate {
  final String title;
  final String description;
  final int targetValue;
  final List<QuestRequirement> requirements;
  final List<QuestReward> rewards;

  QuestTemplate({
    required this.title,
    required this.description,
    required this.targetValue,
    required this.requirements,
    required this.rewards,
  });
}