import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/features/notifications/domain/entities/notification_item_entity.dart';

class NotificationsFakeDataSource {
  const NotificationsFakeDataSource();

  List<NotificationItemEntity> loadNotifications(AppLocalizations locale) {
    final isAr = locale.localeName == 'ar';

    return [
      NotificationItemEntity(
        id: 'notif_1',
        title: locale.notif_today_meals_title,
        body: locale.notif_today_meals_subtitle,
        category: NotificationCategory.meals,
        iconType: NotificationCardIcon.mealCloche,
        timeText: locale.notifications_time_just_now,
        isToday: true,
        isRead: false,
      ),
      NotificationItemEntity(
        id: 'notif_2',
        title: locale.notif_meals_selected_title,
        body: locale.notif_meals_selected_subtitle,
        category: NotificationCategory.meals,
        iconType: NotificationCardIcon.mealCheck,
        timeText: isAr ? '10:30 ص' : '10:30 AM',
        isToday: true,
        isRead: true,
      ),
      NotificationItemEntity(
        id: 'notif_3',
        title: locale.notif_package_renew_title,
        body: locale.notif_package_renew_subtitle,
        category: NotificationCategory.subscription,
        iconType: NotificationCardIcon.packageCard,
        timeText: isAr ? '9:15 ص' : '9:15 AM',
        isToday: true,
        isRead: true,
      ),
      NotificationItemEntity(
        id: 'notif_4',
        title: locale.notif_delivery_coming_title,
        body: locale.notif_delivery_coming_subtitle,
        category: NotificationCategory.subscription,
        iconType: NotificationCardIcon.deliveryTruck,
        timeText: isAr ? 'أمس 8:45 م' : 'Yesterday 8:45 PM',
        isToday: false,
        isRead: true,
      ),
      NotificationItemEntity(
        id: 'notif_5',
        title: locale.notif_new_offer_title,
        body: locale.notif_new_offer_subtitle,
        category: NotificationCategory.subscription,
        iconType: NotificationCardIcon.offerGift,
        timeText: isAr ? 'أمس 6:20 م' : 'Yesterday 6:20 PM',
        isToday: false,
        isRead: true,
      ),
      NotificationItemEntity(
        id: 'notif_6',
        title: locale.notif_system_update_title,
        body: locale.notif_system_update_subtitle,
        category: NotificationCategory.system,
        iconType: NotificationCardIcon.systemRefresh,
        timeText: isAr ? 'أمس 6:20 م' : 'Yesterday 6:20 PM',
        isToday: false,
        isRead: true,
      ),
    ];
  }
}
