part of 'restaurant_menu_view.dart';

class RestaurantMenuNutrition extends StatelessWidget {
  const RestaurantMenuNutrition({
    super.key,
    this.icon,
    this.animationAsset,
    required this.value,
    required this.label,
  });

  final IconData? icon;
  final String? animationAsset;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Lottie.asset(
              width: 30,
              height: 30,
              animationAsset!,
              fit: BoxFit.contain,
              repeat: true,
            ),
            const SizedBox(width: Spacing.xs),
            Flexible(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  value.formattedValue,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: getBoldStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size11,
                    color: color.onSurface,
                  ).copyWith(height: 1),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: Spacing.zero),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: getBoldStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size9,
              color: color.onSurface.withValues(alpha: 0.62),
            ),
          ),
        ),
      ],
    );
  }
}
