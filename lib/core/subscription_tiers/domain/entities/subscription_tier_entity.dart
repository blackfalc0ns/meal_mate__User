import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/subscription_tiers/domain/entities/subscription_tier_theme_entity.dart';
import 'package:meal_meat_user/core/widget/restaurant_tier/restaurant_package_tier_ui_model.dart';
import 'package:meal_meat_user/features/monthly_plans/domain/entities/monthly_plan_details_entity.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_availability_entity.dart';

class SubscriptionTierEntity {
  const SubscriptionTierEntity({
    required this.tier,
    required this.nameAr,
    required this.nameEn,
    required this.logoUrl,
    required this.descriptionAr,
    required this.descriptionEn,
    required this.restaurantCount,
    required List<SubscriptionTierRestaurantEntity> restaurants,
    this.durationDays,
    this.totalPrice,
    this.dailyPrice,
    this.priceDifference,
    required this.currencyCode,
    required this.selectionCount,
    required this.isRecommended,
    required this.includeFriday,
    this.fridayDays,
    this.totalServiceDays,
    this.theme,
    this.availability,
    this.canSelect = true,
    this.isAvailable = true,
    this.disabledReason,
    this.durationPrices,
    // ignore: prefer_initializing_formals
  }) : _restaurants = restaurants;

  final String tier;
  final String nameAr;
  final String nameEn;
  final String? logoUrl;
  final String descriptionAr;
  final String descriptionEn;
  final int restaurantCount;
  final List<SubscriptionTierRestaurantEntity> _restaurants;
  List<SubscriptionTierRestaurantEntity> get restaurants =>
      effectiveCanSelect ? _restaurants : const [];
  final int? durationDays;
  final double? totalPrice;
  final double? dailyPrice;
  final double? priceDifference;
  final String currencyCode;
  final int selectionCount;
  final bool isRecommended;
  final bool includeFriday;
  final int? fridayDays;
  final int? totalServiceDays;
  final SubscriptionTierThemeEntity? theme;
  final SubscriptionAvailabilityEntity? availability;
  final bool canSelect;
  final bool isAvailable;
  final String? disabledReason;
  final List<DurationPriceEntity>? durationPrices;

  String name(String localeName) {
    final isAr = localeName == 'ar';

    if (isAr) {
      if (nameAr.trim().isNotEmpty) return nameAr.trim();
      if (nameEn.trim().isNotEmpty) return nameEn.trim();
    } else {
      if (nameEn.trim().isNotEmpty) return nameEn.trim();
      if (nameAr.trim().isNotEmpty) return nameAr.trim();
    }

    if (tier.trim().isNotEmpty) return tier.trim();
    return '';
  }

  String description(String localeName) {
    final isAr = localeName == 'ar';
    if (isAr) {
      if (descriptionAr.trim().isNotEmpty) return descriptionAr.trim();
      if (descriptionEn.trim().isNotEmpty) return descriptionEn.trim();
    } else {
      if (descriptionEn.trim().isNotEmpty) return descriptionEn.trim();
      if (descriptionAr.trim().isNotEmpty) return descriptionAr.trim();
    }
    return '';
  }

  bool get effectiveCanSelect {
    if (!canSelect) return false;
    if (!isAvailable) return false;
    if (availability != null && !availability!.effectiveCanSelect) return false;
    return true;
  }

  int get effectiveRestaurantCount => effectiveCanSelect ? restaurantCount : 0;

  MonthlyPackageTierEntity toPackageTier(String localeName) {
    final lower = tier.toLowerCase();
    final icon =
        lower.contains('max') ||
            lower.contains('diamond') ||
            lower.contains('elite')
        ? 'diamond'
        : lower.contains('plus') ||
              lower.contains('crown') ||
              lower.contains('platinum')
        ? 'crown'
        : 'heart';

    final effectivePrice = totalPrice ?? dailyPrice ?? priceDifference;
    final formattedPriceStr = effectivePrice != null
        ? effectivePrice.formattedPrice
        : '';
    final defaultCurrency = localeName == 'ar' ? 'د.ك' : 'KWD';
    final effectiveCurrency = currencyCode.isNotEmpty
        ? (currencyCode == 'KWD' ? defaultCurrency : currencyCode)
        : defaultCurrency;

    return MonthlyPackageTierEntity(
      title: name(localeName),
      subtitle: description(localeName),
      price: formattedPriceStr,
      currency: effectiveCurrency,
      period: '',
      bullets: const [],
      iconName: icon,
      logoUrl: logoUrl,
      restaurantCount: effectiveCanSelect ? restaurantCount : 0,
      restaurantLogoUrls: effectiveCanSelect
          ? restaurants
                .map((restaurant) => restaurant.logoUrl)
                .whereType<String>()
                .toList()
          : const [],
      isPopular: isRecommended,
      canSelect: effectiveCanSelect,
      isAvailable: isAvailable,
      disabledReason: disabledReason,
    );
  }

  RestaurantPackageTierUiModel toTierUiModel(String localeName) {
    final lower = tier.toLowerCase();
    final icon =
        lower.contains('max') ||
            lower.contains('diamond') ||
            lower.contains('elite')
        ? 'diamond'
        : lower.contains('plus') ||
              lower.contains('crown') ||
              lower.contains('platinum')
        ? 'crown'
        : 'heart';

    final effectivePrice = totalPrice ?? dailyPrice ?? priceDifference;
    final formattedPriceStr = effectivePrice != null
        ? effectivePrice.formattedPrice
        : '';
    final defaultCurrency = localeName == 'ar' ? 'د.ك' : 'KWD';
    final effectiveCurrency = currencyCode.isNotEmpty
        ? (currencyCode == 'KWD' ? defaultCurrency : currencyCode)
        : defaultCurrency;

    return RestaurantPackageTierUiModel(
      id: tier,
      title: name(localeName),
      subtitle: description(localeName),
      iconName: icon,
      logoUrl: logoUrl,
      restaurantCount: effectiveCanSelect ? restaurantCount : 0,
      restaurantLogoUrls: effectiveCanSelect
          ? restaurants.map((r) => r.logoUrl).whereType<String>().toList()
          : const [],
      isPopular: isRecommended,
      price: formattedPriceStr,
      currency: effectiveCurrency,
      canSelect: effectiveCanSelect,
      isAvailable: isAvailable,
      disabledReason: disabledReason,
    );
  }
}

class SubscriptionTierRestaurantEntity {
  const SubscriptionTierRestaurantEntity({
    required this.restaurantId,
    required this.logoUrl,
  });

  final String restaurantId;
  final String? logoUrl;
}

class DurationPriceEntity {
  const DurationPriceEntity({
    required this.durationDays,
    required this.totalPrice,
    required this.dailyPrice,
    required this.currencyCode,
  });

  final int durationDays;
  final double totalPrice;
  final double dailyPrice;
  final String currencyCode;
}
