import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../core/models/user_profile.dart';
import '../../../core/constants/enums.dart';
import '../models/character_class.dart';

class ClassNotifier extends Notifier<CharacterClassModel> {
  @override
  CharacterClassModel build() {
    final box = Hive.box<UserProfile>('userProfileBox');
    final profile = box.get(0) ?? UserProfile();
    return CharacterClassModel.getById(profile.currentClassType);
  }

  void evaluateClass() {
    final box = Hive.box<UserProfile>('userProfileBox');
    final profile = box.get(0) ?? UserProfile();

    CharacterClass suggestedClassType = CharacterClass.novice;
    
    // Logic based on current progress
    if (profile.selectedTitleId == 'title_warrior') {
      suggestedClassType = CharacterClass.warrior;
    } else if (profile.stepCount >= 10000 || profile.selectedTitleId == 'title_runner') {
      suggestedClassType = CharacterClass.ranger;
    } else if (profile.level >= 5) {
      suggestedClassType = CharacterClass.warrior; 
    }

    if (profile.currentClassType != suggestedClassType.id) {
      profile.currentClassType = suggestedClassType.id;
      box.put(0, profile);
      state = CharacterClassModel.getByType(suggestedClassType);
    }
  }

  void setClass(CharacterClass classType) {
    final box = Hive.box<UserProfile>('userProfileBox');
    final profile = box.get(0) ?? UserProfile();
    profile.currentClassType = classType.id;
    box.put(0, profile);
    state = CharacterClassModel.getByType(classType);
  }

  void setClassById(String classId) {
    final classType = CharacterClass.fromId(classId);
    setClass(classType);
  }
}

final classProvider = NotifierProvider<ClassNotifier, CharacterClassModel>(() {
  return ClassNotifier();
});
