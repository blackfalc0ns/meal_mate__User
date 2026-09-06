import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/features/addresses/domain/entities/customer_address_entity.dart';
import 'package:meal_meat_user/features/addresses/presentation/widgets/building_type_selector.dart';
import 'package:meal_meat_user/features/addresses/presentation/widgets/home_address_form_card.dart';

void main() {
  testWidgets('edit address form starts with the selected address values', (
    tester,
  ) async {
    const address = CustomerAddressEntity(
      addressId: 'address-1',
      label: 'Home',
      addressLine: 'Capital, Rawda, Block 1, 22, 32, 33',
      regionId: 'area-1',
      governorate: 'Capital',
      area: 'Rawda',
      block: 'Block 1',
      blockRegionId: 'block-1',
      street: '22',
      building: '32',
      unit: '1201',
      floor: '33',
      notes: 'Avenue 5',
      isDefault: true,
      notifyOnDelivery: true,
    );

    final streetController = TextEditingController(text: address.street);
    final avenueController = TextEditingController(text: address.notes);
    final floorController = TextEditingController(text: address.floor);
    final buildingController = TextEditingController(text: address.building);
    final apartmentController = TextEditingController(text: address.unit);

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: SingleChildScrollView(
            child: HomeAddressFormCard(
              governorates: const [],
              areas: const [],
              blocks: const [],
              streetController: streetController,
              avenueController: avenueController,
              floorController: floorController,
              buildingNumberController: buildingController,
              apartmentController: apartmentController,
              selectedBuildingType: AddressBuildingType.home,
              onGovernorateSelected: (_) {},
              onAreaSelected: (_) {},
              onBlockSelected: (_) {},
              onBuildingTypeChanged: (_) {},
            ),
          ),
        ),
      ),
    );

    expect(find.text('22'), findsOneWidget);
    expect(find.text('Avenue 5'), findsOneWidget);
    expect(find.text('33'), findsOneWidget);
    expect(find.text('32'), findsOneWidget);
    expect(find.text('1201'), findsOneWidget);
  });
}
