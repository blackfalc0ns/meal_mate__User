import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/influencer/domain/entities/influencer_dashboard_entity.dart';

class InfluencerActivityTile extends StatelessWidget {
  const InfluencerActivityTile({super.key, required this.activity});

  final InfluencerActivityEntity activity;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return Container(
      height: Spacing.influencerActivityTileHeight,
      padding: const EdgeInsets.only(left: Spacing.md, right: Spacing.xs),
      decoration: BoxDecoration(
        color: color.surface,
        borderRadius: BorderRadius.circular(
          Spacing.influencerActivityTileRadius,
        ),
        border: Border.all(color: color.outlineVariant),
      ),
      child: Stack(
        children: [
          Positioned(
            left: Spacing.zero,
            top: Spacing.zero,
            bottom: Spacing.zero,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity.amount,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: getBoldStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size12,
                    color: color.primary,
                  ),
                ),
                const SizedBox(height: Spacing.xs),
                Text(
                  activity.time,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: getSemiBoldStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size10,
                    color: color.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: Spacing.xxxl,
            right: Spacing.influencerActivityAvatarSize + Spacing.md,
            top: Spacing.zero,
            bottom: Spacing.zero,
            child: Align(
              alignment: Alignment.centerRight,
              child: Text.rich(
                TextSpan(
                  text: activity.title,
                  children: [
                    TextSpan(
                      text: ' ${activity.subtitle}',
                      style: getMediumStyle(
                        fontFamily: FontConstant.alexandria,
                        fontSize: FontSize.size10,
                        color: color.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,

                style: getBoldStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size10,
                  color: color.onSurface,
                ),
              ),
            ),
          ),
          Positioned(
            right: Spacing.zero,
            top: Spacing.zero,
            bottom: Spacing.zero,
            child: Center(
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  ClipOval(
                    child: Image.asset(
                      activity.avatarAsset,
                      width: Spacing.influencerActivityAvatarSize,
                      height: Spacing.influencerActivityAvatarSize,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    right: Spacing.zero,
                    bottom: Spacing.zero,
                    child: Icon(
                      Icons.verified_rounded,
                      color: color.primary,
                      size: Spacing.influencerVerifiedSize,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
