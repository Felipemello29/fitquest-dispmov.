import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitquest/main.dart';

void main() {
  testWidgets('FitQuest welcome message smoke test', (WidgetTester tester) async {
    // Build our app wrapped with ProviderScope and trigger a frame.
    await tester.pumpWidget(
      const ProviderScope(
        child: FitQuestApp(),
      ),
    );

    // Verify that our welcome message is displayed.
    // TODO: Update smoke test to mock Hive boxes and test the LoginScreen instead.
  });
}
