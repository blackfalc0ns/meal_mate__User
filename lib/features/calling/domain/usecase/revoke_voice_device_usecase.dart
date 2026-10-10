import 'package:injectable/injectable.dart';
import '../../../../core/network/api_results.dart';
import '../repo/voice_call_repository.dart';

@injectable
class RevokeVoiceDeviceUseCase {
  RevokeVoiceDeviceUseCase(this._repository);

  final VoiceCallRepository _repository;

  Future<ApiResult<void>> call() {
    return _repository.revokeDevice();
  }
}
