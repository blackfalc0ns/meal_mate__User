import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/subscription_settings/data/family_restaurants_fake_data_source.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/family_restaurants_filter_chip.dart';

class FamilyRestaurantsFilterStrip extends StatelessWidget {
  const FamilyRestaurantsFilterStrip({super.key, required this.filters});

  final List<FamilyRestaurantsFilterData> filters;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    color.surface;
    locale.localeName;

    return SizedBox(
      height: Spacing.familyRestaurantsFilterHeight,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: filters.length,
        separatorBuilder: (_, _) =>
            const SizedBox(width: Spacing.familyRestaurantsFilterGap),
        itemBuilder: (context, index) {
          return FamilyRestaurantsFilterChip(filter: filters[index]);
        },
      ),
    );
  }
}
