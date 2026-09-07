import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/features/addresses/domain/entities/address_coverage_preview_entity.dart';
import 'package:meal_meat_user/features/addresses/presentation/widgets/address_coverage_preview_bottom_sheet.dart';

void main() {
  testWidgets('confirming coverage closes the preview before submitting', (
    tester,
  ) async {
    var submissionCount = 0;

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: Builder(
            builder: (context) => TextButton(
              onPressed: () => showModalBottomSheet<void>(
                context: context,
                builder: (_) => AddressCoveragePreviewBottomSheet(
                  preview: const AddressCoveragePreviewEntity(
                    canSetAsDefault: true,
                    isCurrentSubscriptionRestaurantCovered: true,
                    hasActiveSubscription: true,
                  ),
                  isSubmitting: false,
                  confirmButtonText: 'Confirm',
                  onConfirm: () => submissionCount++,
                  onChooseAnother: () {},
                ),
              ),
              child: const Text('Open'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    expect(find.text('Confirm'), findsOneWidget);

    await tester.tap(find.text('Confirm'));
    await tester.pumpAndSettle();

    expect(submissionCount, 1);
    expect(find.text('Confirm'), findsNothing);
  });
}
