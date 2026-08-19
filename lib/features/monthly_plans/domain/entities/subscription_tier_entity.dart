import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/monthly_plans/domain/entities/monthly_plan_details_entity.dart';

class SubscriptionTierEntity {
  const SubscriptionTierEntity({
    required this.tier,
    required this.nameAr,
    required this.nameEn,
    required this.logoUrl,
    required this.descriptionAr,
    required this.descriptionEn,
    required this.restaurantCount,
    required this.restaurants,
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
  });

  final String tier;
  final String nameAr;
  final String nameEn;
  final String? logoUrl;
  final String descriptionAr;
  final String descriptionEn;
  final int restaurantCount;
  final List<SubscriptionTierRestaurantEntity> restaurants;
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

  String name(String localeName) => localeName == 'ar' ? nameAr : nameEn;

  String description(String localeName) =>
      localeName == 'ar' ? descriptionAr : descriptionEn;

  MonthlyPackageTierEntity toPackageTier(String localeName) {
    return MonthlyPackageTierEntity(
      title: name(localeName),
      subtitle: description(localeName),
      price: totalPrice == null ? '' : totalPrice!.formattedPrice,
      currency: currencyCode,
      period: '',
      bullets: const [],
      iconName: tier.toLowerCase(),
      logoUrl: logoUrl,
      restaurantCount: restaurantCount,
      restaurantLogoUrls: restaurants
          .map((restaurant) => restaurant.logoUrl)
          .whereType<String>()
          .toList(),
      isPopular: isRecommended,
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
