import '../models/response/compensation_response_dto.dart';
import '../models/response/alternative_date_response_dto.dart';
import '../models/response/compensation_choice_response_dto.dart';
import '../models/request/choose_compensation_request_dto.dart';

abstract interface class CompensationsRemoteDataSource {
  Future<List<CompensationResponseDto>> getCompensations();
  Future<List<AlternativeDateResponseDto>> getAlternativeDates(String id);
  Future<CompensationChoiceResponseDto> choose(
    String id,
    ChooseCompensationRequestDto request,
  );
}
