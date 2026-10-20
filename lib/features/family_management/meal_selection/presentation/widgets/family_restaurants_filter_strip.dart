import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/features/family_management/meal_selection/presentation/models/family_restaurants_view_data.dart';
import 'package:meal_meat_user/features/family_management/meal_selection/presentation/widgets/family_restaurants_filter_chip.dart';

class FamilyRestaurantsFilterStrip extends StatelessWidget {
  const FamilyRestaurantsFilterStrip({super.key, required this.filters});

  final List<FamilyRestaurantsFilterData> filters;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: [
          for (var index = 0; index < filters.length; index++) ...[
            if (index > 0)
              const SizedBox(width: Spacing.familyRestaurantsFilterGap),
            FamilyRestaurantsFilterChip(filter: filters[index]),
          ],
        ],
      ),
    );
  }
}
