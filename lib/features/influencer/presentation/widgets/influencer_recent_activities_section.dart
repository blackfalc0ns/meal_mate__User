import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/influencer/domain/entities/influencer_dashboard_entity.dart';
import 'package:meal_meat_user/features/influencer/presentation/widgets/influencer_activity_tile.dart';

class InfluencerRecentActivitiesSection extends StatelessWidget {
  const InfluencerRecentActivitiesSection({
    super.key,
    required this.title,
    required this.actionLabel,
    required this.activities,
  });

  final String title;
  final String actionLabel;
  final List<InfluencerActivityEntity> activities;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return Column(
      children: [
        SizedBox(
          height: Spacing.influencerActivityHeaderHeight,
          child: Row(
            children: [
              Text(
                actionLabel,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: getBoldStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size8,
                  color: color.primary,
                ),
              ),
              const Spacer(),
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: getBoldStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size8,
                  color: color.onSurface,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: Spacing.sm),
        ...activities.map(
          (activity) => Padding(
            padding: const EdgeInsets.only(bottom: Spacing.hairline),
            child: InfluencerActivityTile(activity: activity),
          ),
        ),
      ],
    );
  }
}
