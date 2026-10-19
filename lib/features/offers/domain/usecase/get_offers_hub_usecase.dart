import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/offers/domain/entities/offers_hub_entity.dart';
import 'package:meal_meat_user/features/offers/domain/repo/offers_repository.dart';

@injectable
class GetOffersHubUseCase {
  const GetOffersHubUseCase(this._repository);

  final OffersRepository _repository;

  Future<ApiResult<OffersHubEntity>> call() {
    return _repository.getOffersHub();
  }
}
