import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/config/theme/app_theme.dart';
import 'package:meal_meat_user/core/di/di.dart';
import 'package:meal_meat_user/core/errors/api_error_type.dart';
import 'package:meal_meat_user/core/errors/api_exception.dart';
import 'package:meal_meat_user/core/errors/error_widgets/api_error_widget.dart';
import 'package:meal_meat_user/core/errors/error_widgets/no_internet_error_widget.dart';
import 'package:meal_meat_user/core/errors/error_widgets/server_error_widget.dart';
import 'package:meal_meat_user/core/errors/error_widgets/timeout_error_widget.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/core/network/failures.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/entities/subscription_billing_entity.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/repo/subscription_billing_repository.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/repo/subscription_uncompleted_subscription_repository.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/usecase/create_subscription_cancellation_request_usecase.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/usecase/create_subscription_freeze_request_usecase.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/usecase/create_subscription_renewal_request_usecase.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/usecase/delete_uncompleted_subscription_usecase.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/usecase/get_subscription_billing_usecase.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/usecase/get_subscription_cancellation_quote_usecase.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/usecase/get_subscription_resume_preview_usecase.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/usecase/resume_subscription_usecase.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/manager/subscription_billing_action_type.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/manager/subscription_billing_state.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/manager/subscription_billing_view_model.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/screens/subscription_billing_screen.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/subscription_billing_empty_subscription_card.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/subscription_billing_invoices_section.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/subscription_billing_management_section.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/subscription_billing_payment_card.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/subscription_billing_payment_section.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/subscription_billing_plan_card.dart';

class _MockBillingRepo implements SubscriptionBillingRepository {
  int fetchCount = 0;
  ApiResult<SubscriptionBillingEntity>? resultToReturn;

  @override
  Future<ApiResult<SubscriptionBillingEntity>> getSubscriptionBilling() async {
    fetchCount++;
    return resultToReturn ?? ApiSuccessResult(data: _mockBillingData());
  }

  @override
  Future<ApiResult<SubscriptionBillingCurrentEntity>>
  getCurrentCustomerSubscription() async => throw UnimplementedError();
  @override
  Future<ApiResult<SubscriptionBillingFreezeDetailsEntity>>
  getCurrentCustomerSubscriptionFreezeDetails() async =>
      throw UnimplementedError();
  @override
  Future<ApiResult<SubscriptionBillingFreezeDetailsEntity>>
  getCustomerSubscriptionFreezeDetails(String id) async =>
      throw UnimplementedError();
  @override
  Future<ApiResult<SubscriptionBillingFreezeResponseEntity>>
  createCustomerSubscriptionFreezeRequest({
    required String subscriptionId,
    required SubscriptionBillingFreezeRequestEntity request,
  }) async => throw UnimplementedError();
  @override
  Future<ApiResult<SubscriptionBillingCancellationQuoteEntity>>
  getCustomerSubscriptionCancellationQuote(String id) async =>
      throw UnimplementedError();
  @override
  Future<ApiResult<SubscriptionBillingCancellationResultEntity>>
  createCustomerSubscriptionCancellationRequest({
    required String subscriptionId,
    required SubscriptionBillingCancellationRequestEntity request,
  }) async => throw UnimplementedError();
  @override
  Future<ApiResult<void>> createCustomerSubscriptionRenewalRequest(
    String id,
  ) async => throw UnimplementedError();
}

class _MockUncompletedRepo
    implements SubscriptionUncompletedSubscriptionRepository {
  @override
  Future<ApiResult<SubscriptionBillingResumePreviewEntity>> getResumePreview(
    String id,
  ) async => throw UnimplementedError();
  @override
  Future<ApiResult<SubscriptionBillingResumeEntity>> resumeSubscription({
    required String subscriptionId,
    String? startDate,
    int? paymentMethodId,
  }) async => throw UnimplementedError();
  @override
  Future<ApiResult<void>> deleteUncompletedSubscription(String id) async =>
      throw UnimplementedError();
}

SubscriptionBillingEntity _mockBillingData({
  bool hasSubscription = true,
  bool hasSavedPaymentMethod = true,
  List<SubscriptionBillingUncompletedSubscriptionEntity> uncompleted = const [],
}) {
  return SubscriptionBillingEntity(
    current: SubscriptionBillingCurrentEntity(
      emptyStateCode: '',
      subscription: hasSubscription
          ? const SubscriptionBillingSubscriptionEntity(
              subscriptionId: 'sub-test-101',
              status: 'active',
              statusNameAr: 'نشط',
              programId: 'prog-1',
              programNameAr: 'دايت',
              programNameEn: 'Diet',
              bundleId: 'bundle-1',
              bundleNameAr: 'باقة الغداء',
              bundleNameEn: 'Lunch Bundle',
              tier: 'Gold',
              tierNameAr: 'ذهبي',
              tierNameEn: 'Gold',
              tierLogoUrl: '',
              mealsPerDay: 2,
              imageUrl: '',
              startDate: '2026-10-01',
              endDate: '2026-10-31',
              nextRenewalDate: '2026-11-01',
              totalServiceDays: 30,
              completedServiceDays: 10,
              remainingServiceDays: 20,
              progressPercentage: 33.3,
              paidAmount: 120.0,
              currencyCode: 'KWD',
              restaurant: SubscriptionBillingRestaurantEntity(
                restaurantId: 'rest-1',
                nameAr: 'هيلثي كورنر',
                nameEn: 'Healthy Corner',
                logoUrl: '',
              ),
              actions: SubscriptionBillingActionsEntity(
                canRenew: true,
                canFreeze: true,
                canCancel: true,
                canUpgrade: false,
                renewUnavailableReason: '',
                freezeUnavailableReason: '',
                cancelUnavailableReason: '',
                upgradeUnavailableReason: '',
                freezeStartDelayDays: 3,
                maximumFreezeDays: 14,
                freezeExtendsSubscriptionEnd: true,
                earliestFreezeStartDate: '2026-10-05',
                renewalEndpoint: '',
                freezeEndpoint: '',
                cancellationEndpoint: '',
                upgradeEndpoint: '',
                cancellationQuoteEndpoint: '',
                freezeNoticeAr: 'تنبيه',
              ),
            )
          : null,
    ),
    uncompletedSubscriptions: uncompleted,
    invoices: const [],
    paymentMethod: SubscriptionBillingPaymentMethodEntity(
      hasSavedMethod: hasSavedPaymentMethod,
      brand: 'Visa',
      last4: '4242',
      expiry: '12/27',
      gateway: 'knet',
      emptyStateCode: '',
    ),
    freezePolicy: const SubscriptionBillingFreezePolicyEntity(
      defaultDurationDays: 7,
      startDelayDays: 3,
      extendSubscriptionEnd: true,
      earliestAllowedStartDate: '2026-10-05',
      notice: 'Policy notice',
      noticeAr: 'تنبيه السياسة',
      messageEn: 'Freeze message EN',
      messageAr: 'رسالة التجميد عربي',
    ),
  );
}

void main() {
  late _MockBillingRepo mockRepo;
  late _MockUncompletedRepo mockUncompletedRepo;
  late SubscriptionBillingViewModel viewModel;

  setUp(() async {
    mockRepo = _MockBillingRepo();
    mockUncompletedRepo = _MockUncompletedRepo();

    viewModel = SubscriptionBillingViewModel(
      GetSubscriptionBillingUseCase(mockRepo),
      CreateSubscriptionRenewalRequestUseCase(mockRepo),
      CreateSubscriptionFreezeRequestUseCase(mockRepo),
      GetSubscriptionCancellationQuoteUseCase(mockRepo),
      CreateSubscriptionCancellationRequestUseCase(mockRepo),
      DeleteUncompletedSubscriptionUseCase(mockUncompletedRepo),
      GetSubscriptionResumePreviewUseCase(mockUncompletedRepo),
      ResumeSubscriptionUseCase(mockUncompletedRepo),
    );

    if (getIt.isRegistered<SubscriptionBillingViewModel>()) {
      await getIt.unregister<SubscriptionBillingViewModel>();
    }
    getIt.registerFactory<SubscriptionBillingViewModel>(() => viewModel);
  });

  tearDown(() async {
    if (getIt.isRegistered<SubscriptionBillingViewModel>()) {
      await getIt.unregister<SubscriptionBillingViewModel>();
    }
  });

  Widget buildTestApp({Locale locale = const Locale('en')}) {
    return MaterialApp(
      theme: AppTheme.lightTheme,
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const SubscriptionBillingScreen(),
    );
  }

  testWidgets(
    'Initial error displays ApiErrorWidget with NoInternetErrorWidget on no connection',
    (tester) async {
      mockRepo.resultToReturn = ApiErrorResult(
        failure: Failure(
          errorMessage: 'no internet',
          code: 'no_internet',
          exception: const ApiException(
            errorType: ApiErrorType.noInternetConnection,
            message: 'No internet connection',
          ),
        ),
      );

      await tester.pumpWidget(buildTestApp());
      await tester.pumpAndSettle();

      expect(find.byType(ApiErrorWidget), findsOneWidget);
      expect(find.byType(NoInternetErrorWidget), findsOneWidget);

      // Verify retry re-triggers getSubscriptionBilling
      expect(mockRepo.fetchCount, 1);
      final retryFinder = find.text('Try Again');
      if (retryFinder.evaluate().isNotEmpty) {
        await tester.tap(retryFinder);
        await tester.pump();
        expect(mockRepo.fetchCount, 2);
      }
    },
  );

  testWidgets(
    'Initial error displays ApiErrorWidget with TimeoutErrorWidget on timeout',
    (tester) async {
      mockRepo.resultToReturn = ApiErrorResult(
        failure: Failure(
          errorMessage: 'connection timeout',
          code: 'timeout',
          exception: const ApiException(
            errorType: ApiErrorType.connectionTimeout,
            message: 'Connection timed out',
          ),
        ),
      );

      await tester.pumpWidget(buildTestApp());
      await tester.pumpAndSettle();

      expect(find.byType(ApiErrorWidget), findsOneWidget);
      expect(find.byType(TimeoutErrorWidget), findsOneWidget);
    },
  );

  testWidgets(
    'Initial error displays ApiErrorWidget with ServerErrorWidget on 500 error',
    (tester) async {
      mockRepo.resultToReturn = ApiErrorResult(
        failure: Failure(
          errorMessage: 'Internal Server Error',
          code: '500',
          exception: const ApiException(
            errorType: ApiErrorType.internalServerError,
            statusCode: 500,
            message: 'Internal server error occurred',
          ),
        ),
      );

      await tester.pumpWidget(buildTestApp());
      await tester.pumpAndSettle();

      expect(find.byType(ApiErrorWidget), findsOneWidget);
      expect(find.byType(ServerErrorWidget), findsOneWidget);
    },
  );

  testWidgets('Renders all sections when data is available', (tester) async {
    await tester.pumpWidget(buildTestApp());
    await tester.pumpAndSettle();

    expect(find.byType(SubscriptionBillingPlanCard), findsOneWidget);
    expect(find.byType(SubscriptionBillingPaymentSection), findsOneWidget);
    expect(find.byType(SubscriptionBillingPaymentCard), findsOneWidget);
    expect(find.byType(SubscriptionBillingInvoicesSection), findsOneWidget);
    expect(find.byType(SubscriptionBillingManagementSection), findsOneWidget);
  });

  testWidgets('Hides payment section when no saved method exists', (
    tester,
  ) async {
    mockRepo.resultToReturn = ApiSuccessResult(
      data: _mockBillingData(hasSavedPaymentMethod: false),
    );

    await tester.pumpWidget(buildTestApp());
    await tester.pumpAndSettle();

    expect(find.byType(SubscriptionBillingPlanCard), findsOneWidget);
    expect(find.byType(SubscriptionBillingPaymentCard), findsNothing);
  });

  testWidgets('Shows empty subscription card when subscription is null', (
    tester,
  ) async {
    mockRepo.resultToReturn = ApiSuccessResult(
      data: _mockBillingData(hasSubscription: false),
    );

    await tester.pumpWidget(buildTestApp());
    await tester.pumpAndSettle();

    expect(
      find.byType(SubscriptionBillingEmptySubscriptionCard),
      findsOneWidget,
    );
    expect(find.byType(SubscriptionBillingPlanCard), findsNothing);
  });

  testWidgets(
    'Action error triggers CustomSnackbar via ErrorMessagePresenter',
    (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pumpAndSettle();

      // Emit a failure action
      viewModel.emit(
        viewModel.state.copyWith(
          billingAction: SubscriptionBillingActionState(
            type: SubscriptionBillingActionType.renew,
            failure: Failure(
              errorMessage: 'Renewal payment failed',
              code: 'renewal.failed',
              exception: const ApiException(
                errorType: ApiErrorType.badRequest,
                message: 'Renewal payment failed',
              ),
            ),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));

      // Verify error text from ErrorMessagePresenter is displayed in UI
      expect(find.text('Renewal payment failed'), findsOneWidget);
      // After error snackbar, action is reset
      expect(viewModel.state.billingAction.type, isNull);
    },
  );

  testWidgets(
    'Freeze overwrite consent error triggers overwrite dialog instead of generic snackbar',
    (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pumpAndSettle();

      // Emit freeze overwrite consent required failure
      viewModel.emit(
        viewModel.state.copyWith(
          billingAction: SubscriptionBillingActionState(
            type: SubscriptionBillingActionType.freeze,
            failure: Failure(
              errorMessage: 'Please confirm overwrite of dates',
              code: 'freeze.confirm_overwrite_selections',
              exception: const ApiException(
                errorType: ApiErrorType.conflict,
                backendErrorCode: 'freeze.confirm_overwrite_selections',
                message: 'Please confirm overwrite of dates',
              ),
            ),
            pendingFreezeRequest: const SubscriptionBillingFreezeRequestEntity(
              startDate: '2026-10-10',
              endDate: '2026-10-15',
            ),
            pendingFreezeSubscriptionId: 'sub-test-101',
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Overwrite consent dialog should be presented (not generic snackbar)
      expect(find.text('Confirm Meal Selections Cancellation'), findsOneWidget);
    },
  );
}
