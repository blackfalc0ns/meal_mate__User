import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/errors/failures.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/family_summary/domain/entities/family_summary_entity.dart';
import 'package:meal_meat_user/features/family_summary/domain/entities/family_summary_selection_entity.dart';
import 'package:meal_meat_user/features/family_summary/domain/repo/family_summary_repository.dart';
import 'package:meal_meat_user/features/family_summary/domain/usecase/checkout_family_subscription_usecase.dart';
import 'package:meal_meat_user/features/family_summary/domain/usecase/get_family_payment_methods_usecase.dart';
import 'package:meal_meat_user/features/family_summary/domain/usecase/get_family_summary_usecase.dart';
import 'package:meal_meat_user/features/family_summary/domain/usecase/retry_family_subscription_payment_usecase.dart';
import 'package:meal_meat_user/features/family_summary/domain/usecase/save_family_member_start_date_usecase.dart';
import 'package:meal_meat_user/features/family_summary/domain/usecase/select_family_member_summary_usecase.dart';
import 'package:meal_meat_user/features/family_summary/presentation/manager/family_summary_event.dart';
import 'package:meal_meat_user/features/family_summary/presentation/manager/family_summary_state.dart';
import 'package:meal_meat_user/features/family_summary/presentation/manager/family_summary_view_model.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/entities/family_flow_current_entity.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/entities/family_member_entity.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/repo/family_subscription_setup_repository.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/usecase/get_family_flow_current_usecase.dart';
import 'package:meal_meat_user/features/payment/domain/entities/payment_entity.dart';

void main() {
  test('loading summary never selects a deferred member for payment', () async {
    final repository = _CheckoutRepository();
    final viewModel = FamilyCheckoutViewModel(
      GetFamilyFlowCurrentUseCase(_FlowRepository()),
      GetFamilySummaryUseCase(repository),
      GetFamilyPaymentMethodsUseCase(repository),
      CheckoutFamilySubscriptionUseCase(repository),
      SelectFamilyMemberCheckoutUseCase(repository),
      SaveFamilyMemberStartDateUseCase(repository),
    );
    addTearDown(viewModel.close);

    viewModel.doIntent(const GetFamilySummaryEvent());
    await Future<void>.delayed(const Duration(milliseconds: 20));

    expect(repository.selectionCalls, isEmpty);
    expect(viewModel.state.summary?.selectedNewSubscriberCount, 0);
  });

  test(
    'failure in saveFamilyMemberStartDate reverts optimistic local startDate',
    () async {
      final repository = _CheckoutRepository();
      repository.saveStartDateResult = ApiErrorResult(
        failure: Failure(errorMessage: 'Network error saving date'),
      );

      final viewModel = FamilyCheckoutViewModel(
        GetFamilyFlowCurrentUseCase(_FlowRepository()),
        GetFamilySummaryUseCase(repository),
        GetFamilyPaymentMethodsUseCase(repository),
        CheckoutFamilySubscriptionUseCase(repository),
        SelectFamilyMemberCheckoutUseCase(repository),
        SaveFamilyMemberStartDateUseCase(repository),
      );
      addTearDown(viewModel.close);

      // Initial state with member-1 having startDate 2026-10-01
      viewModel.emit(
        const FamilyCheckoutState(
          currentFlow: FamilyFlowCurrentEntity(
            members: [
              FamilyMemberEntity(
                memberId: 'mem-1',
                displayName: 'Member One',
                startDate: '2026-10-01',
                role: 1,
                relationshipCode: 'SELF',
                gender: 1,
                ageYears: 30,
                setupStatus: 2,
                includeFriday: false,
                isCurrentUser: true,
              ),
            ],
          ),
        ),
      );

      viewModel.doIntent(
        const UpdateMemberStartDateEvent(
          memberId: 'mem-1',
          startDate: '2026-10-25',
        ),
      );
      await Future<void>.delayed(const Duration(milliseconds: 30));

      expect(
        viewModel.state.members.first.startDate,
        '2026-10-01',
        reason: 'Failed save must revert startDate back to previous snapshot',
      );
      expect(viewModel.state.failure, isNotNull);
    },
  );

  test(
    'coupon application failure does not retain appliedPromoCode as confirmed',
    () async {
      final repository = _CheckoutRepository();
      repository.summaryResultBuilder = (memberId, promoCode) {
        if (promoCode == 'INVALID_CODE') {
          return ApiErrorResult(
            failure: Failure(
              code: 'family.coupon_rejected',
              errorMessage: 'Invalid coupon',
            ),
          );
        }
        return const ApiSuccessResult(
          data: FamilySummaryEntity(
            subtotal: 100,
            familyDiscountPercent: 0,
            familyDiscountAmount: 0,
            finalPrice: 100,
            canCheckout: true,
            selectedNewSubscriberCount: 1,
          ),
        );
      };

      final viewModel = FamilyCheckoutViewModel(
        GetFamilyFlowCurrentUseCase(_FlowRepository()),
        GetFamilySummaryUseCase(repository),
        GetFamilyPaymentMethodsUseCase(repository),
        CheckoutFamilySubscriptionUseCase(repository),
        SelectFamilyMemberCheckoutUseCase(repository),
        SaveFamilyMemberStartDateUseCase(repository),
      );
      addTearDown(viewModel.close);

      viewModel.doIntent(const ApplyFamilyCouponEvent('INVALID_CODE'));
      await Future<void>.delayed(const Duration(milliseconds: 30));

      expect(
        viewModel.state.appliedPromoCode,
        isNull,
        reason:
            'Failed coupon application must not be confirmed in appliedPromoCode',
      );
    },
  );

  test(
    'older member selection response does not overwrite newer member selection',
    () async {
      final repository = _CheckoutRepository();
      final completerMem1 =
          Completer<ApiResult<FamilyCheckoutSelectionEntity>>();
      final completerMem2 =
          Completer<ApiResult<FamilyCheckoutSelectionEntity>>();

      repository.memberSelectionCompleters['mem-1'] = completerMem1;
      repository.memberSelectionCompleters['mem-2'] = completerMem2;

      final viewModel = FamilyCheckoutViewModel(
        GetFamilyFlowCurrentUseCase(_FlowRepository()),
        GetFamilySummaryUseCase(repository),
        GetFamilyPaymentMethodsUseCase(repository),
        CheckoutFamilySubscriptionUseCase(repository),
        SelectFamilyMemberCheckoutUseCase(repository),
        SaveFamilyMemberStartDateUseCase(repository),
      );
      addTearDown(viewModel.close);

      // Trigger selection for mem-1 (slow)
      viewModel.doIntent(
        const SelectFamilyMemberCheckoutEvent(
          memberId: 'mem-1',
          subscribeNow: true,
        ),
      );

      // Trigger selection for mem-2 (fast)
      viewModel.doIntent(
        const SelectFamilyMemberCheckoutEvent(
          memberId: 'mem-2',
          subscribeNow: true,
        ),
      );

      // Complete mem-2 first
      completerMem2.complete(
        const ApiSuccessResult(
          data: FamilyCheckoutSelectionEntity(
            batchId: 'batch',
            batchVersion: 1,
            memberId: 'mem-2',
            checkoutSelected: true,
            selectedNewSubscriberCount: 1,
          ),
        ),
      );
      await Future<void>.delayed(const Duration(milliseconds: 30));

      // Now complete mem-1 late
      completerMem1.complete(
        const ApiSuccessResult(
          data: FamilyCheckoutSelectionEntity(
            batchId: 'batch',
            batchVersion: 1,
            memberId: 'mem-1',
            checkoutSelected: true,
            selectedNewSubscriberCount: 1,
          ),
        ),
      );
      await Future<void>.delayed(const Duration(milliseconds: 30));

      // The active summary should be for mem-2, NOT mem-1!
      expect(repository.summaryCalls.last, 'mem-2');
    },
  );

  test(
    'retry is prevented when retry or checkout is already loading',
    () async {
      final repository = _CheckoutRepository();
      final viewModel = FamilyCheckoutViewModel(
        GetFamilyFlowCurrentUseCase(_FlowRepository()),
        GetFamilySummaryUseCase(repository),
        GetFamilyPaymentMethodsUseCase(repository),
        CheckoutFamilySubscriptionUseCase(repository),
        SelectFamilyMemberCheckoutUseCase(repository),
        SaveFamilyMemberStartDateUseCase(repository),
        RetryFamilySubscriptionPaymentUseCase(repository),
      );
      addTearDown(viewModel.close);

      viewModel.emit(
        const FamilyCheckoutState(
          isRetryLoading: true,
          summary: FamilySummaryEntity(
            subtotal: 100,
            familyDiscountPercent: 0,
            familyDiscountAmount: 0,
            finalPrice: 100,
            canCheckout: true,
            selectedNewSubscriberCount: 1,
            batchId: 'batch-1',
            batchVersion: 1,
          ),
        ),
      );

      viewModel.doIntent(
        const RetryFamilySubscriptionPaymentEvent(
          callbackUrl: 'url',
          errorUrl: 'err',
          correlationId: 'corr',
          paymentMethodId: 1,
        ),
      );
      await Future<void>.delayed(const Duration(milliseconds: 20));

      expect(
        repository.retryCallsCount,
        0,
        reason: 'Retry must be prevented if isRetryLoading is true',
      );
    },
  );
}

class _CheckoutRepository implements FamilyCheckoutRepository {
  final List<String> selectionCalls = [];
  final List<String?> summaryCalls = [];
  int retryCallsCount = 0;
  int checkoutCallsCount = 0;

  ApiResult<void>? saveStartDateResult;
  ApiResult<FamilySummaryEntity> Function(String? memberId, String? promoCode)?
  summaryResultBuilder;
  final Map<String, Completer<ApiResult<FamilyCheckoutSelectionEntity>>>
  memberSelectionCompleters = {};

  @override
  Future<ApiResult<FamilySummaryEntity>> getFamilySummary({
    String? memberId,
    String? promoCode,
  }) async {
    summaryCalls.add(memberId);
    if (summaryResultBuilder != null) {
      return summaryResultBuilder!(memberId, promoCode);
    }
    return const ApiSuccessResult(
      data: FamilySummaryEntity(
        subtotal: 0,
        familyDiscountPercent: 0,
        familyDiscountAmount: 0,
        finalPrice: 0,
        canCheckout: false,
        selectedNewSubscriberCount: 0,
        members: [
          FamilySummaryMemberEntity(
            memberId: 'deferred',
            displayName: 'Deferred',
            isReady: true,
          ),
        ],
      ),
    );
  }

  @override
  Future<ApiResult<void>> saveFamilyMemberStartDate({
    required String memberId,
    required String startDate,
  }) async {
    return saveStartDateResult ?? const ApiSuccessResult(data: null);
  }

  @override
  Future<ApiResult<FamilyCheckoutSelectionEntity>>
  selectFamilyMemberForCheckout({
    required String memberId,
    required bool subscribeNow,
  }) async {
    selectionCalls.add(memberId);
    if (memberSelectionCompleters.containsKey(memberId)) {
      return memberSelectionCompleters[memberId]!.future;
    }
    return ApiSuccessResult(
      data: FamilyCheckoutSelectionEntity(
        batchId: 'batch',
        batchVersion: 1,
        memberId: memberId,
        checkoutSelected: subscribeNow,
        selectedNewSubscriberCount: 1,
      ),
    );
  }

  @override
  Future<ApiResult<PaymentCheckoutEntity>> retryFamilySubscriptionPayment({
    required String callbackUrl,
    required String errorUrl,
    required String correlationId,
    int? paymentMethodId,
    required String batchId,
    required int batchVersion,
    required String idempotencyKey,
    int clientContractVersion = 1,
    String? promoCode,
  }) async {
    retryCallsCount++;
    return const ApiSuccessResult(
      data: PaymentCheckoutEntity(
        subscriptionId: 'sub-1',
        paymentUrl: 'url',
        holdExpiresAtUtc: '2026-10-20T00:00:00Z',
        chosenStartDate: '2026-10-20',
        startDate: '2026-10-20',
        finalPrice: 100,
        priceSnapshotId: 's1',
        restaurantPoolSnapshotId: 'p1',
        paymentStatus: '0',
      ),
    );
  }

  @override
  Future<ApiResult<PaymentCheckoutEntity>> checkoutFamilySubscription({
    required String callbackUrl,
    required String errorUrl,
    required String correlationId,
    int? paymentMethodId,
    String? batchId,
    int? batchVersion,
    String? idempotencyKey,
    int? clientContractVersion,
    String? promoCode,
  }) async {
    checkoutCallsCount++;
    return const ApiSuccessResult(
      data: PaymentCheckoutEntity(
        subscriptionId: 'sub-1',
        paymentUrl: 'url',
        holdExpiresAtUtc: '2026-10-20T00:00:00Z',
        chosenStartDate: '2026-10-20',
        startDate: '2026-10-20',
        finalPrice: 100,
        priceSnapshotId: 's1',
        restaurantPoolSnapshotId: 'p1',
        paymentStatus: '0',
      ),
    );
  }

  @override
  Future<ApiResult<List<PaymentMethodEntity>>> getFamilyPaymentMethods(
    double amount,
  ) async {
    return const ApiSuccessResult(data: []);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FlowRepository implements FamilySubscriptionSetupRepository {
  @override
  Future<ApiResult<FamilyFlowCurrentEntity>>
  getFamilySubscriptionCurrent() async =>
      const ApiSuccessResult(data: FamilyFlowCurrentEntity());

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
