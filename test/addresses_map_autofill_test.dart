import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/features/addresses/data/mapper/map_address_autofill_mapper.dart';
import 'package:meal_meat_user/features/addresses/data/models/response/map_address_autofill_response_dto.dart';
import 'package:meal_meat_user/features/addresses/presentation/manager/addresses_state.dart';
import 'package:meal_meat_user/features/addresses/presentation/manager/addresses_view_model.dart';

void main() {
  group('Addresses Map Autofill & Bounds', () {
    test('Kuwait bounds validation correctly checks coordinates', () {
      // Inside Kuwait
      expect(AddressesViewModel.isWithinKuwaitBounds(29.3780, 47.9900), isTrue);
      expect(AddressesViewModel.isWithinKuwaitBounds(28.5, 46.5), isTrue);
      expect(AddressesViewModel.isWithinKuwaitBounds(30.2, 48.5), isTrue);

      // Outside Kuwait
      expect(AddressesViewModel.isWithinKuwaitBounds(30.21, 48.0), isFalse);
      expect(AddressesViewModel.isWithinKuwaitBounds(28.49, 48.0), isFalse);
      expect(AddressesViewModel.isWithinKuwaitBounds(29.0, 46.49), isFalse);
      expect(AddressesViewModel.isWithinKuwaitBounds(29.0, 48.51), isFalse);
      expect(AddressesViewModel.isWithinKuwaitBounds(null, 48.0), isFalse);
      expect(AddressesViewModel.isWithinKuwaitBounds(29.0, null), isFalse);
    });

    test('MapAddressAutofillResponseDto deserialization and mapping to entity', () {
      final json = {
        'formattedAddress': '83XW+67P، 2 شارع 1 جادة 2، السالمية، الكويت',
        'latitude': 29.3480994,
        'longitude': 48.095364,
        'governorate': 'حولي',
        'area': 'السالمية',
        'block': 'قطعة 1',
        'street': 'شارع 1',
        'avenue': 'جادة 2',
        'building': null,
        'suggestedRegionId': 'd4a9acc2-afb8-49d8-b440-f93b8622239c',
        'suggestedRegionNameAr': 'السالمية',
        'suggestedGovernorateId': 'ec19c873-a752-4797-a6e3-068ddd3ccc2a',
        'suggestedGovernorateNameAr': 'حولي',
        'suggestedBlockId': '2e8b83eb-f4a7-43ea-b6fb-dc83ee1c44e6',
        'suggestedBlockNameAr': 'قطعة 1',
        'suggestedRegionName': 'السالمية',
        'suggestedGovernorateName': 'حولي',
        'suggestedBlockName': 'قطعة 1',
      };

      final dto = MapAddressAutofillResponseDto.fromJson(json);
      final entity = dto.toEntity();

      expect(entity.formattedAddress, '83XW+67P، 2 شارع 1 جادة 2، السالمية، الكويت');
      expect(entity.latitude, 29.3480994);
      expect(entity.longitude, 48.095364);
      expect(entity.governorate, 'حولي');
      expect(entity.area, 'السالمية');
      expect(entity.block, 'قطعة 1');
      expect(entity.street, 'شارع 1');
      expect(entity.avenue, 'جادة 2');
      expect(entity.building, isNull);
      expect(entity.suggestedRegionId, 'd4a9acc2-afb8-49d8-b440-f93b8622239c');
      expect(entity.suggestedRegionNameAr, 'السالمية');
      expect(entity.suggestedGovernorateId, 'ec19c873-a752-4797-a6e3-068ddd3ccc2a');
      expect(entity.suggestedGovernorateNameAr, 'حولي');
      expect(entity.suggestedBlockId, '2e8b83eb-f4a7-43ea-b6fb-dc83ee1c44e6');
      expect(entity.suggestedBlockNameAr, 'قطعة 1');
      expect(entity.suggestedRegionName, 'السالمية');
      expect(entity.suggestedGovernorateName, 'حولي');
      expect(entity.suggestedBlockName, 'قطعة 1');
    });

    test('MapAutofillState handles loading and success state transitions', () {
      const initial = MapAutofillState();
      expect(initial.isLoading, isFalse);
      expect(initial.isSuccess, isFalse);
      expect(initial.autofill, isNull);

      final loading = initial.copyWith(isLoading: true);
      expect(loading.isLoading, isTrue);

      final dto = MapAddressAutofillResponseDto(
        formattedAddress: 'Kuwait City',
        latitude: 29.37,
        longitude: 47.98,
      );
      final entity = dto.toEntity();

      final success = loading.copyWith(
        isLoading: false,
        isSuccess: true,
        autofill: entity,
      );
      expect(success.isLoading, isFalse);
      expect(success.isSuccess, isTrue);
      expect(success.autofill?.formattedAddress, 'Kuwait City');
    });
  });
}
