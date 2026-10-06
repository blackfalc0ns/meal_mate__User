import 'package:intl/intl.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/features/notifications/domain/entities/notification_item_entity.dart';

class NotificationSectionData {
  const NotificationSectionData({
    required this.title,
    required this.items,
    this.showMarkAllRead = false,
  });

  final String title;
  final List<NotificationItemEntity> items;
  final bool showMarkAllRead;
}

abstract final class NotificationPresentationMapper {
  static List<NotificationSectionData> buildSections({
    required List<NotificationItemEntity> items,
    required NotificationCategory selectedCategory,
    required AppLocalizations locale,
    DateTime? now,
  }) {
    final effectiveNow = now ?? DateTime.now();

    // 1. Filter by category
    final filtered = items.where((item) {
      if (selectedCategory == NotificationCategory.all) return true;
      final category = resolveCategory(item);
      return category == selectedCategory;
    }).map((item) => projectItem(item, locale, effectiveNow)).toList();

    if (filtered.isEmpty) return const [];

    // 2. Group into Today, Yesterday, Earlier
    final todayList = <NotificationItemEntity>[];
    final yesterdayList = <NotificationItemEntity>[];
    final earlierList = <NotificationItemEntity>[];

    final nowDate = DateTime(effectiveNow.year, effectiveNow.month, effectiveNow.day);
    final yesterdayDate = nowDate.subtract(const Duration(days: 1));

    for (final item in filtered) {
      final itemUtc = item.createdAtUtc;
      if (itemUtc == null) {
        if (item.isToday) {
          todayList.add(item);
        } else {
          earlierList.add(item);
        }
        continue;
      }

      final local = itemUtc.toLocal();
      final itemDate = DateTime(local.year, local.month, local.day);

      if (itemDate.isAtSameMomentAs(nowDate)) {
        todayList.add(item);
      } else if (itemDate.isAtSameMomentAs(yesterdayDate)) {
        yesterdayList.add(item);
      } else {
        earlierList.add(item);
      }
    }

    final hasUnread = items.any((e) => !e.isRead);
    final sections = <NotificationSectionData>[];

    if (todayList.isNotEmpty) {
      sections.add(
        NotificationSectionData(
          title: locale.notifications_group_today,
          items: todayList,
          showMarkAllRead: hasUnread,
        ),
      );
    }

    if (yesterdayList.isNotEmpty) {
      sections.add(
        NotificationSectionData(
          title: locale.notifications_group_yesterday,
          items: yesterdayList,
          showMarkAllRead: false,
        ),
      );
    }

    if (earlierList.isNotEmpty) {
      sections.add(
        NotificationSectionData(
          title: locale.notifications_group_earlier,
          items: earlierList,
          showMarkAllRead: false,
        ),
      );
    }

    return sections;
  }

  static NotificationItemEntity projectItem(
    NotificationItemEntity item,
    AppLocalizations locale,
    DateTime now,
  ) {
    final isAr = locale.localeName.startsWith('ar');
    final title = isAr
        ? (item.titleAr?.trim().isNotEmpty == true
            ? item.titleAr!
            : (item.titleEn?.trim().isNotEmpty == true
                ? item.titleEn!
                : item.title))
        : (item.titleEn?.trim().isNotEmpty == true
            ? item.titleEn!
            : (item.titleAr?.trim().isNotEmpty == true
                ? item.titleAr!
                : item.title));

    final body = isAr
        ? (item.bodyAr?.trim().isNotEmpty == true
            ? item.bodyAr!
            : (item.bodyEn?.trim().isNotEmpty == true
                ? item.bodyEn!
                : item.body))
        : (item.bodyEn?.trim().isNotEmpty == true
            ? item.bodyEn!
            : (item.bodyAr?.trim().isNotEmpty == true
                ? item.bodyAr!
                : item.body));

    final category = resolveCategory(item);
    final iconType = resolveIcon(item);
    final timeText = formatRelativeTime(item, locale, now);

    return item.copyWith(
      title: title,
      body: body,
      category: category,
      iconType: iconType,
      timeText: timeText,
    );
  }

  static NotificationCategory resolveCategory(NotificationItemEntity item) {
    final key = item.eventKey?.toLowerCase() ?? '';
    if (key.contains('subscription') ||
        key.contains('package') ||
        key.contains('freeze') ||
        key.contains('renewal')) {
      return NotificationCategory.subscription;
    }
    if (key.contains('order') ||
        key.contains('meal') ||
        key.contains('delivery')) {
      return NotificationCategory.meals;
    }
    if (item.category != NotificationCategory.all) {
      return item.category;
    }
    return NotificationCategory.system;
  }

  static NotificationCardIcon resolveIcon(NotificationItemEntity item) {
    final key = item.eventKey?.toLowerCase() ?? '';
    if (key.contains('deliver')) {
      return NotificationCardIcon.deliveryTruck;
    }
    if (key.contains('confirm') || key.contains('ready')) {
      return NotificationCardIcon.mealCheck;
    }
    if (key.contains('order') || key.contains('meal')) {
      return NotificationCardIcon.mealCloche;
    }
    if (key.contains('subscription') || key.contains('package')) {
      return NotificationCardIcon.packageCard;
    }
    if (key.contains('offer') || key.contains('gift') || key.contains('promo')) {
      return NotificationCardIcon.offerGift;
    }
    return item.iconType;
  }

  static String formatRelativeTime(
    NotificationItemEntity item,
    AppLocalizations locale,
    DateTime now,
  ) {
    final utc = item.createdAtUtc;
    if (utc == null) return item.timeText;

    final local = utc.toLocal();
    final diff = now.difference(local);

    if (diff.inSeconds < 60) {
      return locale.notifications_time_just_now;
    }
    if (diff.inMinutes < 60) {
      return locale.notifications_time_minutes_ago(diff.inMinutes);
    }
    if (diff.inHours < 24 &&
        local.day == now.day &&
        local.month == now.month &&
        local.year == now.year) {
      return locale.notifications_time_hours_ago(diff.inHours);
    }

    try {
      return DateFormat.jm(locale.localeName).format(local);
    } catch (_) {
      return item.timeText;
    }
  }
}
