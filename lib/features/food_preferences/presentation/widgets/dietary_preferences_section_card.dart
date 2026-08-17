import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/food_preferences/presentation/widgets/dietary_preferences_choice_chip.dart';
import 'package:meal_meat_user/features/food_preferences/presentation/widgets/dietary_preferences_option.dart';
import 'package:meal_meat_user/features/food_preferences/presentation/widgets/dietary_preferences_options_bottom_sheet.dart';

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
    this.singleSelection = false,
    required this.iconColor,
  });

  final String title;
  final IconData icon;
  final List<DietaryPreferencesOption> options;
  final Set<String> selectedOptions;
  final ValueChanged<String> onOptionSelected;
  final double headerTopInset;
  final double choicesTopInset;
  final double choicesSpacing;
  final String? actionLabel;
  final VoidCallback? onActionPressed;
  final bool singleSelection;
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
          Padding(
            padding: EdgeInsetsDirectional.only(
              start: choicesSpacing,
              end: Spacing.dietaryCardInset,
              bottom: Spacing.sm,
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(Spacing.dietaryChipRadius),
              onTap: () => _showOptionsBottomSheet(context),
              child: Container(
                padding: const EdgeInsetsDirectional.only(
                  start: Spacing.sm,
                  end: Spacing.xs,
                  top: Spacing.xs,
                  bottom: Spacing.xs,
                ),
                decoration: BoxDecoration(
                  color: color.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(
                    Spacing.dietaryChipRadius,
                  ),
                  border: Border.all(color: color.outlineVariant),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Wrap(
                        spacing: choicesSpacing,
                        runSpacing: Spacing.xs,
                        children: [
                          ..._visibleOptions.map(
                            (option) => DietaryPreferencesChoiceChip(
                              label: option.label,
                              isSelected: selectedOptions.contains(option.code),
                              onSelected: (_) =>
                                  _showOptionsBottomSheet(context),
                            ),
                          ),
                          if (actionLabel != null)
                            OutlinedButton.icon(
                              onPressed: onActionPressed,
                              icon: Icon(
                                Icons.arrow_back_ios_new_rounded,
                                size: Spacing.xs,
                              ),
                              label: Text(actionLabel!),
                              style: OutlinedButton.styleFrom(
                                minimumSize: const Size(
                                  0,
                                  Spacing.dietaryChipHeight,
                                ),
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
                        ],
                      ),
                    ),
                    const SizedBox(width: Spacing.xs),
                    Container(
                      width: Spacing.lg,
                      height: Spacing.lg,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: color.primaryContainer,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        size: Spacing.iconSm,
                        color: color.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<DietaryPreferencesOption> get _visibleOptions {
    final selected = options
        .where((option) => selectedOptions.contains(option.code))
        .toList();

    return selected.isEmpty ? options.take(3).toList() : selected;
  }

  Future<void> _showOptionsBottomSheet(BuildContext context) {
    final color = context.colorScheme;

    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: color.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(Spacing.bottomSheetRadius),
        ),
      ),
      builder: (_) => DietaryPreferencesOptionsBottomSheet(
        title: title,
        icon: icon,
        iconColor: iconColor,
        options: options,
        selectedOptions: selectedOptions,
        onOptionSelected: onOptionSelected,
        singleSelection: singleSelection,
      ),
    );
  }
}
