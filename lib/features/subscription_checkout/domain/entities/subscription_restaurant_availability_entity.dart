import 'package:meal_meat_user/core/entities/pagination_entity.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_availability_entity.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_summary_entity.dart';

class SubscriptionRestaurantAvailabilityEntity {
  const SubscriptionRestaurantAvailabilityEntity({
    required this.availability,
    required this.totalCount,
    this.pagination,
    required this.restaurants,
  });

  final SubscriptionAvailabilityEntity availability;
  final int totalCount;
  final PaginationEntity? pagination;
  final List<SubscriptionSummaryRestaurantEntity> restaurants;

  SubscriptionRestaurantAvailabilityEntity copyWith({
    SubscriptionAvailabilityEntity? availability,
    int? totalCount,
    PaginationEntity? pagination,
    List<SubscriptionSummaryRestaurantEntity>? restaurants,
  }) {
    return SubscriptionRestaurantAvailabilityEntity(
      availability: availability ?? this.availability,
      totalCount: totalCount ?? this.totalCount,
      pagination: pagination ?? this.pagination,
      restaurants: restaurants ?? this.restaurants,
    );
  }
}
