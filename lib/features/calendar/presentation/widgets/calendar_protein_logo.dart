part of 'calendar_meal_picker_sheet.dart';

class CalendarProteinLogo extends StatelessWidget {
  const CalendarProteinLogo({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.inverseSurface,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          'THE\nPROTEIN\nKITCHEN',
          textAlign: TextAlign.center,
          style: getBoldStyle(
            fontFamily: FontConstant.ibmPlexSansArabic,
            fontSize: size * 0.159,
            color: color.onInverseSurface,
          ).copyWith(height: 1),
        ),
      ),
    );
  }
}
