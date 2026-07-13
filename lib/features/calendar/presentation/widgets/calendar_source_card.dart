part of 'calendar_meal_picker_sheet.dart';

class CalendarSourceCard extends StatelessWidget {
  const CalendarSourceCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.country,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String country;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return Container(
      width: 68.8,
      height: 67,
      padding: const EdgeInsets.symmetric(vertical: 3),
      decoration: BoxDecoration(
        color: color.surface,
        borderRadius: BorderRadius.circular(7.15),
        border: Border.all(color: color.outlineVariant, width: 0.45),
      ),
      child: Column(
        children: [
          Icon(icon, size: 19, color: color.primary),
          const SizedBox(height: 1),
          Text(
            title,
            style: getSemiBoldStyle(
              fontFamily: FontConstant.ibmPlexSansArabic,
              fontSize: 8,
              color: color.primary,
            ).copyWith(height: 1),
          ),
          const SizedBox(height: 3),
          Text(
            subtitle,
            style: getRegularStyle(
              fontFamily: FontConstant.ibmPlexSansArabic,
              fontSize: 8,
              color: color.onSurface,
            ).copyWith(height: 1),
          ),
          const Spacer(),
          Container(
            height: 13,
            constraints: const BoxConstraints(minWidth: 44.7),
            padding: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              color: color.primaryContainer,
              borderRadius: BorderRadius.circular(4.47),
            ),
            child: Center(
              child: Text(
                country,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: getRegularStyle(
                  fontFamily: FontConstant.ibmPlexSansArabic,
                  fontSize: 7.6,
                  color: color.onSurface,
                ).copyWith(height: 1),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
