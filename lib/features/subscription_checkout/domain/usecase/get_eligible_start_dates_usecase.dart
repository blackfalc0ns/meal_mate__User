import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import '../entities/eligible_start_dates_entity.dart';
import '../repo/eligible_start_dates_repository.dart';

@injectable
class GetEligibleStartDatesUseCase {
  const GetEligibleStartDatesUseCase(this._repository);
  final EligibleStartDatesRepository _repository;
  Future<ApiResult<EligibleStartDatesEntity>> call({
    required bool includeFriday,
  }) => _repository.getDates(includeFriday: includeFriday);
}
