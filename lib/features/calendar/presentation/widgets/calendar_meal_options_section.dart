part of 'calendar_meal_picker_sheet.dart';

class _MealOptionsSection extends StatelessWidget {
  const _MealOptionsSection({required this.mealType});

  final String mealType;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 240),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      child: Column(
        key: ValueKey(mealType),
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _SectionTitle(mealType: mealType),
          const SizedBox(height: Spacing.lg),
          const _MealOptionCard(selected: false),
          const _DividerLine(),
          const _MealOptionCard(selected: true),
          const _DividerLine(),
          const _MealOptionCard(selected: false),
        ],
      ),
    );
  }
}
