import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/monthly_plans/domain/entities/monthly_plan_details_entity.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_summary_entity.dart';
import 'package:meal_meat_user/features/subscription_checkout/presentation/widgets/subscription_summary_value_tile.dart';

class SubscriptionSummaryDetailsCard extends StatelessWidget {
  const SubscriptionSummaryDetailsCard({
    super.key,
    required this.plan,
    required this.summary,
  });

  final MonthlyPlanDetailsEntity plan;
  final SubscriptionSummaryEntity? summary;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final includeTitle = _buildIncludeTitle(summary, locale.localeName);
    final includeItems = _buildIncludeItems(summary, locale.localeName);

    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: Spacing.subscriptionSummaryDetailsWidth,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            locale.subscription_summary_title,
            textAlign: TextAlign.center,
            style: getBoldStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size24,
              color: color.onSurface,
            ).copyWith(height: FontSize.size30 / FontSize.size24),
          ),
          const SizedBox(height: Spacing.lg),
          SubscriptionSummaryValueTile(
            width: double.infinity,
            height: Spacing.subscriptionSummaryTopTileHeight,
            label: locale.subscription_summary_package_label,
            value: plan.packageTiers.isEmpty
                ? plan.mealsPerDay
                : plan.packageTiers.first.title,
            labelTop: Spacing.subscriptionSummaryTileLabelTop,
            valueTop: Spacing.subscriptionSummaryTileValueTop,
          ),
          const SizedBox(height: Spacing.md),
          Row(
            children: [
              Expanded(
                child: SubscriptionSummaryValueTile(
                  width: double.infinity,
                  height: Spacing.subscriptionSummaryTopTileHeight,
                  label: locale.subscription_summary_duration_label,
                  value: plan.duration,
                  labelTop: Spacing.subscriptionSummaryTileLabelTop,
                  valueTop: Spacing.subscriptionSummaryTileValueTop,
                ),
              ),
              if (plan.discountLabel.isNotEmpty) ...[
                const SizedBox(width: Spacing.md),
                Expanded(
                  child: SubscriptionSummaryValueTile(
                    width: double.infinity,
                    height: Spacing.subscriptionSummaryTopTileHeight,
                    label: locale.subscription_summary_restaurant_tier_label,
                    value: plan.discountLabel,
                    labelTop: Spacing.subscriptionSummaryClassificationLabelTop,
                    valueTop: Spacing.subscriptionSummaryClassificationValueTop,
                  ),
                ),
              ],
            ],
          ),
          if (includeItems.isNotEmpty) ...[
            const SizedBox(height: Spacing.md),
            _buildInfoSection(
              context: context,
              title: includeTitle.isEmpty
                  ? locale.subscription_summary_includes_label
                  : includeTitle,
              child: Column(
                children: [
                  for (final item in includeItems)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: Spacing.xs),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: Spacing.subscriptionSummaryBulletSize,
                            height: Spacing.subscriptionSummaryBulletSize,
                            decoration: BoxDecoration(
                              color: color.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(
                            width: Spacing.subscriptionSummaryBulletGap,
                          ),
                          Expanded(
                            child: Text(
                              item,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style:
                                  getMediumStyle(
                                    fontFamily: FontConstant.alexandria,
                                    fontSize: FontSize.size14,
                                    color: color.inverseSurface,
                                  ).copyWith(
                                    height: FontSize.size20 / FontSize.size14,
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
          const SizedBox(height: Spacing.md),
          _buildInfoSection(
            context: context,
            title: locale.subscription_summary_total_price_label,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Flexible(
                  child: Text(
                    plan.price,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: getBoldStyle(
                      fontFamily: FontConstant.alexandria,
                      fontSize: FontSize.size40,
                      color: color.primary,
                    ).copyWith(height: FontSize.size40 / FontSize.size40),
                  ),
                ),
                const SizedBox(width: Spacing.sm),
                Padding(
                  padding: const EdgeInsets.only(bottom: Spacing.xs),
                  child: Text(
                    plan.currency,
                    textAlign: TextAlign.center,
                    style: getBoldStyle(
                      fontFamily: FontConstant.alexandria,
                      fontSize: FontSize.size18,
                      color: color.onSurface,
                    ).copyWith(height: FontSize.size22 / FontSize.size18),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _buildIncludeTitle(
    SubscriptionSummaryEntity? summary,
    String localeName,
  ) {
    if (summary == null) {
      return '';
    }

    return summary.includes.title(localeName).trim();
  }

  List<String> _buildIncludeItems(
    SubscriptionSummaryEntity? summary,
    String localeName,
  ) {
    if (summary == null) {
      return const [];
    }

    final includesItems = summary.includes.items
        .map((item) => item.text(localeName).trim())
        .where((text) => text.isNotEmpty)
        .toList();

    if (includesItems.isNotEmpty) {
      return includesItems;
    }

    return summary.slotRequirements
        .where(
          (requirement) =>
              requirement.count > 0 &&
              (requirement.name(localeName).trim().isNotEmpty ||
                  requirement.slot.trim().isNotEmpty),
        )
        .map((requirement) {
          final name = requirement.name(localeName).trim();
          return '${requirement.count} ${name.isEmpty ? requirement.slot.trim() : name}';
        })
        .toList();
  }

  Widget _buildInfoSection({
    required BuildContext context,
    required String title,
    required Widget child,
  }) {
    final color = context.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.base,
        vertical: Spacing.md,
      ),
      decoration: BoxDecoration(
        color: color.surface,
        border: Border.all(
          color: color.outlineVariant,
          width: Spacing.subscriptionSummaryCardBorder,
        ),
        borderRadius: BorderRadius.circular(
          Spacing.subscriptionSummaryCardRadius,
        ),
        boxShadow: [
          BoxShadow(
            color: color.shadow.withValues(alpha: 0.06),
            blurRadius: Spacing.md,
            offset: const Offset(0, Spacing.xs),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: getBoldStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size16,
              color: color.onSurface,
            ).copyWith(height: FontSize.size22 / FontSize.size16),
          ),
          const SizedBox(height: Spacing.xs),
          child,
        ],
      ),
    );
  }
}
