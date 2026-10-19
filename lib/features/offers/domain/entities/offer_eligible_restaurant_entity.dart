class OfferEligibleRestaurantEntity {
  const OfferEligibleRestaurantEntity({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    this.logoUrl,
    this.rating,
  });

  final String id;
  final String nameAr;
  final String nameEn;
  final String? logoUrl;
  final double? rating;

  String name(String lang) => lang == 'ar' ? nameAr : (nameEn.isNotEmpty ? nameEn : nameAr);
}
