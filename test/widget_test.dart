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
    expect(find.text('Welcome to FitQuest'), findsOneWidget);
    expect(find.text('Your epic fitness journey starts here.'), findsOneWidget);
  });
}
