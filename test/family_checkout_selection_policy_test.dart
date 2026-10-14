import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/family_checkout/domain/entities/family_summary_entity.dart';
import 'package:meal_meat_user/features/family_checkout/domain/entities/family_checkout_selection_entity.dart';
import 'package:meal_meat_user/features/family_checkout/domain/repo/family_checkout_repository.dart';
import 'package:meal_meat_user/features/family_checkout/domain/usecase/checkout_family_subscription_usecase.dart';
import 'package:meal_meat_user/features/family_checkout/domain/usecase/get_family_payment_methods_usecase.dart';
import 'package:meal_meat_user/features/family_checkout/domain/usecase/get_family_summary_usecase.dart';
import 'package:meal_meat_user/features/family_checkout/domain/usecase/save_family_member_start_date_usecase.dart';
import 'package:meal_meat_user/features/family_checkout/domain/usecase/select_family_member_checkout_usecase.dart';
import 'package:meal_meat_user/features/family_checkout/presentation/manager/family_checkout_event.dart';
import 'package:meal_meat_user/features/family_checkout/presentation/manager/family_checkout_view_model.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/entities/family_flow_current_entity.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/repo/family_subscription_setup_repository.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/usecase/get_family_flow_current_usecase.dart';

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
}

class _CheckoutRepository implements FamilyCheckoutRepository {
  final List<String> selectionCalls = [];

  @override
  Future<ApiResult<FamilySummaryEntity>> getFamilySummary({
    String? memberId,
  }) async => const ApiSuccessResult(
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

  @override
  Future<ApiResult<FamilyCheckoutSelectionEntity>>
  selectFamilyMemberForCheckout({
    required String memberId,
    required bool subscribeNow,
  }) async {
    selectionCalls.add(memberId);
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
