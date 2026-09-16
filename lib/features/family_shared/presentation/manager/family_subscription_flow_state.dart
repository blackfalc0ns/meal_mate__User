import 'package:meal_meat_user/core/network/failures.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/entities/family_flow_current_entity.dart';

class FamilySubscriptionFlowState {
  final bool isLoading;
  final FamilyFlowCurrentEntity? flow;
  final Failure? failure;

  const FamilySubscriptionFlowState({
    this.isLoading = false,
    this.flow,
    this.failure,
  });

  FamilySubscriptionFlowState copyWith({
    bool? isLoading,
    FamilyFlowCurrentEntity? flow,
    Failure? failure,
    bool clearFailure = false,
  }) {
    return FamilySubscriptionFlowState(
      isLoading: isLoading ?? this.isLoading,
      flow: flow ?? this.flow,
      failure: clearFailure ? null : (failure ?? this.failure),
    );
  }
}
