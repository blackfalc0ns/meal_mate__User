import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_cached_network_image.dart';
import 'package:meal_meat_user/features/monthly_plans/domain/entities/monthly_plan_details_entity.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_summary_entity.dart';
import 'package:meal_meat_user/features/subscription_checkout/presentation/widgets/subscription_summary_restaurants_sheet.dart';
import 'package:meal_meat_user/features/subscription_checkout/presentation/widgets/subscription_summary_value_tile.dart';

class SubscriptionSummaryDetailsCard extends StatelessWidget {
  const SubscriptionSummaryDetailsCard({
    super.key,
    required this.plan,
    required this.summary,
    required this.selectedStartDate,
  });

  final MonthlyPlanDetailsEntity plan;
  final SubscriptionSummaryEntity? summary;
  final String selectedStartDate;

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
              fontSize: FontSize.size20,
              color: color.onSurface,
            ),
          ),
          const SizedBox(height: Spacing.lg),
          SubscriptionSummaryValueTile(
            width: double.infinity,
            height: Spacing.subscriptionSummaryTopTileHeight,
            label: locale.subscription_summary_package_label,
            value: summary != null
                ? summary!.bundleName(locale.localeName)
                : (plan.packageTiers.isEmpty
                      ? plan.mealsPerDay
                      : plan.packageTiers.first.title),
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
                  value: summary != null
                      ? '${summary!.durationDays} ${locale.subscription_day}'
                      : plan.duration,
                  labelTop: Spacing.subscriptionSummaryTileLabelTop,
                  valueTop: Spacing.subscriptionSummaryTileValueTop,
                ),
              ),
              if ((summary?.tierName(locale.localeName) ?? plan.discountLabel)
                  .isNotEmpty) ...[
                const SizedBox(width: Spacing.md),
                Expanded(
                  child: SubscriptionSummaryValueTile(
                    width: double.infinity,
                    height: Spacing.subscriptionSummaryTopTileHeight,
                    label: locale.subscription_summary_restaurant_tier_label,
                    value: summary != null
                        ? summary!.tierName(locale.localeName)
                        : plan.discountLabel,
                    labelTop: Spacing.subscriptionSummaryClassificationLabelTop,
                    valueTop: Spacing.subscriptionSummaryClassificationValueTop,
                  ),
                ),
              ],
            ],
          ),
          if (_chosenStartDate.isNotEmpty || _firstDeliveryDate.isNotEmpty) ...[
            const SizedBox(height: Spacing.md),
            Row(
              children: [
                Expanded(
                  child: SubscriptionSummaryValueTile(
                    width: double.infinity,
                    height: Spacing.subscriptionSummaryTopTileHeight,
                    label: locale.subscription_chosen_start_date_label,
                    value: _chosenStartDate,
                    labelTop: Spacing.subscriptionSummaryTileLabelTop,
                    valueTop: Spacing.subscriptionSummaryTileValueTop,
                  ),
                ),
                if (_firstDeliveryDate.isNotEmpty) ...[
                  const SizedBox(width: Spacing.md),
                  Expanded(
                    child: SubscriptionSummaryValueTile(
                      width: double.infinity,
                      height: Spacing.subscriptionSummaryTopTileHeight,
                      label: locale.subscription_first_delivery_date_label,
                      value: _firstDeliveryDate,
                      labelTop: Spacing.subscriptionSummaryTileLabelTop,
                      valueTop: Spacing.subscriptionSummaryTileValueTop,
                    ),
                  ),
                ],
              ],
            ),
          ],
          if ((summary?.restaurantRepetition?.limit ?? 0) > 0) ...[
            const SizedBox(height: Spacing.md),
            _buildInfoSection(
              context: context,
              title: locale.subscription_restaurant_repetition_label,
              child: Text(
                locale.subscription_restaurant_repetition_message(
                  summary!.restaurantRepetition!.limit,
                ),
                textAlign: TextAlign.center,
                style: getMediumStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size13,
                  color: color.inverseSurface,
                ).copyWith(height: FontSize.size20 / FontSize.size13),
              ),
            ),
          ],
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
          if (summary?.address != null) ...[
            const SizedBox(height: Spacing.md),
            _buildInfoSection(
              context: context,
              title: locale.profile_addresses,
              child: Text(
                summary!.address!.formattedAddress,
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: getMediumStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size14,
                  color: color.inverseSurface,
                ).copyWith(height: FontSize.size20 / FontSize.size14),
              ),
            ),
          ],
          if (summary?.restaurants.isNotEmpty == true) ...[
            const SizedBox(height: Spacing.md),
            _buildInfoSection(
              context: context,
              title: locale.home_restaurants,
              child: Column(
                children: [
                  for (final restaurant in summary!.restaurants.take(4))
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: Spacing.xs),
                      child: Row(
                        children: [
                          ClipOval(
                            child: SizedBox(
                              width: Spacing.xl,
                              height: Spacing.xl,
                              child: restaurant.logoUrl == null
                                  ? Icon(
                                      Icons.restaurant_rounded,
                                      color: color.primary,
                                      size: Spacing.iconMd,
                                    )
                                  : AppCachedNetworkImage(
                                      imageUrl: restaurant.logoUrl!,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),
                          const SizedBox(width: Spacing.sm),
                          Expanded(
                            child: Text(
                              restaurant.name(locale.localeName),
                              maxLines: 1,
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
                  if ((summary?.restaurants.length ?? 0) > 4) ...[
                    const SizedBox(height: Spacing.xs),
                    InkWell(
                      onTap: () {
                        SubscriptionSummaryRestaurantsSheet.show(
                          context: context,
                          restaurants: summary!.restaurants,
                        );
                      },
                      borderRadius: BorderRadius.circular(Spacing.radiusSm),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          vertical: Spacing.sm,
                          horizontal: Spacing.md,
                        ),
                        decoration: BoxDecoration(
                          color: color.tertiaryContainer,
                          borderRadius: BorderRadius.circular(Spacing.radiusSm),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              locale.subscription_summary_show_more,
                              style: getSemiBoldStyle(
                                fontFamily: FontConstant.alexandria,
                                fontSize: FontSize.size13,
                                color: color.primary,
                              ),
                            ),
                            const SizedBox(width: Spacing.xs),
                            Icon(
                              Icons.keyboard_arrow_down_rounded,
                              size: Spacing.iconSm,
                              color: color.primary,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
          if (summary?.canCheckout == false &&
              summary?.checkoutBlockReason ==
                  'subscription_flow.no_restaurants_for_address') ...[
            const SizedBox(height: Spacing.md),
            _buildInfoSection(
              context: context,
              title: locale.home_restaurants,
              child: Text(
                locale.subscription_summary_no_restaurants_for_address,
                textAlign: TextAlign.center,
                style: getMediumStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size13,
                  color: color.error,
                ).copyWith(height: FontSize.size20 / FontSize.size13),
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

  String get _chosenStartDate {
    final fromSummary = summary?.chosenStartDate.trim() ?? '';
    return fromSummary.isEmpty ? selectedStartDate : fromSummary;
  }

  String get _firstDeliveryDate => summary?.startDate.trim() ?? '';

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
