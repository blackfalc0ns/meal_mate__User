part of 'calendar_meal_picker_sheet.dart';

class CalendarMealPickerRestaurantHeader extends StatelessWidget {
  const CalendarMealPickerRestaurantHeader({
    super.key,
    required this.restaurantName,
    this.restaurantLogoAsset,
    this.restaurantInitials,
  });

  final String restaurantName;
  final String? restaurantLogoAsset;
  final String? restaurantInitials;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Semantics(
      label: '${locale.calendar_restaurant_name}: $restaurantName',
      child: SizedBox(
        height: 31,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              top: 2,
              right: Spacing.lg,
              child: CalendarProteinLogo(
                size: Spacing.xxxl + Spacing.md,
                label: restaurantInitials ?? restaurantName,
                logoAsset: restaurantLogoAsset,
              ),
            ),
            Positioned(
              top: 0,
              right: Spacing.xxxl + Spacing.xxl + Spacing.sm,
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: Row(
                  children: [
                    Icon(
                      Icons.verified_user_rounded,
                      color: color.primary,
                      size: Spacing.iconMd + Spacing.xs,
                    ),
                    const SizedBox(width: Spacing.md),
                    Text(
                      restaurantName,
                      textAlign: TextAlign.right,
                      style: getMediumStyle(
                        fontFamily: FontConstant.ibmPlexSansArabic,
                        fontSize: 20.8,
                        color: color.onSurface,
                      ).copyWith(letterSpacing: 0.46),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
