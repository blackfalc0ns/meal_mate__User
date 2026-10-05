sealed class SubscriptionPackagesEvent {
  const SubscriptionPackagesEvent();
}

class GetSubscriptionPackagesEvent extends SubscriptionPackagesEvent {
  const GetSubscriptionPackagesEvent(this.programId, {this.isRefresh = false});

  final String programId;
  final bool isRefresh;
}

class LoadMoreSubscriptionPackagesEvent extends SubscriptionPackagesEvent {
  const LoadMoreSubscriptionPackagesEvent();
}

class RetrySubscriptionPackagesEvent extends SubscriptionPackagesEvent {
  const RetrySubscriptionPackagesEvent();
}
