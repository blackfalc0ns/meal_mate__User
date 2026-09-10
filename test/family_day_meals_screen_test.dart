import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/screens/family_day_meals_screen.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/family_day_current_restaurant_card.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/family_day_meal_card.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/family_day_meals_loading_skeleton.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/family_day_review_button.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/family_day_selected_status.dart';

void main() {
  Widget buildTestableWidget({Locale locale = const Locale('ar')}) {
    return MaterialApp(
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const FamilyDayMealsScreen(),
    );
  }

  testWidgets('FamilyDayMealsScreen renders fallback with Figma 2929-7148 design components',
      (tester) async {
    await tester.pumpWidget(buildTestableWidget());
    await tester.pump();

    // Verify AppBar title matches Figma ("تفاصيل يوم")
    expect(find.text('تفاصيل يوم'), findsWidgets);

    // Verify FamilyDayCurrentRestaurantCard is rendered
    expect(find.byType(FamilyDayCurrentRestaurantCard), findsOneWidget);
    expect(find.text('المطعم الحالي'), findsOneWidget);
    expect(find.text('تغيير المطعم'), findsOneWidget);

    // Verify meal cards are rendered
    expect(find.byType(FamilyDayMealCard), findsWidgets);

    // Verify review button
    expect(find.byType(FamilyDayReviewButton), findsOneWidget);
    expect(find.text('مراجعة وجبات اليوم'), findsOneWidget);

    // Verify status text
    expect(find.byType(FamilyDaySelectedStatus), findsOneWidget);
    expect(find.text('تم اختيار جميع الوجبات'), findsOneWidget);
  });

  testWidgets('FamilyDayMealsLoadingSkeleton renders correctly', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: FamilyDayMealsLoadingSkeleton(),
        ),
      ),
    );

    expect(find.byKey(const ValueKey('family-day-meals-loading-skeleton')), findsOneWidget);
  });
}
