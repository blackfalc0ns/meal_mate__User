import 'package:meal_meat_user/features/notifications/domain/entities/notification_item_entity.dart';

class NotificationsPageEntity {
  const NotificationsPageEntity({
    required this.items,
    required this.page,
    required this.pageSize,
    required this.totalCount,
    required this.totalPages,
    required this.hasNextPage,
    required this.hasPreviousPage,
  });

  final List<NotificationItemEntity> items;
  final int page;
  final int pageSize;
  final int totalCount;
  final int totalPages;
  final bool hasNextPage;
  final bool hasPreviousPage;

  NotificationsPageEntity copyWith({
    List<NotificationItemEntity>? items,
    int? page,
    int? pageSize,
    int? totalCount,
    int? totalPages,
    bool? hasNextPage,
    bool? hasPreviousPage,
  }) {
    return NotificationsPageEntity(
      items: items ?? this.items,
      page: page ?? this.page,
      pageSize: pageSize ?? this.pageSize,
      totalCount: totalCount ?? this.totalCount,
      totalPages: totalPages ?? this.totalPages,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      hasPreviousPage: hasPreviousPage ?? this.hasPreviousPage,
    );
  }
}
