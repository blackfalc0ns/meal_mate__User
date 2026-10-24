import 'package:injectable/injectable.dart';
import '../../../../core/network/api_results.dart';
import '../entities/voice_call_display_entity.dart';
import '../repo/voice_call_repository.dart';

@injectable
class GetVoiceCallDisplayUseCase {
  GetVoiceCallDisplayUseCase(this._repository);

  final VoiceCallRepository _repository;

  Future<ApiResult<VoiceCallDisplayEntity>> call(
    String callId, {
    String? language,
  }) {
    return _repository.getCallDisplay(callId, language: language);
  }
}
