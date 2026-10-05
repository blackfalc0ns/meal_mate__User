sealed class SubscriptionProgramsEvent {
  const SubscriptionProgramsEvent();
}

class GetSubscriptionProgramsEvent extends SubscriptionProgramsEvent {
  const GetSubscriptionProgramsEvent({this.isRefresh = false});

  final bool isRefresh;
}

class LoadMoreSubscriptionProgramsEvent extends SubscriptionProgramsEvent {
  const LoadMoreSubscriptionProgramsEvent();
}

class RetrySubscriptionProgramsEvent extends SubscriptionProgramsEvent {
  const RetrySubscriptionProgramsEvent();
}

class GetSubscriptionProgramBundlesEvent extends SubscriptionProgramsEvent {
  const GetSubscriptionProgramBundlesEvent(this.programId);

  final String programId;
}
