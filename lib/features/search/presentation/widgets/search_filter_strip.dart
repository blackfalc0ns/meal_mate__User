import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class SearchFilterStrip extends StatelessWidget {
  const SearchFilterStrip({
    super.key,
    required this.selectedIndex,
    required this.onSelected,
  });

  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final labels = [
      locale.search_filter_all,
      locale.search_filter_meals,
      locale.search_filter_restaurants,
      locale.search_filter_plans,
    ];
    final icons = [
      Icons.grid_view_rounded,
      Icons.ramen_dining_rounded,
      Icons.location_on_rounded,
      Icons.assignment_rounded,
    ];

    return SizedBox(
      height: Spacing.xxxl - Spacing.xss,
      child: ListView.separated(
        reverse: true,
        scrollDirection: Axis.horizontal,
        itemCount: labels.length,
        separatorBuilder: (_, _) => const SizedBox(width: Spacing.sm),
        itemBuilder: (context, index) {
          final selected = index == selectedIndex;
          return ChoiceChip(
            selected: selected,
            onSelected: (_) => onSelected(index),
            avatar: Icon(
              icons[index],
              size: Spacing.iconSm,
              color: selected ? color.onPrimary : color.primary,
            ),
            label: Text(
              labels[index],
              style: getMediumStyle(
                fontFamily: FontConstant.alexandria,
                fontSize: FontSize.size10,
                color: selected ? color.onPrimary : color.onSurface,
              ),
            ),
            selectedColor: color.primary,
            backgroundColor: color.surface,
            side: BorderSide(
              color: selected ? color.primary : color.outlineVariant,
            ),
            shape: const StadiumBorder(),
          );
        },
      ),
    );
  }
}
