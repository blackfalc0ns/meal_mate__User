import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import '../repo/compensations_repository.dart';
import '../entities/alternative_date_entity.dart';

@injectable
class GetCompensationAlternativeDatesUseCase {
  const GetCompensationAlternativeDatesUseCase(this._repository);
  final CompensationsRepository _repository;
  Future<ApiResult<List<AlternativeDateEntity>>> call(String id) =>
      _repository.getAlternativeDates(id);
}
