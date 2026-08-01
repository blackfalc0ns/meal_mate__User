import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/custom_app_bar.dart';
import 'package:meal_meat_user/features/home/data/home_nutrition_details_fake_data_source.dart';
import 'package:meal_meat_user/features/home/presentation/widgets/home_nutrition_details_calorie_card.dart';
import 'package:meal_meat_user/features/home/presentation/widgets/home_nutrition_details_date_card.dart';
import 'package:meal_meat_user/features/home/presentation/widgets/home_nutrition_details_macro_card.dart';
import 'package:meal_meat_user/features/home/presentation/widgets/home_nutrition_details_section_title.dart';
import 'package:meal_meat_user/features/home/presentation/widgets/home_nutrition_details_tip_card.dart';

class HomeNutritionDetailsScreen extends StatelessWidget {
  const HomeNutritionDetailsScreen({super.key});

  static const _dataSource = HomeNutritionDetailsFakeDataSource();

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final details = _dataSource.getDetails();

    return Scaffold(
      backgroundColor: color.surface,
      appBar: CustomAppBar(
        title: locale.nutrition_details_title,
        titleFontSize: FontSize.size14,
        backgroundColor: color.surface,
        showShadow: false,
        onBackPressed: () => Navigator.maybePop(context),
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsetsDirectional.only(
            start: Spacing.nutritionDetailsHorizontalPadding,
            end: Spacing.nutritionDetailsHorizontalPadding,
            bottom: Spacing.xxxl,
          ),
          child: Column(
            children: [
              const SizedBox(height: Spacing.sm),
              const HomeNutritionDetailsDateCard(),
              const SizedBox(height: Spacing.nutritionDetailsSectionGap),
              HomeNutritionDetailsCalorieCard(details: details),
              const SizedBox(height: Spacing.base),
              HomeNutritionDetailsSectionTitle(
                title: locale.home_main_nutrients,
              ),
              const SizedBox(height: Spacing.sm),
              Column(
                children: [
                  for (final macro in details.macros) ...[
                    HomeNutritionDetailsMacroCard(macro: macro),
                    const SizedBox(height: Spacing.nutritionDetailsListGap),
                  ],
                ],
              ),
              const SizedBox(height: Spacing.lg),
              const HomeNutritionDetailsTipCard(),
            ],
          ),
        ),
      ),
    );
  }
}
