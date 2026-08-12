import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class DeliveryPreferenceTile extends StatelessWidget {
  const DeliveryPreferenceTile({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Expanded(
      child: Row(
        textDirection: locale.localeName == 'ar'
            ? TextDirection.rtl
            : TextDirection.ltr,
        children: [
          Container(
            width: Spacing.addressesPreferenceIconContainerSize,
            height: Spacing.addressesPreferenceIconContainerSize,
            decoration: BoxDecoration(
              color: color.secondaryContainer,
              borderRadius: BorderRadius.circular(Spacing.radiusXs),
            ),
            child: Icon(icon, color: color.primary, size: Spacing.lg),
          ),
          const SizedBox(width: Spacing.sm),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: getSemiBoldStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size10,
                    color: color.onSurface,
                  ),
                ),
                const SizedBox(height: Spacing.xs),
                Text(
                  description,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.end,
                  style: getMediumStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size8,
                    color: color.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Switch(value: true, onChanged: (_) {}),
        ],
      ),
    );
  }
}
