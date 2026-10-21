import '../../support/family_member_view_model_factory.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/family_management/member/domain/entities/family_member_detail_entity.dart';
import 'package:meal_meat_user/features/family_management/member/domain/repo/family_member_repository.dart';
import 'package:meal_meat_user/features/family_management/member/domain/usecase/detach_family_member_usecase.dart';
import 'package:meal_meat_user/features/family_management/member/domain/usecase/get_family_member_access_usecase.dart';
import 'package:meal_meat_user/features/family_management/member/domain/usecase/get_family_member_detail_usecase.dart';
import 'package:meal_meat_user/features/family_management/member/domain/usecase/get_family_member_permissions_usecase.dart';
import 'package:meal_meat_user/features/family_management/member/domain/usecase/renew_family_member_subscription_usecase.dart';
import 'package:meal_meat_user/features/family_management/member/domain/usecase/update_family_member_access_usecase.dart';
import 'package:meal_meat_user/features/family_management/member/domain/usecase/update_family_member_basic_info_usecase.dart';
import 'package:meal_meat_user/features/family_management/member/domain/usecase/update_family_member_permissions_usecase.dart';
import 'package:meal_meat_user/features/family_management/member/presentation/manager/family_member_event.dart';
import 'package:meal_meat_user/features/family_management/member/presentation/manager/family_member_view_model.dart';

class FakeDetachFamilyMemberRepository implements FamilyMemberRepository {
  int detachCallCount = 0;
  String? lastDetachedMemberId;
  ApiResult<void>? detachResult;

  @override
  Future<ApiResult<void>> detachMember(String memberId) async {
    detachCallCount++;
    lastDetachedMemberId = memberId;
    return detachResult ?? const ApiSuccessResult(data: null);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

FamilyMemberViewModel _createViewModel(
  FakeDetachFamilyMemberRepository fakeRepo,
) {
  return createFamilyMemberViewModel(
    GetFamilyMemberDetailUseCase(fakeRepo),
    GetFamilyMemberAccessUseCase(fakeRepo),
    UpdateFamilyMemberAccessUseCase(fakeRepo),
    GetFamilyMemberPermissionsUseCase(fakeRepo),
    UpdateFamilyMemberPermissionsUseCase(fakeRepo),
    UpdateFamilyMemberBasicInfoUseCase(fakeRepo),
    RenewFamilyMemberSubscriptionUseCase(fakeRepo),
    DetachFamilyMemberUseCase(fakeRepo),
  );
}

void main() {
  group('Task 8: Family member detachment and post-detachment authorization', () {
    test('1. Idempotent detach calls DetachFamilyMemberUseCase and marks isDetached in state', () async {
      final fakeRepo = FakeDetachFamilyMemberRepository();
      final viewModel = _createViewModel(fakeRepo);

      viewModel.doIntent(const DetachFamilyMemberEvent('member-detach-1'));
      await Future<void>.delayed(const Duration(milliseconds: 20));

      expect(fakeRepo.detachCallCount, equals(1));
      expect(fakeRepo.lastDetachedMemberId, equals('member-detach-1'));
      expect(viewModel.state.isDetached, isTrue);
      expect(viewModel.state.saveSuccessCount, equals(1));

      // Idempotent retry succeeds
      viewModel.doIntent(const DetachFamilyMemberEvent('member-detach-1'));
      await Future<void>.delayed(const Duration(milliseconds: 20));

      expect(fakeRepo.detachCallCount, equals(2));
      expect(viewModel.state.isDetached, isTrue);

      viewModel.close();
    });

    test('2. Detachment is blocked locally when member has pending checkout or payment', () async {
      final fakeRepo = FakeDetachFamilyMemberRepository();
      final viewModel = _createViewModel(fakeRepo);

      // Detail with checkoutSelected = true
      const blockedDetail = FamilyMemberDetailEntity(
        memberId: 'member-checkout-pending',
        displayName: 'Pending Member',
        role: 2,
        ageYears: 25,
        isPaused: false,
        subscriptionId: 'sub-pending',
        programName: 'Fit',
        remainingDays: 10,
        setupStatus: 2,
        canRenew: false,
        checkoutSelected: true,
      );

      viewModel.emit(viewModel.state.copyWith(detail: blockedDetail));

      viewModel.doIntent(const DetachFamilyMemberEvent('member-checkout-pending'));
      await Future<void>.delayed(const Duration(milliseconds: 10));

      // No network call should be made!
      expect(fakeRepo.detachCallCount, equals(0));
      expect(viewModel.state.isDetached, isFalse);
      expect(viewModel.state.saveFailure, isNotNull);
      expect(
        viewModel.state.saveFailure?.code,
        equals('family.detach_blocked_financial_intent'),
      );

      viewModel.close();
    });

    test('3. Detachment is blocked locally when paymentStatus is pending', () async {
      final fakeRepo = FakeDetachFamilyMemberRepository();
      final viewModel = _createViewModel(fakeRepo);

      const pendingPaymentDetail = FamilyMemberDetailEntity(
        memberId: 'member-payment-pending',
        displayName: 'Payment Pending',
        role: 2,
        ageYears: 28,
        isPaused: false,
        subscriptionId: 'sub-pay-pending',
        programName: 'Keto',
        remainingDays: 14,
        setupStatus: 2,
        canRenew: false,
        paymentStatus: 'pending',
      );

      viewModel.emit(viewModel.state.copyWith(detail: pendingPaymentDetail));

      viewModel.doIntent(const DetachFamilyMemberEvent('member-payment-pending'));
      await Future<void>.delayed(const Duration(milliseconds: 10));

      expect(fakeRepo.detachCallCount, equals(0));
      expect(viewModel.state.isDetached, isFalse);
      expect(
        viewModel.state.saveFailure?.code,
        equals('family.detach_blocked_financial_intent'),
      );

      viewModel.close();
    });

    test('4. Detached member entity properties preserve subscription and mark isDetached accurately', () {
      const detachedDetail = FamilyMemberDetailEntity(
        memberId: 'm-detached',
        displayName: 'Detached Member',
        role: 2,
        ageYears: 30,
        isPaused: false,
        subscriptionId: 'sub-funded-entitlement',
        programName: 'Active Life',
        remainingDays: 20,
        setupStatus: 2,
        canRenew: true,
        accessStatus: 'detached',
      );

      expect(detachedDetail.isDetached, isTrue);
      // Subscription entitlement and days remain preserved!
      expect(detachedDetail.hasPlan, isTrue);
      expect(detachedDetail.subscriptionId, equals('sub-funded-entitlement'));
      expect(detachedDetail.remainingDays, equals(20));
      expect(detachedDetail.effectiveSubscriptionId, equals('sub-funded-entitlement'));

      const pendingDetachDetail = FamilyMemberDetailEntity(
        memberId: 'm-pending-detach',
        displayName: 'Pending Detach',
        role: 2,
        ageYears: 30,
        isPaused: false,
        subscriptionId: 'sub-pending-detach',
        programName: 'Active',
        remainingDays: 15,
        setupStatus: 2,
        canRenew: false,
        lifecycleStatus: 'pendingdetach',
      );

      expect(pendingDetachDetail.isDetached, isTrue);
    });
  });
}
