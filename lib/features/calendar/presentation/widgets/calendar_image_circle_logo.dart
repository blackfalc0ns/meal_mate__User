part of 'calendar_restaurant_picker_sheet.dart';

class CalendarImageCircleLogo extends StatelessWidget {
  const CalendarImageCircleLogo({super.key, required this.asset});

  final String asset;

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Image.asset(asset, width: 59.9, height: 59.9, fit: BoxFit.contain),
    );
  }
}
