import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/offers/domain/entities/offers_page_entity.dart';

class OffersInviteBanner extends StatelessWidget {
  const OffersInviteBanner({super.key, required this.banner});

  final InviteBannerEntity banner;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Container(
      height: Spacing.offersInviteBannerHeight,
      margin: const EdgeInsets.symmetric(
        horizontal: Spacing.offersHorizontalPadding,
      ),
      decoration: BoxDecoration(
        color: color.tertiaryContainer,
        borderRadius: BorderRadius.circular(Spacing.offersInviteBannerRadius),
      ),
      clipBehavior: Clip.antiAlias,
      child: Semantics(
        label: '${locale.nav_offers}: ${banner.buttonLabel}',
        child: Image.asset(
          banner.bannerImageAsset,
          fit: BoxFit.cover,
          width: double.infinity,
        ),
      ),
    );
  }
}
