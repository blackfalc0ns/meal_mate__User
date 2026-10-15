import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/errors/api_error_type.dart';
import 'package:meal_meat_user/core/errors/api_exception.dart';
import 'package:meal_meat_user/core/errors/error_widgets/empty_state_widget.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/core/network/failures.dart';
import 'package:meal_meat_user/features/offers/domain/entities/campaign_payment_entity.dart';
import 'package:meal_meat_user/features/offers/domain/entities/campaign_payment_screen_args.dart';
import 'package:meal_meat_user/features/offers/domain/entities/start_campaign_payment_request_entity.dart';
import 'package:meal_meat_user/features/offers/domain/repo/offers_repository.dart';
import 'package:meal_meat_user/features/offers/domain/usecase/get_campaign_payment_status_usecase.dart';
import 'package:meal_meat_user/features/offers/domain/usecase/start_campaign_payment_usecase.dart';
import 'package:meal_meat_user/features/offers/presentation/manager/campaign_payment_view_model.dart';
import 'package:meal_meat_user/features/offers/presentation/screens/campaign_payment_screen.dart';
import 'package:meal_meat_user/features/offers/presentation/widgets/campaign_payment_header_card.dart';
import 'package:meal_meat_user/features/offers/presentation/widgets/campaign_pending_status_view.dart';

class MockOffersRepository implements OffersRepository {
  ApiResult<CampaignPaymentEntity>? startPaymentResult;
  ApiResult<CampaignPaymentEntity>? statusResult;

  @override
  Future<ApiResult<CampaignPaymentEntity>> startCampaignPayment(
    StartCampaignPaymentRequestEntity request,
  ) async {
    return startPaymentResult ??
        const ApiSuccessResult(
          data: CampaignPaymentEntity(
            sessionId: 'sess-123',
            amount: 12.500,
            currency: 'KWD',
            status: CampaignPaymentStatus.pending,
            rawStatus: 'Pending',
          ),
        );
  }

  @override
  Future<ApiResult<CampaignPaymentEntity>> getCampaignPaymentStatus(
    String sessionId,
  ) async {
    return statusResult ??
        const ApiSuccessResult(
          data: CampaignPaymentEntity(
            sessionId: 'sess-123',
            amount: 12.500,
            currency: 'KWD',
            status: CampaignPaymentStatus.pending,
            rawStatus: 'Pending',
          ),
        );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  late MockOffersRepository repository;
  late StartCampaignPaymentUseCase startUseCase;
  late GetCampaignPaymentStatusUseCase getStatusUseCase;
  late CampaignPaymentViewModel viewModel;

  setUp(() {
    repository = MockOffersRepository();
    startUseCase = StartCampaignPaymentUseCase(repository);
    getStatusUseCase = GetCampaignPaymentStatusUseCase(repository);
    viewModel = CampaignPaymentViewModel.withSchedule(
      startUseCase,
      getStatusUseCase,
      backoffScheduleOverride: () => [Duration.zero],
    );
  });

  tearDown(() async {
    await viewModel.close();
  });

  Widget buildTestWidget({Widget? child, Locale locale = const Locale('en')}) {
    return MaterialApp(
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: child,
    );
  }

  group('CampaignPaymentScreen Tests', () {
    testWidgets('renders empty state when no session id is provided', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestWidget(
          child: CampaignPaymentScreen(args: null, viewModel: viewModel),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(EmptyStateWidget), findsOneWidget);
      expect(
        find.text('Campaign checkout session was not found.'),
        findsOneWidget,
      );
    });

    testWidgets('renders header card when session is loaded', (tester) async {
      repository.startPaymentResult = const ApiSuccessResult(
        data: CampaignPaymentEntity(
          sessionId: 'sess-abc',
          amount: 25.500,
          currency: 'KWD',
          status: CampaignPaymentStatus.pending,
          rawStatus: 'Pending',
        ),
      );

      await tester.pumpWidget(
        buildTestWidget(
          child: CampaignPaymentScreen(
            args: const CampaignPaymentScreenArgs(
              sessionId: 'sess-abc',
              amount: 25.500,
            ),
            viewModel: viewModel,
          ),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byType(CampaignPaymentHeaderCard), findsOneWidget);
      expect(find.text('25.500 KWD'), findsOneWidget);
    });

    testWidgets(
      'renders CampaignPendingStatusView when returning from payment callback',
      (tester) async {
        repository.statusResult = const ApiSuccessResult(
          data: CampaignPaymentEntity(
            sessionId: 'sess-abc',
            status: CampaignPaymentStatus.pending,
            rawStatus: 'Pending',
            amount: 25.500,
            currency: 'KWD',
          ),
        );

        await tester.pumpWidget(
          buildTestWidget(
            child: CampaignPaymentScreen(
              args: const CampaignPaymentScreenArgs(
                sessionId: 'sess-abc',
                paymentId: 'pz-123',
                callbackStatus: 'success',
              ),
              viewModel: viewModel,
            ),
          ),
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));

        expect(find.byType(CampaignPendingStatusView), findsOneWidget);
        expect(find.text('Verifying payment status...'), findsOneWidget);
      },
    );

    testWidgets(
      'displays localized server error copy for SessionExpired in Arabic',
      (tester) async {
        repository.startPaymentResult = ApiErrorResult(
          failure: ServerFailure(
            errorMessage: 'Session expired',
            code: 'SessionExpired',
            exception: const ApiException(
              errorType: ApiErrorType.unknown,
              message: 'Session expired',
              backendErrorCode: 'SessionExpired',
              statusCode: 409,
            ),
          ),
        );

        await tester.pumpWidget(
          buildTestWidget(
            locale: const Locale('ar'),
            child: CampaignPaymentScreen(
              args: const CampaignPaymentScreenArgs(sessionId: 'sess-expired'),
              viewModel: viewModel,
            ),
          ),
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));

        // Should show the localized Arabic error snackbar
        expect(
          find.text(
            'انتهت صلاحية جلسة الدفع لهذه الحملة، يرجى إعادة بدء عملية الشراء.',
          ),
          findsOneWidget,
        );
      },
    );
  });
}
