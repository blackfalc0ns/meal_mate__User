import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/entities/restaurant_tier_upgrade_entity.dart';

class RestaurantTierPaymentMethodTile extends StatelessWidget {
  const RestaurantTierPaymentMethodTile({super.key, required this.payment});

  final RestaurantTierPaymentMethodEntity payment;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Container(
      height: Spacing.restaurantTierActionPanelHeight,
      padding: const EdgeInsets.symmetric(horizontal: Spacing.sm),
      decoration: BoxDecoration(
        color: color.surface,
        border: Border.all(color: color.outlineVariant),
        borderRadius: BorderRadius.circular(Spacing.radiusSm),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: Spacing.sm,
              vertical: Spacing.xs,
            ),
            decoration: BoxDecoration(
              color: color.primaryContainer.withValues(alpha: 0.28),
              borderRadius: BorderRadius.circular(Spacing.radiusSm),
            ),
            child: Text(
              payment.changeLabel,
              style: getMediumStyle(
                fontFamily: FontConstant.alexandria,
                fontSize: FontSize.size11,
                color: color.primary,
              ),
            ),
          ),
          const Spacer(),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                payment.cardText,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: getSemiBoldStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size12,
                  color: color.onSurface,
                ),
              ),
              Text(
                payment.subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: getMediumStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size10,
                  color: color.primary,
                ),
              ),
            ],
          ),
          const SizedBox(width: Spacing.md),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: Spacing.xs),
            decoration: BoxDecoration(
              border: Border.all(color: color.outlineVariant),
              borderRadius: BorderRadius.circular(Spacing.radiusXs),
            ),
            child: Text(
              payment.brand,
              style: getBoldStyle(
                fontFamily: FontConstant.alexandria,
                fontSize: FontSize.size11,
                color: color.primary,
              ),
            ),
          ),
          const SizedBox(width: Spacing.sm),
          Icon(
            Icons.arrow_forward_ios_rounded,
            color: color.primary,
            size: Spacing.iconSm,
            semanticLabel: locale.profile_billing,
          ),
        ],
      ),
    );
  }
}
