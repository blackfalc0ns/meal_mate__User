import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class SavedAddressTile extends StatelessWidget {
  const SavedAddressTile({
    super.key,
    required this.icon,
    required this.title,
    required this.address,
  });

  final IconData icon;
  final String title;
  final String address;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Container(
      height: Spacing.addressesSavedTileHeight,
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.addressesCardContentPadding,
      ),
      decoration: BoxDecoration(
        color: color.surface,
        borderRadius: BorderRadius.circular(Spacing.addressesCardRadius),
        border: Border.all(color: color.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: color.shadow.withValues(alpha: 0.07),
            blurRadius: Spacing.xs,
            offset: const Offset(0, Spacing.xs),
          ),
        ],
      ),
      child: Row(
        textDirection: locale.localeName == 'ar'
            ? TextDirection.rtl
            : TextDirection.ltr,
        children: [
          Container(
            width: Spacing.addressesIconContainerSize,
            height: Spacing.addressesIconContainerSize,
            decoration: BoxDecoration(
              color: color.secondaryContainer,
              borderRadius: BorderRadius.circular(Spacing.addressesIconRadius),
            ),
            child: Icon(icon, color: color.primary, size: Spacing.iconMd),
          ),
          const SizedBox(width: Spacing.sm),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  title,
                  style: getSemiBoldStyle(
                    fontFamily: FontConstant.ibmPlexSansArabic,
                    fontSize: FontSize.size11,
                    color: color.onSurface,
                  ),
                ),
                const SizedBox(height: Spacing.xs),
                Text(
                  address,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.end,
                  style: getLightStyle(
                    fontFamily: FontConstant.ibmPlexSansArabic,
                    fontSize: FontSize.size10,
                    color: color.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: Spacing.sm),
          Container(
            width: Spacing.addressesOverflowButtonSize,
            height: Spacing.addressesOverflowButtonSize,
            decoration: BoxDecoration(
              color: color.secondaryContainer,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.more_horiz_rounded,
              color: color.primary,
              size: Spacing.iconMd,
            ),
          ),
        ],
      ),
    );
  }
}
