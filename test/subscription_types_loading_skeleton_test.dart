import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/config/theme/app_theme.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/core/widget/shimmer_widget.dart';
import 'package:meal_meat_user/features/subscription_types/presentation/widgets/subscription_types_loading_skeleton.dart';

void main() {
  Widget buildTestWidget({
    required Widget child,
    Locale locale = const Locale('ar'),
    TextDirection textDirection = TextDirection.rtl,
  }) {
    return MaterialApp(
      theme: AppTheme.lightTheme,
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Directionality(
        textDirection: textDirection,
        child: Scaffold(body: child),
      ),
    );
  }

  group('SubscriptionTypesLoadingSkeleton', () {
    testWidgets('renders all skeleton shimmer placeholders and no raw text', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(800, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        buildTestWidget(
          child: const SubscriptionTypesLoadingSkeleton(showBottomSpace: false),
        ),
      );
      await tester.pump();

      // Ensure no raw text title or subtitle is present
      expect(find.text('اختر نوع الاشتراك'), findsNothing);
      expect(find.byType(Text), findsNothing);

      // Verify shimmer placeholders are rendered for all 8 components:
      // (1: logo, 2: hero, 3: title, 4: subtitle, 5: card1, 6: card2, 7: notice, 8: button)
      expect(find.byType(ShimmerPlaceholder), findsNWidgets(8));
      expect(find.byType(ShimmerWidget), findsNWidgets(8));
    });
  });
}
