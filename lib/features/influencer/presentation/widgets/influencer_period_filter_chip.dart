import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class InfluencerPeriodFilterChip extends StatelessWidget {
  const InfluencerPeriodFilterChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return InkWell(
      borderRadius: BorderRadius.circular(
        Spacing.influencerStatsPeriodChipRadius,
      ),
      onTap: onTap,
      child: Container(
        width: Spacing.influencerStatsPeriodChipWidth,
        height: Spacing.influencerStatsPeriodChipHeight,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? color.primary : color.surface,
          borderRadius: BorderRadius.circular(
            Spacing.influencerStatsPeriodChipRadius,
          ),
          border: selected ? null : Border.all(color: color.outlineVariant),
        ),
        child: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: (selected ? getBoldStyle : getRegularStyle)(
            fontFamily: FontConstant.alexandria,
            fontSize: FontSize.size9,
            color: selected ? color.onPrimary : color.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}
