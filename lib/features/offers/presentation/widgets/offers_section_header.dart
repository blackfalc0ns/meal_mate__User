import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class OffersSectionHeader extends StatelessWidget {
  const OffersSectionHeader({
    super.key,
    required this.title,
    this.actionLabel,
    this.onActionTap,
    this.icon,
    this.iconColor,
    this.actionColor,
  });

  final String title;
  final String? actionLabel;
  final VoidCallback? onActionTap;
  final IconData? icon;
  final Color? iconColor;
  final Color? actionColor;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: Spacing.sm,
        horizontal: Spacing.screenH,
      ),
      child: Row(
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null)
                Icon(
                  icon,
                  size: Spacing.iconSm + Spacing.xs / 2,
                  color: iconColor ?? color.primary,
                  semanticLabel: locale.offers_featured_section_title,
                ),
              if (icon != null) const SizedBox(width: Spacing.xs),
              Text(
                title,
                style: getSemiBoldStyle(
                  fontFamily: FontConstant.ibmPlexSansArabic,
                  fontSize: FontSize.size15,
                  color: color.onSurface,
                ),
              ),
            ],
          ),
          if (actionLabel != null) const Spacer(),
          if (actionLabel != null)
            GestureDetector(
              onTap: onActionTap,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: Spacing.iconSm,
                    color: actionColor ?? color.primary,
                  ),
                  const SizedBox(width: Spacing.xs),
                  Text(
                    actionLabel!,
                    style: getBoldStyle(
                      fontFamily: FontConstant.ibmPlexSansArabic,
                      fontSize: FontSize.size14,
                      color: actionColor ?? color.primary,
                    ),
                  ),
                ],
              ),
            ),
          if (actionLabel == null) const Spacer(),
        ],
      ),
    );
  }
}
