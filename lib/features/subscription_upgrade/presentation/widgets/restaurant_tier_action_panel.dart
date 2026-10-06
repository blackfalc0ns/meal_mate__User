import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class RestaurantTierActionPanel extends StatelessWidget {
  const RestaurantTierActionPanel({
    super.key,
    required this.isCurrent,
    required this.text,
    required this.panelColor,
    required this.panelBorderColor,
    required this.buttonColor,
    required this.buttonTextColor,
    required this.priceColor,
    required this.price,
    required this.pricePeriod,
  });

  final bool isCurrent;
  final String text;
  final Color panelColor;
  final Color panelBorderColor;
  final Color buttonColor;
  final Color buttonTextColor;
  final Color priceColor;
  final String price;
  final String pricePeriod;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    if (isCurrent) {
      return Container(
        height: Spacing.restaurantTierInlineButtonHeight,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: color.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(Spacing.radiusPill),
          border: Border.all(color: color.outline),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: getSemiBoldStyle(
                fontFamily: FontConstant.alexandria,
                fontSize: FontSize.size13,
                color: color.onSurfaceVariant,
              ),
            ),
            const SizedBox(width: Spacing.xs),
            Icon(
              Icons.check_rounded,
              color: color.onSurfaceVariant,
              size: Spacing.iconMd,
              semanticLabel: locale.subscription_summary_restaurant_tier_label,
            ),
          ],
        ),
      );
    }

    return Container(
      height: Spacing.restaurantTierActionPanelHeight,
      padding: const EdgeInsets.all(Spacing.sm),
      decoration: BoxDecoration(
        color: panelColor,
        borderRadius: BorderRadius.circular(Spacing.radiusMd),
        border: Border.all(color: panelBorderColor),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: Spacing.restaurantTierInlineButtonHeight,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: buttonColor,
                borderRadius: BorderRadius.circular(Spacing.radiusPill),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                      text,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: getSemiBoldStyle(
                        fontFamily: FontConstant.alexandria,
                        fontSize: FontSize.size12,
                        color: buttonTextColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: Spacing.lg),
                  Icon(
                    Icons.chevron_right_rounded,
                    color: buttonTextColor,
                    size: Spacing.iconMd,
                  ),
                ],
              ),
            ),
          ),
          VerticalDivider(
            width: Spacing.xl,
            color: color.onPrimary.withValues(alpha: 0.5),
          ),
          SizedBox(
            width: Spacing.xxxl + Spacing.xxxl,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  price,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: getSemiBoldStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size14,
                    color: priceColor,
                  ),
                ),
                Text(
                  pricePeriod,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: getMediumStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size10,
                    color: color.onPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
