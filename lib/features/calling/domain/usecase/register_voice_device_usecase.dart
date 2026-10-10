import 'package:injectable/injectable.dart';
import '../../../../core/network/api_results.dart';
import '../entities/voice_device_session_entity.dart';
import '../repo/voice_call_repository.dart';

@injectable
class RegisterVoiceDeviceUseCase {
  RegisterVoiceDeviceUseCase(this._repository);

  final VoiceCallRepository _repository;

  Future<ApiResult<VoiceDeviceSessionEntity>> call({
    String? fcmDeviceTokenId,
    String? apnsVoipToken,
    bool force = false,
  }) {
    return _repository.registerDevice(
      fcmDeviceTokenId: fcmDeviceTokenId,
      apnsVoipToken: apnsVoipToken,
      force: force,
    );
  }
}
