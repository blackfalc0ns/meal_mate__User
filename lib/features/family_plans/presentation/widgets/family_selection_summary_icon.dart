import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/family_plans/presentation/models/family_ui_models.dart';

class FamilySelectionSummaryIconView extends StatelessWidget {
  const FamilySelectionSummaryIconView({super.key, required this.icon});

  final FamilySelectionSummaryIcon icon;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return Icon(
      switch (icon) {
        FamilySelectionSummaryIcon.balance => Icons.balance_rounded,
        FamilySelectionSummaryIcon.cutlery => Icons.restaurant_rounded,
        FamilySelectionSummaryIcon.calendar => Icons.calendar_month_rounded,
        FamilySelectionSummaryIcon.check => Icons.check_circle_rounded,
        FamilySelectionSummaryIcon.receipt => Icons.receipt_rounded,
      },
      color: color.primary,
      size: Spacing.iconSm,
    );
  }
}
