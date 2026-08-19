class RestaurantPackageTierUiModel {
  const RestaurantPackageTierUiModel({
    required this.title,
    this.subtitle = '',
    this.iconName = '',
    this.logoUrl,
    this.restaurantCount = 0,
    this.restaurantLogoUrls = const [],
    this.isPopular = false,
    this.id,
  });

  final String title;
  final String subtitle;
  final String iconName;
  final String? logoUrl;
  final int restaurantCount;
  final List<String?> restaurantLogoUrls;
  final bool isPopular;
  final String? id;
}
