import 'package:flutter/material.dart';
import 'package:meal_meat_user/core/widget/app_filter_strip.dart';
import 'package:meal_meat_user/features/offers/domain/entities/offers_page_entity.dart';

class OffersFilterStrip extends StatelessWidget {
  const OffersFilterStrip({super.key, required this.filters, this.onTap});

  final List<OfferFilterEntity> filters;
  final ValueChanged<int>? onTap;

  @override
  Widget build(BuildContext context) {
    return AppFilterStrip(
      onTap: onTap,
      items: List.generate(filters.length, (index) {
        final filter = filters[index];
        return AppFilterItem(
          label: filter.label,
          icon: _icons[index % _icons.length],
          isSelected: filter.isSelected,
        );
      }),
    );
  }

  static const _icons = [
    Icons.local_fire_department_rounded,
    Icons.local_offer_rounded,
    Icons.restaurant_rounded,
    Icons.restaurant_menu_rounded,
  ];
}
