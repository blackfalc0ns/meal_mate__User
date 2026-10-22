import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import '../repo/compensations_repository.dart';
import '../entities/compensation_choice_entity.dart';
import '../entities/choose_compensation_request_entity.dart';

@injectable
class ChooseCompensationUseCase {
  const ChooseCompensationUseCase(this._repository);
  final CompensationsRepository _repository;
  Future<ApiResult<CompensationChoiceEntity>> call(
    ChooseCompensationRequestEntity request,
  ) => _repository.choose(request);
}
