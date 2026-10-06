import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/di/di.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/core/address/domain/entities/address_coverage_pagination_entity.dart';
import 'package:meal_meat_user/core/address/domain/entities/address_coverage_preview_entity.dart';
import 'package:meal_meat_user/core/address/domain/entities/customer_address_entity.dart';
import 'package:meal_meat_user/core/address/domain/entities/locations_catalog_entity.dart';
import 'package:meal_meat_user/features/addresses/domain/repo/addresses_repository.dart';
import 'package:meal_meat_user/features/addresses/domain/usecase/add_customer_address_usecase.dart';
import 'package:meal_meat_user/features/addresses/domain/usecase/confirm_set_default_address_usecase.dart';
import 'package:meal_meat_user/features/addresses/domain/usecase/delete_customer_address_usecase.dart';
import 'package:meal_meat_user/core/address/domain/usecase/geocode_address_usecase.dart';
import 'package:meal_meat_user/features/addresses/domain/usecase/get_customer_addresses_usecase.dart';
import 'package:meal_meat_user/core/address/domain/usecase/get_locations_catalog_usecase.dart';
import 'package:meal_meat_user/features/addresses/domain/usecase/preview_existing_address_coverage_usecase.dart';
import 'package:meal_meat_user/features/addresses/domain/usecase/preview_new_address_coverage_usecase.dart';
import 'package:meal_meat_user/core/address/domain/usecase/reverse_geocode_location_usecase.dart';
import 'package:meal_meat_user/features/addresses/domain/usecase/update_customer_address_usecase.dart';
import 'package:meal_meat_user/features/addresses/presentation/manager/addresses_event.dart';
import 'package:meal_meat_user/features/addresses/presentation/manager/addresses_view_model.dart';
import 'package:meal_meat_user/core/address/domain/repo/address_location_repository.dart';
import 'package:meal_meat_user/features/addresses/presentation/screens/addresses_screen.dart';

class _FakeAddressesRepo
    implements AddressesRepository, AddressLocationRepository {
  List<ServingRestaurantEntity> page1Restaurants = const [
    ServingRestaurantEntity(id: 'r1', nameAr: 'مطعم 1', nameEn: 'Restaurant 1'),
  ];
  List<ServingRestaurantEntity> page2Restaurants = const [
    ServingRestaurantEntity(id: 'r2', nameAr: 'مطعم 2', nameEn: 'Restaurant 2'),
  ];

  @override
  Future<ApiResult<AddressCoveragePreviewEntity>>
  previewExistingAddressCoverage(
    String addressId, {
    int? page,
    int? pageSize,
  }) async {
    if (page == 2) {
      return ApiSuccessResult(
        data: AddressCoveragePreviewEntity(
          canSetAsDefault: true,
          isCurrentSubscriptionRestaurantCovered: true,
          hasActiveSubscription: true,
          servingRestaurants: page2Restaurants,
          pagination: const AddressCoveragePaginationEntity(
            page: 2,
            pageSize: 20,
            hasNextPage: false,
          ),
        ),
      );
    }
    return ApiSuccessResult(
      data: AddressCoveragePreviewEntity(
        canSetAsDefault: true,
        isCurrentSubscriptionRestaurantCovered: true,
        hasActiveSubscription: true,
        servingRestaurants: page1Restaurants,
        pagination: const AddressCoveragePaginationEntity(
          page: 1,
          pageSize: 20,
          hasNextPage: true,
        ),
      ),
    );
  }

  @override
  Future<ApiResult<List<CustomerAddressEntity>>> getCustomerAddresses() async {
    return ApiSuccessResult(
      data: const [
        CustomerAddressEntity(
          addressId: 'addr-1',
          label: 'Home',
          addressLine: 'Street 1',
          governorate: 'Capital',
          area: 'Sharq',
          block: '1',
          street: 'Main',
          building: '10',
          isDefault: false,
          isDeliveryActive: true,
          notifyOnDelivery: false,
        ),
      ],
    );
  }

  @override
  Future<ApiResult<LocationsCatalogEntity>> getLocationsCatalog(
    String countryCode,
    String? areaId,
  ) async => ApiSuccessResult(
    data: const LocationsCatalogEntity(
      countryId: '1',
      countryCode: 'KW',
      governorates: [],
    ),
  );

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _ModalCountNavigatorObserver extends NavigatorObserver {
  int modalPushCount = 0;

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    if (route.toString().contains('Modal') ||
        route.runtimeType.toString().contains('ModalSheet')) {
      modalPushCount++;
    }
  }
}

void main() {
  testWidgets(
    'AddressesScreen opens coverage modal once and appends page 2 without duplicate routes',
    (tester) async {
      final repo = _FakeAddressesRepo();
      late AddressesViewModel viewModel;
      getIt.registerFactory<AddressesViewModel>(() {
        viewModel = AddressesViewModel(
          GetCustomerAddressesUseCase(repo),
          GetLocationsCatalogUseCase(repo),
          AddCustomerAddressUseCase(repo),
          UpdateCustomerAddressUseCase(repo),
          DeleteCustomerAddressUseCase(repo),
          GeocodeAddressUseCase(repo),
          ReverseGeocodeLocationUseCase(repo),
          PreviewNewAddressCoverageUseCase(repo),
          PreviewExistingAddressCoverageUseCase(repo),
          ConfirmSetDefaultAddressUseCase(repo),
        );
        return viewModel;
      });
      addTearDown(getIt.reset);

      final observer = _ModalCountNavigatorObserver();

      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          navigatorObservers: [observer],
          home: const AddressesScreen(),
        ),
      );

      // Initial loading of addresses list
      await tester.pumpAndSettle();

      expect(find.text('Street 1'), findsWidgets);

      // Trigger preview coverage for existing address
      viewModel.doIntent(const PreviewExistingAddressCoverageEvent('addr-1'));
      await tester.pump(); // Start request
      await tester.pumpAndSettle(); // Resolve request and show modal

      expect(find.text('Restaurant 1'), findsOneWidget);
      final initialModalCount = observer.modalPushCount;
      expect(initialModalCount, greaterThan(0));

      // Trigger load more
      viewModel.doIntent(const LoadMoreAddressCoverageRestaurantsEvent());
      await tester.pump();
      await tester.pumpAndSettle();

      // Verify page 2 restaurant is now visible in the SAME modal
      expect(find.text('Restaurant 1'), findsOneWidget);
      expect(find.text('Restaurant 2'), findsOneWidget);

      // Modal count must still be the same (no duplicate modal pushed)
      expect(observer.modalPushCount, initialModalCount);
    },
  );
}
