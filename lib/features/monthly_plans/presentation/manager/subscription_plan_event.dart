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
