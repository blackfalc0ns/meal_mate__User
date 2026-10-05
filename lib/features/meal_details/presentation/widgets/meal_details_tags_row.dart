import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/features/meal_details/domain/entities/meal_details_entity.dart';
import 'package:meal_meat_user/features/meal_details/presentation/widgets/meal_details_tag_chip.dart';

class MealDetailsTagsRow extends StatelessWidget {
  const MealDetailsTagsRow({super.key, required this.tags});

  final List<MealDetailsTagEntity> tags;

  @override
  Widget build(BuildContext context) {
    if (tags.isEmpty) {
      return const SizedBox.shrink();
    }

    return Row(
      children: [
        for (int i = 0; i < tags.length; i++) ...[
          Expanded(child: MealDetailsTagChip(tag: tags[i])),
          if (i < tags.length - 1) const SizedBox(width: Spacing.sm),
        ],
      ],
    );
  }
}
