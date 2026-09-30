sealed class SubscriptionPackagesEvent {
  const SubscriptionPackagesEvent();
}

class GetSubscriptionPackagesEvent extends SubscriptionPackagesEvent {
  const GetSubscriptionPackagesEvent(this.programId);

  final String programId;
}
