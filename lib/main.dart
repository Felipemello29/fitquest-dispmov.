import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/theme/app_theme.dart';
import 'features/home/screens/main_app_shell.dart';
import 'core/models/user_profile.dart';
import 'core/models/quest_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(UserProfileAdapter());
  Hive.registerAdapter(QuestAdapter());
  await Hive.openBox<UserProfile>('userProfileBox');
  await Hive.openBox<Quest>('questsBox');
  await Hive.openBox<String>('appStateBox');

  runApp(
    const ProviderScope(
      child: FitQuestApp(),
    ),
  );
}

/// The root widget of the FitQuest application.
class FitQuestApp extends StatelessWidget {
  const FitQuestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FitQuest',
      theme: RPGTheme.darkTheme,
      home: const MainAppShell(),
    );
  }
}
