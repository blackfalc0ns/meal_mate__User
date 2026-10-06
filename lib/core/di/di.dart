import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import '../services/location_service.dart';
import '../../features/calendar/domain/usecase/get_calendar_usecase.dart';
import '../../features/notifications/domain/usecase/get_notifications_usecase.dart';
import '../../features/notifications/domain/usecase/mark_all_notifications_read_usecase.dart';
import '../../features/notifications/domain/usecase/mark_notification_read_usecase.dart';
import '../../features/notifications/presentation/manager/notification_badge_view_model.dart';
import '../../features/notifications/presentation/manager/notifications_view_model.dart';
import 'di.config.dart';

final getIt = GetIt.instance;

@InjectableInit(
  preferRelativeImports: true, // default
)
Future<void> configureDependencies() async {
  await getIt.init();
  if (!getIt.isRegistered<LocationService>()) {
    getIt.registerLazySingleton<LocationService>(() => const LocationService());
  }
  if (!getIt.isRegistered<NotificationBadgeViewModel>()) {
    getIt.registerLazySingleton<NotificationBadgeViewModel>(
      () => NotificationBadgeViewModel(getIt<GetCalendarUseCase>()),
    );
  }
  if (!getIt.isRegistered<NotificationsViewModel>()) {
    getIt.registerFactory<NotificationsViewModel>(
      () => NotificationsViewModel(
        getIt<GetNotificationsUseCase>(),
        getIt<MarkNotificationReadUseCase>(),
        getIt<MarkAllNotificationsReadUseCase>(),
        getIt.isRegistered<NotificationBadgeViewModel>()
            ? getIt<NotificationBadgeViewModel>()
            : null,
      ),
    );
  }
}
