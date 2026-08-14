part of 'calendar_meal_picker_sheet.dart';

class CalendarMealTabs extends StatelessWidget {
  const CalendarMealTabs({
    required this.labels,
    required this.selectedIndex,
    required this.onChanged,
  });

  final List<String> labels;
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return SizedBox(
      height: 26.3,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Divider(
              height: 1.04,
              thickness: 1.04,
              color: color.outlineVariant,
            ),
          ),
          Positioned(
            right: 36,
            left: 36,
            top: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                for (var index = 0; index < labels.length; index++)
                  CalendarTabLabel(
                    text: labels[index],
                    active: selectedIndex == index,
                    onTap: () => onChanged(index),
                  ),
              ],
            ),
          ),
          Positioned(
            right: 36,
            left: 36,
            bottom: 0,
            child: AnimatedAlign(
              duration: const Duration(milliseconds: 260),
              curve: Curves.easeOutCubic,
              alignment: Alignment(
                labels.length <= 1
                    ? 1
                    : 1 - ((selectedIndex * 2) / (labels.length - 1)),
                0,
              ),
              child: Container(
                width: 100,
                height: 2,
                decoration: BoxDecoration(
                  color: color.primary,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(16.6),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
