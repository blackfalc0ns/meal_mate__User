import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_button.dart';
import 'package:meal_meat_user/features/food_preferences/presentation/manager/food_preferences_event.dart';
import 'package:meal_meat_user/features/food_preferences/presentation/manager/food_preferences_view_model.dart';

class DietaryPreferencesSaveSection extends StatelessWidget {
  const DietaryPreferencesSaveSection({super.key, required this.isLoading});

  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return ColoredBox(
      color: color.surface,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Spacing.screenH,
            vertical: Spacing.sm,
          ),
          child: AppButton.filled(
            text: locale.dietary_preferences_save,
            onPressed: isLoading
                ? null
                : () {
                    FocusManager.instance.primaryFocus?.unfocus();
                    context.read<FoodPreferencesViewModel>().doIntent(
                      const SaveFoodPreferencesEvent(),
                    );
                  },
            isLoading: false,
            height: Spacing.dietarySaveButtonHeight,
            borderRadius: Spacing.dietarySaveButtonRadius,
            color: color.primary,
            textColor: color.onPrimary,
            fontSize: FontSize.size12,
          ),
        ),
      ),
    );
  }
}
