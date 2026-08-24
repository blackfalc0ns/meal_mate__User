import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/family_shared/presentation/models/family_ui_models.dart';
import 'package:meal_meat_user/features/family_package_days/presentation/widgets/family_day_option_card.dart';

class FamilyDayOptionsRow extends StatelessWidget {
  const FamilyDayOptionsRow({
    super.key,
    required this.options,
    required this.onOptionSelected,
  });

  final List<FamilyDayOptionUiModel> options;
  final ValueChanged<int> onOptionSelected;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return IconTheme(
      data: IconThemeData(color: color.primary),
      child: Row(
        children: List.generate(options.length, (index) {
          return Expanded(
            child: Padding(
              padding: EdgeInsetsDirectional.only(
                start: index == 0 ? Spacing.zero : Spacing.md,
              ),
              child: FamilyDayOptionCard(
                option: options[index],
                onTap: () => onOptionSelected(index),
              ),
            ),
          );
        }),
      ),
    );
  }
}
