import 'package:injectable/injectable.dart';
import '../../../../core/network/api_results.dart';
import '../entities/voice_call_snapshot_entity.dart';
import '../repo/voice_call_repository.dart';

@injectable
class GetVoiceCallDetailsUseCase {
  GetVoiceCallDetailsUseCase(this._repository);

  final VoiceCallRepository _repository;

  Future<ApiResult<VoiceCallSnapshotEntity>> call(String callId) {
    return _repository.getCallDetails(callId);
  }
}
