import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/config/theme/app_theme.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/features/addresses/domain/entities/address_coverage_preview_entity.dart';
import 'package:meal_meat_user/features/addresses/presentation/widgets/address_coverage_preview_bottom_sheet.dart';
import 'package:meal_meat_user/features/addresses/presentation/widgets/address_choose_location_sheet.dart';
import 'package:meal_meat_user/features/addresses/presentation/widgets/address_details_bottom_sheet.dart';
import 'package:meal_meat_user/features/addresses/presentation/widgets/address_details_wolt_sheet.dart';
import 'package:meal_meat_user/features/addresses/presentation/widgets/address_choose_location_options_row.dart';
import 'package:meal_meat_user/features/addresses/presentation/widgets/address_choose_location_search_bar.dart';
import 'package:meal_meat_user/features/addresses/presentation/widgets/home_address_form_card.dart';
import 'package:meal_meat_user/features/addresses/presentation/widgets/location_confirmation_card.dart';

void main() {
  testWidgets('address form scales without overflow in a scrollable sheet', (
    tester,
  ) async {
    final controllers = List.generate(5, (_) => TextEditingController());
    addTearDown(() {
      for (final controller in controllers) {
        controller.dispose();
      }
    });

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        locale: const Locale('ar'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: SingleChildScrollView(
            child: FittedBox(
              fit: BoxFit.fitWidth,
              alignment: Alignment.topCenter,
              child: SizedBox(
                width: Spacing.addressesHomeFormWidth,
                child: HomeAddressFormCard(
                  governorates: const [],
                  areas: const [],
                  blocks: const [],
                  streetController: controllers[0],
                  avenueController: controllers[1],
                  floorController: controllers[2],
                  buildingNumberController: controllers[3],
                  apartmentController: controllers[4],
                  onGovernorateSelected: (_) {},
                  onAreaSelected: (_) {},
                  onBlockSelected: (_) {},
                ),
              ),
            ),
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
  });

  testWidgets('address form delegates scrolling to its parent sheet', (
    tester,
  ) async {
    final controllers = List.generate(5, (_) => TextEditingController());
    addTearDown(() {
      for (final controller in controllers) {
        controller.dispose();
      }
    });

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        locale: const Locale('ar'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: SingleChildScrollView(
            child: HomeAddressFormCard(
              governorates: const [],
              areas: const [],
              blocks: const [],
              streetController: controllers[0],
              avenueController: controllers[1],
              floorController: controllers[2],
              buildingNumberController: controllers[3],
              apartmentController: controllers[4],
              onGovernorateSelected: (_) {},
              onAreaSelected: (_) {},
              onBlockSelected: (_) {},
            ),
          ),
        ),
      ),
    );

    expect(
      find.descendant(
        of: find.byType(HomeAddressFormCard),
        matching: find.byWidgetPredicate(
          (widget) =>
              widget is Scrollable &&
              (widget.axisDirection == AxisDirection.down ||
                  widget.axisDirection == AxisDirection.up),
        ),
      ),
      findsNothing,
    );
  });

  testWidgets('uses the Figma location selection controls', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        locale: const Locale('ar'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const Scaffold(
          body: AddressChooseLocationSheet(
            isSubmitting: false,
            selectedMode: AddressLocationMode.currentLocation,
          ),
        ),
      ),
    );

    expect(find.byType(AddressChooseLocationSearchBar), findsOneWidget);
    expect(find.byType(AddressChooseLocationOptionsRow), findsOneWidget);
  });

  testWidgets('review card exposes edit and confirm actions', (tester) async {
    var editTapped = false;
    var confirmTapped = false;

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        locale: const Locale('ar'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: LocationConfirmationCard(
            isLoading: false,
            content: const SizedBox.shrink(),
            secondaryButtonText: 'تعديل البيانات',
            onSecondaryPressed: () => editTapped = true,
            onConfirm: () => confirmTapped = true,
          ),
        ),
      ),
    );

    await tester.tap(find.text('تعديل البيانات'));
    await tester.tap(find.text('تأكــــيـد المــوقـــع'));

    expect(editTapped, isTrue);
    expect(confirmTapped, isTrue);
  });

  testWidgets('address details use a draggable scrollable bottom sheet', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        locale: const Locale('ar'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: AddressDetailsBottomSheet(
            isLoading: false,
            onConfirm: () {},
            content: const SizedBox(height: 1200),
          ),
        ),
      ),
    );

    expect(find.byType(DraggableScrollableSheet), findsOneWidget);
    expect(find.byType(LocationConfirmationCard), findsOneWidget);
    final initialHeight = tester
        .getRect(find.byType(LocationConfirmationCard))
        .height;
    final confirmationCard = tester.widget<LocationConfirmationCard>(
      find.byType(LocationConfirmationCard),
    );
    expect(confirmationCard.primaryButtonText, 'متابعة وتحقق من التغطية');

    final sheet = tester.widget<DraggableScrollableSheet>(
      find.byType(DraggableScrollableSheet),
    );
    expect(sheet.snap, isTrue);
    expect(sheet.maxChildSize, greaterThan(sheet.initialChildSize));

    await tester.pumpAndSettle();
    final expandedHeight = tester
        .getRect(find.byType(LocationConfirmationCard))
        .height;
    expect(expandedHeight, greaterThan(initialHeight));
    expect(
      tester.getRect(find.byType(LocationConfirmationCard)).width,
      closeTo(360, 0.1),
    );
  });

  testWidgets('address details open in a scrollable Wolt sheet', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(360, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        locale: const Locale('ar'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(
          builder: (context) => TextButton(
            onPressed: () => AddressDetailsWoltSheet.show(
              context: context,
              isLoading: false,
              onConfirm: () {},
              content: const SizedBox(height: 1200),
            ),
            child: const Text('open'),
          ),
        ),
      ),
    );

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    expect(find.byType(AddressDetailsWoltSheet), findsOneWidget);
    expect(find.byType(Scrollable), findsWidgets);
    expect(tester.takeException(), isNull);
  });

  testWidgets('inline coverage confirmation does not pop the address frame', (
    tester,
  ) async {
    var confirmed = false;

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        locale: const Locale('ar'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: AddressCoveragePreviewBottomSheet(
            preview: const AddressCoveragePreviewEntity(
              canSetAsDefault: true,
              isCurrentSubscriptionRestaurantCovered: true,
              hasActiveSubscription: false,
            ),
            isSubmitting: false,
            confirmButtonText: 'Confirm',
            popOnConfirm: false,
            onConfirm: () => confirmed = true,
            onChooseAnother: () {},
          ),
        ),
      ),
    );

    await tester.tap(find.text('Confirm'));
    await tester.pumpAndSettle();

    expect(confirmed, isTrue);
    expect(find.byType(AddressCoveragePreviewBottomSheet), findsOneWidget);
  });
}
