import 'family_capability_entity.dart';

class FamilyContextEntity {
  const FamilyContextEntity({
    required this.groupId,
    required this.isManager,
    this.memberId,
    this.memberSubscriptionId,
    this.capabilities = const [],
  });

  final String groupId;
  final bool isManager;
  final String? memberId;
  final String? memberSubscriptionId;
  final List<FamilyCapabilityEntity> capabilities;

  bool can(String action) {
    final cap = capabilities
        .where((c) => c.action.toLowerCase() == action.toLowerCase())
        .firstOrNull;
    return cap?.allowed ?? false;
  }

  bool canPerform(String action) => can(action);
}
