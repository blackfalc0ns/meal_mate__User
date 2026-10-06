import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/di/di.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/core/address/domain/entities/customer_address_entity.dart';
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
import 'package:meal_meat_user/features/addresses/presentation/manager/addresses_event.dart';
import 'package:meal_meat_user/features/addresses/presentation/manager/addresses_view_model.dart';
import 'package:meal_meat_user/features/addresses/presentation/screens/addresses_screen.dart';

void main() {
  testWidgets('successful default address action shows a success snackbar', (
    tester,
  ) async {
    final repository = _SuccessfulAddressesRepository();
    late AddressesViewModel viewModel;
    getIt.registerFactory<AddressesViewModel>(() {
      viewModel = AddressesViewModel(
        GetCustomerAddressesUseCase(repository),
        GetLocationsCatalogUseCase(repository),
        AddCustomerAddressUseCase(repository),
        UpdateCustomerAddressUseCase(repository),
        DeleteCustomerAddressUseCase(repository),
        GeocodeAddressUseCase(repository),
        ReverseGeocodeLocationUseCase(repository),
        PreviewNewAddressCoverageUseCase(repository),
        PreviewExistingAddressCoverageUseCase(repository),
        ConfirmSetDefaultAddressUseCase(repository),
      );
      return viewModel;
    });
    addTearDown(getIt.reset);

    await tester.pumpWidget(
      const MaterialApp(
        locale: Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: AddressesScreen(),
      ),
    );
    await tester.pumpAndSettle();

    viewModel.doIntent(const ConfirmSetDefaultAddressEvent('address-1'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Address saved successfully.'), findsOneWidget);
  });
}

class _SuccessfulAddressesRepository
    implements AddressesRepository, AddressLocationRepository {
  @override
  Future<ApiResult<List<CustomerAddressEntity>>> getCustomerAddresses() async {
    return ApiSuccessResult(data: const []);
  }

  @override
  Future<ApiResult<CustomerAddressEntity>> confirmSetDefaultAddress(
    String addressId,
  ) async {
    return ApiSuccessResult(
      data: CustomerAddressEntity(
        addressId: addressId,
        label: 'Home',
        addressLine: 'Address line',
        isDefault: true,
        notifyOnDelivery: false,
      ),
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
