import 'package:meal_meat_user/features/notifications/data/models/response/notification_item_response_dto.dart';
import 'package:meal_meat_user/features/notifications/data/models/response/notifications_page_response_dto.dart';
import 'package:meal_meat_user/features/notifications/domain/entities/notification_item_entity.dart';
import 'package:meal_meat_user/features/notifications/domain/entities/notifications_page_entity.dart';

abstract final class NotificationsMapper {
  static NotificationsPageEntity toEntity(NotificationsPageResponseDto dto) {
    final rawItems = dto.items ?? const <NotificationItemResponseDto>[];
    final validItems = rawItems
        .where((item) => item.id != null && item.id!.trim().isNotEmpty)
        .map(toItemEntity)
        .toList(growable: false);

    final totalCount = dto.totalCount ?? validItems.length;
    final page = dto.page ?? 1;
    final pageSize = dto.pageSize ?? (validItems.isNotEmpty ? validItems.length : 20);
    final totalPages = dto.totalPages ??
        (totalCount > 0 ? ((totalCount + pageSize - 1) ~/ pageSize) : 1);
    final hasNextPage = dto.hasNextPage ?? (page < totalPages);
    final hasPreviousPage = dto.hasPreviousPage ?? (page > 1);

    return NotificationsPageEntity(
      items: validItems,
      page: page,
      pageSize: pageSize,
      totalCount: totalCount,
      totalPages: totalPages,
      hasNextPage: hasNextPage,
      hasPreviousPage: hasPreviousPage,
    );
  }

  static NotificationItemEntity toItemEntity(NotificationItemResponseDto dto) {
    return NotificationItemEntity(
      id: dto.id ?? '',
      eventKey: dto.eventKey,
      subjectId: dto.subjectId,
      subscriptionId: dto.subscriptionId,
      titleAr: dto.titleAr,
      titleEn: dto.titleEn,
      bodyAr: dto.bodyAr,
      bodyEn: dto.bodyEn,
      deepLink: dto.deepLink,
      createdAtUtc: dto.createdAtUtc,
      readAtUtc: dto.readAtUtc,
    );
  }
}
