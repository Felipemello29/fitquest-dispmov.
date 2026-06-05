import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'features/home/screens/main_app_shell.dart';

void main() {
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
