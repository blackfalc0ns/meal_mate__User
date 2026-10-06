import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/notifications/data/data_source/notifications_remote_data_source.dart';
import 'package:meal_meat_user/features/notifications/data/mapper/device_token_mapper.dart';
import 'package:meal_meat_user/features/notifications/data/mapper/notifications_mapper.dart';
import 'package:meal_meat_user/features/notifications/domain/entities/device_token_register_request_entity.dart';
import 'package:meal_meat_user/features/notifications/domain/entities/device_token_unregister_request_entity.dart';
import 'package:meal_meat_user/features/notifications/domain/entities/notifications_page_entity.dart';
import 'package:meal_meat_user/features/notifications/domain/repo/notifications_repository.dart';

@Injectable(as: NotificationsRepository)
class NotificationsRepositoryImpl implements NotificationsRepository {
  NotificationsRepositoryImpl(this._remoteDataSource);

  final NotificationsRemoteDataSource _remoteDataSource;

  @override
  Future<ApiResult<NotificationsPageEntity>> getNotifications({
    int page = 1,
    int pageSize = 20,
  }) {
    return safeApiCall(() async {
      final dto = await _remoteDataSource.getCustomerNotifications(
        page: page,
        pageSize: pageSize,
      );
      return NotificationsMapper.toEntity(dto);
    });
  }

  @override
  Future<ApiResult<void>> markNotificationRead(String id) {
    return safeApiCall(() {
      return _remoteDataSource.markCustomerNotificationRead(id);
    });
  }

  @override
  Future<ApiResult<void>> markAllNotificationsRead() {
    return safeApiCall(_remoteDataSource.markAllCustomerNotificationsRead);
  }

  @override
  Future<ApiResult<void>> registerDeviceToken(
    DeviceTokenRegisterRequestEntity request,
  ) {
    return safeApiCall(() {
      return _remoteDataSource.registerDeviceToken(request.toDto());
    });
  }

  @override
  Future<ApiResult<void>> unregisterDeviceToken(
    DeviceTokenUnregisterRequestEntity request,
  ) {
    return safeApiCall(() {
      return _remoteDataSource.unregisterDeviceToken(request.toDto());
    });
  }
}
