class LocationsCatalogEntity {
  const LocationsCatalogEntity({
    required this.countryId,
    required this.countryCode,
    this.governorates = const [],
  });

  final String countryId;
  final String countryCode;
  final List<LocationGovernorateEntity> governorates;
}

class LocationGovernorateEntity {
  const LocationGovernorateEntity({
    required this.id,
    required this.code,
    required this.nameAr,
    required this.nameEn,
    this.areas = const [],
  });

  final String id;
  final String code;
  final String nameAr;
  final String nameEn;
  final List<LocationAreaEntity> areas;

  String nameForLanguage(String languageCode) {
    return languageCode == 'ar' && nameAr.isNotEmpty ? nameAr : nameEn;
  }
}

class LocationAreaEntity {
  const LocationAreaEntity({
    required this.id,
    required this.code,
    required this.nameAr,
    required this.nameEn,
    this.blocks = const [],
  });

  final String id;
  final String code;
  final String nameAr;
  final String nameEn;
  final List<LocationBlockEntity> blocks;

  String nameForLanguage(String languageCode) {
    return languageCode == 'ar' && nameAr.isNotEmpty ? nameAr : nameEn;
  }
}

class LocationBlockEntity {
  const LocationBlockEntity({
    required this.id,
    required this.code,
    required this.nameAr,
    required this.nameEn,
  });

  final String id;
  final String code;
  final String nameAr;
  final String nameEn;

  String nameForLanguage(String languageCode) {
    return languageCode == 'ar' && nameAr.isNotEmpty ? nameAr : nameEn;
  }
}
