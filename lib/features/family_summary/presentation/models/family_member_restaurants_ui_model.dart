import 'package:flutter/foundation.dart';
import 'package:meal_meat_user/features/family_summary/domain/entities/family_summary_entity.dart';

@immutable
class FamilyMemberRestaurantsUiModel {
  const FamilyMemberRestaurantsUiModel({
    required this.memberId,
    required this.memberName,
    required this.restaurants,
    required this.repetitionLimit,
    required this.restaurantCount,
    required this.durationDays,
    required this.isSubscribed,
  });

  final String? memberId;
  final String memberName;
  final List<FamilyMemberRestaurantEntity> restaurants;
  final int repetitionLimit;
  final int restaurantCount;
  final int durationDays;
  final bool isSubscribed;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FamilyMemberRestaurantsUiModel &&
          runtimeType == other.runtimeType &&
          memberId == other.memberId &&
          memberName == other.memberName &&
          repetitionLimit == other.repetitionLimit &&
          restaurantCount == other.restaurantCount &&
          durationDays == other.durationDays &&
          isSubscribed == other.isSubscribed &&
          listEquals(restaurants, other.restaurants);

  @override
  int get hashCode => Object.hash(
    memberId,
    memberName,
    Object.hashAll(restaurants),
    repetitionLimit,
    restaurantCount,
    durationDays,
    isSubscribed,
  );
}
