import 'package:meal_meat_user/features/subscription_settings/presentation/manager/family_calendar_view_model.dart';

class FamilyReviewMemberMealsArgs {
  const FamilyReviewMemberMealsArgs({
    required this.subscriptionId,
    required this.date,
    required this.memberName,
    this.memberId,
    this.viewModel,
  });

  final String subscriptionId;
  final DateTime date;
  final String memberName;
  final String? memberId;
  final FamilyCalendarViewModel? viewModel;
}
