import 'family_capability_entity.dart';

class FamilyContextEntity {
  const FamilyContextEntity({
    required this.groupId,
    required this.isManager,
    this.memberId,
    this.memberSubscriptionId,
    this.isDetachedFromFamilyManagement = false,
    this.setupStatus,
    this.hasSeparateAccount = false,
    this.isPaused = false,
    this.requiresPasswordSetup = false,
    this.accessStatus,
    this.capabilities = const [],
  });

  final String groupId;
  final bool isManager;
  final String? memberId;
  final String? memberSubscriptionId;
  final bool isDetachedFromFamilyManagement;
  final String? setupStatus;
  final bool hasSeparateAccount;
  final bool isPaused;
  final bool requiresPasswordSetup;
  final String? accessStatus;
  final List<FamilyCapabilityEntity> capabilities;

  bool get isPendingSetup {
    if (requiresPasswordSetup) return true;
    final status = setupStatus?.toLowerCase();
    return status == 'notstarted' ||
        status == 'inprogress' ||
        status == 'pending_first_login' ||
        status == 'pending' ||
        status == '0' ||
        status == '1';
  }

  bool can(String action) {
    final cap = capabilities
        .where((c) =>
            c.action.toLowerCase() == action.toLowerCase() ||
            (c.requiredPermission?.toLowerCase() == action.toLowerCase()))
        .firstOrNull;
    return cap?.allowed ?? false;
  }

  bool canPerform(String action) => can(action);
}
