import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/routing/routing_extensions.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/custom_app_bar.dart';
import 'package:meal_meat_user/features/subscription_settings/data/family_meal_selection_fake_data_source.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/family_meal_selection_bottom_bar.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/family_meal_selection_card.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/family_meal_selection_category_chips.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/family_meal_selection_macros_card.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/family_meal_selection_stepper.dart';

class FamilyMealSelectionScreen extends StatefulWidget {
  const FamilyMealSelectionScreen({super.key});

  static const _dataSource = FamilyMealSelectionFakeDataSource();

  @override
  State<FamilyMealSelectionScreen> createState() =>
      _FamilyMealSelectionScreenState();
}

class _FamilyMealSelectionScreenState extends State<FamilyMealSelectionScreen> {
  int _selectedCategoryIndex = 0;
  String _selectedMealId = '1';

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final data = FamilyMealSelectionScreen._dataSource.getContent(locale);

    return Scaffold(
      backgroundColor: color.surface,
      appBar: CustomAppBar(
        titleWidget: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              locale.family_meal_selection_title(data.memberName),
              style: getBoldStyle(
                fontFamily: FontConstant.alexandria,
                fontSize: FontSize.size16,
                color: color.onSurface,
              ),
            ),
            const SizedBox(height: Spacing.xs / 2),
            Text(
              locale.family_meal_selection_context(
                data.restaurantName,
                data.slotName,
              ),
              style: getRegularStyle(
                fontFamily: FontConstant.alexandria,
                fontSize: FontSize.size10,
                color: color.onSurfaceVariant,
              ),
            ),
          ],
        ),
        onBackPressed: () => Navigator.maybePop(context),
      ),
      bottomNavigationBar: FamilyMealSelectionBottomBar(
        selectedCount: data.selectedCount,
        totalCount: data.totalCount,
        slotAndDateLabel: '${data.slotName} • ${data.dateLabel}',
        onContinue: () {
          context.pushNamed(AppRoutes.familyReviewMemberMeals);
        },
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(
            horizontal: Spacing.screenH,
            vertical: Spacing.sm,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const FamilyMealSelectionStepper(currentStep: 2),
              const SizedBox(height: Spacing.md),
              FamilyMealSelectionMacrosCard(macros: data.macros),
              const SizedBox(height: Spacing.base),
              FamilyMealSelectionCategoryChips(
                selectedIndex: _selectedCategoryIndex,
                onSelected: (index) {
                  setState(() => _selectedCategoryIndex = index);
                },
              ),
              const SizedBox(height: Spacing.base),
              for (final meal in data.meals)
                FamilyMealSelectionCard(
                  meal: FamilyMealItemData(
                    id: meal.id,
                    title: meal.title,
                    description: meal.description,
                    calories: meal.calories,
                    protein: meal.protein,
                    carbs: meal.carbs,
                    fat: meal.fat,
                    tags: meal.tags,
                    imageAsset: meal.imageAsset,
                    isSelected: meal.id == _selectedMealId,
                  ),
                  onSelect: () {
                    setState(() => _selectedMealId = meal.id);
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
