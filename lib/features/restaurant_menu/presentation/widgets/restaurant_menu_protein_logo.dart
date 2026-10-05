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

    return Container(
      width: size,
      height: size,
      padding: const EdgeInsets.all(Spacing.xs),
      decoration: BoxDecoration(
        color: color.inverseSurface,
        shape: BoxShape.circle,
      ),
      child: AppCachedNetworkImage(
        imageUrl: logoUrl,
        fit: BoxFit.contain,
        shape: BoxShape.circle,
        semanticLabel: label,
      ),
    );
  }
}
