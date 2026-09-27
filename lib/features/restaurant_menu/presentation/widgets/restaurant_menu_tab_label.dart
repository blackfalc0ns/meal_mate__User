part of 'restaurant_menu_view.dart';

class RestaurantMenuTabLabel extends StatelessWidget {
  const RestaurantMenuTabLabel({
    super.key,
    required this.text,
    required this.active,
    required this.onTap,
  });

  final String text;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(Spacing.radiusSm),
      child: SizedBox(
        width: double.infinity,
        height: Spacing.restaurantDetailsTabsHeight,
        child: Center(
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOutCubic,
            textAlign: TextAlign.center,
            style: getSemiBoldStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size15,
              color: active ? color.primary : color.onSurfaceVariant,
            ).copyWith(height: 12.48 / 13.52, letterSpacing: 0),
            child: Text(text, maxLines: 1, overflow: TextOverflow.ellipsis),
          ),
        ),
      ),
    );
  }
}
