import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class SubscriptionTotalPriceCard extends StatelessWidget {
  const SubscriptionTotalPriceCard({
    super.key,
    required this.price,
    required this.currency,
    this.originalPrice,
    this.discountAmount,
  });

  final String price;
  final String currency;
  final String? originalPrice;
  final String? discountAmount;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    final effectiveCurrency = (currency.isEmpty || currency == 'KWD')
        ? locale.currency_kwd
        : currency;

    final hasDiscount = originalPrice != null &&
        originalPrice!.isNotEmpty &&
        originalPrice != price;

    return Container(
      padding: const EdgeInsets.all(Spacing.sm),
      decoration: BoxDecoration(
        color: color.surface,
        border: Border.all(
          color: hasDiscount
              ? color.primary.withValues(alpha: 0.3)
              : color.outlineVariant,
          width: Spacing.border,
        ),
        borderRadius: BorderRadius.circular(Spacing.radiusLg),
      ),
      child: Row(
        children: [
          Container(
            width: Spacing.avatarSm,
            height: Spacing.avatarSm,
            decoration: BoxDecoration(
              color: color.primaryContainer,
              borderRadius: BorderRadius.circular(Spacing.radiusSm),
            ),
            alignment: Alignment.center,
            child: Icon(
              Icons.attach_money_rounded,
              color: color.primary,
              size: Spacing.iconSm,
            ),
          ),
          const SizedBox(width: Spacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  locale.subscription_summary_total_price_label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: getBoldStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size12,
                    color: color.onSurface,
                  ),
                ),
                if (hasDiscount && discountAmount != null && discountAmount!.isNotEmpty) ...[
                  const SizedBox(height: Spacing.xxs),
                  Text(
                    locale.localeName == 'ar'
                        ? 'وفرت $discountAmount $effectiveCurrency'
                        : 'Saved $discountAmount $effectiveCurrency',
                    style: getSemiBoldStyle(
                      fontFamily: FontConstant.alexandria,
                      fontSize: FontSize.size10,
                      color: color.primary,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: Spacing.sm),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (hasDiscount) ...[
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      originalPrice!,
                      style: getMediumStyle(
                        fontFamily: FontConstant.alexandria,
                        fontSize: FontSize.size11,
                        color: color.onSurfaceVariant,
                      ).copyWith(
                        decoration: TextDecoration.lineThrough,
                        decorationColor: color.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(width: Spacing.xxs),
                    Text(
                      effectiveCurrency,
                      style: getRegularStyle(
                        fontFamily: FontConstant.alexandria,
                        fontSize: FontSize.size10,
                        color: color.onSurfaceVariant,
                      ).copyWith(
                        decoration: TextDecoration.lineThrough,
                        decorationColor: color.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
              ],
              Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    price,
                    style: getBoldStyle(
                      fontFamily: FontConstant.alexandria,
                      fontSize: FontSize.size26,
                      color: color.primary,
                    ),
                  ),
                  const SizedBox(width: Spacing.xs),
                  Text(
                    effectiveCurrency,
                    style: getBoldStyle(
                      fontFamily: FontConstant.alexandria,
                      fontSize: FontSize.size14,
                      color: color.onSurface,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
