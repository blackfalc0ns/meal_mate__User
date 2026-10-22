import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import '../repo/compensations_repository.dart';
import '../entities/compensation_entity.dart';

@injectable
class GetCompensationsUseCase {
  const GetCompensationsUseCase(this._repository);
  final CompensationsRepository _repository;
  Future<ApiResult<List<CompensationEntity>>> call() =>
      _repository.getCompensations();
}
