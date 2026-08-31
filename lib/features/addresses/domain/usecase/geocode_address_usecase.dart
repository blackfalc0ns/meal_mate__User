import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/addresses/domain/entities/map_address_autofill_entity.dart';
import 'package:meal_meat_user/features/addresses/domain/repo/addresses_repository.dart';

@injectable
class GeocodeAddressUseCase {
  GeocodeAddressUseCase(this._repository);

  final AddressesRepository _repository;

  Future<ApiResult<MapAddressAutofillEntity>> call(
    String address, {
    String countryCode = 'KW',
  }) {
    return _repository.geocode(address, countryCode: countryCode);
  }
}
