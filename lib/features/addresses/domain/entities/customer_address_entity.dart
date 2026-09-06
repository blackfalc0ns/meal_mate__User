class CustomerAddressEntity {
  const CustomerAddressEntity({
    required this.addressId,
    required this.label,
    required this.addressLine,
    this.regionId,
    this.governorate,
    this.area,
    this.block,
    this.blockRegionId,
    this.street,
    this.avenue,
    this.building,
    this.unit,
    this.floor,
    this.latitude,
    this.longitude,
    this.notes,
    required this.isDefault,
    this.isDeliveryActive = false,
    this.deliveryEffectiveFromUtc,
    this.deliveryChangeNotice,
    required this.notifyOnDelivery,
    this.restaurantCoverageNotice,
    this.servingRestaurants = const [],
  });

  final String addressId;
  final String label;
  final String addressLine;
  final String? regionId;
  final String? governorate;
  final String? area;
  final String? block;
  final String? blockRegionId;
  final String? street;
  final String? avenue;
  final String? building;
  final String? unit;
  final String? floor;
  final double? latitude;
  final double? longitude;
  final String? notes;
  final bool isDefault;
  final bool isDeliveryActive;
  final DateTime? deliveryEffectiveFromUtc;
  final String? deliveryChangeNotice;
  final bool notifyOnDelivery;
  final CustomerAddressCoverageNoticeEntity? restaurantCoverageNotice;
  final List<ServingRestaurantEntity> servingRestaurants;

  bool get canDelete => !isDeliveryActive;
}

class CustomerAddressCoverageNoticeEntity {
  const CustomerAddressCoverageNoticeEntity({
    required this.ar,
    required this.en,
  });

  final String ar;
  final String en;

  bool get hasContent => ar.trim().isNotEmpty || en.trim().isNotEmpty;

  String text(String localeName) {
    if (localeName.startsWith('ar')) {
      return ar.isNotEmpty ? ar : en;
    }
    return en.isNotEmpty ? en : ar;
  }
}

class ServingRestaurantEntity {
  const ServingRestaurantEntity({
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

  String name(String localeName) {
    if (localeName.startsWith('ar')) {
      return nameAr.isNotEmpty ? nameAr : nameEn;
    }
    return nameEn.isNotEmpty ? nameEn : nameAr;
  }
}
