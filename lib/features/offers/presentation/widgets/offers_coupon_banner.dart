import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/offers/domain/entities/offers_page_entity.dart';

class OffersCouponBanner extends StatelessWidget {
  const OffersCouponBanner({super.key, required this.banner});

  final OfferCouponBannerEntity banner;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final direction = Directionality.of(context);

    return Container(
      height: Spacing.offersCouponBannerHeight,
      margin: const EdgeInsets.symmetric(
        horizontal: Spacing.offersHorizontalPadding,
      ),
      padding: const EdgeInsets.symmetric(horizontal: Spacing.lg),
      decoration: BoxDecoration(
        color: color.tertiaryContainer,
        borderRadius: BorderRadius.circular(Spacing.offersCouponBannerRadius),
      ),
      child: Row(
        children: [
          Expanded(
            child: RichText(
              textAlign: TextAlign.center,
              textDirection: direction,
              text: TextSpan(
                style: getRegularStyle(
                  fontFamily: FontConstant.ibmPlexSansArabic,
                  fontSize: FontSize.size20,
                  color: color.onSurface,
                ).copyWith(height: 1.35),
                children: [
                  TextSpan(text: banner.titlePrefix),
                  TextSpan(
                    text: banner.highlight,
                    style: getBoldStyle(
                      fontFamily: FontConstant.ibmPlexSansArabic,
                      fontSize: FontSize.size20,
                      color: color.onSurface,
                    ).copyWith(height: 1.35),
                  ),
                  TextSpan(text: banner.titleSuffix),
                  TextSpan(text: '\n${banner.secondLine}'),
                ],
              ),
            ),
          ),
          const SizedBox(width: Spacing.md),
          SizedBox(
            width: Spacing.offersCouponButtonWidth,
            height: Spacing.offersCouponButtonHeight,
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: Icon(
                Icons.arrow_back_ios_new_rounded,
                size: Spacing.iconSm,
                color: color.onSecondary,
                semanticLabel: locale.offers_coupon_button,
              ),
              label: Text(
                banner.buttonLabel,
                style: getBoldStyle(
                  fontFamily: FontConstant.ibmPlexSansArabic,
                  fontSize: FontSize.size12,
                  color: color.onSecondary,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: color.secondary,
                foregroundColor: color.onSecondary,
                padding: const EdgeInsets.symmetric(horizontal: Spacing.sm),
                shape: const StadiumBorder(),
                elevation: Spacing.cardElevation,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
