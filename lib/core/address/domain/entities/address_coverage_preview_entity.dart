import 'package:meal_meat_user/core/address/domain/entities/address_coverage_pagination_entity.dart';
import 'package:meal_meat_user/core/address/domain/entities/customer_address_entity.dart';

class AddressCoveragePreviewEntity {
  const AddressCoveragePreviewEntity({
    required this.canSetAsDefault,
    required this.isCurrentSubscriptionRestaurantCovered,
    this.uncoveredRestaurantNameAr,
    this.uncoveredRestaurantNameEn,
    this.conflictMessage,
    this.resolvedRegionId,
    this.resolvedRegionNameAr,
    this.resolvedRegionNameEn,
    this.governorate,
    this.area,
    this.block,
    this.latitude,
    this.longitude,
    required this.hasActiveSubscription,
    this.restaurantCoverageNotice,
    this.servingRestaurants = const [],
    this.pagination,
  });

  final bool canSetAsDefault;
  final bool isCurrentSubscriptionRestaurantCovered;
  final String? uncoveredRestaurantNameAr;
  final String? uncoveredRestaurantNameEn;
  final String? conflictMessage;
  final String? resolvedRegionId;
  final String? resolvedRegionNameAr;
  final String? resolvedRegionNameEn;
  final String? governorate;
  final String? area;
  final String? block;
  final double? latitude;
  final double? longitude;
  final bool hasActiveSubscription;
  final CustomerAddressCoverageNoticeEntity? restaurantCoverageNotice;
  final List<ServingRestaurantEntity> servingRestaurants;
  final AddressCoveragePaginationEntity? pagination;

  String? uncoveredRestaurantName(String localeName) {
    if (localeName.startsWith('ar')) {
      return (uncoveredRestaurantNameAr != null &&
              uncoveredRestaurantNameAr!.isNotEmpty)
          ? uncoveredRestaurantNameAr
          : uncoveredRestaurantNameEn;
    }
    return (uncoveredRestaurantNameEn != null &&
            uncoveredRestaurantNameEn!.isNotEmpty)
        ? uncoveredRestaurantNameEn
        : uncoveredRestaurantNameAr;
  }

  AddressCoveragePreviewEntity copyWith({
    bool? canSetAsDefault,
    bool? isCurrentSubscriptionRestaurantCovered,
    String? uncoveredRestaurantNameAr,
    String? uncoveredRestaurantNameEn,
    String? conflictMessage,
    String? resolvedRegionId,
    String? resolvedRegionNameAr,
    String? resolvedRegionNameEn,
    String? governorate,
    String? area,
    String? block,
    double? latitude,
    double? longitude,
    bool? hasActiveSubscription,
    CustomerAddressCoverageNoticeEntity? restaurantCoverageNotice,
    List<ServingRestaurantEntity>? servingRestaurants,
    AddressCoveragePaginationEntity? pagination,
    bool clearPagination = false,
  }) {
    return AddressCoveragePreviewEntity(
      canSetAsDefault: canSetAsDefault ?? this.canSetAsDefault,
      isCurrentSubscriptionRestaurantCovered:
          isCurrentSubscriptionRestaurantCovered ??
          this.isCurrentSubscriptionRestaurantCovered,
      uncoveredRestaurantNameAr:
          uncoveredRestaurantNameAr ?? this.uncoveredRestaurantNameAr,
      uncoveredRestaurantNameEn:
          uncoveredRestaurantNameEn ?? this.uncoveredRestaurantNameEn,
      conflictMessage: conflictMessage ?? this.conflictMessage,
      resolvedRegionId: resolvedRegionId ?? this.resolvedRegionId,
      resolvedRegionNameAr: resolvedRegionNameAr ?? this.resolvedRegionNameAr,
      resolvedRegionNameEn: resolvedRegionNameEn ?? this.resolvedRegionNameEn,
      governorate: governorate ?? this.governorate,
      area: area ?? this.area,
      block: block ?? this.block,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      hasActiveSubscription:
          hasActiveSubscription ?? this.hasActiveSubscription,
      restaurantCoverageNotice:
          restaurantCoverageNotice ?? this.restaurantCoverageNotice,
      servingRestaurants: servingRestaurants ?? this.servingRestaurants,
      pagination: clearPagination ? null : (pagination ?? this.pagination),
    );
  }

  static bool _listEquals(
    List<ServingRestaurantEntity> a,
    List<ServingRestaurantEntity> b,
  ) {
    if (identical(a, b)) return true;
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AddressCoveragePreviewEntity &&
          runtimeType == other.runtimeType &&
          canSetAsDefault == other.canSetAsDefault &&
          isCurrentSubscriptionRestaurantCovered ==
              other.isCurrentSubscriptionRestaurantCovered &&
          uncoveredRestaurantNameAr == other.uncoveredRestaurantNameAr &&
          uncoveredRestaurantNameEn == other.uncoveredRestaurantNameEn &&
          conflictMessage == other.conflictMessage &&
          resolvedRegionId == other.resolvedRegionId &&
          resolvedRegionNameAr == other.resolvedRegionNameAr &&
          resolvedRegionNameEn == other.resolvedRegionNameEn &&
          governorate == other.governorate &&
          area == other.area &&
          block == other.block &&
          latitude == other.latitude &&
          longitude == other.longitude &&
          hasActiveSubscription == other.hasActiveSubscription &&
          restaurantCoverageNotice == other.restaurantCoverageNotice &&
          pagination == other.pagination &&
          _listEquals(servingRestaurants, other.servingRestaurants);

  @override
  int get hashCode => Object.hash(
    canSetAsDefault,
    isCurrentSubscriptionRestaurantCovered,
    uncoveredRestaurantNameAr,
    uncoveredRestaurantNameEn,
    conflictMessage,
    resolvedRegionId,
    resolvedRegionNameAr,
    resolvedRegionNameEn,
    governorate,
    area,
    block,
    latitude,
    longitude,
    hasActiveSubscription,
    restaurantCoverageNotice,
    pagination,
    Object.hashAll(servingRestaurants),
  );
}
