import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_services.dart';
import 'compensations_remote_data_source.dart';
import '../models/response/compensation_response_dto.dart';
import '../models/response/alternative_date_response_dto.dart';
import '../models/response/compensation_choice_response_dto.dart';
import '../models/request/choose_compensation_request_dto.dart';

@LazySingleton(as: CompensationsRemoteDataSource)
class CompensationsRemoteDataSourceImpl
    implements CompensationsRemoteDataSource {
  const CompensationsRemoteDataSourceImpl(this._api);
  final ApiServices _api;
  @override
  Future<List<CompensationResponseDto>> getCompensations() =>
      _api.getCustomerCompensations();
  @override
  Future<List<AlternativeDateResponseDto>> getAlternativeDates(String id) =>
      _api.getCompensationAlternativeDates(id, 14);
  @override
  Future<CompensationChoiceResponseDto> choose(
    String id,
    ChooseCompensationRequestDto request,
  ) => _api.chooseCustomerCompensation(id, request);
}
