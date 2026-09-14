import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/influencer/dashboard/domain/entities/influencer_dashboard_entity.dart';

class InfluencerShareQuickStatsCard extends StatelessWidget {
  const InfluencerShareQuickStatsCard({super.key, required this.shareLinks});

  final InfluencerShareLinksEntity shareLinks;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return Container(
      height: Spacing.influencerShareLinksQuickStatsHeight,
      padding: const EdgeInsets.all(Spacing.sm),
      decoration: BoxDecoration(
        color: color.primaryContainer.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(
          Spacing.influencerShareLinksQuickStatsRadius,
        ),
        border: Border.all(color: color.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            shareLinks.quickStatsTitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,

            style: getBoldStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size10,
              color: color.onSurface,
            ),
          ),
          const SizedBox(height: Spacing.xs),
          Text(
            shareLinks.quickStatsSubtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,

            style: getMediumStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size9,
              color: color.onSurfaceVariant,
            ),
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (var index = 0; index < shareLinks.quickStats.length; index++)
                Expanded(
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        shareLinks.quickStats[index].iconAsset,
                        width: Spacing.influencerShareLinksQuickStatIconSize,
                        height: Spacing.influencerShareLinksQuickStatIconSize,
                      ),
                      const SizedBox(width: Spacing.xs),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            FittedBox(
                              child: Text(
                                shareLinks.quickStats[index].label,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: getRegularStyle(
                                  fontFamily: FontConstant.alexandria,
                                  fontSize: FontSize.size10,
                                  color: color.onSurfaceVariant,
                                ),
                              ),
                            ),
                            const SizedBox(height: Spacing.xs),
                            Text(
                              shareLinks.quickStats[index].value,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.end,
                              style: getBoldStyle(
                                fontFamily: FontConstant.alexandria,
                                fontSize: FontSize.size14,
                                color: color.onSurface,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (index < shareLinks.quickStats.length - 1) ...[
                        const SizedBox(width: Spacing.md),
                        Container(
                          width: Spacing.hairline,
                          height: Spacing.influencerShareLinksDividerHeight,
                          color: color.outlineVariant,
                        ),
                        const SizedBox(width: Spacing.md),
                      ],
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
