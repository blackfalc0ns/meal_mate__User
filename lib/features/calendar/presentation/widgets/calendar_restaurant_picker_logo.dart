part of 'calendar_restaurant_picker_sheet.dart';

class CalendarRestaurantPickerLogo extends StatelessWidget {
  const CalendarRestaurantPickerLogo({
    super.key,
    this.type,
    this.logoUrl,
    this.semanticLabel,
    this.size = 64,
  });

  final CalendarRestaurantLogoType? type;
  final String? logoUrl;
  final String? semanticLabel;
  final double size;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return AppCachedNetworkImage(
      imageUrl: logoUrl,
      width: size,
      height: size,
      shape: BoxShape.circle,
      semanticLabel: semanticLabel,
      errorWidget: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color.surfaceContainerHighest,
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: Icon(
          Icons.restaurant_rounded,
          size: size * 0.45,
          color: color.onSurfaceVariant,
        ),
      ),
    );
  }
}
