import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class MealDetailsInfoItem extends StatelessWidget {
  const MealDetailsInfoItem({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: Spacing.iconLg,
            height: Spacing.iconLg,
            decoration: BoxDecoration(
              color: color.tertiaryContainer,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: Spacing.iconSm, color: color.primary),
          ),
          const SizedBox(width: Spacing.sm),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: getMediumStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size10,
                    color: color.onSurfaceVariant,
                  ).copyWith(height: locale.localeName == 'ar' ? 1.3 : 1.1),
                ),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: getBoldStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size9,
                    color: color.onSurface,
                  ).copyWith(height: locale.localeName == 'ar' ? 1.4 : 1.2),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
