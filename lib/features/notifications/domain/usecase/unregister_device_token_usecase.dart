import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/notifications/domain/entities/device_token_unregister_request_entity.dart';
import 'package:meal_meat_user/features/notifications/domain/repo/notifications_repository.dart';

@injectable
class UnregisterDeviceTokenUseCase {
  UnregisterDeviceTokenUseCase(this._repository);

  final NotificationsRepository _repository;

  Future<ApiResult<void>> call(DeviceTokenUnregisterRequestEntity request) {
    return _repository.unregisterDeviceToken(request);
  }
}
