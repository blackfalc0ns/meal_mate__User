import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/profile/presentation/widgets/dietary_preferences_choice_chip.dart';

class DietaryPreferencesSectionCard extends StatelessWidget {
  const DietaryPreferencesSectionCard({
    super.key,
    required this.title,
    required this.icon,
    required this.options,
    required this.selectedOptions,
    required this.onOptionSelected,
    this.actionLabel,
    this.onActionPressed,
  });

  final String title;
  final IconData icon;
  final List<String> options;
  final Set<String> selectedOptions;
  final ValueChanged<String> onOptionSelected;
  final String? actionLabel;
  final VoidCallback? onActionPressed;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Semantics(
      label: '${locale.profile_dietary_preferences}: $title',
      child: Container(
        constraints: const BoxConstraints(minHeight: Spacing.dietaryCardHeight),
        padding: const EdgeInsets.all(Spacing.dietaryCardInset),
        decoration: BoxDecoration(
          color: color.surface,
          borderRadius: BorderRadius.circular(Spacing.dietaryCardRadius),
          border: Border.all(color: color.outlineVariant),
          boxShadow: [
            BoxShadow(
              color: color.shadow.withValues(alpha: 0.07),
              blurRadius: Spacing.xs,
              offset: const Offset(0, Spacing.xs),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  title,
                  style: getBoldStyle(
                    fontFamily: FontConstant.ibmPlexSansArabic,
                    fontSize: FontSize.size10,
                    color: color.onSurface,
                  ),
                ),
                const SizedBox(width: Spacing.xss),
                Container(
                  width: Spacing.dietaryIconSize,
                  height: Spacing.dietaryIconSize,
                  decoration: BoxDecoration(
                    color: color.primaryContainer,
                    borderRadius: BorderRadius.circular(Spacing.radiusXs),
                  ),
                  child: Icon(icon, color: color.primary, size: Spacing.md),
                ),
              ],
            ),
            const SizedBox(height: Spacing.md),
            Wrap(
              spacing: Spacing.sm,
              runSpacing: Spacing.sm,
              children: [
                if (actionLabel != null)
                  OutlinedButton.icon(
                    onPressed: onActionPressed,
                    icon: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: Spacing.xs,
                    ),
                    label: Text(actionLabel!),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(0, Spacing.dietaryChipHeight),
                      padding: const EdgeInsets.symmetric(
                        horizontal: Spacing.sm,
                      ),
                      textStyle: getMediumStyle(
                        fontFamily: FontConstant.ibmPlexSansArabic,
                        fontSize: FontSize.size11,
                        color: color.primary,
                      ),
                      side: BorderSide(color: color.primaryContainer),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          Spacing.dietaryChipRadius,
                        ),
                      ),
                    ),
                  ),
                ...options.map(
                  (option) => DietaryPreferencesChoiceChip(
                    label: option,
                    isSelected: selectedOptions.contains(option),
                    onSelected: (_) => onOptionSelected(option),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
