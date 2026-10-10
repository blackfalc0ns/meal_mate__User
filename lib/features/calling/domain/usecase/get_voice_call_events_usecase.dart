import 'package:injectable/injectable.dart';
import '../../../../core/network/api_results.dart';
import '../entities/voice_call_event_entity.dart';
import '../repo/voice_call_repository.dart';

@injectable
class GetVoiceCallEventsUseCase {
  GetVoiceCallEventsUseCase(this._repository);

  final VoiceCallRepository _repository;

  Future<ApiResult<List<VoiceCallEventEntity>>> call(
    String callId, {
    int afterSequence = 0,
  }) {
    return _repository.getCallEvents(callId, afterSequence: afterSequence);
  }
}
