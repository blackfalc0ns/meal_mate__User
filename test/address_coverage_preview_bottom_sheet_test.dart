import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/core/widget/custom_progress_indecator.dart';
import 'package:meal_meat_user/core/widget/shimmer_widget.dart';
import 'package:meal_meat_user/core/address/domain/entities/address_coverage_preview_entity.dart';
import 'package:meal_meat_user/core/address/domain/entities/customer_address_entity.dart';
import 'package:meal_meat_user/core/address/presentation/widgets/address_coverage_preview_bottom_sheet.dart';

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

  testWidgets(
    'when submitting, shows centered CustomProgressIndicator and no button spinner',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: AddressCoveragePreviewBottomSheet(
              preview: const AddressCoveragePreviewEntity(
                canSetAsDefault: true,
                isCurrentSubscriptionRestaurantCovered: true,
                hasActiveSubscription: true,
              ),
              isSubmitting: true,
              confirmButtonText: 'Confirm',
              popOnConfirm: false,
              onConfirm: () {},
              onChooseAnother: () {},
            ),
          ),
        ),
      );

      // Button must NOT contain a CircularProgressIndicator spinner
      expect(find.byType(CircularProgressIndicator), findsNothing);

      // Instead, CustomProgressIndicator must be displayed in the center
      expect(find.byType(CustomProgressIndicator), findsOneWidget);
    },
  );

  testWidgets(
    'when isLoadingMore is true, bottom sheet renders restaurant list with shimmer',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: AddressCoveragePreviewBottomSheet(
              preview: const AddressCoveragePreviewEntity(
                canSetAsDefault: true,
                isCurrentSubscriptionRestaurantCovered: true,
                hasActiveSubscription: true,
                servingRestaurants: [
                  ServingRestaurantEntity(
                    id: 'r1',
                    nameAr: 'مطعم',
                    nameEn: 'Restaurant 1',
                  ),
                ],
              ),
              isSubmitting: false,
              confirmButtonText: 'Confirm',
              isLoadingMore: true,
              hasMoreRestaurants: true,
              onConfirm: () {},
              onChooseAnother: () {},
            ),
          ),
        ),
      );

      // Bounded pump for shimmer loop
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('Restaurant 1'), findsOneWidget);
      expect(find.byType(ShimmerWidget), findsWidgets);
    },
  );
}
