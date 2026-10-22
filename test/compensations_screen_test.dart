import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/config/theme/app_theme.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/features/compensations/domain/usecase/get_compensations_usecase.dart';
import 'package:meal_meat_user/features/compensations/domain/usecase/get_compensation_alternative_dates_usecase.dart';
import 'package:meal_meat_user/features/compensations/domain/usecase/choose_compensation_usecase.dart';
import 'package:meal_meat_user/features/compensations/presentation/manager/compensations_view_model.dart';
import 'package:meal_meat_user/features/compensations/presentation/screens/compensations_screen.dart';
import 'package:meal_meat_user/features/compensations/presentation/widgets/home_compensations_notice.dart';
import 'package:meal_meat_user/core/errors/error_widgets/empty_state_widget.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/features/profile/presentation/widgets/profile_settings_card.dart';
import 'compensations_view_model_test.dart' show FakeRepository, item;

void main() {
  testWidgets(
    'profile compensations entry navigates without overflowing the settings card',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          routes: {
            AppRoutes.compensations: (_) =>
                const Scaffold(body: Text('destination')),
          },
          home: const Scaffold(
            body: SingleChildScrollView(child: ProfileSettingsCard()),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Compensations'));
      await tester.pumpAndSettle();
      expect(find.text('destination'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
  for (final language in ['en', 'ar']) {
    testWidgets(
      'compensation actions and date selection fit narrow $language screen',
      (tester) async {
        tester.view.physicalSize = const Size(360, 900);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        final repo = FakeRepository();
        final vm = CompensationsViewModel(
          GetCompensationsUseCase(repo),
          GetCompensationAlternativeDatesUseCase(repo),
          ChooseCompensationUseCase(repo),
        );
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.lightTheme,
            locale: Locale(language),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: CompensationsScreen(viewModel: vm),
          ),
        );
        await tester.pumpAndSettle();
        final context = tester.element(find.byType(CompensationsScreen));
        final locale = AppLocalizations.of(context)!;
        expect(
          Directionality.of(
            tester.element(find.text(locale.compensations_title)),
          ),
          language == 'ar' ? TextDirection.rtl : TextDirection.ltr,
        );
        await tester.tap(find.text(locale.compensations_alternative));
        await tester.pumpAndSettle();
        expect(find.byType(ChoiceChip), findsOneWidget);
        await tester.tap(find.byType(ChoiceChip));
        await tester.pump();
        expect(vm.state.selectedDates['c1'], '2026-10-24');
        expect(tester.takeException(), isNull);
        await tester.pumpWidget(const SizedBox.shrink());
        await vm.close();
      },
    );
  }

  testWidgets('successful empty list uses existing empty state', (
    tester,
  ) async {
    final repo = FakeRepository()..items = [];
    final vm = CompensationsViewModel(
      GetCompensationsUseCase(repo),
      GetCompensationAlternativeDatesUseCase(repo),
      ChooseCompensationUseCase(repo),
    );
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: CompensationsScreen(viewModel: vm),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(EmptyStateWidget), findsOneWidget);
    await tester.pumpWidget(const SizedBox.shrink());
    await vm.close();
  });

  testWidgets('home notice appears only for pending choices', (tester) async {
    final repo = FakeRepository()
      ..items = [item().withChoice(status: 'Settled')];
    final vm = CompensationsViewModel(
      GetCompensationsUseCase(repo),
      GetCompensationAlternativeDatesUseCase(repo),
      ChooseCompensationUseCase(repo),
    );
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(body: HomeCompensationsNotice(viewModel: vm)),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.redeem_rounded), findsNothing);
    await tester.pumpWidget(const SizedBox.shrink());
    await vm.close();
  });
}
