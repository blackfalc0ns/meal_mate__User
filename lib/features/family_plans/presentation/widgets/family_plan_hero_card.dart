import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/features/family_plans/presentation/models/family_ui_models.dart';

class FamilyPlanHeroCard extends StatelessWidget {
  const FamilyPlanHeroCard({super.key, required this.plan});

  final FamilyPlanDetailsUiModel plan;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 350 / 189,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(Spacing.cardRadius),
        child: Image.asset(
          Assets.familyBanner,
          fit: BoxFit.cover,
          alignment: Alignment.center,
        ),
      ),
    );
  }
}
