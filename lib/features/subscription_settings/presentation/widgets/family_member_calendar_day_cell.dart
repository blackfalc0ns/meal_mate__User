import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_day_entity.dart';

class FamilyMemberCalendarDayCell extends StatelessWidget {
  const FamilyMemberCalendarDayCell({
    super.key,
    required this.day,
    required this.isSelected,
    required this.onTap,
  });

  final CalendarDayEntity day;
  final bool isSelected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final isMuted = day.isMuted;

    final textColor = isSelected
        ? color.onPrimary
        : isMuted
            ? color.onSurface.withValues(alpha: 0.25)
            : color.onSurface;

    return InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: isSelected
                ? BoxDecoration(
                    color: color.primary,
                    shape: BoxShape.circle,
                  )
                : null,
            alignment: Alignment.center,
            child: Text(
              '${day.dayNumber}',
              style: getBoldStyle(
                fontFamily: FontConstant.alexandria,
                fontSize: isSelected ? FontSize.size14 : FontSize.size12,
                color: textColor,
              ).copyWith(height: 1),
            ),
          ),
          const SizedBox(height: 3),
          SizedBox(
            width: 4,
            height: 4,
            child: (!isMuted && !isSelected && day.hasMeals)
                ? DecoratedBox(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: color.primary,
                    ),
                  )
                : null,
          ),
        ],
      ),
    );
  }
}
