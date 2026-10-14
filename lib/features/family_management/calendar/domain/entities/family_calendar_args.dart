import 'package:meal_meat_user/features/calendar/domain/entities/calendar_restaurant_option_entity.dart';
import 'package:meal_meat_user/features/family_management/calendar/presentation/manager/family_calendar_view_model.dart';
import 'package:meal_meat_user/features/family_management/overview/domain/entities/family_member_summary_entity.dart';

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

class FamilyDayMealsArgs {
  const FamilyDayMealsArgs({
    required this.subscriptionId,
    required this.date,
    this.memberName,
    this.memberId,
    this.members = const [],
    this.viewModel,
  });

  final String subscriptionId;
  final DateTime date;
  final String? memberName;
  final String? memberId;
  final List<FamilyMemberSummaryEntity> members;
  final FamilyCalendarViewModel? viewModel;
}

class FamilyRestaurantsArgs {
  const FamilyRestaurantsArgs({
    required this.subscriptionId,
    required this.date,
    this.memberName,
    this.memberId,
    this.members = const [],
    this.slot = '',
    this.viewModel,
  });

  final String subscriptionId;
  final DateTime date;
  final String? memberName;
  final String? memberId;
  final List<FamilyMemberSummaryEntity> members;
  final String slot;
  final FamilyCalendarViewModel? viewModel;
}

class FamilyMealSelectionArgs {
  const FamilyMealSelectionArgs({
    required this.subscriptionId,
    required this.date,
    this.restaurantId = '',
    this.restaurant,
    this.restaurantName = '',
    this.memberName,
    this.memberId,
    this.slot = '',
    this.members = const [],
    this.viewModel,
  });

  final String subscriptionId;
  final DateTime date;
  final String restaurantId;
  final CalendarRestaurantOptionEntity? restaurant;
  final String? restaurantName;
  final String? memberName;
  final String? memberId;
  final String slot;
  final List<FamilyMemberSummaryEntity> members;
  final FamilyCalendarViewModel? viewModel;
}

class FamilyReviewMemberMealsArgs {
  const FamilyReviewMemberMealsArgs({
    required this.subscriptionId,
    required this.date,
    this.memberName,
    this.memberId,
    this.members = const [],
    this.viewModel,
  });

  final String subscriptionId;
  final DateTime date;
  final String? memberName;
  final String? memberId;
  final List<FamilyMemberSummaryEntity> members;
  final FamilyCalendarViewModel? viewModel;
}
