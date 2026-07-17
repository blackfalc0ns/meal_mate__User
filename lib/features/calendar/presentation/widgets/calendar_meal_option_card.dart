part of 'calendar_meal_picker_sheet.dart';

class CalendarMealOptionCard extends StatelessWidget {
  const CalendarMealOptionCard({required this.option});

  final CalendarMealPickerOption option;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Spacing.lg, vertical: Spacing.xs),
      child: SizedBox(
        width: 317,
        height: 105,
        child: Row(
          textDirection: TextDirection.ltr,
          children: [
            CalendarSelectButton(selected: option.selected),
            const SizedBox(width: Spacing.lg),
            Expanded(
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 3),
                    Text(
                      option.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: getMediumStyle(
                        fontFamily: FontConstant.ibmPlexSansArabic,
                        fontSize: 16.64,
                        color: color.onSurface,
                      ).copyWith(height: 24.96 / 16.64),
                    ),
                    const SizedBox(height: 7),
                    CalendarMealPickerNutritionRow(option: option),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(top: Spacing.xs),
                      child: Text(
                        locale.calendar_ingredients,
                        style: getBoldStyle(
                          fontFamily: FontConstant.ibmPlexSansArabic,
                          fontSize: FontSize.size10,
                          color: color.onSurface,
                        ),
                      ),
                    ),
                    const SizedBox(height: Spacing.xs),
                    CalendarMealIngredientRow(ingredients: option.ingredients),
                  ],
                ),
              ),
            ),
            const SizedBox(width: Spacing.xss),
            ClipRRect(
              borderRadius: BorderRadius.circular(15.6),
              child: Image.asset(
                option.imageAsset,
                width: 92,
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
