import 'package:meal_meat_user/features/subscription_settings/domain/entities/family_day_details_entity.dart';

class FamilyMemberCalendarEntity {
  const FamilyMemberCalendarEntity({
    required this.title,
    required this.month,
    required this.selectedDay,
    required this.detailsButtonLabel,
    required this.members,
    required this.selectedMealsTitle,
    required this.selectedMealsSubtitle,
    required this.selectedMealsCountLabel,
    required this.daySummary,
    required this.selectedMeals,
  });

  final String title;
  final DateTime month;
  final int selectedDay;
  final String detailsButtonLabel;
  final List<FamilyDayMemberEntity> members;
  final String selectedMealsTitle;
  final String selectedMealsSubtitle;
  final String selectedMealsCountLabel;
  final FamilyCalendarDaySummaryEntity daySummary;
  final List<FamilyCalendarSelectedMealEntity> selectedMeals;
}

class FamilyCalendarDaySummaryEntity {
  const FamilyCalendarDaySummaryEntity({
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;
}

class FamilyCalendarSelectedMealEntity {
  const FamilyCalendarSelectedMealEntity({
    required this.typeLabel,
    required this.name,
    required this.description,
    required this.chosenLabel,
    required this.imageAsset,
  });

  final String typeLabel;
  final String name;
  final String description;
  final String chosenLabel;
  final String imageAsset;
}
