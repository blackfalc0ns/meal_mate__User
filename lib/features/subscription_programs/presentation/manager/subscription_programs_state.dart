import 'package:meal_meat_user/core/network/failures.dart';
import 'package:meal_meat_user/features/subscription_programs/domain/entities/subscription_program_entity.dart';

class SubscriptionProgramsState {
  const SubscriptionProgramsState({
    this.isLoading = false,
    this.isSuccess = false,
    this.programs = const [],
    this.failure,
  });

  final bool isLoading;
  final bool isSuccess;
  final List<SubscriptionProgramEntity> programs;
  final Failure? failure;

  SubscriptionProgramsState copyWith({
    bool? isLoading,
    bool? isSuccess,
    List<SubscriptionProgramEntity>? programs,
    Failure? failure,
    bool clearFailure = false,
  }) {
    return SubscriptionProgramsState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      programs: programs ?? this.programs,
      failure: clearFailure ? null : failure ?? this.failure,
    );
  }
}
