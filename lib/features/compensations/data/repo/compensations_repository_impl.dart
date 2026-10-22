import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import '../../domain/repo/compensations_repository.dart';
import '../../domain/entities/compensation_entity.dart';
import '../../domain/entities/alternative_date_entity.dart';
import '../../domain/entities/compensation_choice_entity.dart';
import '../../domain/entities/choose_compensation_request_entity.dart';
import '../data_source/compensations_remote_data_source.dart';
import '../mapper/compensation_mapper.dart';

@Injectable(as: CompensationsRepository)
class CompensationsRepositoryImpl implements CompensationsRepository {
  const CompensationsRepositoryImpl(this._source);
  final CompensationsRemoteDataSource _source;
  @override
  Future<ApiResult<List<CompensationEntity>>> getCompensations() => safeApiCall(
    () async => List.unmodifiable(
      (await _source.getCompensations()).map((dto) => dto.toEntity()),
    ),
  );
  @override
  Future<ApiResult<List<AlternativeDateEntity>>> getAlternativeDates(
    String id,
  ) => safeApiCall(
    () async => List.unmodifiable(
      (await _source.getAlternativeDates(id)).map((dto) => dto.toEntity()),
    ),
  );
  @override
  Future<ApiResult<CompensationChoiceEntity>> choose(
    ChooseCompensationRequestEntity request,
  ) => safeApiCall(
    () async => (await _source.choose(
      request.compensationId,
      request.toDto(),
    )).toEntity(),
  );
}
