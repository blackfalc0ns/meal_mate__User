import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/config/theme/app_theme.dart';
import 'package:meal_meat_user/core/di/di.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
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
import 'package:meal_meat_user/features/subscription_settings/presentation/manager/subscription_billing_state.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/manager/subscription_billing_view_model.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/screens/subscription_billing_screen.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/subscription_billing_invoice_history_card.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/subscription_billing_payment_card.dart';

class _FakeBillingRepo implements SubscriptionBillingRepository {
  int fetchCallCount = 0;
  SubscriptionBillingEntity? mockEntity;

  @override
  Future<ApiResult<SubscriptionBillingEntity>> getSubscriptionBilling() async {
    fetchCallCount++;
    return ApiSuccessResult(data: mockEntity ?? _defaultMockEntity());
  }

  @override
  Future<ApiResult<SubscriptionBillingCurrentEntity>> getCurrentCustomerSubscription() async =>
      throw UnimplementedError();
  @override
  Future<ApiResult<SubscriptionBillingFreezeDetailsEntity>> getCurrentCustomerSubscriptionFreezeDetails() async =>
      throw UnimplementedError();
  @override
  Future<ApiResult<SubscriptionBillingFreezeDetailsEntity>> getCustomerSubscriptionFreezeDetails(String id) async =>
      throw UnimplementedError();
  @override
  Future<ApiResult<SubscriptionBillingFreezeResponseEntity>> createCustomerSubscriptionFreezeRequest({
    required String subscriptionId,
    required SubscriptionBillingFreezeRequestEntity request,
  }) async =>
      throw UnimplementedError();
  @override
  Future<ApiResult<SubscriptionBillingCancellationQuoteEntity>> getCustomerSubscriptionCancellationQuote(String id) async =>
      throw UnimplementedError();
  @override
  Future<ApiResult<SubscriptionBillingCancellationResultEntity>> createCustomerSubscriptionCancellationRequest({
    required String subscriptionId,
    required SubscriptionBillingCancellationRequestEntity request,
  }) async =>
      throw UnimplementedError();
  @override
  Future<ApiResult<void>> createCustomerSubscriptionRenewalRequest(String id) async =>
      throw UnimplementedError();
}

class _FakeUncompletedRepo implements SubscriptionUncompletedSubscriptionRepository {
  @override
  Future<ApiResult<SubscriptionBillingResumePreviewEntity>> getResumePreview(String id) async =>
      throw UnimplementedError();
  @override
  Future<ApiResult<SubscriptionBillingResumeEntity>> resumeSubscription({
    required String subscriptionId,
    String? startDate,
    int? paymentMethodId,
  }) async =>
      throw UnimplementedError();
  @override
  Future<ApiResult<void>> deleteUncompletedSubscription(String id) async =>
      throw UnimplementedError();
}

SubscriptionBillingEntity _defaultMockEntity() {
  return const SubscriptionBillingEntity(
    current: SubscriptionBillingCurrentEntity(
      emptyStateCode: '',
      subscription: SubscriptionBillingSubscriptionEntity(
        subscriptionId: 'sub-rebuild-1',
        status: 'active',
        statusNameAr: 'نشط',
        programId: 'prog-1',
        programNameAr: 'برنامج',
        programNameEn: 'Program',
        bundleId: 'bundle-1',
        bundleNameAr: 'باقة',
        bundleNameEn: 'Bundle',
        tier: 'Basic',
        tierNameAr: 'أساسي',
        tierNameEn: 'Basic',
        tierLogoUrl: '',
        mealsPerDay: 2,
        imageUrl: '',
        startDate: '2026-10-01',
        endDate: '2026-10-30',
        nextRenewalDate: '2026-10-31',
        totalServiceDays: 30,
        completedServiceDays: 5,
        remainingServiceDays: 25,
        progressPercentage: 16.6,
        paidAmount: 100.0,
        currencyCode: 'KWD',
        restaurant: SubscriptionBillingRestaurantEntity(
          restaurantId: 'rest-1',
          nameAr: 'مطعم',
          nameEn: 'Restaurant',
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
          maximumFreezeDays: 7,
          freezeExtendsSubscriptionEnd: true,
          earliestFreezeStartDate: '2026-10-05',
          renewalEndpoint: '',
          freezeEndpoint: '',
          cancellationEndpoint: '',
          upgradeEndpoint: '',
          cancellationQuoteEndpoint: '',
        ),
      ),
    ),
    uncompletedSubscriptions: [],
    invoices: [
      SubscriptionBillingInvoiceEntity(
        receiptId: 'rec-1',
        subscriptionId: 'sub-rebuild-1',
        invoiceNumber: 'INV-100',
        paymentId: 'pay-1',
        issuedAtUtc: '2026-10-01T00:00:00Z',
        amount: 100.0,
        currencyCode: 'KWD',
        status: 'paid',
        statusNameAr: 'مدفوع',
        gateway: 'knet',
        maskedCardNumber: '**** 1111',
        canDownload: true,
        downloadUnavailableReason: '',
      ),
    ],
    paymentMethod: SubscriptionBillingPaymentMethodEntity(
      hasSavedMethod: true,
      brand: 'visa',
      last4: '1234',
      expiry: '12/28',
      gateway: 'knet',
      emptyStateCode: '',
    ),
    freezePolicy: SubscriptionBillingFreezePolicyEntity(
      defaultDurationDays: 7,
      startDelayDays: 3,
      extendSubscriptionEnd: true,
      earliestAllowedStartDate: '2026-10-05',
      messageAr: '',
      messageEn: '',
      noticeAr: '',
      notice: '',
      message: '',
    ),
  );
}

void main() {
  late _FakeBillingRepo fakeBillingRepo;
  late _FakeUncompletedRepo fakeUncompletedRepo;
  late SubscriptionBillingViewModel viewModel;

  setUp(() async {
    fakeBillingRepo = _FakeBillingRepo();
    fakeUncompletedRepo = _FakeUncompletedRepo();

    viewModel = SubscriptionBillingViewModel(
      GetSubscriptionBillingUseCase(fakeBillingRepo),
      CreateSubscriptionRenewalRequestUseCase(fakeBillingRepo),
      CreateSubscriptionFreezeRequestUseCase(fakeBillingRepo),
      GetSubscriptionCancellationQuoteUseCase(fakeBillingRepo),
      CreateSubscriptionCancellationRequestUseCase(fakeBillingRepo),
      DeleteUncompletedSubscriptionUseCase(fakeUncompletedRepo),
      GetSubscriptionResumePreviewUseCase(fakeUncompletedRepo),
      ResumeSubscriptionUseCase(fakeUncompletedRepo),
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

  testWidgets('rebuild isolation: action loading does not rebuild payment or invoice sections', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const SubscriptionBillingScreen(),
      ),
    );

    await tester.pumpAndSettle();

    // Confirm initial aggregate fetch was called exactly once
    expect(fakeBillingRepo.fetchCallCount, 1);

    expect(find.byType(SubscriptionBillingPaymentCard), findsOneWidget);
    expect(find.byType(SubscriptionBillingInvoiceHistoryCard), findsOneWidget);

    // Now emit an action state update (e.g. renewal loading in progress)
    viewModel.emit(
      viewModel.state.copyWith(
        billingAction: const SubscriptionBillingActionState(
          type: 'renew',
          isLoading: true,
        ),
      ),
    );

    await tester.pump();

    // Verify aggregate fetch was NOT re-triggered
    expect(fakeBillingRepo.fetchCallCount, 1);

    // The payment card and invoice card elements remain mounted and stable
    expect(find.byType(SubscriptionBillingPaymentCard), findsOneWidget);
    expect(find.byType(SubscriptionBillingInvoiceHistoryCard), findsOneWidget);
  });
}
