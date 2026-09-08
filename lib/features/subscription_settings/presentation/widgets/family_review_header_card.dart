import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class FamilyReviewHeaderCard extends StatelessWidget {
  const FamilyReviewHeaderCard({
    super.key,
    required this.memberName,
    required this.avatarAsset,
    required this.statusLabel,
    required this.dateLabel,
    required this.goalLabel,
  });

  final String memberName;
  final String avatarAsset;
  final String statusLabel;
  final String dateLabel;
  final String goalLabel;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Container(
      padding: const EdgeInsets.all(Spacing.cardPadding),
      decoration: BoxDecoration(
        color: color.surface,
        borderRadius: BorderRadius.circular(Spacing.cardRadius),
        border: Border.all(color: color.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: color.shadow.withValues(alpha: 0.04),
            blurRadius: Spacing.xs,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipOval(
            child: Image.asset(
              avatarAsset,
              width: Spacing.avatarLg,
              height: Spacing.avatarLg,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: Spacing.avatarLg,
                  height: Spacing.avatarLg,
                  color: color.surfaceContainerHighest,
                  child: Icon(
                    Icons.person_rounded,
                    color: color.onSurfaceVariant,
                    size: Spacing.iconLg,
                  ),
                );
              },
            ),
          ),
          const SizedBox(width: Spacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: Spacing.sm,
                        vertical: Spacing.xs / 2,
                      ),
                      decoration: BoxDecoration(
                        color: color.primary.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(Spacing.radiusPill),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.check_circle_rounded,
                            size: Spacing.iconSm * 0.8,
                            color: color.primary,
                          ),
                          const SizedBox(width: Spacing.xs / 2),
                          Text(
                            statusLabel,
                            style: getMediumStyle(
                              fontFamily: FontConstant.alexandria,
                              fontSize: FontSize.size10,
                              color: color.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.balance_rounded,
                          size: Spacing.iconSm,
                          color: color.primary,
                        ),
                        const SizedBox(width: Spacing.xs / 2),
                        Text(
                          goalLabel,
                          style: getBoldStyle(
                            fontFamily: FontConstant.alexandria,
                            fontSize: FontSize.size11,
                            color: color.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: Spacing.sm),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today_rounded,
                      size: Spacing.iconSm * 0.85,
                      color: color.onSurfaceVariant,
                    ),
                    const SizedBox(width: Spacing.xs),
                    Text(
                      '${locale.family_review_selected_day_label}: $dateLabel',
                      style: getRegularStyle(
                        fontFamily: FontConstant.alexandria,
                        fontSize: FontSize.size11,
                        color: color.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
