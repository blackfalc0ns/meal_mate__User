import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/features/subscriptions/domain/entities/family_plan_entity.dart';

class FamilyPlanHeroCard extends StatelessWidget {
  const FamilyPlanHeroCard({super.key, required this.plan});

  final FamilyPlanEntity plan;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(Spacing.cardRadius),
      child: Image.asset(
        Assets.familyBanner,
        // fit: BoxFit.cover,
        alignment: Alignment.center,
      ),
    );
  }
}
