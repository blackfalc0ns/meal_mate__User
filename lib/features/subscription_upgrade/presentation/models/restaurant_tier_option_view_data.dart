import 'package:flutter/foundation.dart';
import 'package:meal_meat_user/features/subscription_upgrade/domain/entities/subscription_upgrade_entity.dart';
import 'package:meal_meat_user/features/subscription_upgrade/presentation/helpers/restaurant_tier_helpers.dart';

enum RestaurantTierOptionType { current, plus, max }

@immutable
class RestaurantTierOptionViewData {
  const RestaurantTierOptionViewData({
    required this.option,
    required this.index,
    required this.badgeAsset,
    this.imageUrl,
    required this.optionType,
  });

  factory RestaurantTierOptionViewData.fromEntity({
    required SubscriptionUpgradeOptionEntity option,
    int index = 0,
  }) {
    final optionType = RestaurantTierHelpers.optionType(
      isCurrent: option.isCurrent,
      index: index,
      tierCode: option.targetTier,
    );
    return RestaurantTierOptionViewData(
      option: option,
      index: index,
      badgeAsset: RestaurantTierHelpers.badgeAssetForIndex(index),
      imageUrl: option.logoUrl,
      optionType: optionType,
    );
  }

  final SubscriptionUpgradeOptionEntity option;
  final int index;
  final String badgeAsset;
  final String? imageUrl;
  final RestaurantTierOptionType optionType;

  String get targetTier => option.targetTier;
  bool get isCurrent => option.isCurrent;
  bool get selectable => option.selectable;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RestaurantTierOptionViewData &&
          runtimeType == other.runtimeType &&
          option == other.option &&
          index == other.index &&
          badgeAsset == other.badgeAsset &&
          imageUrl == other.imageUrl &&
          optionType == other.optionType;

  @override
  int get hashCode =>
      Object.hash(option, index, badgeAsset, imageUrl, optionType);
}
