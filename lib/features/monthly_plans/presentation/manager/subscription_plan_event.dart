sealed class SubscriptionPlanEvent {
  const SubscriptionPlanEvent();
}

class GetSubscriptionDurationsEvent extends SubscriptionPlanEvent {
  const GetSubscriptionDurationsEvent({
    required this.programId,
    required this.bundleId,
    required this.includeFriday,
  });

  final String programId;
  final String bundleId;
  final bool includeFriday;
}

class ToggleSubscriptionFridayEvent extends SubscriptionPlanEvent {
  const ToggleSubscriptionFridayEvent({
    required this.programId,
    required this.bundleId,
    required this.includeFriday,
  });

  final String programId;
  final String bundleId;
  final bool includeFriday;
}

class SelectSubscriptionDurationEvent extends SubscriptionPlanEvent {
  const SelectSubscriptionDurationEvent({
    required this.programId,
    required this.bundleId,
    required this.durationIndex,
  });

  final String programId;
  final String bundleId;
  final int durationIndex;
}

class SelectSubscriptionTierEvent extends SubscriptionPlanEvent {
  const SelectSubscriptionTierEvent(this.tierIndex);

  final int tierIndex;
}

class UpdateCustomSubscriptionDurationEvent extends SubscriptionPlanEvent {
  const UpdateCustomSubscriptionDurationEvent({
    required this.programId,
    required this.bundleId,
    required this.durationDays,
  });

  final String programId;
  final String bundleId;
  final int? durationDays;
}

class BrowseSubscriptionTierRestaurantsEvent extends SubscriptionPlanEvent {
  const BrowseSubscriptionTierRestaurantsEvent({
    required this.programId,
    required this.bundleId,
    required this.tierIndex,
    this.startDate,
  });

  final String programId;
  final String bundleId;
  final int tierIndex;
  final String? startDate;
}

class SelectSubscriptionPlanStartDateEvent extends SubscriptionPlanEvent {
  const SelectSubscriptionPlanStartDateEvent(this.startDate);

  final String startDate;
}

class CheckSubscriptionReadinessEvent extends SubscriptionPlanEvent {
  const CheckSubscriptionReadinessEvent({
    required this.programId,
    required this.bundleId,
    required this.tier,
    required this.durationDays,
    required this.includeFriday,
  });

  final String programId;
  final String bundleId;
  final String tier;
  final int durationDays;
  final bool includeFriday;
}

class CloseSubscriptionTierRestaurantsEvent extends SubscriptionPlanEvent {
  const CloseSubscriptionTierRestaurantsEvent();
}

class LoadMoreSubscriptionTierRestaurantsEvent extends SubscriptionPlanEvent {
  const LoadMoreSubscriptionTierRestaurantsEvent();
}

class RetrySubscriptionTierRestaurantsEvent extends SubscriptionPlanEvent {
  const RetrySubscriptionTierRestaurantsEvent();
}
