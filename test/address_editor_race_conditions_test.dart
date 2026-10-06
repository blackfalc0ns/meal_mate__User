import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/address/domain/contracts/address_editor_operations.dart';
import 'package:meal_meat_user/core/address/domain/entities/address_coverage_preview_entity.dart';
import 'package:meal_meat_user/core/address/domain/entities/customer_address_entity.dart';
import 'package:meal_meat_user/core/address/domain/entities/customer_address_request_entity.dart';
import 'package:meal_meat_user/core/address/domain/entities/locations_catalog_entity.dart';
import 'package:meal_meat_user/core/address/domain/entities/map_address_autofill_entity.dart';
import 'package:meal_meat_user/core/address/domain/repo/address_location_repository.dart';
import 'package:meal_meat_user/core/address/domain/usecase/geocode_address_usecase.dart';
import 'package:meal_meat_user/core/address/domain/usecase/get_locations_catalog_usecase.dart';
import 'package:meal_meat_user/core/address/domain/usecase/reverse_geocode_location_usecase.dart';
import 'package:meal_meat_user/core/address/presentation/manager/address_editor_event.dart';
import 'package:meal_meat_user/core/address/presentation/manager/address_editor_view_model.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/core/network/failures.dart';
import 'package:meal_meat_user/features/addresses/domain/usecase/customer_address_editor_operations.dart';
import 'package:meal_meat_user/features/family_addresses/presentation/manager/family_addresses_view_model.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/entities/family_flow_current_entity.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/entities/family_member_entity.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/repo/family_subscription_setup_repository.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/usecase/get_family_flow_current_usecase.dart';

class ControllableAddressLocationRepo implements AddressLocationRepository {
  final Map<String, Completer<ApiResult<LocationsCatalogEntity>>> catalogCompleters = {};
  final Map<String, Completer<ApiResult<MapAddressAutofillEntity>>> geocodeCompleters = {};

  @override
  Future<ApiResult<LocationsCatalogEntity>> getLocationsCatalog(
    String countryCode, [
    String? areaId,
  ]) {
    final key = '$countryCode:${areaId ?? ''}';
    final completer = catalogCompleters.putIfAbsent(
      key,
      () => Completer<ApiResult<LocationsCatalogEntity>>(),
    );
    return completer.future;
  }

  @override
  Future<ApiResult<MapAddressAutofillEntity>> geocode(
    String address, {
    String countryCode = 'KW',
  }) {
    final completer = geocodeCompleters.putIfAbsent(
      address,
      () => Completer<ApiResult<MapAddressAutofillEntity>>(),
    );
    return completer.future;
  }

  @override
  Future<ApiResult<MapAddressAutofillEntity>> reverseGeocode(
    double latitude,
    double longitude,
  ) async {
    return ApiSuccessResult(
      data: MapAddressAutofillEntity(
        latitude: latitude,
        longitude: longitude,
        formattedAddress: 'Kuwait',
      ),
    );
  }
}

void main() {
  group('AddressEditor race conditions and concurrency guards', () {
    const validRequest = CustomerAddressRequestEntity(
      label: 'Home',
      addressLine: 'Kuwait City',
      latitude: 29.34,
      longitude: 48.08,
      isDefault: true,
      notifyOnDelivery: true,
    );

    const dummyAddress = CustomerAddressEntity(
      addressId: 'addr-1',
      label: 'Home',
      addressLine: 'Kuwait City',
      isDefault: true,
      notifyOnDelivery: true,
    );

    test('select Area A then B; complete B first, then A -> Area B wins', () async {
      final repo = ControllableAddressLocationRepo();
      final getCatalog = GetLocationsCatalogUseCase(repo);
      final geocode = GeocodeAddressUseCase(repo);
      final reverseGeocode = ReverseGeocodeLocationUseCase(repo);

      final ops = CustomerAddressEditorOperations();
      final vm = AddressEditorViewModel(
        operations: ops,
        getLocationsCatalogUseCase: getCatalog,
        geocodeAddressUseCase: geocode,
        reverseGeocodeLocationUseCase: reverseGeocode,
      );

      const areaA = LocationAreaEntity(
        id: 'area-A',
        nameAr: 'منطقة أ',
        nameEn: 'Area A',
        code: 'A',
      );

      const areaB = LocationAreaEntity(
        id: 'area-B',
        nameAr: 'منطقة ب',
        nameEn: 'Area B',
        code: 'B',
      );

      // Start selecting Area A then Area B
      final futureA = vm.doIntent(const SelectAddressAreaEvent(areaA));
      final futureB = vm.doIntent(const SelectAddressAreaEvent(areaB));

      // Catalog response for B with blocks
      const catalogB = LocationsCatalogEntity(
        countryId: 'c1',
        countryCode: 'KW',
        governorates: [
          LocationGovernorateEntity(
            id: 'gov-1',
            nameAr: 'العاصمة',
            nameEn: 'Capital',
            code: 'CAP',
            areas: [
              LocationAreaEntity(
                id: 'area-B',
                nameAr: 'منطقة ب',
                nameEn: 'Area B',
                code: 'B',
                blocks: [
                  LocationBlockEntity(
                    id: 'block-B1',
                    nameAr: 'قطعة 1',
                    nameEn: 'Block 1',
                    code: 'B1',
                  ),
                ],
              ),
            ],
          ),
        ],
      );

      // Catalog response for A with blocks
      const catalogA = LocationsCatalogEntity(
        countryId: 'c1',
        countryCode: 'KW',
        governorates: [
          LocationGovernorateEntity(
            id: 'gov-1',
            nameAr: 'العاصمة',
            nameEn: 'Capital',
            code: 'CAP',
            areas: [
              LocationAreaEntity(
                id: 'area-A',
                nameAr: 'منطقة أ',
                nameEn: 'Area A',
                code: 'A',
                blocks: [
                  LocationBlockEntity(
                    id: 'block-A1',
                    nameAr: 'قطعة 1',
                    nameEn: 'Block 1',
                    code: 'A1',
                  ),
                ],
              ),
            ],
          ),
        ],
      );

      // Complete B first
      repo.catalogCompleters['KW:area-B']!.complete(const ApiSuccessResult(data: catalogB));
      await futureB;
      expect(vm.state.locations.selectedArea?.id, 'area-B');

      // Then complete A
      repo.catalogCompleters['KW:area-A']!.complete(const ApiSuccessResult(data: catalogA));
      await futureA;

      // Expect latest selection (Area B) still wins
      expect(vm.state.locations.selectedArea?.id, 'area-B');

      await vm.close();
    });

    test('geocode A then B; complete B first, then A -> geocode B wins', () async {
      final repo = ControllableAddressLocationRepo();
      final getCatalog = GetLocationsCatalogUseCase(repo);
      final geocode = GeocodeAddressUseCase(repo);
      final reverseGeocode = ReverseGeocodeLocationUseCase(repo);

      final ops = CustomerAddressEditorOperations();
      final vm = AddressEditorViewModel(
        operations: ops,
        getLocationsCatalogUseCase: getCatalog,
        geocodeAddressUseCase: geocode,
        reverseGeocodeLocationUseCase: reverseGeocode,
      );

      final futureA = vm.doIntent(const GeocodeAddressEvent(address: 'Query A'));
      final futureB = vm.doIntent(const GeocodeAddressEvent(address: 'Query B'));

      const autofillA = MapAddressAutofillEntity(
        latitude: 29.31,
        longitude: 48.01,
        formattedAddress: 'Address A',
      );

      const autofillB = MapAddressAutofillEntity(
        latitude: 29.32,
        longitude: 48.02,
        formattedAddress: 'Address B',
      );

      // Complete B first
      repo.geocodeCompleters['Query B']!.complete(const ApiSuccessResult(data: autofillB));
      await futureB;
      expect(vm.state.mapAutofill.autofill?.formattedAddress, 'Address B');

      // Complete A later
      repo.geocodeCompleters['Query A']!.complete(const ApiSuccessResult(data: autofillA));
      await futureA;

      // Expect B remains the selected autofill
      expect(vm.state.mapAutofill.autofill?.formattedAddress, 'Address B');

      await vm.close();
    });

    test('governorate change clears area and invalidates in-flight area load', () async {
      final repo = ControllableAddressLocationRepo();
      final getCatalog = GetLocationsCatalogUseCase(repo);
      final geocode = GeocodeAddressUseCase(repo);
      final reverseGeocode = ReverseGeocodeLocationUseCase(repo);

      final ops = CustomerAddressEditorOperations();
      final vm = AddressEditorViewModel(
        operations: ops,
        getLocationsCatalogUseCase: getCatalog,
        geocodeAddressUseCase: geocode,
        reverseGeocodeLocationUseCase: reverseGeocode,
      );

      const areaA = LocationAreaEntity(
        id: 'area-A',
        nameAr: 'منطقة أ',
        nameEn: 'Area A',
        code: 'A',
      );

      const gov2 = LocationGovernorateEntity(
        id: 'gov-2',
        nameAr: 'حولي',
        nameEn: 'Hawalli',
        code: 'HAW',
      );

      // Start area load
      final areaFuture = vm.doIntent(const SelectAddressAreaEvent(areaA));

      // User changes governorate before area finish
      vm.doIntent(const SelectAddressGovernorateEvent(gov2));
      expect(vm.state.locations.selectedGovernorate?.id, 'gov-2');
      expect(vm.state.locations.selectedArea, isNull);

      // In-flight area completes
      const catalogA = LocationsCatalogEntity(
        countryId: 'c1',
        countryCode: 'KW',
        governorates: [],
      );
      repo.catalogCompleters['KW:area-A']!.complete(const ApiSuccessResult(data: catalogA));
      await areaFuture;

      // Area should remain null because governorate changed
      expect(vm.state.locations.selectedArea, isNull);

      await vm.close();
    });

    test('duplicate submit is synchronously prevented by save lock', () async {
      final repo = ControllableAddressLocationRepo();
      final getCatalog = GetLocationsCatalogUseCase(repo);
      final geocode = GeocodeAddressUseCase(repo);
      final reverseGeocode = ReverseGeocodeLocationUseCase(repo);

      var addCallCount = 0;
      final addCompleter = Completer<ApiResult<CustomerAddressEntity>>();

      final ops = CustomerAddressEditorOperations(
        addCustomerAddress: (req) {
          addCallCount++;
          return addCompleter.future;
        },
      );

      final vm = AddressEditorViewModel(
        operations: ops,
        getLocationsCatalogUseCase: getCatalog,
        geocodeAddressUseCase: geocode,
        reverseGeocodeLocationUseCase: reverseGeocode,
      );

      // Dispatch two submits concurrently
      final submit1 = vm.doIntent(const SubmitAddressEvent(request: validRequest));
      final submit2 = vm.doIntent(const SubmitAddressEvent(request: validRequest));

      // Only one API call should have been made
      expect(addCallCount, 1);

      addCompleter.complete(const ApiSuccessResult(data: dummyAddress));
      await Future.wait([submit1, submit2]);

      expect(addCallCount, 1);
      expect(vm.state.action.isSuccess, isTrue);

      await vm.close();
    });

    test('failed save retains pending context so retry can succeed', () async {
      final repo = ControllableAddressLocationRepo();
      final getCatalog = GetLocationsCatalogUseCase(repo);
      final geocode = GeocodeAddressUseCase(repo);
      final reverseGeocode = ReverseGeocodeLocationUseCase(repo);

      var attempt = 0;
      final ops = CustomerAddressEditorOperations(
        previewNewAddressCoverage: (req, {page, pageSize}) async {
          attempt++;
          if (attempt == 1) {
            return ApiErrorResult(failure: Failure(errorMessage: 'Network timeout'));
          }
          return const ApiSuccessResult(
            data: AddressCoveragePreviewEntity(
              canSetAsDefault: true,
              isCurrentSubscriptionRestaurantCovered: true,
              hasActiveSubscription: true,
              servingRestaurants: [],
            ),
          );
        },
      );

      final vm = AddressEditorViewModel(
        operations: ops,
        getLocationsCatalogUseCase: getCatalog,
        geocodeAddressUseCase: geocode,
        reverseGeocodeLocationUseCase: reverseGeocode,
      );

      // First preview fails
      await vm.doIntent(const PreviewNewAddressCoverageEvent(validRequest));
      expect(vm.state.coveragePreview.failure, isNotNull);
      expect(vm.state.coveragePreview.pendingRequest, equals(validRequest));

      // Retry preview with same request succeeds
      await vm.doIntent(const RetryAddressCoveragePreviewEvent());
      expect(vm.state.coveragePreview.isSuccess, isTrue);
      expect(attempt, 2);

      await vm.close();
    });

    test('revisiting saved family member displays the newly saved address', () async {
      const member1 = FamilyMemberEntity(
        memberId: 'mem-1',
        displayName: 'Member 1',
        relationshipCode: 'CHILD',
        role: 2,
        gender: 1,
        ageYears: 10,
        setupStatus: 1,
        includeFriday: false,
        isCurrentUser: false,
      );

      const member2 = FamilyMemberEntity(
        memberId: 'mem-2',
        displayName: 'Member 2',
        relationshipCode: 'SPOUSE',
        role: 2,
        gender: 2,
        ageYears: 30,
        setupStatus: 1,
        includeFriday: false,
        isCurrentUser: false,
      );

      final flowSnapshot = FamilyFlowCurrentEntity(
        name: 'The Family',
        members: [member1, member2],
      );

      final familyVm = FamilyAddressesViewModel(
        GetFamilyFlowCurrentUseCase(_FakeFamilySubscriptionSetupRepo(flowSnapshot)),
      );

      await familyVm.load();
      expect(familyVm.state.members.length, 2);
      expect(familyVm.state.currentIndex, 0);

      // Save address for member 1
      familyVm.addressSaved(
        memberId: 'mem-1',
        savedAddress: dummyAddress,
      );

      // Member 1 now has deliveryAddress and deliveryAddressId updated in state.members
      expect(familyVm.state.members[0].deliveryAddressId, 'addr-1');
      expect(familyVm.state.members[0].deliveryAddress, dummyAddress);
      expect(familyVm.state.completedMemberIds, contains('mem-1'));

      // Switched to member 2
      expect(familyVm.state.currentIndex, 1);

      // User revisits member 1
      familyVm.selectMember(0);
      expect(familyVm.state.currentIndex, 0);
      expect(familyVm.state.currentMember?.deliveryAddress, dummyAddress);

      await familyVm.close();
    });
  });
}

class _FakeFamilySubscriptionSetupRepo implements FamilySubscriptionSetupRepository {
  _FakeFamilySubscriptionSetupRepo(this._snapshot);

  final FamilyFlowCurrentEntity _snapshot;

  @override
  Future<ApiResult<FamilyFlowCurrentEntity>> getFamilySubscriptionCurrent() async {
    return ApiSuccessResult(data: _snapshot);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
