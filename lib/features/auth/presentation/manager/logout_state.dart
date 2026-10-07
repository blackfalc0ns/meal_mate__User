import 'package:meal_meat_user/core/network/failures.dart';

enum LogoutOutcome { idle, success, failure }

class LogoutState {
  const LogoutState({
    this.isLoading = false,
    this.outcome = LogoutOutcome.idle,
    this.isServerRevoked = true,
    this.failure,
  });

  final bool isLoading;
  final LogoutOutcome outcome;
  final bool isServerRevoked;
  final Failure? failure;

  LogoutState copyWith({
    bool? isLoading,
    LogoutOutcome? outcome,
    bool? isServerRevoked,
    Failure? Function()? failure,
  }) {
    return LogoutState(
      isLoading: isLoading ?? this.isLoading,
      outcome: outcome ?? this.outcome,
      isServerRevoked: isServerRevoked ?? this.isServerRevoked,
      failure: failure != null ? failure() : this.failure,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LogoutState &&
          runtimeType == other.runtimeType &&
          isLoading == other.isLoading &&
          outcome == other.outcome &&
          isServerRevoked == other.isServerRevoked &&
          failure == other.failure;

  @override
  int get hashCode => Object.hash(isLoading, outcome, isServerRevoked, failure);
}
