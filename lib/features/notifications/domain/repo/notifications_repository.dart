import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/notifications/domain/entities/device_token_register_request_entity.dart';
import 'package:meal_meat_user/features/notifications/domain/entities/device_token_unregister_request_entity.dart';
import 'package:meal_meat_user/features/notifications/domain/entities/notifications_page_entity.dart';

abstract interface class NotificationsRepository {
  Future<ApiResult<NotificationsPageEntity>> getNotifications({
    int page = 1,
    int pageSize = 20,
  });

  Future<ApiResult<void>> markNotificationRead(String id);

  Future<ApiResult<void>> markAllNotificationsRead();

  Future<ApiResult<void>> registerDeviceToken(
    DeviceTokenRegisterRequestEntity request,
  );

  Future<ApiResult<void>> unregisterDeviceToken(
    DeviceTokenUnregisterRequestEntity request,
  );
}
