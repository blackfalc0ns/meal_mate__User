import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class MealDetailsMacroColumn extends StatelessWidget {
  const MealDetailsMacroColumn({
    super.key,
    required this.percent,
    required this.value,
    required this.label,
    required this.icon,
    required this.indicatorColor,
  });

  final String percent;
  final String value;
  final String label;
  final IconData icon;
  final Color indicatorColor;

  double get _progressFraction {
    final clean = percent.replaceAll(RegExp(r'[^0-9.]'), '');
    final parsed = double.tryParse(clean);
    if (parsed == null || parsed <= 0) return 0.25;
    return (parsed / 100.0).clamp(0.08, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            percent,
            textAlign: TextAlign.center,
            style: getSemiBoldStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size10,
              color: indicatorColor,
            ),
          ),
          const SizedBox(height: Spacing.xxs),
          Text(
            value,
            textAlign: TextAlign.center,
            style: getBoldStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size12,
              color: color.onSurface,
            ),
          ),
          const SizedBox(height: Spacing.xxs),
          Text(
            label,
            textAlign: TextAlign.center,
            style: getMediumStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size10,
              color: indicatorColor,
            ),
          ),
          const SizedBox(height: Spacing.xs),
          Icon(icon, size: Spacing.iconSm, color: indicatorColor),
          const SizedBox(height: Spacing.xs),
          Stack(
            alignment: AlignmentDirectional.centerStart,
            children: [
              Container(
                width: 44.0,
                height: 3.5,
                decoration: BoxDecoration(
                  color: color.outlineVariant.withValues(alpha: 0.35),
                  borderRadius: BorderRadius.circular(Spacing.radiusPill),
                ),
              ),
              Container(
                width: 44.0 * _progressFraction,
                height: 3.5,
                decoration: BoxDecoration(
                  color: indicatorColor,
                  borderRadius: BorderRadius.circular(Spacing.radiusPill),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
