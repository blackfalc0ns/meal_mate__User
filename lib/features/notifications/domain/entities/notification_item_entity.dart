enum NotificationCategory {
  all,
  subscription,
  meals,
  system,
}

enum NotificationCardIcon {
  mealCloche,
  mealCheck,
  packageCard,
  deliveryTruck,
  offerGift,
  systemRefresh,
}

class NotificationItemEntity {
  final String id;
  final String title;
  final String body;
  final NotificationCategory category;
  final NotificationCardIcon iconType;
  final String timeText;
  final bool isToday;
  final bool isRead;

  const NotificationItemEntity({
    required this.id,
    required this.title,
    required this.body,
    required this.category,
    required this.iconType,
    required this.timeText,
    required this.isToday,
    this.isRead = false,
  });

  NotificationItemEntity copyWith({
    String? id,
    String? title,
    String? body,
    NotificationCategory? category,
    NotificationCardIcon? iconType,
    String? timeText,
    bool? isToday,
    bool? isRead,
  }) {
    return NotificationItemEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      category: category ?? this.category,
      iconType: iconType ?? this.iconType,
      timeText: timeText ?? this.timeText,
      isToday: isToday ?? this.isToday,
      isRead: isRead ?? this.isRead,
    );
  }
}
