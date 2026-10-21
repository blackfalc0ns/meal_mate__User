class OfferDetailsData {
  const OfferDetailsData({
    this.heroImageUrl,
    this.couponCode,
    required this.infoRows,
    required this.benefitsTitle,
    required this.benefits,
    this.discountRate,
    this.discountText,
    this.offerHeading,
    this.offerSubtitle,
    this.endsAt,
    this.serverNowUtc,
    this.isFeatured = true,
    this.isCodeActive = true,
  });

  final String? heroImageUrl;
  final String? couponCode;
  final List<OfferDetailsInfoRowData> infoRows;
  final String benefitsTitle;
  final List<OfferDetailsBenefitData> benefits;
  final double? discountRate;
  final String? discountText;
  final String? offerHeading;
  final String? offerSubtitle;
  final DateTime? endsAt;
  final DateTime? serverNowUtc;
  final bool isFeatured;
  final bool isCodeActive;
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
