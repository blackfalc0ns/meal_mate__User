import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/address/data/data_source/address_location_remote_data_source.dart';
import 'package:meal_meat_user/core/address/data/models/request/map_geocode_request_dto.dart';
import 'package:meal_meat_user/core/address/data/models/request/map_reverse_geocode_request_dto.dart';
import 'package:meal_meat_user/core/address/data/models/response/locations_catalog_response_dto.dart';
import 'package:meal_meat_user/core/address/data/models/response/map_address_autofill_response_dto.dart';
import 'package:meal_meat_user/core/network/api_services.dart';

@Injectable(as: AddressLocationRemoteDataSource)
class AddressLocationRemoteDataSourceImpl
    implements AddressLocationRemoteDataSource {
  AddressLocationRemoteDataSourceImpl(this._apiServices);

  final ApiServices _apiServices;

  @override
  Future<LocationsCatalogResponseDto> getLocationsCatalog(
    String countryCode,
    String? areaId,
  ) {
    return _apiServices.getLocationsCatalog(countryCode, areaId);
  }

  @override
  Future<MapAddressAutofillResponseDto> geocode(MapGeocodeRequestDto request) {
    return _apiServices.geocode(request);
  }

  @override
  Future<MapAddressAutofillResponseDto> reverseGeocode(
    MapReverseGeocodeRequestDto request,
  ) {
    return _apiServices.reverseGeocode(request);
  }
}
