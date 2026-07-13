part of 'calendar_meal_picker_sheet.dart';

class CalendarMealPickerRestaurantHeader extends StatelessWidget {
  const CalendarMealPickerRestaurantHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return SizedBox(
      height: 31,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          const PositionedDirectional(
            top: 2,
            end: Spacing.lg,
            child: CalendarProteinLogo(size: 59.9),
          ),
          PositionedDirectional(
            top: 0,
            end: Spacing.xxxl + Spacing.xxl + Spacing.sm,
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: Row(
                children: [
                  Icon(
                    Icons.verified_user_rounded,
                    color: color.primary,
                    size: Spacing.iconMd + Spacing.xs,
                  ),
                  const SizedBox(width: Spacing.md),
                  Text(
                    locale.calendar_restaurant_name,
                    textAlign: TextAlign.right,
                    style: getMediumStyle(
                      fontFamily: FontConstant.ibmPlexSansArabic,
                      fontSize: 20.8,
                      color: color.onSurface,
                    ).copyWith(letterSpacing: 0.46),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
