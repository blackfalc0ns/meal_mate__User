import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/entities/family_subscription_settings_entity.dart';

class FamilySubscriptionQuickAccessTile extends StatelessWidget {
  const FamilySubscriptionQuickAccessTile({
    super.key,
    required this.action,
    this.onTap,
  });

  final FamilySubscriptionQuickActionEntity action;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(Spacing.radiusSm),
      child: Container(
        height: Spacing.familyManageQuickTileHeight,
        decoration: BoxDecoration(
          color: color.surface,
          border: Border.all(color: color.outlineVariant, width: 1.45),
          borderRadius: BorderRadiusDirectional.circular(13.07),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              action.iconAsset,
              width: Spacing.familyManageQuickIconSize,
              height: Spacing.familyManageQuickIconSize,
            ),
            const SizedBox(height: Spacing.xs),
            Text(
              action.label,
              locale: Locale(locale.localeName),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: getSemiBoldStyle(
                fontFamily: FontConstant.alexandria,
                fontSize: 9.1,
                color: color.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
