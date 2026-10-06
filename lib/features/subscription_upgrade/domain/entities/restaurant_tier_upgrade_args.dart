import 'package:meal_meat_user/features/subscription_upgrade/domain/entities/subscription_upgrade_entity.dart';

class RestaurantTierUpgradeArgs {
  const RestaurantTierUpgradeArgs({this.subscriptionId});

  final String? subscriptionId;
}

class RestaurantTierUpgradeConfirmationArgs {
  const RestaurantTierUpgradeConfirmationArgs({
    required this.subscriptionId,
    required this.selectedOption,
    required this.optionsEntity,
    this.programName,
    this.bundleName,
  });

  final String subscriptionId;
  final SubscriptionUpgradeOptionEntity selectedOption;
  final SubscriptionUpgradeOptionsEntity optionsEntity;
  final String? programName;
  final String? bundleName;
}

class RestaurantTierUpgradeWebViewArgs {
  const RestaurantTierUpgradeWebViewArgs({
    required this.subscriptionId,
    required this.upgradeId,
    required this.paymentUrl,
  });

  final String subscriptionId;
  final String upgradeId;
  final String paymentUrl;
}
