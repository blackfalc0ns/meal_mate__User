import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/config/theme/app_theme.dart';
import 'package:meal_meat_user/core/widget/app_subscription_button.dart';

void main() {
  Widget buildTestWidget({
    required Widget child,
    TextDirection textDirection = TextDirection.rtl,
  }) {
    return MaterialApp(
      theme: AppTheme.lightTheme,
      home: Directionality(
        textDirection: textDirection,
        child: Scaffold(body: child),
      ),
    );
  }

  group('AppSubscriptionButton.next Tests', () {
    testWidgets('renders chevron_left_rounded in RTL', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          textDirection: TextDirection.rtl,
          child: AppSubscriptionButton.next(text: 'التالي', onPressed: () {}),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('التالي'), findsOneWidget);
      expect(find.byIcon(Icons.chevron_left_rounded), findsOneWidget);
      expect(find.byIcon(Icons.chevron_right_rounded), findsNothing);
    });

    testWidgets('renders chevron_right_rounded in LTR', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          textDirection: TextDirection.ltr,
          child: AppSubscriptionButton.next(text: 'Next', onPressed: () {}),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Next'), findsOneWidget);
      expect(find.byIcon(Icons.chevron_right_rounded), findsOneWidget);
      expect(find.byIcon(Icons.chevron_left_rounded), findsNothing);
    });

    testWidgets('triggers callback on tap when enabled', (tester) async {
      var tapped = false;

      await tester.pumpWidget(
        buildTestWidget(
          child: AppSubscriptionButton.next(
            text: 'التالي',
            onPressed: () => tapped = true,
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byType(AppSubscriptionButton));
      expect(tapped, isTrue);
    });

    testWidgets('shows loading state when isLoading is true', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          child: AppSubscriptionButton.next(
            text: 'التالي',
            isLoading: true,
            onPressed: () {},
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}
