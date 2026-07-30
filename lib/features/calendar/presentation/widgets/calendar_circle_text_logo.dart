part of 'calendar_restaurant_picker_sheet.dart';

class CalendarCircleTextLogo extends StatelessWidget {
  const CalendarCircleTextLogo({super.key, 
    required this.top,
    required this.bottom,
    required this.foreground,
    required this.background,
    this.eyebrow,
    this.icon,
    this.outlined = false,
  });

  final String? eyebrow;
  final String top;
  final String bottom;
  final IconData? icon;
  final Color foreground;
  final Color background;
  final bool outlined;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return Container(
      width: 64.7,
      height: 64.7,
      decoration: BoxDecoration(
        color: background,
        shape: BoxShape.circle,
        border: outlined
            ? Border.all(color: color.outlineVariant, width: 2.1)
            : null,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null)
            Icon(icon, color: foreground, size: 27)
          else if (eyebrow != null)
            Text(eyebrow!, style: _logoStyle(9.5, foreground)),
          Text(top, style: _logoStyle(icon == null ? 10 : 11.6, foreground)),
          Text(bottom, style: _logoStyle(icon == null ? 10 : 11.6, foreground)),
        ],
      ),
    );
  }

  TextStyle _logoStyle(double size, Color color) {
    return getBoldStyle(
      fontFamily: FontConstant.alexandria,
      fontSize: size,
      color: color,
    ).copyWith(height: 0.95);
  }
}
