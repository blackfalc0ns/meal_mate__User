import 'package:meal_meat_user/features/subscription_settings/domain/entities/family_management_entity.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/manager/family_calendar_view_model.dart';

class FamilyRestaurantsArgs {
  const FamilyRestaurantsArgs({
    required this.subscriptionId,
    required this.date,
    required this.memberName,
    this.memberId,
    this.members = const [],
    this.slot = '',
    this.viewModel,
  });

  final String subscriptionId;
  final DateTime date;
  final String memberName;
  final String? memberId;
  final List<FamilyMemberSummaryEntity> members;
  final String slot;
  final FamilyCalendarViewModel? viewModel;
}
