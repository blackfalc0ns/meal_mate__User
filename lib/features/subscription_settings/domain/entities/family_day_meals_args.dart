import 'package:meal_meat_user/features/subscription_settings/domain/entities/family_management_entity.dart';

class FamilyDayMealsArgs {
  const FamilyDayMealsArgs({
    required this.subscriptionId,
    required this.date,
    this.memberName,
    this.memberId,
    this.members = const [],
  });

  final String subscriptionId;
  final DateTime date;
  final String? memberName;
  final String? memberId;
  final List<FamilyMemberSummaryEntity> members;
}
