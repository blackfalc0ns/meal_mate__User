import 'package:injectable/injectable.dart';
import '../../../../core/network/api_results.dart';
import '../repo/native_voice_repository.dart';

@injectable
class RejectNativeCallUseCase {
  final NativeVoiceRepository _repository;

  RejectNativeCallUseCase(this._repository);

  Future<ApiResult<void>> call({
    required String callId,
    required String lifecycleId,
    required String requestId,
  }) {
    return _repository.reject(
      callId: callId,
      lifecycleId: lifecycleId,
      requestId: requestId,
    );
  }
}
