class CalendarRestaurantEntity {
  const CalendarRestaurantEntity({
    this.id = '',
    this.logoUrl,
    this.maxUsageCount,
    required this.name,
    required this.category,
    required this.rating,
    required this.deliveryDuration,
    required this.deliveryWindow,
  });

  final String id;
  final String? logoUrl;
  final int? maxUsageCount;
  final String name;
  final String category;
  final String rating;
  final String deliveryDuration;
  final String deliveryWindow;
}
