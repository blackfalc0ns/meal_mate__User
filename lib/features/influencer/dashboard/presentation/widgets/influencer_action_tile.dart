import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/influencer/dashboard/domain/entities/influencer_dashboard_entity.dart';

class InfluencerActionTile extends StatelessWidget {
  const InfluencerActionTile({
    super.key,
    required this.action,
    required this.onTap,
  });

  final InfluencerActionEntity action;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(Spacing.radiusMd),
      child: Container(
        padding: const EdgeInsets.all(Spacing.md),
        decoration: BoxDecoration(
          color: color.surface,
          borderRadius: BorderRadius.circular(Spacing.radiusMd),
          border: Border.all(color: color.outlineVariant),
        ),
        child: Row(
          children: [
            Container(
              width: Spacing.iconXl,
              height: Spacing.iconXl,
              decoration: BoxDecoration(
                color: color.secondaryContainer,
                borderRadius: BorderRadius.circular(Spacing.radiusSm),
              ),
              child: Icon(_icon, color: color.primary, size: Spacing.iconMd),
            ),
            const SizedBox(width: Spacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    action.title,
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
                    action.subtitle,
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
              Icons.chevron_right_rounded,
              color: color.onSurfaceVariant,
              size: Spacing.iconMd,
            ),
          ],
        ),
      ),
    );
  }

  IconData get _icon {
    return switch (action.icon) {
      InfluencerActionIcon.share => Icons.share_rounded,
      InfluencerActionIcon.social => Icons.groups_rounded,
      InfluencerActionIcon.wallet => Icons.account_balance_wallet_rounded,
      InfluencerActionIcon.history => Icons.receipt_long_rounded,
    };
  }
}
