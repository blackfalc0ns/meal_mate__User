import 'package:injectable/injectable.dart';
import '../../../../core/network/api_results.dart';
import '../../data/models/request/voice_media_report_request_dto.dart';
import '../repo/voice_call_repository.dart';

@injectable
class ReportVoiceConnectingUseCase {
  ReportVoiceConnectingUseCase(this._repository);

  final VoiceCallRepository _repository;

  Future<ApiResult<void>> call(
    String callId, {
    VoiceMediaReportRequestDto? report,
  }) {
    return _repository.reportConnecting(callId, report: report);
  }
}
