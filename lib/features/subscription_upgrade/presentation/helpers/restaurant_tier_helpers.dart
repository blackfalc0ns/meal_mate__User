import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/features/subscription_upgrade/presentation/models/restaurant_tier_option_view_data.dart';

abstract class RestaurantTierHelpers {
  static const List<String> availableBadges = [
    Assets.restaurantTierSelect,
    Assets.restaurantTierPlus,
    Assets.restaurantTierMax,
  ];

  /// Returns badge asset based on tier index without hardcoding any tier names.
  static String badgeAssetForIndex(int index) {
    if (index < 0) return Assets.restaurantTierSelect;
    return availableBadges[index % availableBadges.length];
  }

  /// Determines card styling dynamically based on whether it is current and its index.
  static RestaurantTierOptionType optionType({
    required bool isCurrent,
    int index = 0,
  }) {
    if (isCurrent) return RestaurantTierOptionType.current;
    return (index % 2 == 1)
        ? RestaurantTierOptionType.max
        : RestaurantTierOptionType.plus;
  }
}
