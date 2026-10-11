import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/address/domain/entities/customer_address_entity.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/features/addresses/presentation/widgets/current_address_card.dart';

void main() {
  const sampleAddress = CustomerAddressEntity(
    addressId: '0f10fbb7-fa79-4692-9068-514f2a315cdb',
    label: 'المنزل',
    addressLine: 'حولي, السالمية, قطعة 3, شارع 2, جادة 2, 2',
    regionId: '20344d90-d50d-4607-8101-f25ac40e229c',
    latitude: 29.340746,
    longitude: 48.083898,
    notes: 'جادة 2',
    isDefault: true,
    notifyOnDelivery: true,
    governorate: 'حولي',
    area: 'السالمية',
    block: 'قطعة 3',
    street: 'شارع 2',
    avenue: 'جادة 2',
    building: '2',
    blockRegionId: 'df58d2e7-b629-4984-9256-3f1e1457f994',
    isDeliveryActive: true,
  );

  Widget createWidget({
    required Size screenSize,
    CustomerAddressEntity address = sampleAddress,
  }) {
    return MaterialApp(
      locale: const Locale('ar'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: MediaQuery(
        data: MediaQueryData(size: screenSize),
        child: Scaffold(
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: CurrentAddressCard(address: address),
          ),
        ),
      ),
    );
  }

  testWidgets(
    'CurrentAddressCard renders without overflow on 390px width screen in RTL',
    (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(createWidget(screenSize: const Size(390, 844)));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('المنزل'), findsOneWidget);
      expect(find.text('عنوان التوصيل'), findsOneWidget);
    },
  );

  testWidgets(
    'CurrentAddressCard renders without overflow on 360px narrow screen in RTL',
    (tester) async {
      tester.view.physicalSize = const Size(360, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(createWidget(screenSize: const Size(360, 800)));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('المنزل'), findsOneWidget);
    },
  );

  testWidgets('CurrentAddressCard handles long custom label without crashing', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(375, 667);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    const longLabelAddress = CustomerAddressEntity(
      addressId: 'long-id',
      label: 'منزل العائلة الكبير في منطقة السالمية',
      addressLine: 'حولي, السالمية, قطعة 3, شارع 2, جادة 2, 2',
      regionId: 'reg-id',
      latitude: 29.340746,
      longitude: 48.083898,
      isDefault: false,
      notifyOnDelivery: true,
      isDeliveryActive: false,
    );

    await tester.pumpWidget(
      createWidget(screenSize: const Size(375, 667), address: longLabelAddress),
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('منزل العائلة الكبير في منطقة السالمية'), findsOneWidget);
  });
}
