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
    required this.headerTopInset,
    required this.choicesTopInset,
    required this.choicesSpacing,
    this.actionLabel,
    this.onActionPressed,
    required this.iconColor,
  });

  final String title;
  final IconData icon;
  final List<String> options;
  final Set<String> selectedOptions;
  final ValueChanged<String> onOptionSelected;
  final double headerTopInset;
  final double choicesTopInset;
  final double choicesSpacing;
  final String? actionLabel;
  final VoidCallback? onActionPressed;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return Container(
      constraints: const BoxConstraints(minHeight: Spacing.dietaryCardHeight),
      padding: EdgeInsets.only(
        top: headerTopInset,
        left: Spacing.dietaryCardInset,
      ),
      decoration: BoxDecoration(
        color: color.surface,
        borderRadius: BorderRadius.circular(Spacing.dietaryCardRadius),
        border: Border.all(
          color: color.outlineVariant,
          width: Spacing.dietaryCardBorderWidth,
        ),
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
          Padding(
            padding: const EdgeInsetsDirectional.only(start: Spacing.xss),
            child: Align(
              alignment: AlignmentDirectional.topStart,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, color: iconColor, size: Spacing.lg),
                  const SizedBox(width: Spacing.xss),
                  Text(
                    title,
                    style: getBoldStyle(
                      fontFamily: FontConstant.alexandria,
                      fontSize: FontSize.size12,
                      color: color.onSurface,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height:
                choicesTopInset -
                headerTopInset -
                Spacing.dietaryHeaderIconHeight,
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                ...options.map(
                  (option) => Padding(
                    padding: EdgeInsetsDirectional.only(
                      start: choicesSpacing,
                      //choicesSpacing,
                    ),
                    child: DietaryPreferencesChoiceChip(
                      label: option,
                      isSelected: selectedOptions.contains(option),
                      onSelected: (_) => onOptionSelected(option),
                    ),
                  ),
                ),
                if (actionLabel != null)
                  Padding(
                    padding: EdgeInsetsDirectional.only(start: choicesSpacing),
                    child: OutlinedButton.icon(
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
                          fontFamily: FontConstant.alexandria,
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
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
