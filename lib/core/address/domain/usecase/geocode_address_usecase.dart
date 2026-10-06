import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/address/domain/entities/map_address_autofill_entity.dart';
import 'package:meal_meat_user/core/address/domain/repo/address_location_repository.dart';
import 'package:meal_meat_user/core/network/api_results.dart';

@injectable
class GeocodeAddressUseCase {
  GeocodeAddressUseCase(this._repository);

  final AddressLocationRepository _repository;

  Future<ApiResult<MapAddressAutofillEntity>> call(
    String address, {
    String countryCode = 'KW',
  }) {
    return _repository.geocode(address, countryCode: countryCode);
  }
}
