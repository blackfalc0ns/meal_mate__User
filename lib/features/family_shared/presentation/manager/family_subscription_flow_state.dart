import 'package:meal_meat_user/core/errors/failures.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/entities/family_flow_current_entity.dart';

class FamilySubscriptionFlowState {
  final bool isLoading;
  final bool isAbandonDraftLoading;
  final bool isAbandonDraftSuccess;
  final FamilyFlowCurrentEntity? flow;
  final Failure? failure;
  final int currentStep;
  final String? targetMemberId;

  const FamilySubscriptionFlowState({
    this.isLoading = false,
    this.isAbandonDraftLoading = false,
    this.isAbandonDraftSuccess = false,
    this.flow,
    this.failure,
    this.currentStep = 0,
    this.targetMemberId,
  });

  FamilySubscriptionFlowState copyWith({
    bool? isLoading,
    bool? isAbandonDraftLoading,
    bool? isAbandonDraftSuccess,
    FamilyFlowCurrentEntity? flow,
    Failure? failure,
    int? currentStep,
    String? targetMemberId,
    bool clearFailure = false,
    bool clearTargetMemberId = false,
    bool clearFlow = false,
  }) {
    return FamilySubscriptionFlowState(
      isLoading: isLoading ?? this.isLoading,
      isAbandonDraftLoading:
          isAbandonDraftLoading ?? this.isAbandonDraftLoading,
      isAbandonDraftSuccess:
          isAbandonDraftSuccess ?? this.isAbandonDraftSuccess,
      flow: clearFlow ? null : (flow ?? this.flow),
      failure: clearFailure ? null : (failure ?? this.failure),
      currentStep: currentStep ?? this.currentStep,
      targetMemberId: clearTargetMemberId
          ? null
          : (targetMemberId ?? this.targetMemberId),
    );
  }
}
