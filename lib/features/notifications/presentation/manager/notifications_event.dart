import 'package:flutter/foundation.dart';
import 'package:meal_meat_user/features/notifications/domain/entities/notification_item_entity.dart';

sealed class NotificationsEvent {
  const NotificationsEvent();
}

class LoadNotificationsEvent extends NotificationsEvent {
  const LoadNotificationsEvent({this.page = 1, this.pageSize = 20});
  final int page;
  final int pageSize;
}

class RefreshNotificationsEvent extends NotificationsEvent {
  const RefreshNotificationsEvent();
}

class LoadMoreNotificationsEvent extends NotificationsEvent {
  const LoadMoreNotificationsEvent();
}

class SelectNotificationCategoryEvent extends NotificationsEvent {
  const SelectNotificationCategoryEvent(this.category);
  final NotificationCategory category;
}

class MarkNotificationReadEvent extends NotificationsEvent {
  const MarkNotificationReadEvent(this.id, {this.onSuccessNavigate});
  final String id;
  final VoidCallback? onSuccessNavigate;
}

class MarkAllNotificationsReadEvent extends NotificationsEvent {
  const MarkAllNotificationsReadEvent();
}

class ClearActionFailureEvent extends NotificationsEvent {
  const ClearActionFailureEvent();
}
