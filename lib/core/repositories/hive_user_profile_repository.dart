library hive_repositories;

import 'dart:async';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/user_profile.dart';
import '../constants/app_constants.dart';
import 'repository_interfaces.dart';

class HiveUserProfileRepository implements UserProfileRepository {
  static const String _boxName = 'userProfileBox';
  late Box<UserProfile> _box;
  
  @override
  Future<void> init() async {
    _box = await Hive.openBox<UserProfile>(_boxName);
  }

  @override
  Future<void> close() async {
    await _box.close();
  }

  @override
  Stream<UserProfile?> watchProfile() {
    return _box.watch(key: AppConstants.userProfileKey).asyncMap((_) async => await getProfile());
  }

  @override
  Future<UserProfile?> getProfile() async {
    return _box.get(AppConstants.userProfileKey);
  }

  @override
  Future<void> saveProfile(UserProfile profile) async {
    await _box.put(AppConstants.userProfileKey, profile);
  }

  @override
  Future<void> updateSteps(int steps) async {
    final profile = await getProfile() ?? UserProfile();
    final updated = profile.copyWith(stepCount: steps);
    await saveProfile(updated);
  }

  @override
  Future<void> addExperience(int xp) async {
    final profile = await getProfile() ?? UserProfile();
    final updated = profile.copyWith(evolutionPoints: profile.evolutionPoints + xp);
    await saveProfile(updated);
  }

  @override
  Future<void> updateLevel(int level) async {
    final profile = await getProfile() ?? UserProfile();
    final updated = profile.copyWith(level: level);
    await saveProfile(updated);
  }

  @override
  Future<void> setCharacterClass(String classId) async {
    final profile = await getProfile() ?? UserProfile();
    final updated = profile.copyWith(currentClassType: classId);
    await saveProfile(updated);
  }

  @override
  Future<void> setSelectedTitle(String? titleId) async {
    final profile = await getProfile() ?? UserProfile();
    final updated = profile.copyWith(selectedTitleId: titleId);
    await saveProfile(updated);
  }
}