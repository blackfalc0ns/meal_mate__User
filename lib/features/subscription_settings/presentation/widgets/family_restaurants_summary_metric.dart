import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class FamilyRestaurantsSummaryMetric extends StatelessWidget {
  const FamilyRestaurantsSummaryMetric({
    super.key,
    required this.value,
    required this.label,
    required this.icon,
  });

  final String value;
  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (value.isNotEmpty)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Text(
                    value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: getBoldStyle(
                      fontFamily: FontConstant.alexandria,
                      fontSize: FontSize.size14,
                      color: color.onSurface,
                    ),
                  ),
                ),
                const SizedBox(width: Spacing.xxs),
                Icon(icon, color: color.primary, size: Spacing.iconSm),
              ],
            )
          else
            Icon(icon, color: color.primary, size: Spacing.iconMd),
          const SizedBox(height: Spacing.xs),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: getRegularStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size10,
              color: value.isNotEmpty
                  ? color.onSurfaceVariant
                  : color.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
