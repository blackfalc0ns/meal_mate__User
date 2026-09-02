part of 'restaurant_menu_view.dart';

class RestaurantMenuHeader extends StatelessWidget {
  const RestaurantMenuHeader({
    super.key,
    required this.restaurantName,
    this.restaurantLogoAsset,
    this.restaurantLogoUrl,
    this.restaurantInitials,
  });

  final String restaurantName;
  final String? restaurantLogoAsset;
  final String? restaurantLogoUrl;
  final String? restaurantInitials;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Spacing.xxl),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          RestaurantMenuProteinLogo(
            size: Spacing.restaurantDetailsHeaderLogoSize,
            label: restaurantInitials ?? restaurantName,
            logoAsset: restaurantLogoAsset,
            logoUrl: restaurantLogoUrl,
          ),
          const SizedBox(width: Spacing.md),
          Flexible(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Text(
                    restaurantName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.start,
                    style: getSemiBoldStyle(
                      fontFamily: FontConstant.alexandria,
                      fontSize: FontSize.size20,
                      color: color.onSurface,
                    ),
                  ),
                ),
                const SizedBox(width: Spacing.md),
                Icon(
                  Icons.verified_user_rounded,
                  color: color.primary,
                  size: Spacing.iconMd,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
