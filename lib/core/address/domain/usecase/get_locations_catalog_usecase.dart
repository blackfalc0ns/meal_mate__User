import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/address/domain/entities/locations_catalog_entity.dart';
import 'package:meal_meat_user/core/address/domain/repo/address_location_repository.dart';
import 'package:meal_meat_user/core/network/api_results.dart';

@injectable
class GetLocationsCatalogUseCase {
  GetLocationsCatalogUseCase(this._repository);

  final AddressLocationRepository _repository;

  Future<ApiResult<LocationsCatalogEntity>> call(
    String countryCode, {
    String? areaId,
  }) {
    return _repository.getLocationsCatalog(countryCode, areaId);
  }
}
