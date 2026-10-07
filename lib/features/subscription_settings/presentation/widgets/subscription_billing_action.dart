import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class SubscriptionBillingAction extends StatelessWidget {
  const SubscriptionBillingAction({
    required this.iconAsset,
    required this.label,
    required this.actionColor,
    this.backgroundColor,
    this.borderColor,
    this.onTap,
    super.key,
  });

  final String iconAsset;
  final String label;
  final Color actionColor;
  final Color? backgroundColor;
  final Color? borderColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(Spacing.radiusMd),
      child: Container(
        height: Spacing.profileBillingActionCardHeight,
        decoration: BoxDecoration(
          color: backgroundColor ?? color.surface,
          borderRadius: BorderRadius.circular(Spacing.radiusMd),
          border: Border.all(
            color: borderColor ?? color.outlineVariant.withValues(alpha: 0.25),
            width: borderColor != null ? 1.5 : 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: color.shadow.withValues(alpha: 0.03),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
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
              style: getBoldStyle(
                fontFamily: FontConstant.alexandria,
                fontSize: FontSize.size9,
                color: color.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
