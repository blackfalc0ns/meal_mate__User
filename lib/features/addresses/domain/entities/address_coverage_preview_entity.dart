import 'package:meal_meat_user/features/addresses/domain/entities/customer_address_entity.dart';

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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AddressCoveragePreviewEntity &&
          runtimeType == other.runtimeType &&
          canSetAsDefault == other.canSetAsDefault &&
          isCurrentSubscriptionRestaurantCovered ==
              other.isCurrentSubscriptionRestaurantCovered &&
          conflictMessage == other.conflictMessage &&
          resolvedRegionId == other.resolvedRegionId &&
          hasActiveSubscription == other.hasActiveSubscription;

  @override
  int get hashCode => Object.hash(
        canSetAsDefault,
        isCurrentSubscriptionRestaurantCovered,
        conflictMessage,
        resolvedRegionId,
        hasActiveSubscription,
      );
}
