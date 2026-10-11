import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/core/widget/shimmer_widget.dart';
import 'package:meal_meat_user/features/subscription_upgrade/presentation/widgets/restaurant_tier_confirmation_loading_skeleton.dart';
import 'package:meal_meat_user/features/subscription_upgrade/presentation/widgets/restaurant_tier_entry_animation.dart';
import 'package:meal_meat_user/features/subscription_upgrade/presentation/widgets/restaurant_tier_selection_loading_skeleton.dart';

void main() {
  testWidgets(
    'RestaurantTierEntryAnimation returns child directly when animations are disabled',
    (tester) async {
      await tester.pumpWidget(
        const MediaQuery(
          data: MediaQueryData(disableAnimations: true),
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: RestaurantTierEntryAnimation(
              child: Text('Test Animated Content'),
            ),
          ),
        ),
      );

      expect(find.text('Test Animated Content'), findsOneWidget);
    },
  );

  testWidgets(
    'RestaurantTierEntryAnimation renders child with animation when enabled',
    (tester) async {
      await tester.pumpWidget(
        const MediaQuery(
          data: MediaQueryData(disableAnimations: false),
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: RestaurantTierEntryAnimation(
              child: Text('Test Animated Content'),
            ),
          ),
        ),
      );

      expect(find.text('Test Animated Content'), findsOneWidget);
      await tester.pumpAndSettle();
      expect(find.text('Test Animated Content'), findsOneWidget);
    },
  );

  testWidgets(
    'RestaurantTierSelectionLoadingSkeleton renders shimmer placeholders',
    (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: Locale('ar'),
          home: RestaurantTierSelectionLoadingSkeleton(),
        ),
      );

      expect(
        find.byType(RestaurantTierSelectionLoadingSkeleton),
        findsOneWidget,
      );
      expect(find.byType(ShimmerPlaceholder), findsWidgets);
    },
  );

  testWidgets(
    'RestaurantTierConfirmationLoadingSkeleton renders shimmer placeholders',
    (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: Locale('ar'),
          home: RestaurantTierConfirmationLoadingSkeleton(),
        ),
      );

      expect(
        find.byType(RestaurantTierConfirmationLoadingSkeleton),
        findsOneWidget,
      );
      expect(find.byType(ShimmerPlaceholder), findsWidgets);
    },
  );
}
