import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_button.dart';
import 'package:meal_meat_user/core/widget/custom_warning_widget.dart';
import 'package:meal_meat_user/features/food_preferences/presentation/manager/food_preferences_event.dart';
import 'package:meal_meat_user/features/food_preferences/presentation/manager/food_preferences_view_model.dart';

class DietaryPreferencesSaveSection extends StatelessWidget {
  const DietaryPreferencesSaveSection({super.key, required this.isLoading});

  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CustomWarningWidget(
          icon: Icons.warning_rounded,
          title: locale.dietary_preferences_allergy_notice_title,
          message: locale.dietary_preferences_allergy_notice_message,
          isWarning: true,
          height: Spacing.dietaryNoticeHeight,
          backgroundColor: color.secondaryContainer,
          borderColor: color.outlineVariant,
          horizontalPadding: Spacing.md,
          iconSize: Spacing.xl,
          iconTextSpacing: Spacing.sm,
          borderRadius: Spacing.dietaryCardRadius,
          messageFontSize: FontSize.size10,
        ),
        const SizedBox(height: Spacing.sm),
        AppButton.filled(
          text: locale.dietary_preferences_save,
          onPressed: () => context.read<FoodPreferencesViewModel>().doIntent(
            const SaveFoodPreferencesEvent(),
          ),
          isLoading: isLoading,
          height: Spacing.dietarySaveButtonHeight,
          borderRadius: Spacing.dietarySaveButtonRadius,
          color: color.primary,
          textColor: color.onPrimary,
          fontSize: FontSize.size12,
        ),
      ],
    );
  }
}
