import 'package:meal_meat_user/core/network/failures.dart';
import 'package:meal_meat_user/features/subscription_programs/domain/entities/subscription_type_entity.dart';

class SubscriptionTypesState {
  const SubscriptionTypesState({
    this.isLoading = false,
    this.isSuccess = false,
    this.types = const [],
    this.failure,
  });

  final bool isLoading;
  final bool isSuccess;
  final List<SubscriptionTypeEntity> types;
  final Failure? failure;

  SubscriptionTypesState copyWith({
    bool? isLoading,
    bool? isSuccess,
    List<SubscriptionTypeEntity>? types,
    Failure? failure,
    bool clearFailure = false,
  }) {
    return SubscriptionTypesState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      types: types ?? this.types,
      failure: clearFailure ? null : failure ?? this.failure,
    );
  }
}
