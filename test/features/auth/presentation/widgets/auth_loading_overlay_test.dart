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
        home: AuthLoadingOverlay(
          isLoading: true,
          child: TextButton(
            onPressed: () => tapCount += 1,
            child: const Text('Continue'),
          ),
        ),
      ),
    );

    expect(find.byType(CustomProgressIndicator), findsOneWidget);
    expect(
      tester.getCenter(find.byType(CustomProgressIndicator)),
      tester.getCenter(find.byType(AuthLoadingOverlay)),
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
        home: AuthLoadingOverlay(
          isLoading: false,
          child: TextButton(
            onPressed: () => tapCount += 1,
            child: const Text('Continue'),
          ),
        ),
      ),
    );

    expect(find.byType(CustomProgressIndicator), findsNothing);

    await tester.tap(find.text('Continue'));
    expect(tapCount, 1);
  });
}
