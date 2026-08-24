class SubscriptionTypeEntity {
  const SubscriptionTypeEntity({
    required this.code,
    required this.nameAr,
    required this.nameEn,
    required this.descriptionAr,
    required this.descriptionEn,
    required this.maxMembers,
    required this.isAvailable,
    required this.membersConfiguredAfterPayment,
    this.disabledReason,
    required this.requiresConversion,
    this.conversionEndpoint,
    required this.imageAsset,
  });

  final String code;
  final String nameAr;
  final String nameEn;
  final String descriptionAr;
  final String descriptionEn;
  final int maxMembers;
  final bool isAvailable;
  final bool membersConfiguredAfterPayment;
  final String? disabledReason;
  final bool requiresConversion;
  final String? conversionEndpoint;
  final String imageAsset;

  bool get isFamily => code == 'FAMILY';

  String name(String localeName) => localeName == 'ar' ? nameAr : nameEn;

  String description(String localeName) =>
      localeName == 'ar' ? descriptionAr : descriptionEn;
}
