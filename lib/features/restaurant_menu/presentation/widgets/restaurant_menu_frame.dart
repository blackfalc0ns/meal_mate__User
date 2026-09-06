part of 'restaurant_menu_view.dart';

class RestaurantMenuFrame extends StatelessWidget {
  const RestaurantMenuFrame({
    super.key,
    required this.child,
    required this.restaurantName,
    this.coverImageUrl,
    this.onBackPressed,
  });
  final Widget child;
  final String restaurantName;
  final String? coverImageUrl;
  final VoidCallback? onBackPressed;
  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final height = MediaQuery.sizeOf(context).height;
    return Material(
      color: color.surface,
      child: Container(
        height: height,
        color: color.surface,
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: Spacing.restaurantDetailsHeroHeight,
              child: coverImageUrl == null
                  ? Image.asset(
                      Assets.calendarMealPickerHero,
                      fit: BoxFit.cover,
                    )
                  : AppCachedNetworkImage(
                      imageUrl: coverImageUrl,
                      fit: BoxFit.cover,
                      semanticLabel: restaurantName,
                    ),
            ),
            CustomBackButton(
              onPressed: onBackPressed ?? () => Navigator.maybePop(context),
            ),
            Positioned(
              top: Spacing.restaurantDetailsSheetTop,
              left: 0,
              right: 0,
              bottom: 0,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(Spacing.restaurantDetailsSheetRadius),
                ),
                child: ColoredBox(color: color.surface, child: child),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
