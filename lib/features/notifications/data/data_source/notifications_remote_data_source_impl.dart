import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_services.dart';
import 'package:meal_meat_user/features/notifications/data/data_source/notifications_remote_data_source.dart';
import 'package:meal_meat_user/features/notifications/data/models/request/device_token_register_request_dto.dart';
import 'package:meal_meat_user/features/notifications/data/models/request/device_token_unregister_request_dto.dart';

@Injectable(as: NotificationsRemoteDataSource)
class NotificationsRemoteDataSourceImpl
    implements NotificationsRemoteDataSource {
  NotificationsRemoteDataSourceImpl(this._apiServices);

  final ApiServices _apiServices;

  @override
  Future<void> registerDeviceToken(DeviceTokenRegisterRequestDto request) {
    return _apiServices.registerDeviceToken(request);
  }

  @override
  Future<void> unregisterDeviceToken(DeviceTokenUnregisterRequestDto request) {
    return _apiServices.unregisterDeviceToken(request);
  }
}
