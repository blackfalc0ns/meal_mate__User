import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class OffersCouponBanner extends StatelessWidget {
  const OffersCouponBanner({super.key, this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.offersHorizontalPadding,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(Spacing.offersCouponBannerRadius),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: Spacing.md,
            vertical: Spacing.sm,
          ),
          decoration: BoxDecoration(
            color: color.tertiary.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(Spacing.offersCouponBannerRadius),
            border: Border.all(
              color: color.tertiary.withValues(alpha: 0.22),
              width: Spacing.border,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Promo Text
              Expanded(
                child: Text.rich(
                  TextSpan(
                    text: locale.offers_coupon_prefix,
                    style: getBoldStyle(
                      fontFamily: FontConstant.alexandria,
                      fontSize: FontSize.size12,
                      color: color.onSurface,
                    ),
                    children: [
                      TextSpan(
                        text: locale.offers_coupon_highlight,
                        style: getBoldStyle(
                          fontFamily: FontConstant.alexandria,
                          fontSize: FontSize.size12,
                          color: color.primary,
                        ),
                      ),
                      TextSpan(
                        text: '${locale.offers_coupon_suffix}\n${locale.offers_coupon_second_line}',
                        style: getMediumStyle(
                          fontFamily: FontConstant.alexandria,
                          fontSize: FontSize.size11,
                          color: color.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: Spacing.sm),

              // Button: استفد الآن
              Container(
                height: Spacing.offersCouponButtonHeight,
                padding: const EdgeInsets.symmetric(
                  horizontal: Spacing.md,
                ),
                decoration: BoxDecoration(
                  color: color.tertiary,
                  borderRadius: BorderRadius.circular(Spacing.radiusPill),
                  boxShadow: [
                    BoxShadow(
                      color: color.tertiary.withValues(alpha: 0.25),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      locale.offers_coupon_button,
                      style: getBoldStyle(
                        fontFamily: FontConstant.alexandria,
                        fontSize: FontSize.size11,
                        color: color.onTertiary,
                      ),
                    ),
                    const SizedBox(width: Spacing.xxs),
                    Transform.flip(
                      flipX: Directionality.of(context) == TextDirection.rtl,
                      child: Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 10,
                        color: color.onTertiary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
