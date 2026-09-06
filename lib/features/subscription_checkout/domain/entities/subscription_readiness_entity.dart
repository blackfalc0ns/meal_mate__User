import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_summary_request_entity.dart';

class SubscriptionReadinessEntity {
  const SubscriptionReadinessEntity({
    required this.isComplete,
    required this.canOpenSummary,
    required this.canCheckout,
    required this.nextAction,
    required this.warningAr,
    required this.warningEn,
    this.checkoutBlockReason,
    this.program,
    this.address,
    required this.deliveringRestaurantCount,
    required this.items,
    required this.restaurants,
  });

  final bool isComplete;
  final bool canOpenSummary;
  final bool canCheckout;
  final String nextAction;
  final String warningAr;
  final String warningEn;
  final String? checkoutBlockReason;
  final SubscriptionReadinessProgramEntity? program;
  final SubscriptionReadinessAddressEntity? address;
  final int deliveringRestaurantCount;
  final List<SubscriptionReadinessItemEntity> items;
  final List<SubscriptionReadinessRestaurantEntity> restaurants;

  String warning(String localeName) =>
      localeName == 'ar' ? warningAr : warningEn;

  bool get shouldOpenSummary =>
      canOpenSummary || nextAction.toUpperCase() == 'SUMMARY';

  List<SubscriptionReadinessItemEntity> get incompleteItems =>
      items.where((item) => !item.isComplete).toList();
}

class SubscriptionReadinessProgramEntity {
  const SubscriptionReadinessProgramEntity({
    required this.programId,
    required this.nameAr,
    required this.nameEn,
  });

  final String programId;
  final String nameAr;
  final String nameEn;

  String name(String localeName) => localeName == 'ar' ? nameAr : nameEn;
}

class SubscriptionReadinessAddressEntity {
  const SubscriptionReadinessAddressEntity({
    required this.id,
    required this.label,
    required this.addressLine,
    this.governorate,
    this.area,
    this.block,
    this.regionId,
  });

  final String id;
  final String label;
  final String addressLine;
  final String? governorate;
  final String? area;
  final String? block;
  final String? regionId;
}

class SubscriptionReadinessItemEntity {
  const SubscriptionReadinessItemEntity({
    required this.code,
    required this.isComplete,
    required this.titleAr,
    required this.titleEn,
    required this.actionScreen,
    this.endpoint,
  });

  final String code;
  final bool isComplete;
  final String titleAr;
  final String titleEn;
  final String actionScreen;
  final String? endpoint;

  String title(String localeName) => localeName == 'ar' ? titleAr : titleEn;
}

class SubscriptionReadinessRestaurantEntity {
  const SubscriptionReadinessRestaurantEntity({
    required this.restaurantId,
    required this.nameAr,
    required this.nameEn,
    this.logoUrl,
    required this.tier,
  });

  final String restaurantId;
  final String nameAr;
  final String nameEn;
  final String? logoUrl;
  final String tier;

  String name(String localeName) => localeName == 'ar' ? nameAr : nameEn;
}

class SubscriptionFlowArgs {
  const SubscriptionFlowArgs({this.request});

  final SubscriptionSummaryRequestEntity? request;

  bool get isSubscriptionSource => true;
}
