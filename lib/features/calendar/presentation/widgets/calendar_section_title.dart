part of 'calendar_meal_picker_sheet.dart';

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.mealType});

  final String mealType;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 36),
      child: Text(
        locale.calendar_meals_for(mealType),
        textAlign: TextAlign.right,
        style: getBoldStyle(
          fontFamily: FontConstant.ibmPlexSansArabic,
          fontSize: 18,
          color: color.onSurface,
        ),
      ),
    );
  }
}
