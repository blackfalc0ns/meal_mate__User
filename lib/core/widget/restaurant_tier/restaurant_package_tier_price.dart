import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/shimmer_widget.dart';

class RestaurantPackageTierPrice extends StatelessWidget {
  const RestaurantPackageTierPrice({
    super.key,
    required this.price,
    required this.currency,
    this.priceSubtitle,
    required this.priceColor,
    required this.subtitleColor,
    required this.dividerColor,
    this.isLoading = false,
  });

  final String price;
  final String currency;
  final String? priceSubtitle;
  final Color priceColor;
  final Color subtitleColor;
  final Color dividerColor;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;
    final effectiveCurrency = currency.isNotEmpty
        ? (currency == 'KWD'
              ? (locale.localeName == 'ar' ? 'د.ك' : 'KWD')
              : currency)
        : locale.currency;
    final hasPrice = price.trim().isNotEmpty;
    final cleanPrice = hasPrice
        ? (num.tryParse(price.trim())?.formattedPrice ?? price.trim())
        : '';
    final subtitle = (priceSubtitle != null && priceSubtitle!.trim().isNotEmpty)
        ? priceSubtitle!
        : locale.subscription_until_end_of_subscription;

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 80.0,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 320),
                reverseDuration: const Duration(milliseconds: 180),
                switchInCurve: Curves.easeOutCubic,
                switchOutCurve: Curves.easeInCubic,
                transitionBuilder: (child, animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 0.25),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    ),
                  );
                },
                child: isLoading
                    ? ShimmerWidget(
                        key: const ValueKey<String>('price-shimmer-loading'),
                        baseColor: priceColor.withValues(alpha: 0.18),
                        highlightColor: priceColor.withValues(alpha: 0.42),
                        child: Container(
                          width: 52.0,
                          height: 14.0,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.circular(Spacing.radiusXs),
                          ),
                        ),
                      )
                    : Row(
                        key: ValueKey<String>(
                          '$cleanPrice-$effectiveCurrency-$hasPrice',
                        ),
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            effectiveCurrency,
                            maxLines: 1,
                            style: getBoldStyle(
                              fontFamily: FontConstant.alexandria,
                              fontSize: FontSize.size10,
                              color: priceColor,
                            ).copyWith(height: 1.15),
                          ),
                          const SizedBox(width: Spacing.xxs),

                          if (hasPrice) ...[
                            Flexible(
                              child: Text(
                                cleanPrice,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: getBoldStyle(
                                  fontFamily: FontConstant.alexandria,
                                  fontSize: FontSize.size12,
                                  color: priceColor,
                                ).copyWith(height: 1.15),
                              ),
                            ),
                          ],
                        ],
                      ),
              ),
              const SizedBox(height: Spacing.xxs),
              Text(
                subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: getMediumStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size8,
                  color: subtitleColor,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: Spacing.xs),
        Container(
          width: Spacing.hairline * 2,
          height: Spacing.lg + Spacing.xs,
          color: dividerColor,
        ),
        const SizedBox(width: Spacing.xs),
      ],
    );
  }
}
