import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/features/notifications/data/mapper/notifications_mapper.dart';
import 'package:meal_meat_user/features/notifications/data/models/response/notification_item_response_dto.dart';
import 'package:meal_meat_user/features/notifications/data/models/response/notifications_page_response_dto.dart';

void main() {
  group('NotificationsMapper', () {
    test('maps valid page and items correctly', () {
      final createdDate = DateTime.parse('2026-10-05T09:00:00Z');
      final readDate = DateTime.parse('2026-10-05T09:30:00Z');

      final dto = NotificationsPageResponseDto(
        items: [
          NotificationItemResponseDto(
            id: 'n1',
            eventKey: 'order.confirmed',
            subjectId: 'sub-1',
            subscriptionId: 'sub-2',
            titleAr: 'عنوان',
            titleEn: 'Title',
            bodyAr: 'محتوى',
            bodyEn: 'Body',
            deepLink: 'mealmate://orders',
            createdAtUtc: createdDate,
            readAtUtc: readDate,
          ),
          NotificationItemResponseDto(
            id: 'n2',
            titleAr: 'غير مقروء',
            titleEn: 'Unread',
            readAtUtc: null,
          ),
        ],
        totalCount: 42,
        page: 1,
        pageSize: 20,
        totalPages: 3,
        hasNextPage: true,
        hasPreviousPage: false,
      );

      final entity = NotificationsMapper.toEntity(dto);

      expect(entity.totalCount, 42);
      expect(entity.page, 1);
      expect(entity.pageSize, 20);
      expect(entity.totalPages, 3);
      expect(entity.hasNextPage, isTrue);
      expect(entity.hasPreviousPage, isFalse);
      expect(entity.items.length, 2);

      final item1 = entity.items[0];
      expect(item1.id, 'n1');
      expect(item1.eventKey, 'order.confirmed');
      expect(item1.subjectId, 'sub-1');
      expect(item1.subscriptionId, 'sub-2');
      expect(item1.titleAr, 'عنوان');
      expect(item1.titleEn, 'Title');
      expect(item1.bodyAr, 'محتوى');
      expect(item1.bodyEn, 'Body');
      expect(item1.deepLink, 'mealmate://orders');
      expect(item1.createdAtUtc, createdDate);
      expect(item1.readAtUtc, readDate);
      expect(item1.isRead, isTrue);

      final item2 = entity.items[1];
      expect(item2.id, 'n2');
      expect(item2.readAtUtc, isNull);
      expect(item2.isRead, isFalse);
    });

    test('drops items without id but preserves totalCount', () {
      final dto = NotificationsPageResponseDto(
        items: [
          NotificationItemResponseDto(
            id: null,
            titleEn: 'Corrupted item',
          ),
          NotificationItemResponseDto(
            id: '',
            titleEn: 'Empty id item',
          ),
          NotificationItemResponseDto(
            id: 'valid-id',
            titleEn: 'Valid item',
          ),
        ],
        totalCount: 15,
        page: 1,
        pageSize: 10,
        totalPages: 2,
        hasNextPage: true,
        hasPreviousPage: false,
      );

      final entity = NotificationsMapper.toEntity(dto);

      expect(entity.items.length, 1);
      expect(entity.items.first.id, 'valid-id');
      expect(entity.totalCount, 15);
    });

    test('handles null metadata defensively with fallbacks', () {
      final dto = NotificationsPageResponseDto(
        items: [
          NotificationItemResponseDto(
            id: 'n1',
            titleEn: 'Only item',
          ),
        ],
      );

      final entity = NotificationsMapper.toEntity(dto);

      expect(entity.items.length, 1);
      expect(entity.page, 1);
      expect(entity.pageSize, 1);
      expect(entity.totalCount, 1);
      expect(entity.totalPages, 1);
      expect(entity.hasNextPage, isFalse);
      expect(entity.hasPreviousPage, isFalse);
    });
  });
}
