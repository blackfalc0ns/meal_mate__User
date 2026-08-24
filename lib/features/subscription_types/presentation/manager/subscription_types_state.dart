import 'package:meal_meat_user/core/network/failures.dart';
import 'package:meal_meat_user/features/subscription_types/domain/entities/subscription_type_entity.dart';

class SubscriptionTypesState {
  const SubscriptionTypesState({
    this.isLoading = false,
    this.isConversionLoading = false,
    this.isConversionSuccess = false,
    this.isSuccess = false,
    this.types = const [],
    this.failure,
    this.conversionFailure,
  });

  final bool isLoading;
  final bool isConversionLoading;
  final bool isConversionSuccess;
  final bool isSuccess;
  final List<SubscriptionTypeEntity> types;
  final Failure? failure;
  final Failure? conversionFailure;

  SubscriptionTypesState copyWith({
    bool? isLoading,
    bool? isConversionLoading,
    bool? isConversionSuccess,
    bool? isSuccess,
    List<SubscriptionTypeEntity>? types,
    Failure? failure,
    Failure? conversionFailure,
    bool clearFailure = false,
    bool clearConversionFailure = false,
  }) {
    return SubscriptionTypesState(
      isLoading: isLoading ?? this.isLoading,
      isConversionLoading: isConversionLoading ?? this.isConversionLoading,
      isConversionSuccess: isConversionSuccess ?? this.isConversionSuccess,
      isSuccess: isSuccess ?? this.isSuccess,
      types: types ?? this.types,
      failure: clearFailure ? null : failure ?? this.failure,
      conversionFailure: clearConversionFailure
          ? null
          : conversionFailure ?? this.conversionFailure,
    );
  }
}
