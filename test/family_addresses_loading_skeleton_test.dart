import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/config/theme/app_theme.dart';
import 'package:meal_meat_user/core/di/di.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/core/widget/loading_widget.dart';
import 'package:meal_meat_user/core/address/domain/entities/locations_catalog_entity.dart';
import 'package:meal_meat_user/core/address/domain/repo/address_location_repository.dart';
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
import 'package:meal_meat_user/features/addresses/presentation/manager/addresses_view_model.dart';
import 'package:meal_meat_user/features/family_addresses/domain/repo/family_addresses_repository.dart';
import 'package:meal_meat_user/features/family_addresses/domain/usecase/family_addresses_usecases.dart';
import 'package:meal_meat_user/features/family_addresses/presentation/manager/family_addresses_view_model.dart';
import 'package:meal_meat_user/features/family_addresses/presentation/screens/family_addresses_screen.dart';
import 'package:meal_meat_user/features/family_addresses/presentation/widgets/family_address_location_stage.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/entities/family_flow_current_entity.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/repo/family_subscription_setup_repository.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/usecase/get_family_flow_current_usecase.dart';

void main() {
  testWidgets('family addresses loading preserves the page structure', (
    tester,
  ) async {
    final repository = _PendingFamilyFlowRepository();
    getIt.registerFactory<FamilyAddressesViewModel>(
      () => FamilyAddressesViewModel(GetFamilyFlowCurrentUseCase(repository)),
    );
    addTearDown(getIt.reset);

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        locale: const Locale('ar'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const FamilyAddressesScreen(),
      ),
    );
    await tester.pump();

    expect(find.byType(LoadingWidget), findsNothing);
    expect(find.text('إعداد اشتراك العائلة'), findsOneWidget);
    expect(
      find.text('خصص البرنامج المثالي لكل فرد في العائلة'),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('family-addresses-map-skeleton')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('family-addresses-sheet-skeleton')),
      findsOneWidget,
    );
  });

  testWidgets(
    'loaded family keeps its header while location content shimmers',
    (tester) async {
      tester.view.physicalSize = const Size(1080, 1920);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final addressesRepository = _PendingAddressesRepository();
      final familyAddressesRepository = _FamilyAddressesRepository();
      getIt.registerFactory<GetLocationsCatalogUseCase>(
        () => GetLocationsCatalogUseCase(addressesRepository),
      );
      getIt.registerFactory<GeocodeAddressUseCase>(
        () => GeocodeAddressUseCase(addressesRepository),
      );
      getIt.registerFactory<ReverseGeocodeLocationUseCase>(
        () => ReverseGeocodeLocationUseCase(addressesRepository),
      );
      getIt.registerFactory<AddressesViewModel>(
        () => AddressesViewModel(
          GetCustomerAddressesUseCase(addressesRepository),
          GetLocationsCatalogUseCase(addressesRepository),
          AddCustomerAddressUseCase(addressesRepository),
          UpdateCustomerAddressUseCase(addressesRepository),
          DeleteCustomerAddressUseCase(addressesRepository),
          GeocodeAddressUseCase(addressesRepository),
          ReverseGeocodeLocationUseCase(addressesRepository),
          PreviewNewAddressCoverageUseCase(addressesRepository),
          PreviewExistingAddressCoverageUseCase(addressesRepository),
          ConfirmSetDefaultAddressUseCase(addressesRepository),
        ),
      );
      getIt.registerFactory<PreviewFamilyMemberAddressUseCase>(
        () => PreviewFamilyMemberAddressUseCase(familyAddressesRepository),
      );
      getIt.registerFactory<AddFamilyMemberAddressUseCase>(
        () => AddFamilyMemberAddressUseCase(familyAddressesRepository),
      );
      addTearDown(getIt.reset);

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
      await tester.pump();

      expect(
        find.byKey(const ValueKey('family-addresses-map-skeleton')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey('family-addresses-sheet-skeleton')),
        findsOneWidget,
      );
    },
  );
}

class _PendingFamilyFlowRepository
    implements FamilySubscriptionSetupRepository {
  final Completer<ApiResult<FamilyFlowCurrentEntity>> _completer = Completer();

  @override
  Future<ApiResult<FamilyFlowCurrentEntity>> getFamilySubscriptionCurrent() =>
      _completer.future;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _PendingAddressesRepository
    implements AddressesRepository, AddressLocationRepository {
  final Completer<ApiResult<LocationsCatalogEntity>> _completer = Completer();

  @override
  Future<ApiResult<LocationsCatalogEntity>> getLocationsCatalog(
    String countryCode,
    String? areaId,
  ) => _completer.future;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FamilyAddressesRepository implements FamilyAddressesRepository {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
