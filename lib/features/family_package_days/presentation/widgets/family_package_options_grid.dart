import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/family_shared/presentation/models/family_ui_models.dart';
import 'package:meal_meat_user/features/family_package_days/presentation/widgets/family_package_option_card.dart';

class FamilyPackageOptionsGrid extends StatelessWidget {
  const FamilyPackageOptionsGrid({
    super.key,
    required this.options,
    required this.onOptionSelected,
  });

  final List<FamilyPackageOptionUiModel> options;
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
                start: index == 0 ? Spacing.zero : Spacing.sm,
              ),
              child: FamilyPackageOptionCard(
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
