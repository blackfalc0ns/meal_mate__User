import 'package:injectable/injectable.dart';
import '../../../../core/network/api_results.dart';
import '../repo/native_voice_repository.dart';

@injectable
class AnswerNativeCallUseCase {
  final NativeVoiceRepository _repository;

  AnswerNativeCallUseCase(this._repository);

  Future<ApiResult<void>> call({
    required String callId,
    required String lifecycleId,
    required String requestId,
  }) {
    return _repository.answer(
      callId: callId,
      lifecycleId: lifecycleId,
      requestId: requestId,
    );
  }
}
