import 'package:meal_meat_user/features/subscription_settings/domain/entities/restaurant_tier_upgrade_args.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/entities/subscription_upgrade_entity.dart';

sealed class RestaurantTierUpgradeEvent {
  const RestaurantTierUpgradeEvent();
}

class InitUpgradeConfirmationEvent extends RestaurantTierUpgradeEvent {
  const InitUpgradeConfirmationEvent(this.args);

  final RestaurantTierUpgradeConfirmationArgs args;
}

class LoadUpgradeOptionsEvent extends RestaurantTierUpgradeEvent {
  const LoadUpgradeOptionsEvent({this.subscriptionId});

  final String? subscriptionId;
}

class SelectTierOptionEvent extends RestaurantTierUpgradeEvent {
  const SelectTierOptionEvent(this.option);

  final SubscriptionUpgradeOptionEntity option;
}

class SubmitUpgradeRequestEvent extends RestaurantTierUpgradeEvent {
  const SubmitUpgradeRequestEvent({
    this.paymentMethodId = 1,
    this.reason,
  });

  final int? paymentMethodId;
  final String? reason;
}

class VerifyUpgradeStatusEvent extends RestaurantTierUpgradeEvent {
  const VerifyUpgradeStatusEvent(this.upgradeId);

  final String upgradeId;
}

class MarkUpgradeFailedEvent extends RestaurantTierUpgradeEvent {
  const MarkUpgradeFailedEvent([this.errorMessage]);

  final String? errorMessage;
}

class ResetUpgradeStateEvent extends RestaurantTierUpgradeEvent {
  const ResetUpgradeStateEvent();
}
