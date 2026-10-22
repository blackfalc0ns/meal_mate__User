import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import '../../domain/entities/eligible_start_dates_entity.dart';
import '../../domain/repo/eligible_start_dates_repository.dart';
import '../data_source/eligible_start_dates_remote_data_source.dart';
import '../mapper/eligible_start_dates_mapper.dart';

@Injectable(as: EligibleStartDatesRepository)
class EligibleStartDatesRepositoryImpl implements EligibleStartDatesRepository {
  const EligibleStartDatesRepositoryImpl(this._source);
  final EligibleStartDatesRemoteDataSource _source;
  @override
  Future<ApiResult<EligibleStartDatesEntity>> getDates({
    required bool includeFriday,
  }) => safeApiCall(
    () async => (await _source.getDates(
      includeFriday: includeFriday,
    )).toEntity(requestedIncludeFriday: includeFriday),
  );
}
