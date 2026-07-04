import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/colors.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/features/subscriptions/domain/entities/monthly_plan_details_entity.dart';

class MonthlyPlanFilterStrip extends StatelessWidget {
  const MonthlyPlanFilterStrip({
    super.key,
    required this.filters,
    required this.selectedIndex,
    required this.onSelected,
  });

  final List<MonthlyPlanFilterEntity> filters;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (int index = 0; index < filters.length; index++) ...[
          Expanded(
            child: _PlanFilterChip(
              filter: filters[index],
              selected: selectedIndex == index,
              onTap: () => onSelected(index),
            ),
          ),
          if (index != filters.length - 1) const SizedBox(width: Spacing.sm),
        ],
      ],
    );
  }
}

class _PlanFilterChip extends StatelessWidget {
  const _PlanFilterChip({
    required this.filter,
    required this.selected,
    required this.onTap,
  });

  final MonthlyPlanFilterEntity filter;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final foreground = selected ? AppColors.white : AppColors.appTextMuted;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(Spacing.radiusPill),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOutCubic,
        height: 31,
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : const Color(0xFFECECED),
          borderRadius: BorderRadius.circular(Spacing.radiusPill),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(_iconFor(filter.iconName), size: 16, color: foreground),
            const SizedBox(width: Spacing.xs),
            Flexible(
              child: Text(
                filter.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: getBoldStyle(
                  fontFamily: FontConstant.ibmPlexSansArabic,
                  fontSize: FontSize.size12,
                  color: foreground,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _iconFor(String iconName) {
    switch (iconName) {
      case 'calendar':
        return Icons.calendar_month_outlined;
      case 'restaurant':
        return Icons.restaurant_rounded;
      case 'meal':
        return Icons.ramen_dining_rounded;
      case 'overview':
        return Icons.view_list_rounded;
      default:
        return Icons.circle_outlined;
    }
  }
}
