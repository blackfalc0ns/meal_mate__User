import 'package:meal_meat_user/features/subscription_settings/domain/entities/family_management_entity.dart';

class FamilyMemberCalendarArgs {
  const FamilyMemberCalendarArgs({
    this.memberId,
    this.displayName,
    this.subscriptionId,
    this.isManager = false,
    this.members = const [],
    this.date,
  });

  final String? memberId;
  final String? displayName;
  final String? subscriptionId;
  final bool isManager;
  final List<FamilyMemberSummaryEntity> members;
  final DateTime? date;
}
