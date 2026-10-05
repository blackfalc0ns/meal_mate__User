part of 'restaurant_menu_view.dart';

class RestaurantMenuProteinLogo extends StatelessWidget {
  const RestaurantMenuProteinLogo({
    super.key,
    required this.size,
    required this.label,
    this.logoAsset,
    this.logoUrl,
  });

  final double size;
  final String label;
  final String? logoAsset;
  final String? logoUrl;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    final hasUrl = logoUrl != null && logoUrl!.isNotEmpty;
    final hasAsset = logoAsset != null && logoAsset!.isNotEmpty;

    return Container(
      width: size,
      height: size,
      //  padding: const EdgeInsets.all(Spacing.xs),
      decoration: BoxDecoration(
        color: color.inverseSurface,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: hasUrl
          ? AppCachedNetworkImage(
              imageUrl: logoUrl,
              fit: BoxFit.contain,
              shape: BoxShape.circle,
              semanticLabel: label,
            )
          : hasAsset
          ? Image.asset(logoAsset!, fit: BoxFit.contain)
          : Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: getBoldStyle(
                fontFamily: FontConstant.alexandria,
                fontSize: FontSize.size10,
                color: color.onInverseSurface,
              ).copyWith(height: 1.1),
            ),
    );
  }
}
