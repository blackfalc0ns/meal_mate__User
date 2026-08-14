import 'package:meal_meat_user/features/monthly_plans/domain/entities/monthly_plan_details_entity.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_summary_request_entity.dart';

class SubscriptionSummaryArgs {
  const SubscriptionSummaryArgs({
    required this.initialPlan,
    required this.request,
  });

  final MonthlyPlanDetailsEntity initialPlan;
  final SubscriptionSummaryRequestEntity request;
}
