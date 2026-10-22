import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_services.dart';
import 'eligible_start_dates_remote_data_source.dart';
import '../models/response/eligible_start_dates_response_dto.dart';

@LazySingleton(as: EligibleStartDatesRemoteDataSource)
class EligibleStartDatesRemoteDataSourceImpl
    implements EligibleStartDatesRemoteDataSource {
  EligibleStartDatesRemoteDataSourceImpl(this._api);
  final ApiServices _api;
  final Map<bool, ({DateTime fetchedAt, EligibleStartDatesResponseDto response})>
      _cache = {};

  @override
  Future<EligibleStartDatesResponseDto> getDates({
    required bool includeFriday,
  }) async {
    final cached = _cache[includeFriday];
    if (cached != null &&
        DateTime.now().difference(cached.fetchedAt).inMinutes < 5) {
      return cached.response;
    }
    final response = await _api.getEligibleSubscriptionStartDates(
      includeFriday,
      14,
    );
    _cache[includeFriday] = (fetchedAt: DateTime.now(), response: response);
    return response;
  }
}
