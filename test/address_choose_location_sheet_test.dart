import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/config/theme/app_theme.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/features/addresses/presentation/widgets/address_choose_location_sheet.dart';
import 'package:meal_meat_user/features/addresses/presentation/widgets/address_choose_location_options_row.dart';
import 'package:meal_meat_user/features/addresses/presentation/widgets/address_choose_location_search_bar.dart';
import 'package:meal_meat_user/features/addresses/presentation/widgets/location_confirmation_card.dart';

void main() {
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
}
