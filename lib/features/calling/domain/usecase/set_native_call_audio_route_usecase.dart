import 'package:injectable/injectable.dart';
import '../../../../core/network/api_results.dart';
import '../repo/native_voice_repository.dart';

@injectable
class SetNativeCallAudioRouteUseCase {
  final NativeVoiceRepository _repository;

  SetNativeCallAudioRouteUseCase(this._repository);

  Future<ApiResult<void>> call({
    required String callId,
    required String lifecycleId,
    required String requestId,
    required String routeId,
  }) {
    return _repository.setAudioRoute(
      callId: callId,
      lifecycleId: lifecycleId,
      requestId: requestId,
      routeId: routeId,
    );
  }
}
