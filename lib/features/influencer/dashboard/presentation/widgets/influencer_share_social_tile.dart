import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/influencer/dashboard/domain/entities/influencer_dashboard_entity.dart';

class InfluencerShareSocialTile extends StatelessWidget {
  const InfluencerShareSocialTile({super.key, required this.platform});

  final InfluencerShareSocialPlatformEntity platform;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return Container(
      width: Spacing.influencerShareLinksSocialTileWidth,
      height: Spacing.influencerShareLinksSocialTileHeight,
      padding: const EdgeInsets.symmetric(vertical: Spacing.sm),
      decoration: BoxDecoration(
        color: color.surface,
        borderRadius: BorderRadius.circular(
          Spacing.influencerShareLinksSocialTileRadius,
        ),
        border: Border.all(color: color.outlineVariant),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (platform.drawDotsIcon)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (var index = 0; index < 3; index++) ...[
                  Container(
                    key: ValueKey('influencer-more-dot-$index'),
                    width: Spacing.influencerShareLinksMoreDotSize,
                    height: Spacing.influencerShareLinksMoreDotSize,
                    decoration: BoxDecoration(
                      color: color.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                  if (index < 2)
                    const SizedBox(
                      width: Spacing.influencerShareLinksMoreDotGap,
                    ),
                ],
              ],
            )
          else
            SvgPicture.asset(
              platform.iconAsset,
              width: Spacing.influencerShareLinksSocialIconSize,
              height: Spacing.influencerShareLinksSocialIconSize,
            ),
          const SizedBox(height: Spacing.sm),
          Text(
            platform.label,
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
    );
  }
}
