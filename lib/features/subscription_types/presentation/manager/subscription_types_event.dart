import 'package:meal_meat_user/features/subscription_types/domain/entities/conversion_options_model.dart';

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

class InitializeConversionOptionSelectionEvent extends SubscriptionTypesEvent {
  const InitializeConversionOptionSelectionEvent(this.options);

  final ConversionOptionsModel options;
}

class SelectConversionOptionEvent extends SubscriptionTypesEvent {
  const SelectConversionOptionEvent(this.option);

  final ConversionOptionModel option;
}
