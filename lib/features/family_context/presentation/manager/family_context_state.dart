import 'package:meal_meat_user/core/errors/failures.dart';
import 'package:meal_meat_user/features/family_context/domain/entities/family_context_entity.dart';

enum FamilyNavigationDestination {
  customerHome,
  managerHome,
  memberHome,
  memberDetached,
  memberSetupPending,
}

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

  List<FamilyContextEntity> get activeContexts =>
      contexts.where((c) => !c.isPaused && !c.isDetachedFromFamilyManagement).toList();

  List<FamilyContextEntity> get pausedContexts =>
      contexts.where((c) => c.isPaused).toList();

  List<FamilyContextEntity> get detachedContexts =>
      contexts.where((c) => c.isDetachedFromFamilyManagement).toList();

  bool get hasPausedContext => contexts.any((c) => c.isPaused);
  bool get hasDetachedContext =>
      contexts.any((c) => c.isDetachedFromFamilyManagement);
  bool get hasDisabledContext =>
      contexts.any((c) => c.accessStatus?.toLowerCase() == 'disabled');

  FamilyContextEntity? contextForMember(String memberId) =>
      contexts.where((c) => c.memberId == memberId).firstOrNull;

  FamilyContextEntity? contextForGroup(String groupId) =>
      contexts.where((c) => c.groupId == groupId).firstOrNull;

  String? memberSubscriptionIdFor(String? memberId) {
    if (memberId == null) {
      return primaryContext?.memberSubscriptionId;
    }
    return contextForMember(memberId)?.memberSubscriptionId ??
        primaryContext?.memberSubscriptionId;
  }

  FamilyNavigationDestination get derivedNavigation {
    if (isEmpty) return FamilyNavigationDestination.customerHome;
    if (hasManagerContext) return FamilyNavigationDestination.managerHome;
    final memberCtx = contexts.firstWhere(
      (c) => !c.isManager,
      orElse: () => primaryContext!,
    );
    if (memberCtx.isDetachedFromFamilyManagement) {
      return FamilyNavigationDestination.memberDetached;
    }
    if (memberCtx.isPendingSetup) {
      return FamilyNavigationDestination.memberSetupPending;
    }
    return FamilyNavigationDestination.memberHome;
  }

  bool can(String action) {
    return contexts.any((c) => c.can(action));
  }

  bool canPerform(String action) => can(action);

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
