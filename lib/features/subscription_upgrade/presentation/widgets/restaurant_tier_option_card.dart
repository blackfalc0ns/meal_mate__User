import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/subscription_upgrade/presentation/widgets/restaurant_tier_action_panel.dart';
import 'package:meal_meat_user/features/subscription_upgrade/presentation/widgets/restaurant_tier_badge.dart';
import 'package:meal_meat_user/features/subscription_upgrade/presentation/widgets/restaurant_tier_count_badge.dart';
import 'package:meal_meat_user/features/subscription_upgrade/presentation/widgets/restaurant_tier_logo_strip.dart';

class RestaurantTierOptionCard extends StatelessWidget {
  const RestaurantTierOptionCard({
    super.key,
    required this.title,
    required this.badgeAsset,
    this.imageUrl,
    required this.description,
    required this.restaurantCount,
    required this.titleColor,
    required this.descriptionColor,
    required this.countColor,
    required this.countBorderColor,
    required this.background,
    required this.actionPanelColor,
    required this.actionPanelBorderColor,
    required this.actionButtonColor,
    required this.actionButtonTextColor,
    required this.priceColor,
    required this.actionText,
    required this.price,
    required this.pricePeriod,
    required this.isCurrent,
    required this.isSelected,
    required this.onTap,
  });

  final String title;
  final String badgeAsset;
  final String? imageUrl;
  final String description;
  final String restaurantCount;
  final Color titleColor;
  final Color descriptionColor;
  final Color countColor;
  final Color countBorderColor;
  final BoxDecoration background;
  final Color actionPanelColor;
  final Color actionPanelBorderColor;
  final Color actionButtonColor;
  final Color actionButtonTextColor;
  final Color priceColor;
  final String actionText;
  final String price;
  final String pricePeriod;
  final bool isCurrent;
  final bool isSelected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        height: isCurrent
            ? Spacing.restaurantTierCurrentOptionHeight
            : Spacing.restaurantTierOptionCardHeight,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Align(
              alignment: AlignmentDirectional.bottomCenter,
              child: Container(
                height: isCurrent
                    ? Spacing.restaurantTierCurrentOptionHeight
                    : Spacing.restaurantTierOptionCardHeight,
                decoration: background,
                clipBehavior: Clip.none,
                child: Column(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsetsDirectional.only(
                          start: Spacing.base,
                          top: isCurrent ? Spacing.md : Spacing.xs,
                          end: Spacing.base,
                          bottom: Spacing.sm,
                        ),
                        child: Column(
                          children: [
                            if (isCurrent) ...[
                              Align(
                                alignment: AlignmentDirectional.topEnd,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: Spacing.md,
                                    vertical: Spacing.sm,
                                  ),
                                  decoration: BoxDecoration(
                                    color: color.primary,
                                    borderRadius: BorderRadius.circular(
                                      Spacing.radiusPill,
                                    ),
                                  ),
                                  child: Text(
                                    actionText,
                                    style: getSemiBoldStyle(
                                      fontFamily: FontConstant.alexandria,
                                      fontSize: FontSize.size10,
                                      color: color.onPrimary,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                RestaurantTierBadge(
                                  imageUrl: imageUrl,
                                  badgeAsset: badgeAsset,
                                ),
                                const SizedBox(width: Spacing.sm),
                                Text(
                                  title,
                                  style: getBoldStyle(
                                    fontFamily: FontConstant.alexandria,
                                    fontSize: FontSize.size15,
                                    color: titleColor,
                                  ),
                                ),
                                const SizedBox(width: Spacing.xxl),
                                const Expanded(
                                  child: RestaurantTierLogoStrip(),
                                ),
                                const SizedBox(width: Spacing.sm),
                                RestaurantTierCountBadge(
                                  text: restaurantCount,
                                  foregroundColor: countColor,
                                  borderColor: countBorderColor,
                                ),
                              ],
                            ),
                            const Spacer(),
                            Text(
                              description,
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: getMediumStyle(
                                fontFamily: FontConstant.alexandria,
                                fontSize: FontSize.size11,
                                color: descriptionColor,
                              ),
                            ),
                            const SizedBox(height: Spacing.sm),

                            RestaurantTierActionPanel(
                              isCurrent: isCurrent,
                              text: actionText,
                              panelColor: actionPanelColor,
                              panelBorderColor: actionPanelBorderColor,
                              buttonColor: actionButtonColor,
                              buttonTextColor: actionButtonTextColor,
                              priceColor: priceColor,
                              price: price,
                              pricePeriod: pricePeriod,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (isSelected)
              Align(
                alignment: AlignmentDirectional.topStart,
                child: Transform.translate(
                  offset: const Offset(Spacing.xs, Spacing.zero),
                  child: Container(
                    width: Spacing.iconMd,
                    height: Spacing.iconMd,
                    decoration: BoxDecoration(
                      color: color.primary,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.check_rounded,
                      color: color.onPrimary,
                      size: Spacing.iconSm,
                      semanticLabel:
                          locale.subscription_summary_restaurant_tier_label,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
