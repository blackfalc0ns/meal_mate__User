import 'package:meal_meat_user/core/errors/failures.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/entities/family_flow_current_entity.dart';

class FamilySubscriptionFlowState {
  final bool isLoading;
  final FamilyFlowCurrentEntity? flow;
  final Failure? failure;
  final int currentStep;
  final String? targetMemberId;

  const FamilySubscriptionFlowState({
    this.isLoading = false,
    this.flow,
    this.failure,
    this.currentStep = 0,
    this.targetMemberId,
  });

  FamilySubscriptionFlowState copyWith({
    bool? isLoading,
    FamilyFlowCurrentEntity? flow,
    Failure? failure,
    int? currentStep,
    String? targetMemberId,
    bool clearFailure = false,
    bool clearTargetMemberId = false,
  }) {
    return FamilySubscriptionFlowState(
      isLoading: isLoading ?? this.isLoading,
      flow: flow ?? this.flow,
      failure: clearFailure ? null : (failure ?? this.failure),
      currentStep: currentStep ?? this.currentStep,
      targetMemberId: clearTargetMemberId
          ? null
          : (targetMemberId ?? this.targetMemberId),
    );
  }
}
