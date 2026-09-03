import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/influencer/domain/entities/influencer_dashboard_entity.dart';

class InfluencerWalletActionButton extends StatelessWidget {
  const InfluencerWalletActionButton({
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
      borderRadius: BorderRadius.circular(Spacing.influencerWalletActionRadius),
      child: SizedBox(
        width: Spacing.iconXl + Spacing.lg,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: Spacing.influencerWalletActionSize,
              height: Spacing.influencerWalletActionSize,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: color.primaryContainer,
                borderRadius: BorderRadius.circular(
                  Spacing.influencerWalletActionRadius,
                ),
              ),
              child: Icon(_icon, color: color.primary, size: _iconSize),
            ),
            const SizedBox(height: Spacing.xs),
            Text(
              action.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: getSemiBoldStyle(
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

  IconData get _icon {
    return switch (action.icon) {
      InfluencerActionIcon.wallet => Icons.payments_rounded,
      InfluencerActionIcon.history => Icons.history_rounded,
      InfluencerActionIcon.share => Icons.share_rounded,
      InfluencerActionIcon.social => Icons.groups_rounded,
    };
  }

  double get _iconSize {
    return switch (action.icon) {
      InfluencerActionIcon.wallet => Spacing.influencerWalletActionIconLarge,
      InfluencerActionIcon.history => Spacing.influencerWalletActionIconSmall,
      InfluencerActionIcon.share ||
      InfluencerActionIcon.social => Spacing.influencerWalletActionIconSmall,
    };
  }
}
