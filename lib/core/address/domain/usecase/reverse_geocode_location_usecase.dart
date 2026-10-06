import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/address/domain/entities/map_address_autofill_entity.dart';
import 'package:meal_meat_user/core/address/domain/repo/address_location_repository.dart';
import 'package:meal_meat_user/core/network/api_results.dart';

@injectable
class ReverseGeocodeLocationUseCase {
  ReverseGeocodeLocationUseCase(this._repository);

  final AddressLocationRepository _repository;

  Future<ApiResult<MapAddressAutofillEntity>> call(
    double latitude,
    double longitude,
  ) {
    return _repository.reverseGeocode(latitude, longitude);
  }
}
