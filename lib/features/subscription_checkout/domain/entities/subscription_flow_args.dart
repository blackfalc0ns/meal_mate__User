import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_summary_request_entity.dart';

class SubscriptionFlowArgs {
  const SubscriptionFlowArgs({this.request});

  final SubscriptionSummaryRequestEntity? request;

  bool get isSubscriptionSource => true;
}
