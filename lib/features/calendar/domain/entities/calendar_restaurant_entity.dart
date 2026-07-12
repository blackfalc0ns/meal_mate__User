class CalendarRestaurantEntity {
  const CalendarRestaurantEntity({
    required this.name,
    required this.category,
    required this.rating,
    required this.deliveryDuration,
    required this.deliveryWindow,
  });

  final String name;
  final String category;
  final String rating;
  final String deliveryDuration;
  final String deliveryWindow;
}
