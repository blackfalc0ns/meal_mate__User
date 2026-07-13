part of 'calendar_meal_picker_sheet.dart';

class _MealOptionCard extends StatelessWidget {
  const _MealOptionCard({required this.selected});

  final bool selected;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 36.4, end: 36.4),
      child: SizedBox(
        width: 317,
        height: 97,
        child: Row(
          textDirection: TextDirection.ltr,
          children: [
            _SelectButton(selected: selected),
            const SizedBox(width: Spacing.lg),
            Expanded(
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 3),
                    Text(
                      locale.calendar_meal_name,
                      style: getMediumStyle(
                        fontFamily: FontConstant.ibmPlexSansArabic,
                        fontSize: 16.64,
                        color: color.onSurface,
                      ).copyWith(height: 24.96 / 16.64),
                    ),
                    const SizedBox(height: 7),
                    const _MealNutritionRow(),
                    const Spacer(),
                    Text(
                      locale.calendar_ingredients,
                      style: getSemiBoldStyle(
                        fontFamily: FontConstant.ibmPlexSansArabic,
                        fontSize: 6.8,
                        color: color.onSurface,
                      ),
                    ),
                    const SizedBox(height: Spacing.xs),
                    const _MealIngredientRow(),
                  ],
                ),
              ),
            ),
            const SizedBox(width: Spacing.xss),
            ClipRRect(
              borderRadius: BorderRadius.circular(15.6),
              child: Image.asset(
                Assets.calendarMealPickerBreakfast,
                width: 88,
                height: 92,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
