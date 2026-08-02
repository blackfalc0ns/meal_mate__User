import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class FamilySetupActivityOption extends StatelessWidget {
  const FamilySetupActivityOption({
    super.key,
    required this.label,
    this.selected = false,
  });

  final String label;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Semantics(
      label: '${locale.family_activity_level} $label',
      selected: selected,
      child: Container(
        width: Spacing.familySetupActivityOptionWidth,
        height: Spacing.familySetupActivityOptionHeight,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: color.surface,
          border: Border.all(
            color: selected ? color.primary : color.surface,
            width: selected ? Spacing.border : Spacing.hairline,
          ),
          borderRadius: BorderRadius.circular(Spacing.radiusPill),
        ),
        child: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: getRegularStyle(
            fontFamily: FontConstant.alexandria,
            fontSize: FontSize.size10,
            color: selected ? color.primary : color.onSurface,
          ),
        ),
      ),
    );
  }
}
