import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/features/addresses/presentation/widgets/address_choose_location_header.dart';
import 'package:meal_meat_user/features/addresses/presentation/widgets/address_choose_location_options_row.dart';
import 'package:meal_meat_user/features/addresses/presentation/widgets/address_choose_location_search_bar.dart';
import 'package:meal_meat_user/features/addresses/presentation/widgets/address_choose_location_sheet.dart';

void main() {
  Widget buildTestWidget({
    required Widget child,
    Locale locale = const Locale('ar'),
  }) {
    return MaterialApp(
      locale: locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(body: child),
    );
  }

  group('Address Choose Location Figma 2403-6578 Components', () {
    testWidgets('Header renders title and subtitle in Arabic', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(child: const AddressChooseLocationHeader()),
      );

      expect(find.text('اختيار موقع البيت'), findsOneWidget);
      expect(find.text('اختر موقع التوصيل الأساسي للمنزل'), findsOneWidget);
    });

    testWidgets('Header renders title and subtitle in English', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          locale: const Locale('en'),
          child: const AddressChooseLocationHeader(),
        ),
      );

      expect(find.text('Choose home location'), findsOneWidget);
      expect(
        find.text('Choose the main delivery location for home'),
        findsOneWidget,
      );
    });

    testWidgets('SearchBar displays hint and accepts input', (tester) async {
      final controller = TextEditingController();
      String? submittedText;

      await tester.pumpWidget(
        buildTestWidget(
          child: AddressChooseLocationSearchBar(
            controller: controller,
            onSubmitted: (val) => submittedText = val,
          ),
        ),
      );

      expect(find.text('ابحث عن عنوان أو منطقة أو شارع'), findsOneWidget);

      await tester.enterText(find.byType(TextField), 'السالمية');
      await tester.testTextInput.receiveAction(TextInputAction.search);
      await tester.pump();

      expect(submittedText, 'السالمية');
    });

    testWidgets('OptionsRow renders both modes and switches selection', (
      tester,
    ) async {
      AddressLocationMode currentMode = AddressLocationMode.fromMap;
      bool currentLocationCalled = false;

      await tester.pumpWidget(
        StatefulBuilder(
          builder: (context, setState) {
            return buildTestWidget(
              child: AddressChooseLocationOptionsRow(
                selectedMode: currentMode,
                onModeChanged: (newMode) {
                  setState(() => currentMode = newMode);
                },
                onUseCurrentLocation: () {
                  currentLocationCalled = true;
                },
              ),
            );
          },
        ),
      );

      expect(find.text('اختيار من الخريطة'), findsOneWidget);
      expect(find.text('حدد موقعك من الخريطة'), findsOneWidget);
      expect(find.text('استخدام موقعي الحالي'), findsOneWidget);
      expect(find.text('يحدد موقعك الحالي تلقائياً'), findsOneWidget);

      // Tap "استخدام موقعي الحالي"
      await tester.tap(find.text('استخدام موقعي الحالي'));
      await tester.pumpAndSettle();

      expect(currentMode, AddressLocationMode.currentLocation);
      expect(currentLocationCalled, isTrue);
    });

    testWidgets('Sheet renders all components and handles confirm tap', (
      tester,
    ) async {
      bool confirmTapped = false;

      await tester.pumpWidget(
        buildTestWidget(
          child: AddressChooseLocationSheet(
            selectedMode: AddressLocationMode.currentLocation,
            isSubmitting: false,
            onConfirm: () => confirmTapped = true,
          ),
        ),
      );

      expect(find.byType(AddressChooseLocationHeader), findsOneWidget);
      expect(find.byType(AddressChooseLocationSearchBar), findsOneWidget);
      expect(find.byType(AddressChooseLocationOptionsRow), findsOneWidget);
      expect(find.text('متابعة وتحقق من التغطية'), findsOneWidget);

      await tester.tap(find.text('متابعة وتحقق من التغطية'));
      await tester.pump();

      expect(confirmTapped, isTrue);
    });
  });
}
