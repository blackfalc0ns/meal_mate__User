import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/home/presentation/widgets/home_subscription_status_item.dart';

class HomeSubscriptionSummaryCard extends StatelessWidget {
  const HomeSubscriptionSummaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    return Container(
      width: Spacing.homeSubscriptionSummaryWidth,
      height: Spacing.homeSubscriptionSummaryHeight,
      decoration: BoxDecoration(
        color: color.surface,
        borderRadius: BorderRadius.circular(
          Spacing.homeSubscriptionSummaryRadius,
        ),
        border: Border.all(color: color.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: color.shadow.withValues(alpha: 0.10),
            blurRadius: Spacing.md,
            offset: const Offset(Spacing.xs, Spacing.xs),
          ),
        ],
      ),
      child: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                const Expanded(
                  child: HomeSubscriptionStatusItem(
                    type: HomeSubscriptionStatusItemType.remainingDays,
                  ),
                ),
                Container(
                  width: Spacing.homeSubscriptionDividerWidth,
                  height: Spacing.homeSubscriptionDividerHeight,
                  color: color.outlineVariant,
                ),
                const Expanded(
                  child: HomeSubscriptionStatusItem(
                    type: HomeSubscriptionStatusItemType.selectedMeals,
                  ),
                ),
                Container(
                  width: Spacing.homeSubscriptionDividerWidth,
                  height: Spacing.homeSubscriptionDividerHeight,
                  color: color.outlineVariant,
                ),
                const Expanded(
                  child: HomeSubscriptionStatusItem(
                    type: HomeSubscriptionStatusItemType.commitment,
                  ),
                ),
                Container(
                  width: Spacing.homeSubscriptionDividerWidth,
                  height: Spacing.homeSubscriptionDividerHeight,
                  color: color.outlineVariant,
                ),
                const Expanded(
                  child: HomeSubscriptionStatusItem(
                    type: HomeSubscriptionStatusItemType.nextDelivery,
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: Spacing.homeSubscriptionSummaryFooterHeight,
            alignment: AlignmentDirectional.center,
            decoration: BoxDecoration(
              color: color.primaryContainer,
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(Spacing.homeSubscriptionBadgeRadius),
              ),
            ),
            child: Text(
              locale.home_on_track,
              style: getMediumStyle(
                fontFamily: FontConstant.alexandria,
                fontSize: FontSize.size9,
                color: color.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
