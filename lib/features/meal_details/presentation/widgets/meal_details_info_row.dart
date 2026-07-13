import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/meal_details/domain/entities/meal_details_entity.dart';
import 'package:meal_meat_user/features/meal_details/presentation/widgets/meal_details_info_item.dart';

class MealDetailsInfoRow extends StatelessWidget {
  const MealDetailsInfoRow({super.key, required this.meal});

  final MealDetailsEntity meal;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Row(
      children: [
        MealDetailsInfoItem(
          icon: Icons.monitor_weight_rounded,
          label: meal.programLabel,
          value: meal.programValue,
        ),
        SizedBox(
          height: Spacing.iconLg,
          child: VerticalDivider(color: color.outlineVariant),
        ),
        MealDetailsInfoItem(
          icon: Icons.access_time_filled_rounded,
          label: meal.deliveryLabel,
          value: meal.deliveryValue,
        ),
        SizedBox(width: locale.localeName == 'ar' ? 0 : Spacing.xs),
      ],
    );
  }
}
