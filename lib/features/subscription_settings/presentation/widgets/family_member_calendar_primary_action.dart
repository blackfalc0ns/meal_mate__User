import 'package:flutter/material.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/family_day_review_button.dart';

class FamilyMemberCalendarPrimaryAction extends StatelessWidget {
  const FamilyMemberCalendarPrimaryAction({
    super.key,
    required this.hasMeals,
    required this.canEdit,
    required this.onChooseMeals,
    required this.onShowDetails,
  });

  final bool hasMeals;
  final bool canEdit;
  final VoidCallback onChooseMeals;
  final VoidCallback onShowDetails;

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;

    return FamilyDayReviewButton(
      label: !canEdit
          ? locale.family_member_day_closed_button
          : hasMeals
          ? locale.family_member_day_details_button
          : locale.family_member_choose_meals_button,
      onPressed: !canEdit ? null : (hasMeals ? onShowDetails : onChooseMeals),
    );
  }
}
