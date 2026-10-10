import 'package:injectable/injectable.dart';
import '../../../../core/network/api_results.dart';
import '../entities/voice_ice_server_entity.dart';
import '../repo/voice_call_repository.dart';

@injectable
class GetVoiceIceServersUseCase {
  GetVoiceIceServersUseCase(this._repository);

  final VoiceCallRepository _repository;

  Future<ApiResult<VoiceIceServersConfigEntity>> call(String callId) {
    return _repository.getIceServers(callId);
  }
}
