import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/colors.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';

class OffersSectionHeader extends StatelessWidget {
  const OffersSectionHeader({
    super.key,
    required this.title,
    this.actionLabel,
    this.onActionTap,
    this.icon,
    this.iconColor = AppColors.primaryDark,
    this.actionColor = AppColors.primaryDark,
  });

  final String title;
  final String? actionLabel;
  final VoidCallback? onActionTap;
  final IconData? icon;
  final Color iconColor;
  final Color actionColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        Spacing.screenH,
        Spacing.sm,
        Spacing.screenH,
        0,
      ),
      child: Row(
        textDirection: TextDirection.rtl,
        children: [
          Row(
            textDirection: TextDirection.rtl,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) Icon(icon, size: 18, color: iconColor),
              if (icon != null) const SizedBox(width: 4),
              Text(
                title,
                style: getBoldStyle(
                  fontFamily: FontConstant.ibmPlexSansArabic,
                  fontSize: FontSize.size18,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          if (actionLabel != null) const Spacer(),
          if (actionLabel != null)
            GestureDetector(
              onTap: onActionTap,
              child: Row(
                textDirection: TextDirection.ltr,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 14,
                    color: actionColor,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    actionLabel!,
                    style: getBoldStyle(
                      fontFamily: FontConstant.ibmPlexSansArabic,
                      fontSize: FontSize.size14,
                      color: actionColor,
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
