import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/widget/custom_progress_indecator.dart';
import 'package:meal_meat_user/features/auth/presentation/widgets/auth_loading_overlay.dart';

void main() {
  testWidgets('shows centered loader and blocks content while loading', (
    tester,
  ) async {
    var tapCount = 0;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AuthLoadingOverlay(
            isLoading: true,
            child: TextButton(
              onPressed: () => tapCount += 1,
              child: const Text('Continue'),
            ),
          ),
        ),
      ),
    );

    expect(find.byType(CustomProgressIndicator), findsOneWidget);
    expect(
      tester.getCenter(find.byType(CustomProgressIndicator)),
      tester.getCenter(find.byType(Scaffold)),
    );

    await tester.tap(find.text('Continue'), warnIfMissed: false);
    expect(tapCount, 0);
  });

  testWidgets('hides loader and enables content when loading completes', (
    tester,
  ) async {
    var tapCount = 0;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AuthLoadingOverlay(
            isLoading: false,
            child: TextButton(
              onPressed: () => tapCount += 1,
              child: const Text('Continue'),
            ),
          ),
        ),
      ),
    );

    expect(find.byType(CustomProgressIndicator), findsNothing);

    await tester.tap(find.text('Continue'));
    expect(tapCount, 1);
  });

  testWidgets(
    'PopScope blocks navigation while loading and preserves form input',
    (tester) async {
      final controller = TextEditingController(text: 'Initial Input');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AuthLoadingOverlay(
              isLoading: true,
              child: TextField(controller: controller),
            ),
          ),
        ),
      );

      final popScopeFinder = find.byType(PopScope);
      expect(popScopeFinder, findsOneWidget);
      final popScope = tester.widget<PopScope>(popScopeFinder);
      expect(popScope.canPop, isFalse);

      // After loading completes, form text is intact and canPop is true
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AuthLoadingOverlay(
              isLoading: false,
              child: TextField(controller: controller),
            ),
          ),
        ),
      );

      final updatedPopScope = tester.widget<PopScope>(find.byType(PopScope));
      expect(updatedPopScope.canPop, isTrue);
      expect(controller.text, 'Initial Input');
    },
  );
}
