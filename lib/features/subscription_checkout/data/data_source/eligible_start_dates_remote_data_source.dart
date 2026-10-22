import '../models/response/eligible_start_dates_response_dto.dart';

abstract interface class EligibleStartDatesRemoteDataSource {
  Future<EligibleStartDatesResponseDto> getDates({required bool includeFriday});
}
