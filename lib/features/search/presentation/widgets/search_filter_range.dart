import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class SearchFilterRange extends StatelessWidget {
  const SearchFilterRange({
    super.key,
    required this.label,
    required this.icon,
    required this.range,
    required this.min,
    required this.max,
    required this.onChanged,
  });

  final String label;
  final IconData icon;
  final RangeValues range;
  final double min;
  final double max;
  final ValueChanged<RangeValues> onChanged;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Semantics(
      label: locale.search_quick_results,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Icon(icon, size: Spacing.iconSm, color: color.primary),
              const SizedBox(width: Spacing.xs),
              Text(
                label,
                style: getSemiBoldStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size11,
                  color: color.onSurface,
                ),
              ),
            ],
          ),
          SizedBox(
            height: Spacing.searchFilterRangeHeight,
            child: Row(
              children: [
                Container(
                  width: Spacing.xxxl - Spacing.xss,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(color: color.outlineVariant),
                    borderRadius: BorderRadius.circular(Spacing.radiusXs),
                  ),
                  child: Text(
                    range.start.round().toString(),
                    style: getMediumStyle(
                      fontFamily: FontConstant.alexandria,
                      fontSize: FontSize.size9,
                      color: color.primary,
                    ),
                  ),
                ),
                Expanded(
                  child: RangeSlider(
                    values: range,
                    min: min,
                    max: max,
                    divisions: (max - min).round(),
                    labels: RangeLabels(
                      range.start.round().toString(),
                      range.end.round().toString(),
                    ),
                    onChanged: onChanged,
                  ),
                ),
                Container(
                  width: Spacing.xxxl - Spacing.xss,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(color: color.outlineVariant),
                    borderRadius: BorderRadius.circular(Spacing.radiusXs),
                  ),
                  child: Text(
                    range.end.round().toString(),
                    style: getMediumStyle(
                      fontFamily: FontConstant.alexandria,
                      fontSize: FontSize.size9,
                      color: color.primary,
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
