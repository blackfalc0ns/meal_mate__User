import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_button.dart';
import 'package:meal_meat_user/core/widget/custom_warning_widget.dart';
import 'package:meal_meat_user/features/food_preferences/presentation/manager/food_preferences_event.dart';
import 'package:meal_meat_user/features/food_preferences/presentation/manager/food_preferences_view_model.dart';

class AddAllergySaveSection extends StatelessWidget {
  const AddAllergySaveSection({super.key, required this.isLoading});

  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CustomWarningWidget(
          messageFontSize: FontSize.size10,
          icon: Icons.warning_rounded,
          title: locale.add_allergy_note_title,
          message: locale.add_allergy_note_message,
          isWarning: true,
          height: Spacing.addAllergyNoticeHeight,
          backgroundColor: color.secondaryContainer,
          borderColor: color.outlineVariant,
          horizontalPadding: Spacing.sm,
          iconTextSpacing: Spacing.xs,
          borderRadius: Spacing.addAllergyNoticeRadius,
        ),
        const SizedBox(height: Spacing.md),
        AppButton.filled(
          text: locale.add_allergy_save,
          onPressed: isLoading
              ? null
              : () {
                  FocusManager.instance.primaryFocus?.unfocus();
                  context.read<FoodPreferencesViewModel>().doIntent(
                    const SaveFoodPreferencesAllergiesEvent(),
                  );
                },
          isLoading: false,
          height: Spacing.addAllergyButtonHeight,
          borderRadius: Spacing.addAllergyButtonRadius,
          textColor: color.onPrimary,
          fontSize: FontSize.size12,
        ),
      ],
    );
  }
}
