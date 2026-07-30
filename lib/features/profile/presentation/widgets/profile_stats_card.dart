import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class ProfileStatsCard extends StatelessWidget {
  const ProfileStatsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final stats = [
      (
        Icons.assignment_outlined,
        '12',
        locale.profile_completed_plans,
        color.primary,
      ),
      (
        Icons.local_fire_department_outlined,
        '45',
        locale.profile_streak_days,
        color.error,
      ),
      (
        Icons.star_border_rounded,
        '850',
        locale.profile_points,
        color.secondary,
      ),
      (
        Icons.monitor_weight_outlined,
        '-4.2',
        locale.profile_weight_lost,
        color.primary,
      ),
    ];

    return Container(
      height: Spacing.profileStatsHeight,
      decoration: BoxDecoration(
        color: color.surface,
        borderRadius: BorderRadius.circular(Spacing.profileCardRadius),
        border: Border.all(color: color.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: color.shadow.withValues(alpha: 0.1),
            blurRadius: Spacing.xs,
            offset: const Offset(0, Spacing.xs),
          ),
        ],
      ),
      child: Row(
        textDirection: TextDirection.rtl,
        children: List.generate(stats.length, (index) {
          final stat = stats[index];
          return Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: index == stats.length - 1
                    ? null
                    : BorderDirectional(
                        start: BorderSide(color: color.outlineVariant),
                      ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    stat.$1,
                    color: stat.$4,
                    size: Spacing.profileStatIconSize,
                  ),
                  const SizedBox(height: Spacing.xs),
                  Text(
                    stat.$2,
                    style: getBoldStyle(
                      fontFamily: FontConstant.alexandria,
                      fontSize: Spacing.profileTitleFontSize,
                      color: stat.$4 == color.primary
                          ? color.primary
                          : color.onSurface,
                    ),
                  ),
                  const SizedBox(height: Spacing.xs),
                  Text(
                    stat.$3,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: getRegularStyle(
                      fontFamily: FontConstant.alexandria,
                      fontSize: Spacing.profileBodyFontSize,
                      color: color.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
