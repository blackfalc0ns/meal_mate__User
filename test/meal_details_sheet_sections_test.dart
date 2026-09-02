import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/config/theme/app_theme.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/features/meal_details/domain/entities/meal_details_entity.dart';
import 'package:meal_meat_user/features/meal_details/presentation/widgets/meal_details_sheet.dart';

void main() {
  testWidgets('meal details shows allergens and optional notes sections', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        locale: const Locale('ar'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(body: MealDetailsSheet(meal: _meal())),
      ),
    );

    expect(find.text('لاكتوز'), findsOneWidget);
    expect(find.text('مكسرات'), findsOneWidget);
    expect(find.text('ملاحظات اختيارية'), findsOneWidget);
  });
}

MealDetailsEntity _meal() {
  return const MealDetailsEntity(
    title: 'جبنة كيتو',
    description: 'شيدر وعين جمل وخيار.',
    restaurantName: 'جرين بول',
    restaurantLogo: 'GB',
    ratingTitle: 'تقييم المطعم',
    ratingValue: '',
    programLabel: 'نوع الوجبة',
    programValue: 'سناك',
    deliveryLabel: 'وقت التوصيل',
    deliveryValue: '',
    ingredientsTitle: 'المكونات',
    ingredients: [],
    nutritionTitle: 'القيم الغذائية',
    nutritionItems: [
      MealDetailsNutritionEntity(
        value: '210',
        label: 'سعرة حرارية',
        type: MealDetailsNutritionType.calories,
      ),
    ],
    macroDistributionTitle: 'توزيع العناصر الغذائية',
    macroItems: [],
    allergensTitle: 'مسببات الحساسية',
    allergens: [
      MealDetailsAllergenEntity(
        label: 'لاكتوز',
        type: MealDetailsAllergenType.lactose,
      ),
      MealDetailsAllergenEntity(
        label: 'مكسرات',
        type: MealDetailsAllergenType.nuts,
      ),
    ],
  );
}
