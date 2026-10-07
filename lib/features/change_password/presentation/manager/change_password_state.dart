import 'package:meal_meat_user/core/network/failures.dart';

enum ChangePasswordOutcome { idle, success, failure }

class ChangePasswordState {
  const ChangePasswordState({
    this.isLoading = false,
    this.outcome = ChangePasswordOutcome.idle,
    this.failure,
  });

  final bool isLoading;
  final ChangePasswordOutcome outcome;
  final Failure? failure;

  ChangePasswordState copyWith({
    bool? isLoading,
    ChangePasswordOutcome? outcome,
    Failure? Function()? failure,
  }) {
    return ChangePasswordState(
      isLoading: isLoading ?? this.isLoading,
      outcome: outcome ?? this.outcome,
      failure: failure != null ? failure() : this.failure,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChangePasswordState &&
          runtimeType == other.runtimeType &&
          isLoading == other.isLoading &&
          outcome == other.outcome &&
          failure == other.failure;

  @override
  int get hashCode => Object.hash(isLoading, outcome, failure);
}
