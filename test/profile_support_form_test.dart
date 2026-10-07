import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/profile/data/repo/profile_support_fake_repository.dart';
import 'package:meal_meat_user/features/profile/domain/entities/profile_support_message_entity.dart';
import 'package:meal_meat_user/features/profile/domain/usecase/submit_profile_support_message_usecase.dart';
import 'package:meal_meat_user/features/profile/presentation/support/manager/profile_support_form_view_model.dart';
import 'package:meal_meat_user/features/profile/presentation/support/screens/profile_complaints_screen.dart';
import 'package:meal_meat_user/features/profile/presentation/support/screens/profile_contact_us_screen.dart';

void main() {
  group('ProfileSupportFakeRepository and UseCase', () {
    test('rejects blank inputs without network transport', () async {
      const repo = ProfileSupportFakeRepository(delayDuration: Duration.zero);
      const usecase = SubmitProfileSupportMessageUseCase(repo);

      final result = await usecase(
        const ProfileSupportMessageEntity(
          kind: ProfileSupportMessageKind.contact,
          subject: '   ',
          message: '',
        ),
      );

      expect(result, isA<ApiErrorResult<dynamic>>());
    });

    test(
      'accepts valid input and returns demo result with preserved kind',
      () async {
        const repo = ProfileSupportFakeRepository(delayDuration: Duration.zero);
        const usecase = SubmitProfileSupportMessageUseCase(repo);

        final result = await usecase(
          const ProfileSupportMessageEntity(
            kind: ProfileSupportMessageKind.complaint,
            subject: 'Late delivery',
            message: 'My food was delayed by 30 mins',
            category: 'delivery',
          ),
        );

        expect(result, isA<ApiSuccessResult<dynamic>>());
        final success = result as ApiSuccessResult;
        expect(success.data.isDemoOnly, isTrue);
        expect(success.data.messageKind, ProfileSupportMessageKind.complaint);
      },
    );
  });

  group('ProfileSupportFormViewModel', () {
    test('guards duplicate submission while busy', () async {
      final repo = ProfileSupportFakeRepository(
        delayDuration: const Duration(milliseconds: 100),
      );
      final usecase = SubmitProfileSupportMessageUseCase(repo);
      final viewModel = ProfileSupportFormViewModel(usecase);

      const request = ProfileSupportMessageEntity(
        kind: ProfileSupportMessageKind.contact,
        subject: 'Inquiry',
        message: 'Hello support',
      );

      final future1 = viewModel.submit(request);
      expect(viewModel.state.isSubmitting, isTrue);

      // Second submit while busy
      final future2 = viewModel.submit(request);
      expect(viewModel.state.isSubmitting, isTrue);

      await Future.wait([future1, future2]);
      expect(viewModel.state.isSubmitting, isFalse);
      expect(viewModel.state.result?.isDemoOnly, isTrue);
    });

    test('closing view model during operation does not throw', () async {
      final repo = ProfileSupportFakeRepository(
        delayDuration: const Duration(milliseconds: 100),
      );
      final usecase = SubmitProfileSupportMessageUseCase(repo);
      final viewModel = ProfileSupportFormViewModel(usecase);

      const request = ProfileSupportMessageEntity(
        kind: ProfileSupportMessageKind.contact,
        subject: 'Inquiry',
        message: 'Hello support',
      );

      final future = viewModel.submit(request);
      await viewModel.close();
      await future;
    });
  });

  group('ProfileContactUsScreen and ProfileComplaintsScreen widgets', () {
    Widget buildContactWidget() {
      return const MaterialApp(
        locale: Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: ProfileContactUsScreen(),
      );
    }

    Widget buildComplaintsWidget() {
      return const MaterialApp(
        locale: Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: ProfileComplaintsScreen(),
      );
    }

    testWidgets('shows validation errors when fields are empty', (
      tester,
    ) async {
      await tester.pumpWidget(buildContactWidget());
      await tester.pumpAndSettle();

      final submitButton = find.text('Submit');
      await tester.tap(submitButton);
      await tester.pumpAndSettle();

      expect(find.text('Please enter a subject'), findsOneWidget);
      expect(find.text('Please enter your message'), findsOneWidget);
    });

    testWidgets('shows invalid email error when email is malformed', (
      tester,
    ) async {
      await tester.pumpWidget(buildContactWidget());
      await tester.pumpAndSettle();

      final textFields = find.byType(TextField);
      // subject
      await tester.enterText(textFields.at(0), 'Valid Subject');
      // message
      await tester.enterText(textFields.at(1), 'Valid Message');
      // email
      await tester.enterText(textFields.at(2), 'not-an-email');

      await tester.tap(find.text('Submit'));
      await tester.pumpAndSettle();

      expect(find.text('Please enter a valid email address'), findsOneWidget);
    });

    testWidgets('complaints screen displays category chips', (tester) async {
      await tester.pumpWidget(buildComplaintsWidget());
      await tester.pumpAndSettle();

      expect(find.text('Complaint category'), findsOneWidget);
      expect(find.text('Delivery'), findsOneWidget);
      expect(find.text('Meals quality'), findsOneWidget);
      expect(find.text('Payment & Invoices'), findsOneWidget);
      expect(find.text('Other'), findsOneWidget);
    });
  });
}
