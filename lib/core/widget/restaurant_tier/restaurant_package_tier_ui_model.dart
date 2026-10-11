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
    this.price = '',
    this.currency = '',
    this.priceSubtitle = '',
    this.isPriceLoading = false,
    this.canSelect = true,
    this.isAvailable = true,
    this.disabledReason,
  });

  final String title;
  final String subtitle;
  final String iconName;
  final String? logoUrl;
  final int restaurantCount;
  final List<String?> restaurantLogoUrls;
  final bool isPopular;
  final String? id;
  final String price;
  final String currency;
  final String priceSubtitle;
  final bool isPriceLoading;
  final bool canSelect;
  final bool isAvailable;
  final String? disabledReason;

  RestaurantPackageTierUiModel copyWith({
    String? title,
    String? subtitle,
    String? iconName,
    String? logoUrl,
    int? restaurantCount,
    List<String?>? restaurantLogoUrls,
    bool? isPopular,
    String? id,
    String? price,
    String? currency,
    String? priceSubtitle,
    bool? isPriceLoading,
    bool? canSelect,
    bool? isAvailable,
    String? disabledReason,
  }) {
    return RestaurantPackageTierUiModel(
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      iconName: iconName ?? this.iconName,
      logoUrl: logoUrl ?? this.logoUrl,
      restaurantCount: restaurantCount ?? this.restaurantCount,
      restaurantLogoUrls: restaurantLogoUrls ?? this.restaurantLogoUrls,
      isPopular: isPopular ?? this.isPopular,
      id: id ?? this.id,
      price: price ?? this.price,
      currency: currency ?? this.currency,
      priceSubtitle: priceSubtitle ?? this.priceSubtitle,
      isPriceLoading: isPriceLoading ?? this.isPriceLoading,
      canSelect: canSelect ?? this.canSelect,
      isAvailable: isAvailable ?? this.isAvailable,
      disabledReason: disabledReason ?? this.disabledReason,
    );
  }
}
