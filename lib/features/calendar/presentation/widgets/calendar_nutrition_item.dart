part of 'calendar_meal_card.dart';

class CalendarMealCardNutritionItem extends StatelessWidget {
  const CalendarMealCardNutritionItem({
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
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (animationAsset != null)
              Lottie.asset(
                animationAsset!,
                fit: BoxFit.contain,
                repeat: true,
                width: 30,
                height: 30,
              )
            else if (icon != null)
              Icon(icon, size: 14, color: color.primary),
            const SizedBox(width: 2),
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
        const SizedBox(height: 1),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: getSemiBoldStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size9,
              color: color.onSurface.withValues(alpha: 0.62),
            ).copyWith(height: 1),
          ),
        ),
      ],
    );
  }
}
