import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class ProfileBillingAction extends StatelessWidget {
  const ProfileBillingAction({
    required this.iconAsset,
    required this.label,
    required this.actionColor,
    super.key,
  });

  final String iconAsset;
  final String label;
  final Color actionColor;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    final textDirection = locale.localeName == 'ar'
        ? TextDirection.rtl
        : TextDirection.ltr;

    return Container(
      height: Spacing.profileBillingActionCardHeight,
      decoration: BoxDecoration(
        color: color.surface,
        borderRadius: BorderRadius.circular(Spacing.radiusMd),
        border: Border.all(color: color.outlineVariant),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: Spacing.md,
            backgroundColor: actionColor,
            child: SvgPicture.asset(
              iconAsset,
              width: Spacing.iconSm,
              height: Spacing.iconSm,
            ),
          ),
          const SizedBox(height: Spacing.xs),
          Text(
            label,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            textDirection: textDirection,
            style: getBoldStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size9,
              color: color.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
