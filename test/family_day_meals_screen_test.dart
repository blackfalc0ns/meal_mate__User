import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/entities/family_day_details_entity.dart';
import 'package:meal_meat_user/features/family_management/calendar/presentation/screens/family_day_meals_screen.dart';
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

  testWidgets('FamilyDayMealsScreen renders correctly with empty meals state', (
    tester,
  ) async {
    await tester.pumpWidget(buildTestableWidget());
    await tester.pump();

    // Verify AppBar title matches Figma ("تفاصيل يوم")
    expect(find.text('تفاصيل يوم'), findsWidgets);

    // Verify FamilyDayCurrentRestaurantCard is rendered
    expect(find.byType(FamilyDayCurrentRestaurantCard), findsOneWidget);
    expect(find.text('المطعم الحالي'), findsOneWidget);
    expect(find.text('تغيير المطعم'), findsOneWidget);

    // Verify review button
    expect(find.byType(FamilyDayReviewButton), findsOneWidget);
    expect(find.text('مراجعة وجبات اليوم'), findsOneWidget);

    // Verify status text
    expect(find.byType(FamilyDaySelectedStatus), findsOneWidget);
    expect(find.text('لا توجد وجبات مختارة لهذا اليوم.'), findsOneWidget);
  });

  testWidgets('FamilyDayMealCard renders meal details correctly', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('ar'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: FamilyDayMealCard(
            meal: const FamilyDayMealEntity(
              mealType: 'الإفطار',
              restaurantName: 'مطعم بيت هاريس',
              mealName: 'دجاج بالأعشاب مع أرز أبيض',
              actionLabel: 'تعديل',
              imageAsset: Assets.homeBreakfast,
              iconType: FamilyDayMealIconType.breakfast,
              calories: '350',
              carbs: '38',
              protein: '32',
              fat: '9',
              caloriesLabel: 'سعرة',
              carbsLabel: 'جم كربوهيدرات',
              proteinLabel: 'جم بروتين',
              fatLabel: 'جم دهون',
            ),
            onEditPressed: () {},
          ),
        ),
      ),
    );

    expect(find.text('الإفطار'), findsOneWidget);
    expect(find.text('دجاج بالأعشاب مع أرز أبيض'), findsOneWidget);
  });

  testWidgets('FamilyDayMealsLoadingSkeleton renders correctly', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: FamilyDayMealsLoadingSkeleton())),
    );

    expect(
      find.byKey(const ValueKey('family-day-meals-loading-skeleton')),
      findsOneWidget,
    );
  });
}
