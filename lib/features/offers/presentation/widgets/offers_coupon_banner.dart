import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/features/offers/domain/entities/offers_page_entity.dart';

class OffersCouponBanner extends StatelessWidget {
  const OffersCouponBanner({super.key, required this.banner});

  final OfferCouponBannerEntity banner;

  @override
  Widget build(BuildContext context) {
   
    return Padding(
      padding: const EdgeInsets.all(Spacing.screenH),
      child: Center(
        child: SizedBox(height: 60,
          child: Image.asset(
            banner.imageAsset,
          fit: BoxFit.cover,
            width: double.infinity,
          ),
        ),
      ),
    );
  }
}
