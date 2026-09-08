import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class FamilyReviewCutoffBanner extends StatelessWidget {
  const FamilyReviewCutoffBanner({
    super.key,
    required this.title,
    required this.description,
    required this.remainingTime,
    required this.disclaimer,
  });

  final String title;
  final String description;
  final String remainingTime;
  final String disclaimer;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Container(
      padding: const EdgeInsets.all(Spacing.cardPadding),
      decoration: BoxDecoration(
        color: color.error.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(Spacing.cardRadius),
        border: Border.all(
          color: color.error.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(Spacing.sm),
                decoration: BoxDecoration(
                  color: color.error.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(Spacing.radiusSm),
                ),
                child: Icon(
                  Icons.alarm_rounded,
                  size: Spacing.iconMd,
                  color: color.error,
                ),
              ),
              const SizedBox(width: Spacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: getBoldStyle(
                        fontFamily: FontConstant.alexandria,
                        fontSize: FontSize.size12,
                        color: color.onSurface,
                      ),
                    ),
                    const SizedBox(height: Spacing.xs),
                    Text(
                      description,
                      style: getRegularStyle(
                        fontFamily: FontConstant.alexandria,
                        fontSize: FontSize.size10,
                        color: color.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: Spacing.sm),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: Spacing.md,
              vertical: Spacing.xs,
            ),
            decoration: BoxDecoration(
              color: color.error.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(Spacing.radiusPill),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.schedule_rounded,
                  size: Spacing.iconSm,
                  color: color.error,
                ),
                const SizedBox(width: Spacing.xs),
                Text(
                  locale.family_review_cutoff_time(remainingTime),
                  style: getBoldStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size11,
                    color: color.error,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: Spacing.xs),
          Text(
            disclaimer,
            style: getRegularStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size9,
              color: color.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
