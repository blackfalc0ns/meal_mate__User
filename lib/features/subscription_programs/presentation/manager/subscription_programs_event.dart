sealed class SubscriptionProgramsEvent {
  const SubscriptionProgramsEvent();
}

class GetSubscriptionProgramsEvent extends SubscriptionProgramsEvent {
  const GetSubscriptionProgramsEvent();
}

class GetSubscriptionProgramBundlesEvent extends SubscriptionProgramsEvent {
  const GetSubscriptionProgramBundlesEvent(this.programId);

  final String programId;
}

class CheckSubscriptionPrerequisitesEvent extends SubscriptionProgramsEvent {
  const CheckSubscriptionPrerequisitesEvent();
}
