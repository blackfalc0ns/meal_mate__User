sealed class SubscriptionTypesEvent {
  const SubscriptionTypesEvent();
}

class GetSubscriptionTypesEvent extends SubscriptionTypesEvent {
  const GetSubscriptionTypesEvent();
}

class GetSubscriptionConversionOptionsEvent extends SubscriptionTypesEvent {
  const GetSubscriptionConversionOptionsEvent();
}

class ConvertFromIndividualEvent extends SubscriptionTypesEvent {
  const ConvertFromIndividualEvent();
}
