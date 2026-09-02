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
      padding: const EdgeInsetsDirectional.only(
        start: Spacing.md,
        end: Spacing.xs,
      ),
      decoration: BoxDecoration(
        color: color.surface,
        borderRadius: BorderRadius.circular(
          Spacing.influencerActivityTileRadius,
        ),
        border: Border.all(color: color.outlineVariant),
      ),
      child: Row(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                activity.amount,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: getBoldStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size8,
                  color: color.primary,
                ),
              ),
              const SizedBox(height: Spacing.xs),
              Text(
                activity.time,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: getBoldStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size6,
                  color: color.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const Spacer(),
          Flexible(
            flex: 3,
            child: Text.rich(
              TextSpan(
                text: activity.title,
                children: [
                  TextSpan(
                    text: ' ${activity.subtitle}',
                    style: getRegularStyle(
                      fontFamily: FontConstant.alexandria,
                      fontSize: FontSize.size8,
                      color: color.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.end,
              style: getBoldStyle(
                fontFamily: FontConstant.alexandria,
                fontSize: FontSize.size8,
                color: color.onSurface,
              ),
            ),
          ),
          const SizedBox(width: Spacing.md),
          ClipOval(
            child: Image.asset(
              activity.avatarAsset,
              width: Spacing.influencerActivityAvatarSize,
              height: Spacing.influencerActivityAvatarSize,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}
