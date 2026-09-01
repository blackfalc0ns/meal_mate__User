import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/notifications/domain/entities/device_token_register_request_entity.dart';
import 'package:meal_meat_user/features/notifications/domain/repo/notifications_repository.dart';

@injectable
class RegisterDeviceTokenUseCase {
  RegisterDeviceTokenUseCase(this._repository);

  final NotificationsRepository _repository;

  Future<ApiResult<void>> call(DeviceTokenRegisterRequestEntity request) {
    return _repository.registerDeviceToken(request);
  }
}
