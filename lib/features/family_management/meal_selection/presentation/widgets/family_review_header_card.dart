import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_cached_network_image.dart';

class FamilyReviewHeaderCard extends StatelessWidget {
  const FamilyReviewHeaderCard({
    super.key,
    required this.memberName,
    this.avatarAsset = '',
    this.avatarUrl,
    required this.statusLabel,
    required this.dateLabel,
    required this.goalLabel,
  });

  final String memberName;
  final String avatarAsset;
  final String? avatarUrl;
  final String statusLabel;
  final String dateLabel;
  final String goalLabel;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.md,
        vertical: Spacing.sm,
      ),
      decoration: BoxDecoration(
        color: color.surface,
        borderRadius: BorderRadius.circular(Spacing.radiusLg),
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
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        locale.family_review_goal_label,
                        style: getRegularStyle(
                          fontFamily: FontConstant.alexandria,
                          fontSize: FontSize.size10,
                          color: color.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: Spacing.xs / 2),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.balance_rounded,
                            size: Spacing.iconXs,
                            color: color.primary,
                          ),
                          const SizedBox(width: Spacing.xs / 2),
                          Flexible(
                            child: Text(
                              goalLabel,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: getBoldStyle(
                                fontFamily: FontConstant.alexandria,
                                fontSize: FontSize.size10,
                                color: color.onSurface,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                _buildDivider(color),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        locale.family_review_selected_day_label,
                        style: getRegularStyle(
                          fontFamily: FontConstant.alexandria,
                          fontSize: FontSize.size10,
                          color: color.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: Spacing.xs / 2),
                      Text(
                        dateLabel,
                        textAlign: TextAlign.center,
                        maxLines: 2,
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
                _buildDivider(color),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        locale.calendar_confirmed_sheet_status_label,
                        style: getRegularStyle(
                          fontFamily: FontConstant.alexandria,
                          fontSize: FontSize.size10,
                          color: color.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: Spacing.xs / 2),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: Spacing.xs,
                          vertical: Spacing.xs / 2,
                        ),
                        decoration: BoxDecoration(
                          color: color.primary,
                          borderRadius: BorderRadius.circular(
                            Spacing.radiusPill,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.check_circle_rounded,
                              size: Spacing.iconXs * 0.8,
                              color: color.onPrimary,
                            ),
                            const SizedBox(width: Spacing.xs / 2),
                            Flexible(
                              child: Text(
                                statusLabel,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: getBoldStyle(
                                  fontFamily: FontConstant.alexandria,
                                  fontSize: FontSize.size8,
                                  color: color.onPrimary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: Spacing.md),
          ClipOval(
            child: avatarUrl != null && avatarUrl!.isNotEmpty
                ? AppCachedNetworkImage(
                    imageUrl: avatarUrl!,
                    width: Spacing.avatarMd + Spacing.xs,
                    height: Spacing.avatarMd + Spacing.xs,
                    fit: BoxFit.cover,
                  )
                : (avatarAsset.isNotEmpty
                      ? Image.asset(
                          avatarAsset,
                          width: Spacing.avatarMd + Spacing.xs,
                          height: Spacing.avatarMd + Spacing.xs,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          width: Spacing.avatarMd + Spacing.xs,
                          height: Spacing.avatarMd + Spacing.xs,
                          color: color.surfaceContainerHighest,
                          child: Icon(
                            Icons.person_rounded,
                            color: color.onSurfaceVariant,
                            size: Spacing.iconLg,
                          ),
                        )),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider(ColorScheme color) {
    return Container(
      width: Spacing.border,
      height: Spacing.xl * 1.5,
      margin: const EdgeInsets.symmetric(horizontal: Spacing.xs / 2),
      color: color.outlineVariant,
    );
  }
}
