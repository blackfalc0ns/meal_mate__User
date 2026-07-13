part of 'calendar_restaurant_picker_sheet.dart';

class _RestaurantOptionCard extends StatelessWidget {
  const _RestaurantOptionCard({required this.restaurant, required this.onTap});

  final CalendarRestaurantOptionEntity restaurant;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return SizedBox(
      height: 74.22,
      child: Material(
        color: color.surface,
        borderRadius: BorderRadius.circular(15.46),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(15.46),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.46),
              border: Border.all(color: color.outlineVariant, width: 1.55),
            ),
            padding: const EdgeInsets.fromLTRB(7.4, 4.6, 7.4, 4.8),
            child: Row(
              textDirection: TextDirection.ltr,
              children: [
                const _ArrowBubble(),
                const SizedBox(width: 27.6),
                _Rating(value: restaurant.rating),
                const SizedBox(width: 27.6),
                Expanded(child: _RestaurantCopy(restaurant: restaurant)),
                const SizedBox(width: 10.5),
                _RestaurantLogo(type: restaurant.logoType),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
