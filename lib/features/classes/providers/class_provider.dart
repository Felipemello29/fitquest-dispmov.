import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../core/models/user_profile.dart';
import '../models/character_class.dart';

class ClassNotifier extends Notifier<CharacterClass> {
  @override
  CharacterClass build() {
    final box = Hive.box<UserProfile>('userProfileBox');
    final profile = box.get(0) ?? UserProfile();
    return CharacterClass.getById(profile.currentClassType);
  }

  void evaluateClass() {
    final box = Hive.box<UserProfile>('userProfileBox');
    final profile = box.get(0) ?? UserProfile();

    String suggestedClassId = 'novice';
    
    // Logic based on current progress
    if (profile.selectedTitleId == 'title_warrior') {
      suggestedClassId = 'warrior';
    } else if (profile.stepCount >= 10000 || profile.selectedTitleId == 'title_runner') {
      suggestedClassId = 'ranger';
    } else if (profile.level >= 5) {
      suggestedClassId = 'warrior'; 
    }

    if (profile.currentClassType != suggestedClassId) {
      profile.currentClassType = suggestedClassId;
      box.put(0, profile);
      state = CharacterClass.getById(suggestedClassId);
    }
  }

  void setClass(String classId) {
    final box = Hive.box<UserProfile>('userProfileBox');
    final profile = box.get(0) ?? UserProfile();
    profile.currentClassType = classId;
    box.put(0, profile);
    state = CharacterClass.getById(classId);
  }
}

final classProvider = NotifierProvider<ClassNotifier, CharacterClass>(() {
  return ClassNotifier();
});
