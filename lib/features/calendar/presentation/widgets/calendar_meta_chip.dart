part of 'calendar_restaurant_summary_card.dart';

class CalendarMetaChip extends StatelessWidget {
  const CalendarMetaChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: getBoldStyle(
            fontFamily: FontConstant.alexandria,
            fontSize: FontSize.size10,
            color: color.onPrimary,
          ),
        ),
        const SizedBox(width: 2),
        Icon(icon, color: color.onPrimary, size: 10),
      ],
    );
  }
}
