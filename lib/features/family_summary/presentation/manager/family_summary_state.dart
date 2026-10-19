import 'package:meal_meat_user/core/errors/failures.dart';
import 'package:meal_meat_user/features/family_summary/domain/entities/family_summary_entity.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/entities/family_conversion_draft_session.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/entities/family_flow_current_entity.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/entities/family_member_entity.dart';
import 'package:meal_meat_user/features/payment/domain/entities/payment_entity.dart';

class FamilySummaryState {
  const FamilySummaryState({
    this.isCurrentFlowLoading = false,
    this.currentFlow,
    this.isSummaryLoading = false,
    this.summary,
    this.selectedSummaryMemberId,
    this.selectedMemberIndex = 0,
    this.isPaymentMethodsLoading = false,
    this.paymentMethods = const [],
    this.selectedPaymentMethod,
    this.isCheckoutLoading = false,
    this.isRetryLoading = false,
    this.checkoutResult,
    this.failure,
    this.appliedPromoCode,
    this.isCouponLoading = false,
  });

  final bool isCurrentFlowLoading;
  final FamilyFlowCurrentEntity? currentFlow;

  final bool isSummaryLoading;
  final FamilySummaryEntity? summary;
  final String? selectedSummaryMemberId;
  final int selectedMemberIndex;

  final bool isPaymentMethodsLoading;
  final List<PaymentMethodEntity> paymentMethods;
  final PaymentMethodEntity? selectedPaymentMethod;

  final bool isCheckoutLoading;
  final bool isRetryLoading;
  final PaymentCheckoutEntity? checkoutResult;

  final Failure? failure;
  final String? appliedPromoCode;
  final bool isCouponLoading;

  bool get isLoading =>
      isCurrentFlowLoading ||
      isSummaryLoading ||
      isPaymentMethodsLoading ||
      isCheckoutLoading ||
      isRetryLoading;

  List<FamilyMemberEntity> get members => currentFlow?.members ?? const [];

  List<FamilyMemberEntity> get plannedMembers =>
      members.where((member) => member.hasProgram).toList();

  FamilyMemberEntity? get selectedMember {
    final list = members;
    if (list.isEmpty ||
        selectedMemberIndex < 0 ||
        selectedMemberIndex >= list.length) {
      return null;
    }
    return list[selectedMemberIndex];
  }

  bool get isConvertedFamilyDraft =>
      currentFlow?.managerPrepaid ??
      FamilyConversionDraftSession.isConvertedFamilyDraft;

  String? get activeMemberId =>
      selectedSummaryMemberId ??
      summary?.selectedMemberId ??
      summary?.selectedMember?.memberId ??
      members.firstOrNull?.memberId;

  FamilyMemberScheduleEntity? scheduleForMember(String? memberId) {
    if (memberId == null || summary == null) return null;
    return summary!.memberSchedules
        .where((s) => s.memberId == memberId)
        .firstOrNull;
  }

  FamilySummaryMemberEntity? summaryMember(String? memberId) {
    if (memberId == null || summary == null) return null;
    return summary!.members.where((m) => m.memberId == memberId).firstOrNull;
  }

  FamilyMemberEntity? flowMember(String? memberId) {
    if (memberId == null) return null;
    return members.where((m) => m.memberId == memberId).firstOrNull;
  }

  FamilyMemberScheduleEntity? get activeMemberSchedule =>
      scheduleForMember(activeMemberId);

  FamilySummaryState copyWith({
    bool? isCurrentFlowLoading,
    FamilyFlowCurrentEntity? currentFlow,
    bool? isSummaryLoading,
    FamilySummaryEntity? summary,
    bool clearSummary = false,
    String? selectedSummaryMemberId,
    int? selectedMemberIndex,
    bool? isPaymentMethodsLoading,
    List<PaymentMethodEntity>? paymentMethods,
    PaymentMethodEntity? selectedPaymentMethod,
    bool clearSelectedPaymentMethod = false,
    bool? isCheckoutLoading,
    bool? isRetryLoading,
    PaymentCheckoutEntity? checkoutResult,
    bool clearCheckoutResult = false,
    Failure? failure,
    bool clearFailure = false,
    String? appliedPromoCode,
    bool clearAppliedPromoCode = false,
    bool? isCouponLoading,
  }) {
    return FamilySummaryState(
      isCurrentFlowLoading: isCurrentFlowLoading ?? this.isCurrentFlowLoading,
      currentFlow: currentFlow ?? this.currentFlow,
      isSummaryLoading: isSummaryLoading ?? this.isSummaryLoading,
      summary: clearSummary ? null : (summary ?? this.summary),
      selectedSummaryMemberId:
          selectedSummaryMemberId ?? this.selectedSummaryMemberId,
      selectedMemberIndex: selectedMemberIndex ?? this.selectedMemberIndex,
      isPaymentMethodsLoading:
          isPaymentMethodsLoading ?? this.isPaymentMethodsLoading,
      paymentMethods: paymentMethods ?? this.paymentMethods,
      selectedPaymentMethod: clearSelectedPaymentMethod
          ? null
          : (selectedPaymentMethod ?? this.selectedPaymentMethod),
      isCheckoutLoading: isCheckoutLoading ?? this.isCheckoutLoading,
      isRetryLoading: isRetryLoading ?? this.isRetryLoading,
      checkoutResult: clearCheckoutResult
          ? null
          : (checkoutResult ?? this.checkoutResult),
      failure: clearFailure ? null : (failure ?? this.failure),
      appliedPromoCode: clearAppliedPromoCode
          ? null
          : (appliedPromoCode ?? this.appliedPromoCode),
      isCouponLoading: isCouponLoading ?? this.isCouponLoading,
    );
  }
}

typedef FamilyCheckoutState = FamilySummaryState;
