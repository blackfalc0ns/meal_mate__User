import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/influencer/domain/entities/influencer_dashboard_entity.dart';

class InfluencerSocialTile extends StatelessWidget {
  const InfluencerSocialTile({super.key, required this.account});

  final InfluencerSocialAccountEntity account;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return Container(
      padding: const EdgeInsets.all(Spacing.md),
      decoration: BoxDecoration(
        color: color.surface,
        borderRadius: BorderRadius.circular(Spacing.radiusMd),
        border: Border.all(color: color.outlineVariant),
      ),
      child: Row(
        children: [
          Container(
            width: Spacing.iconLg,
            height: Spacing.iconLg,
            decoration: BoxDecoration(
              color: color.secondaryContainer,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.alternate_email_rounded,
              color: color.primary,
              size: Spacing.iconSm,
            ),
          ),
          const SizedBox(width: Spacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  account.platform,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: getBoldStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size12,
                    color: color.onSurface,
                  ),
                ),
                const SizedBox(height: Spacing.xs),
                Text(
                  account.handle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: getRegularStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size10,
                    color: color.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            account.connected
                ? Icons.check_circle_rounded
                : Icons.add_circle_outline_rounded,
            color: color.primary,
            size: Spacing.iconMd,
          ),
        ],
      ),
    );
  }
}
