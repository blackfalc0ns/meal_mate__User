part of 'calendar_meal_picker_sheet.dart';

class CalendarMealOptionsSection extends StatelessWidget {
  const CalendarMealOptionsSection({
    super.key,
    required this.mealType,
    required this.tabIndex,
    required this.options,
    this.onOptionSelected,
    this.onOptionDetailsSelected,
  });

  final String mealType;
  final int tabIndex;
  final List<CalendarMealPickerOption> options;
  final ValueChanged<int>? onOptionSelected;
  final ValueChanged<int>? onOptionDetailsSelected;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 420),
      reverseDuration: const Duration(milliseconds: 260),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      transitionBuilder: (child, animation) {
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
          reverseCurve: Curves.easeInCubic,
        );
        final offset = Tween<Offset>(
          begin: const Offset(0.22, 0),
          end: Offset.zero,
        ).animate(curvedAnimation);

        return FadeTransition(
          opacity: curvedAnimation,
          child: SizeTransition(
            sizeFactor: curvedAnimation,
            alignment: Alignment.topCenter,
            child: SlideTransition(position: offset, child: child),
          ),
        );
      },
      child: Column(
        key: ValueKey(tabIndex),
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CalendarMealPickerSectionTitle(mealType: mealType),
          const SizedBox(height: Spacing.base),
          for (var index = 0; index < options.length; index++) ...[
            CalendarMealOptionCard(
              option: options[index],
              onTap: onOptionSelected == null
                  ? null
                  : () => onOptionSelected!(index),
              onDetailsTap: onOptionDetailsSelected == null
                  ? null
                  : () => onOptionDetailsSelected!(index),
            ),
            if (index != options.length - 1) const CalendarDividerLine(),
          ],
        ],
      ),
    );
  }
}
