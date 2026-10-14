import 'package:meal_meat_user/core/network/failures.dart';
import 'package:meal_meat_user/features/family_context/domain/entities/family_context_entity.dart';

class FamilyContextState {
  const FamilyContextState({
    this.isLoading = false,
    this.contexts = const [],
    this.failure,
  });

  final bool isLoading;
  final List<FamilyContextEntity> contexts;
  final Failure? failure;

  bool get isEmpty => contexts.isEmpty;
  bool get hasContexts => contexts.isNotEmpty;
  bool get isManager => contexts.any((c) => c.isManager);
  bool get hasManagerContext => isManager;
  bool get isMember => contexts.any((c) => !c.isManager && c.memberId != null);
  FamilyContextEntity? get primaryContext => contexts.firstOrNull;

  bool can(String action) {
    return contexts.any((c) => c.can(action));
  }

  FamilyContextState copyWith({
    bool? isLoading,
    List<FamilyContextEntity>? contexts,
    Failure? Function()? failure,
  }) {
    return FamilyContextState(
      isLoading: isLoading ?? this.isLoading,
      contexts: contexts ?? this.contexts,
      failure: failure != null ? failure() : this.failure,
    );
  }
}
