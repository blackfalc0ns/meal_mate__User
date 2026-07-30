import 'package:meal_meat_user/core/constants/assets_fake.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';

class OfferDetailsFakeDataSource {
  const OfferDetailsFakeDataSource();

  OfferDetailsData getOfferDetails() {
    return const OfferDetailsData(
      heroImageAsset: AssetsFake.offerDetailsHeroBanner,
      couponCode: 'SAVE20',
      infoRows: [
        OfferDetailsInfoRowData(
          label: 'نوع العرض',
          value: 'خصم عى الباقات الشهرية',
          icon: OfferDetailsIconType.tag,
        ),
        OfferDetailsInfoRowData(
          label: 'مدة العرض',
          value: 'ينتهي خلال 24 : 18 : 15',
          emphasizedValue: '24 : 18 : 15',
          icon: OfferDetailsIconType.calendar,
        ),
        OfferDetailsInfoRowData(
          label: 'صالح على',
          value: 'جميع الباقات الشهرية',
          icon: OfferDetailsIconType.box,
        ),
        OfferDetailsInfoRowData(
          label: 'الشروط',
          value: 'لا يدمج مع عروض آخرى',
          icon: OfferDetailsIconType.document,
        ),
      ],
      benefitsTitle: 'لماذا هذا العرض؟',
      benefits: [
        OfferDetailsBenefitData(
          title: 'توفير أكبر',
          description: 'احصل على قيمة أفضل بسعر أقل',
          icon: OfferDetailsIconType.money,
        ),
        OfferDetailsBenefitData(
          title: 'مناسب للأهداف',
          description: 'خطط غذائية لدعم أهدافك الصحية والرياضية',
          icon: OfferDetailsIconType.target,
        ),
        OfferDetailsBenefitData(
          title: 'مرونة في الأختيار',
          description: 'اختر الباقة التي تناسبك وغيرها وقت ما تحتاج',
          icon: OfferDetailsIconType.sliders,
        ),
      ],
    );
  }

  List<OfferDetailsPlanData> getPlans(AppLocalizations l10n) => [
    OfferDetailsPlanData(
      title: l10n.offer_details_plan_month_title,
      duration: l10n.offer_details_plan_duration_month,
      meals: l10n.offer_details_plan_meals,
      originalPrice: '52.000',
      discountedPrice: '41.600',
      imageAsset: AssetsFake.mealBoxes,
    ),
    OfferDetailsPlanData(
      title: l10n.offer_details_plan_half_month_title,
      duration: l10n.offer_details_plan_duration_half_month,
      meals: l10n.offer_details_plan_meals,
      originalPrice: '26.000',
      discountedPrice: '20.600',
      imageAsset: AssetsFake.mealBoxes,
    ),
    OfferDetailsPlanData(
      title: l10n.offer_details_plan_week_title,
      duration: l10n.offer_details_plan_duration_week,
      meals: l10n.offer_details_plan_meals,
      originalPrice: '14.000',
      discountedPrice: '11.600',
      imageAsset: AssetsFake.mealBoxes,
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

class OfferDetailsData {
  const OfferDetailsData({
    required this.heroImageAsset,
    required this.couponCode,
    required this.infoRows,
    required this.benefitsTitle,
    required this.benefits,
  });

  final String heroImageAsset;
  final String couponCode;
  final List<OfferDetailsInfoRowData> infoRows;
  final String benefitsTitle;
  final List<OfferDetailsBenefitData> benefits;
}

class OfferDetailsInfoRowData {
  const OfferDetailsInfoRowData({
    required this.label,
    required this.value,
    required this.icon,
    this.emphasizedValue,
  });

  final String label;
  final String value;
  final String? emphasizedValue;
  final OfferDetailsIconType icon;
}

class OfferDetailsBenefitData {
  const OfferDetailsBenefitData({
    required this.title,
    required this.description,
    required this.icon,
  });

  final String title;
  final String description;
  final OfferDetailsIconType icon;
}

enum OfferDetailsIconType {
  tag,
  calendar,
  target,
  box,
  document,
  copy,
  sliders,
  money,
}
