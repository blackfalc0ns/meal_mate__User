import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/addresses/domain/entities/locations_catalog_entity.dart';
import 'package:meal_meat_user/features/addresses/domain/repo/addresses_repository.dart';

@injectable
class GetLocationsCatalogUseCase {
  GetLocationsCatalogUseCase(this._repository);

  final AddressesRepository _repository;

  Future<ApiResult<LocationsCatalogEntity>> call(String countryCode) {
    return _repository.getLocationsCatalog(countryCode);
  }
}
