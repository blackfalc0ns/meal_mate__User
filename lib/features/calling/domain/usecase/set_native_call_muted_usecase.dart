import 'package:injectable/injectable.dart';
import '../../../../core/network/api_results.dart';
import '../repo/native_voice_repository.dart';

@injectable
class SetNativeCallMutedUseCase {
  final NativeVoiceRepository _repository;

  SetNativeCallMutedUseCase(this._repository);

  Future<ApiResult<void>> call({
    required String callId,
    required String lifecycleId,
    required String requestId,
    required bool muted,
  }) {
    return _repository.setMuted(
      callId: callId,
      lifecycleId: lifecycleId,
      requestId: requestId,
      muted: muted,
    );
  }
}
