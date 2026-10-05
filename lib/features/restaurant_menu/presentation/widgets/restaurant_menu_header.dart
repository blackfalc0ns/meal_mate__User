part of 'restaurant_menu_view.dart';

class RestaurantMenuHeader extends StatelessWidget {
  const RestaurantMenuHeader({
    super.key,
    required this.restaurantName,
    this.restaurantLogoAsset,
    this.restaurantLogoUrl,
    this.restaurantInitials,
    this.description,
  });

  final String restaurantName;
  final String? restaurantLogoAsset;
  final String? restaurantLogoUrl;
  final String? restaurantInitials;
  final Widget? description;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RestaurantMenuProteinLogo(
          size: Spacing.restaurantDetailsHeaderLogoSize,
          label: restaurantInitials ?? restaurantName,
          logoAsset: restaurantLogoAsset,
          logoUrl: restaurantLogoUrl,
        ),
        const SizedBox(width: Spacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: Text(
                      restaurantName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.start,
                      style: getBoldStyle(
                        fontFamily: FontConstant.alexandria,
                        fontSize: FontSize.size20,
                        color: color.onSurface,
                      ),
                    ),
                  ),
                  const SizedBox(width: Spacing.xs),
                  Icon(
                    Icons.verified_user_rounded,
                    color: color.primary,
                    size: Spacing.iconMd,
                  ),
                ],
              ),
              if (description != null) ...[
                const SizedBox(height: Spacing.xs),
                description!,
              ],
            ],
          ),
        ),
      ],
    );
  }
}
