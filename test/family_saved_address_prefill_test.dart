import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/config/theme/app_theme.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/features/addresses/domain/entities/customer_address_entity.dart';
import 'package:meal_meat_user/features/addresses/domain/repo/addresses_repository.dart';
import 'package:meal_meat_user/features/addresses/domain/usecase/add_customer_address_usecase.dart';
import 'package:meal_meat_user/features/addresses/domain/usecase/confirm_set_default_address_usecase.dart';
import 'package:meal_meat_user/features/addresses/domain/usecase/delete_customer_address_usecase.dart';
import 'package:meal_meat_user/features/addresses/domain/usecase/geocode_address_usecase.dart';
import 'package:meal_meat_user/features/addresses/domain/usecase/get_customer_addresses_usecase.dart';
import 'package:meal_meat_user/features/addresses/domain/usecase/get_locations_catalog_usecase.dart';
import 'package:meal_meat_user/features/addresses/domain/usecase/preview_existing_address_coverage_usecase.dart';
import 'package:meal_meat_user/features/addresses/domain/usecase/preview_new_address_coverage_usecase.dart';
import 'package:meal_meat_user/features/addresses/domain/usecase/reverse_geocode_location_usecase.dart';
import 'package:meal_meat_user/features/addresses/domain/usecase/update_customer_address_usecase.dart';
import 'package:meal_meat_user/features/addresses/presentation/manager/addresses_state.dart';
import 'package:meal_meat_user/features/addresses/presentation/manager/addresses_view_model.dart';
import 'package:meal_meat_user/features/addresses/presentation/widgets/address_choose_location_search_bar.dart';
import 'package:meal_meat_user/features/addresses/presentation/widgets/address_details_wolt_sheet.dart';
import 'package:meal_meat_user/features/addresses/presentation/widgets/address_form_field.dart';
import 'package:meal_meat_user/features/addresses/presentation/widgets/home_address_form_card.dart';
import 'package:meal_meat_user/features/addresses/presentation/widgets/addresses_figma_frame.dart';

void main() {
  testWidgets('saved family address is shown in the location search field', (
    tester,
  ) async {
    const address = CustomerAddressEntity(
      addressId: 'address-1',
      label: 'Home',
      addressLine: 'Kuwait City, Block 2, Street 10',
      latitude: 29.37,
      longitude: 47.98,
      isDefault: true,
      notifyOnDelivery: true,
    );
    final repository = _AddressesRepository();
    final viewModel = AddressesViewModel(
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
    addTearDown(viewModel.close);

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        locale: const Locale('en'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: Scaffold(
          body: BlocProvider.value(
            value: viewModel,
            child: const AddressesFigmaFrame(
              locations: LocationsCatalogState(),
              isSubmitting: false,
              initialAddress: address,
              showInitialAddressDetails: false,
            ),
          ),
        ),
      ),
    );

    final searchBar = tester.widget<AddressChooseLocationSearchBar>(
      find.byType(AddressChooseLocationSearchBar),
    );
    expect(searchBar.controller?.text, address.addressLine);
  });

  testWidgets('empty house number keeps address details open', (tester) async {
    final repository = _AddressesRepository();
    final viewModel = AddressesViewModel(
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
    addTearDown(viewModel.close);

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        locale: const Locale('en'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: Scaffold(
          body: BlocProvider.value(
            value: viewModel,
            child: const AddressesFigmaFrame(
              locations: LocationsCatalogState(),
              isSubmitting: false,
              initialAddress: CustomerAddressEntity(
                addressId: 'address-1',
                label: 'Home',
                addressLine: 'Block 2, Street 10',
                isDefault: true,
                notifyOnDelivery: true,
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(AddressDetailsWoltSheet), findsOneWidget);
    await tester.tap(find.text('Continue & Check Coverage').last);
    await tester.pump();

    expect(find.byType(AddressDetailsWoltSheet), findsOneWidget);
    final inlineError = find.descendant(
      of: find.byType(HomeAddressFormCard),
      matching: find.text('This field is required'),
    );
    expect(inlineError, findsOneWidget);

    final houseField = find.byWidgetPredicate(
      (widget) =>
          widget is AddressFormField &&
          widget.label == 'House / building number',
    );
    await tester.enterText(
      find.descendant(of: houseField, matching: find.byType(TextField)),
      '12',
    );
    await tester.pump();
    expect(inlineError, findsNothing);
    expect(tester.takeException(), isNull);
  });
}

class _AddressesRepository implements AddressesRepository {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
