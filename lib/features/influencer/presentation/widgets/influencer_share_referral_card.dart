import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/influencer/domain/entities/influencer_dashboard_entity.dart';

class InfluencerShareReferralCard extends StatelessWidget {
  const InfluencerShareReferralCard({
    super.key,
    required this.shareLinks,
    required this.copyIconAsset,
  });

  final InfluencerShareLinksEntity shareLinks;
  final String copyIconAsset;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return Container(
      height: Spacing.influencerShareLinksReferralCardHeight,
      padding: const EdgeInsets.all(Spacing.md),
      decoration: BoxDecoration(
        color: color.surface,
        borderRadius: BorderRadius.circular(
          Spacing.influencerShareLinksCardRadius,
        ),
        border: Border.all(color: color.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: color.shadow.withValues(alpha: 0.08),
            blurRadius: Spacing.md,
            offset: const Offset(0, Spacing.xs),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: Spacing.zero,
            top: Spacing.zero,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: Spacing.influencerShareLinksIconBoxSize,
                  height: Spacing.influencerShareLinksIconBoxSize,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: color.primaryContainer.withValues(alpha: 0.35),
                    borderRadius: BorderRadius.circular(Spacing.radiusSm),
                  ),
                  child: Icon(
                    Icons.link_rounded,
                    color: color.primary,
                    size: Spacing.iconSm,
                  ),
                ),

                const SizedBox(width: Spacing.sm),

                Text(
                  shareLinks.referralLinkTitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                 
                  style: getBoldStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size10,
                    color: color.onSurface,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: Spacing.zero,
            bottom: Spacing.zero,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: Spacing.iconMd,
                  height: Spacing.iconMd,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: color.primaryContainer.withValues(alpha: 0.35),
                    shape: BoxShape.circle,
                  ),
                  child: SvgPicture.asset(
                    copyIconAsset,
                    width: Spacing.iconSm,
                    height: Spacing.iconSm,
                  ),
                ),
                const SizedBox(height: Spacing.xs),
                Text(
                  shareLinks.copyLinkLabel,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: getBoldStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size7,
                    color: color.onSurface,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: Spacing.iconXl,
            right: Spacing.zero,
            bottom: Spacing.zero,
            child: Container(
              height: Spacing.influencerShareLinksLinkHeight,
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: Spacing.md),
              decoration: BoxDecoration(
                color: color.surface,
                borderRadius: BorderRadius.circular(Spacing.radiusSm),
                border: Border.all(color: color.primaryContainer),
              ),
              child: Text(
                shareLinks.referralLink,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: getBoldStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size9,
                  color: color.primary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
