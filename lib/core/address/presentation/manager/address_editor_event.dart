import 'package:meal_meat_user/core/address/domain/entities/customer_address_entity.dart';
import 'package:meal_meat_user/core/address/domain/entities/customer_address_request_entity.dart';
import 'package:meal_meat_user/core/address/domain/entities/locations_catalog_entity.dart';

sealed class AddressEditorEvent {
  const AddressEditorEvent();
}

class GetLocationsCatalogEvent extends AddressEditorEvent {
  const GetLocationsCatalogEvent({
    this.countryCode = 'KW',
    this.initialAddress,
  });

  final String countryCode;
  final CustomerAddressEntity? initialAddress;
}

class SelectAddressGovernorateEvent extends AddressEditorEvent {
  const SelectAddressGovernorateEvent(this.governorate);

  final LocationGovernorateEntity governorate;
}

class SelectAddressAreaEvent extends AddressEditorEvent {
  const SelectAddressAreaEvent(this.area);

  final LocationAreaEntity area;
}

class SelectAddressBlockEvent extends AddressEditorEvent {
  const SelectAddressBlockEvent(this.block);

  final LocationBlockEntity block;
}

class ReverseGeocodeEvent extends AddressEditorEvent {
  const ReverseGeocodeEvent({
    required this.latitude,
    required this.longitude,
    this.force = false,
  });

  final double latitude;
  final double longitude;
  final bool force;
}

class GeocodeAddressEvent extends AddressEditorEvent {
  const GeocodeAddressEvent({required this.address, this.countryCode = 'KW'});

  final String address;
  final String countryCode;
}

class PreviewNewAddressCoverageEvent extends AddressEditorEvent {
  const PreviewNewAddressCoverageEvent(this.request);

  final CustomerAddressRequestEntity request;
}

class PreviewUpdateAddressCoverageEvent extends AddressEditorEvent {
  const PreviewUpdateAddressCoverageEvent({
    required this.addressId,
    required this.request,
  });

  final String addressId;
  final CustomerAddressRequestEntity request;
}

class PreviewExistingAddressCoverageEvent extends AddressEditorEvent {
  const PreviewExistingAddressCoverageEvent(this.addressId);

  final String addressId;
}

class ConfirmPendingAddressActionEvent extends AddressEditorEvent {
  const ConfirmPendingAddressActionEvent();
}

class ClearCoveragePreviewEvent extends AddressEditorEvent {
  const ClearCoveragePreviewEvent();
}

class LoadMoreAddressCoverageRestaurantsEvent extends AddressEditorEvent {
  const LoadMoreAddressCoverageRestaurantsEvent();
}

class RetryAddressCoveragePreviewEvent extends AddressEditorEvent {
  const RetryAddressCoveragePreviewEvent();
}

class SubmitAddressEvent extends AddressEditorEvent {
  const SubmitAddressEvent({
    required this.request,
    this.addressId,
  });

  final CustomerAddressRequestEntity request;
  final String? addressId;
}

class SetDefaultAddressEvent extends AddressEditorEvent {
  const SetDefaultAddressEvent(this.addressId);

  final String addressId;
}
