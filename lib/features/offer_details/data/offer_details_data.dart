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
    this.heroImageUrl,
    this.couponCode,
    required this.infoRows,
    required this.benefitsTitle,
    required this.benefits,
  });

  final String? heroImageUrl;
  final String? couponCode;
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
