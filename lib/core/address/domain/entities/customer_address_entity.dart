import 'package:meal_meat_user/core/address/domain/entities/customer_address_request_entity.dart';

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

  CustomerAddressRequestEntity toRequest({bool isDefault = true}) {
    return CustomerAddressRequestEntity(
      label: label,
      addressLine: addressLine,
      regionId: regionId,
      governorate: governorate,
      area: area,
      block: block,
      blockRegionId: blockRegionId,
      street: street,
      avenue: avenue,
      building: building,
      unit: unit,
      floor: floor,
      latitude: latitude,
      longitude: longitude,
      notes: notes,
      isDefault: isDefault,
      notifyOnDelivery: notifyOnDelivery,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CustomerAddressEntity &&
          runtimeType == other.runtimeType &&
          addressId == other.addressId &&
          label == other.label &&
          addressLine == other.addressLine &&
          regionId == other.regionId &&
          governorate == other.governorate &&
          area == other.area &&
          block == other.block &&
          blockRegionId == other.blockRegionId &&
          street == other.street &&
          avenue == other.avenue &&
          building == other.building &&
          unit == other.unit &&
          floor == other.floor &&
          latitude == other.latitude &&
          longitude == other.longitude &&
          notes == other.notes &&
          isDefault == other.isDefault &&
          isDeliveryActive == other.isDeliveryActive &&
          notifyOnDelivery == other.notifyOnDelivery;

  @override
  int get hashCode => Object.hash(
    addressId,
    label,
    addressLine,
    regionId,
    governorate,
    area,
    block,
    isDefault,
    isDeliveryActive,
  );
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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CustomerAddressCoverageNoticeEntity &&
          runtimeType == other.runtimeType &&
          ar == other.ar &&
          en == other.en;

  @override
  int get hashCode => Object.hash(ar, en);
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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ServingRestaurantEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          nameAr == other.nameAr &&
          nameEn == other.nameEn &&
          logoUrl == other.logoUrl &&
          rating == other.rating;

  @override
  int get hashCode => Object.hash(id, nameAr, nameEn, logoUrl, rating);
}
