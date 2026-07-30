import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/offers/domain/entities/offers_page_entity.dart';

class OffersCouponBanner extends StatelessWidget {
  const OffersCouponBanner({super.key, required this.banner});

  final OfferCouponBannerEntity banner;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Container(
      height: Spacing.offersCouponBannerHeight,
      margin: const EdgeInsets.symmetric(
        horizontal: Spacing.offersHorizontalPadding,
      ),
      decoration: BoxDecoration(
        color: color.tertiaryContainer,
        borderRadius: BorderRadius.circular(Spacing.offersCouponBannerRadius),
      ),
      clipBehavior: Clip.antiAlias,
      child: Semantics(
        label: '${locale.nav_offers}: ${banner.buttonLabel}',
        child: Image.asset(
          banner.imageAsset,
          fit: BoxFit.cover,
          width: double.infinity,
        ),
      ),
    );
  }
}
