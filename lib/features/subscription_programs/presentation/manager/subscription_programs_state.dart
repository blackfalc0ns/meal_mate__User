import 'package:meal_meat_user/core/network/failures.dart';
import 'package:meal_meat_user/features/subscription_programs/domain/entities/subscription_bundle_entity.dart';
import 'package:meal_meat_user/features/subscription_programs/domain/entities/subscription_program_entity.dart';

class SubscriptionProgramsState {
  const SubscriptionProgramsState({
    this.isLoading = false,
    this.isSuccess = false,
    this.programs = const [],
    this.bundles = const [],
    this.failure,
    this.isPrerequisitesLoading = false,
    this.prerequisitesCompleted = false,
    this.prerequisitesFailure,
  });

  final bool isLoading;
  final bool isSuccess;
  final List<SubscriptionProgramEntity> programs;
  final List<SubscriptionBundleEntity> bundles;
  final Failure? failure;
  final bool isPrerequisitesLoading;
  final bool prerequisitesCompleted;
  final Failure? prerequisitesFailure;

  SubscriptionProgramsState copyWith({
    bool? isLoading,
    bool? isSuccess,
    List<SubscriptionProgramEntity>? programs,
    List<SubscriptionBundleEntity>? bundles,
    Failure? failure,
    bool? isPrerequisitesLoading,
    bool? prerequisitesCompleted,
    Failure? prerequisitesFailure,
    bool clearFailure = false,
    bool clearPrerequisitesFailure = false,
  }) {
    return SubscriptionProgramsState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      programs: programs ?? this.programs,
      bundles: bundles ?? this.bundles,
      failure: clearFailure ? null : failure ?? this.failure,
      isPrerequisitesLoading:
          isPrerequisitesLoading ?? this.isPrerequisitesLoading,
      prerequisitesCompleted:
          prerequisitesCompleted ?? this.prerequisitesCompleted,
      prerequisitesFailure: clearPrerequisitesFailure
          ? null
          : prerequisitesFailure ?? this.prerequisitesFailure,
    );
  }
}
