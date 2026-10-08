import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:meal_meat_user/config/theme/colors.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class CallingDriverRoleBadge extends StatelessWidget {
  const CallingDriverRoleBadge({
    super.key,
    required this.role,
  });

  final String role;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return Container(
      constraints: const BoxConstraints(
        minWidth: Spacing.callingBadgeWidth,
        minHeight: Spacing.callingBadgeHeight,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.md,
        vertical: Spacing.xs,
      ),
      decoration: BoxDecoration(
        color: color.callBadgeBackground,
        borderRadius: BorderRadius.circular(Spacing.callingBadgeRadius),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            Assets.callDriverBadgeIcon,
            width: Spacing.callingBadgeIconSize,
            height: Spacing.callingBadgeIconSize,
          ),
          const SizedBox(width: Spacing.xs),
          Text(
            role,
            style: getBoldStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size12,
              color: color.callBadgeText,
            ),
          ),
        ],
      ),
    );
  }
}
