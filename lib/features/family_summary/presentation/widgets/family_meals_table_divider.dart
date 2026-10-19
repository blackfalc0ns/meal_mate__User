import 'package:flutter/material.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class FamilyMealsTableDivider extends StatelessWidget {
  const FamilyMealsTableDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      thickness: 1,
      color: context.colorScheme.outlineVariant,
    );
  }
}
