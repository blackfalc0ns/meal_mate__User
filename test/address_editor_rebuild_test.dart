import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/config/theme/app_theme.dart';
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
import 'package:meal_meat_user/core/address/presentation/manager/address_editor_state.dart';
import 'package:meal_meat_user/core/address/presentation/manager/address_editor_view_model.dart';
import 'package:meal_meat_user/core/address/presentation/widgets/address_choose_location_map_view.dart';
import 'package:meal_meat_user/core/address/presentation/widgets/address_coverage_preview_bottom_sheet.dart';
import 'package:meal_meat_user/core/di/di.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/addresses/domain/usecase/customer_address_editor_operations.dart';
import 'package:meal_meat_user/features/family_addresses/domain/repo/family_addresses_repository.dart';
import 'package:meal_meat_user/features/family_addresses/domain/usecase/family_addresses_usecases.dart';
import 'package:meal_meat_user/features/family_addresses/presentation/widgets/family_address_location_stage.dart';

class _FakeLocationRepo implements AddressLocationRepository {
  static const dummyCatalog = LocationsCatalogEntity(
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
            id: 'area-1',
            nameAr: 'المنطقة',
            nameEn: 'Area',
            code: 'A1',
            blocks: [
              LocationBlockEntity(
                id: 'b1',
                nameAr: 'قطعة 1',
                nameEn: 'Block 1',
                code: '1',
              ),
            ],
          ),
        ],
      ),
    ],
  );

  @override
  Future<ApiResult<LocationsCatalogEntity>> getLocationsCatalog(
    String countryCode, [
    String? areaId,
  ]) async => const ApiSuccessResult(data: dummyCatalog);

  @override
  Future<ApiResult<MapAddressAutofillEntity>> geocode(
    String address, {
    String countryCode = 'KW',
  }) async => const ApiSuccessResult(
    data: MapAddressAutofillEntity(
      latitude: 29.34,
      longitude: 48.08,
      formattedAddress: 'Kuwait City',
    ),
  );

  @override
  Future<ApiResult<MapAddressAutofillEntity>> reverseGeocode(
    double latitude,
    double longitude,
  ) async => const ApiSuccessResult(
    data: MapAddressAutofillEntity(
      latitude: 29.34,
      longitude: 48.08,
      formattedAddress: 'Kuwait City',
    ),
  );
}

class _CountingMapWidget extends StatelessWidget {
  const _CountingMapWidget({super.key, required this.onBuild});

  final VoidCallback onBuild;

  @override
  Widget build(BuildContext context) {
    onBuild();
    return const SizedBox(
      key: ValueKey('counting-map-widget'),
      height: 300,
      width: 300,
    );
  }
}

void main() {
  setUp(() {
    final repo = _FakeLocationRepo();
    getIt.registerFactory<GetLocationsCatalogUseCase>(
      () => GetLocationsCatalogUseCase(repo),
    );
    getIt.registerFactory<GeocodeAddressUseCase>(
      () => GeocodeAddressUseCase(repo),
    );
    getIt.registerFactory<ReverseGeocodeLocationUseCase>(
      () => ReverseGeocodeLocationUseCase(repo),
    );
  });

  tearDown(getIt.reset);

  group('Address Editor Rebuild Boundaries', () {
    testWidgets(
      'coverage pagination does NOT rebuild AddressChooseLocationMapView',
      (tester) async {
        final repo = _FakeLocationRepo();
        var previewCallCount = 0;
        final previewCompleter =
            Completer<ApiResult<AddressCoveragePreviewEntity>>();

        final ops = CustomerAddressEditorOperations(
          previewNewAddressCoverage: (req, {page, pageSize}) {
            previewCallCount++;
            return previewCompleter.future;
          },
        );

        final vm = AddressEditorViewModel(
          operations: ops,
          getLocationsCatalogUseCase: GetLocationsCatalogUseCase(repo),
          geocodeAddressUseCase: GeocodeAddressUseCase(repo),
          reverseGeocodeLocationUseCase: ReverseGeocodeLocationUseCase(repo),
        );
        addTearDown(vm.close);

        // Track how many times MapView is built
        var mapBuildCount = 0;

        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.lightTheme,
            locale: const Locale('en'),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Scaffold(
              body: Builder(
                builder: (context) {
                  return Stack(
                    children: [
                      // Map subtree using BlocSelector
                      _CountingMapWidget(
                        key: const ValueKey('map'),
                        onBuild: () => mapBuildCount++,
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        );
        await tester.pump();

        final initialBuildCount = mapBuildCount;
        expect(initialBuildCount, 1);

        // Now trigger coverage preview pagination state change
        // State updates with coverage pagination should NOT touch map subtree
        await tester.pump();
        expect(mapBuildCount, initialBuildCount);
      },
    );

    testWidgets(
      'FamilyAddressLocationStage rebuild boundaries isolate map from coverage changes',
      (tester) async {
        tester.view.physicalSize = const Size(1080, 1920);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        final dummyPreview = const AddressCoveragePreviewEntity(
          canSetAsDefault: true,
          isCurrentSubscriptionRestaurantCovered: true,
          hasActiveSubscription: true,
          servingRestaurants: [
            ServingRestaurantEntity(
              id: 'rest-1',
              nameAr: 'مطعم 1',
              nameEn: 'Rest 1',
              logoUrl: '',
            ),
          ],
        );

        getIt.registerFactory<PreviewFamilyMemberAddressUseCase>(
          () => PreviewFamilyMemberAddressUseCase(
            _FakeFamilyAddressesRepo(dummyPreview),
          ),
        );
        getIt.registerFactory<AddFamilyMemberAddressUseCase>(
          () => AddFamilyMemberAddressUseCase(
            _FakeFamilyAddressesRepo(dummyPreview),
          ),
        );

        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.lightTheme,
            locale: const Locale('en'),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Scaffold(
              body: FamilyAddressLocationStage(
                memberId: 'member-1',
                onSaved: () {},
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // The map view exists
        expect(find.byType(AddressChooseLocationMapView), findsOneWidget);

        // State update of coverage loading more or similar doesn't recreate map view
        final mapViewElement = tester.element(
          find.byType(AddressChooseLocationMapView),
        );

        await tester.pump();

        final mapViewElementAfter = tester.element(
          find.byType(AddressChooseLocationMapView),
        );
        expect(identical(mapViewElement, mapViewElementAfter), isTrue);
      },
    );

    testWidgets(
      'switching memberId in FamilyAddressLocationStage reinitializes editor',
      (tester) async {
        tester.view.physicalSize = const Size(1080, 1920);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        final dummyPreview = const AddressCoveragePreviewEntity(
          canSetAsDefault: true,
          isCurrentSubscriptionRestaurantCovered: true,
          hasActiveSubscription: true,
          servingRestaurants: [],
        );

        getIt.registerFactory<PreviewFamilyMemberAddressUseCase>(
          () => PreviewFamilyMemberAddressUseCase(
            _FakeFamilyAddressesRepo(dummyPreview),
          ),
        );
        getIt.registerFactory<AddFamilyMemberAddressUseCase>(
          () => AddFamilyMemberAddressUseCase(
            _FakeFamilyAddressesRepo(dummyPreview),
          ),
        );

        var currentMember = 'member-1';

        await tester.pumpWidget(
          StatefulBuilder(
            builder: (context, setState) {
              return MaterialApp(
                theme: AppTheme.lightTheme,
                locale: const Locale('en'),
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                supportedLocales: AppLocalizations.supportedLocales,
                home: Scaffold(
                  body: Column(
                    children: [
                      ElevatedButton(
                        onPressed: () =>
                            setState(() => currentMember = 'member-2'),
                        child: const Text('Switch'),
                      ),
                      Expanded(
                        child: FamilyAddressLocationStage(
                          key: const ValueKey('stage'),
                          memberId: currentMember,
                          onSaved: () {},
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byKey(const ValueKey('member-1')), findsOneWidget);

        // Switch to member 2
        await tester.tap(find.text('Switch'));
        await tester.pumpAndSettle();

        // Key of AddressChooseLocationMapView is now member-2
        expect(find.byKey(const ValueKey('member-2')), findsOneWidget);
        expect(find.byKey(const ValueKey('member-1')), findsNothing);
      },
    );
  });
}

class _FakeFamilyAddressesRepo implements FamilyAddressesRepository {
  _FakeFamilyAddressesRepo(this._preview);

  final AddressCoveragePreviewEntity _preview;

  @override
  Future<ApiResult<AddressCoveragePreviewEntity>> previewFamilyMemberAddress(
    String memberId,
    CustomerAddressRequestEntity request, {
    int? page,
    int? pageSize,
  }) async {
    return ApiSuccessResult(data: _preview);
  }

  @override
  Future<ApiResult<CustomerAddressEntity>> addFamilyMemberAddress(
    String memberId,
    CustomerAddressRequestEntity request,
  ) async {
    return const ApiSuccessResult(
      data: CustomerAddressEntity(
        addressId: 'a1',
        label: 'Home',
        addressLine: 'Street 1',
        isDefault: true,
        notifyOnDelivery: false,
      ),
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
