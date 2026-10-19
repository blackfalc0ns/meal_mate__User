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
    this.disclaimer,
  });

  final String title;
  final String description;
  final String remainingTime;
  final String? disclaimer;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: Spacing.md,
            vertical: Spacing.sm,
          ),
          decoration: BoxDecoration(
            color: color.secondary.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(11.0),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: getBoldStyle(
                        fontFamily: FontConstant.alexandria,
                        fontSize: FontSize.size11,
                        color: color.secondary,
                      ),
                    ),
                    const SizedBox(height: Spacing.xs / 2),
                    Text(
                      description,
                      style: getRegularStyle(
                        fontFamily: FontConstant.alexandria,
                        fontSize: FontSize.size9,
                        color: color.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: Spacing.xs / 2),
                    Text(
                      locale.family_review_cutoff_time(remainingTime),
                      style: getMediumStyle(
                        fontFamily: FontConstant.alexandria,
                        fontSize: FontSize.size9,
                        color: color.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: Spacing.sm),
              Image.asset(
                'assets/images/subscriptions/figma/family_review_cutoff_clock.png',
                width: 68.0,
                height: 61.0,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => Icon(
                  Icons.access_time_rounded,
                  size: Spacing.iconLg,
                  color: color.secondary,
                ),
              ),
            ],
          ),
        ),
        if (disclaimer != null && disclaimer!.isNotEmpty) ...[
          const SizedBox(height: Spacing.sm),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.info_outline_rounded,
                size: 13.0,
                color: color.primary,
              ),
              const SizedBox(width: Spacing.xs),
              Expanded(
                child: Text(
                  disclaimer!,
                  style: getRegularStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size9,
                    color: color.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
