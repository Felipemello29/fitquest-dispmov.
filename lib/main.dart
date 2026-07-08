import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/theme/app_theme.dart';
import 'features/home/screens/main_app_shell.dart';
import 'core/models/user_profile.dart';
import 'core/models/quest_model.dart';
import 'core/models/activity_record_model.dart';
import 'features/dynamic_quests/models/dynamic_quest_adapters.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/auth/providers/auth_provider.dart';
import 'core/repositories/repository_providers.dart';

final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  
  // Register existing adapters
  Hive.registerAdapter(UserProfileAdapter());
  Hive.registerAdapter(QuestAdapter());
  Hive.registerAdapter(ActivityRecordAdapter());
  
  // Register new dynamic quest adapters
  Hive.registerAdapter(DynamicQuestAdapter());
  Hive.registerAdapter(QuestCategoryAdapter());
  Hive.registerAdapter(QuestDifficultyAdapter());
  Hive.registerAdapter(QuestRequirementAdapter());
  Hive.registerAdapter(QuestRewardAdapter());
  
  // Open boxes
  await Hive.openBox<UserProfile>('userProfileBox');
  await Hive.openBox<Quest>('missoesBox');
  await Hive.openBox<ActivityRecord>('activityRecordsBox');
  await Hive.openBox<String>('appStateBox');

  runApp(
    const ProviderScope(
      child: FitQuestApp(),
    ),
  );
}

/// The root widget of the FitQuest application.
class FitQuestApp extends ConsumerWidget {
  const FitQuestApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authUser = ref.watch(authProvider);

    return MaterialApp(
      title: 'FitQuest',
      scaffoldMessengerKey: rootScaffoldMessengerKey,
      theme: RPGTheme.tavernTheme,
      home: authUser == null ? const LoginScreen() : const MainAppShell(),
    );
  }
}
