import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';

class OfferDetailsFakeDataSource {
  const OfferDetailsFakeDataSource();

  List<OfferDetailsPlanData> getPlans(AppLocalizations l10n) => [
        OfferDetailsPlanData(
          title: l10n.offer_details_plan_month_title,
          duration: l10n.offer_details_plan_duration_month,
          meals: l10n.offer_details_plan_meals,
          originalPrice: '52.000',
          discountedPrice: '41.600',
          imageAsset: 'assets/images/offers/meal_boxes.png',
        ),
        OfferDetailsPlanData(
          title: l10n.offer_details_plan_half_month_title,
          duration: l10n.offer_details_plan_duration_half_month,
          meals: l10n.offer_details_plan_meals,
          originalPrice: '26.000',
          discountedPrice: '20.600',
          imageAsset: 'assets/images/offers/meal_boxes.png',
        ),
        OfferDetailsPlanData(
          title: l10n.offer_details_plan_week_title,
          duration: l10n.offer_details_plan_duration_week,
          meals: l10n.offer_details_plan_meals,
          originalPrice: '14.000',
          discountedPrice: '11.600',
          imageAsset: 'assets/images/offers/meal_boxes.png',
        ),
      ];
}

class OfferDetailsPlanData {
  const OfferDetailsPlanData({
    required this.title,
    required this.duration,
    required this.meals,
    required this.originalPrice,
    required this.discountedPrice,
    required this.imageAsset,
  });

  final String title;
  final String duration;
  final String meals;
  final String originalPrice;
  final String discountedPrice;
  final String imageAsset;
}
