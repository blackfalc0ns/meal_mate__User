import 'package:meal_meat_user/features/subscription_settings/domain/entities/family_management_entity.dart';

sealed class FamilyManagementEvent {
  const FamilyManagementEvent();
}

class LoadFamilyHomeEvent extends FamilyManagementEvent {
  const LoadFamilyHomeEvent(this.localeName);
  final String localeName;
}

class LoadFamilyMembersEvent extends FamilyManagementEvent {
  const LoadFamilyMembersEvent(this.localeName);
  final String localeName;
}

class SearchFamilyMembersEvent extends FamilyManagementEvent {
  const SearchFamilyMembersEvent(this.query);
  final String query;
}

class LoadFamilyMemberEvent extends FamilyManagementEvent {
  const LoadFamilyMemberEvent(this.memberId, this.localeName);
  final String memberId;
  final String localeName;
}

class LoadFamilyMemberAccessEvent extends FamilyManagementEvent {
  const LoadFamilyMemberAccessEvent(this.memberId);
  final String memberId;
}

class UpdateFamilyMemberAccessEvent extends FamilyManagementEvent {
  const UpdateFamilyMemberAccessEvent({
    required this.memberId,
    this.hasSeparateAccount,
    this.isPaused,
    this.remove,
  });
  final String memberId;
  final bool? hasSeparateAccount;
  final bool? isPaused;
  final bool? remove;
}

class ClearGeneratedPasswordEvent extends FamilyManagementEvent {
  const ClearGeneratedPasswordEvent();
}

class LoadFamilyMemberPermissionsEvent extends FamilyManagementEvent {
  const LoadFamilyMemberPermissionsEvent(this.memberId, this.localeName);
  final String memberId;
  final String localeName;
}

class UpdateFamilyMemberPermissionsEvent extends FamilyManagementEvent {
  const UpdateFamilyMemberPermissionsEvent(
    this.memberId,
    this.values,
    this.localeName,
  );
  final String memberId;
  final Map<String, bool> values;
  final String localeName;
}

class ToggleFamilyPermissionEvent extends FamilyManagementEvent {
  const ToggleFamilyPermissionEvent(this.key, this.value);
  final String key;
  final bool value;
}

class SelectFamilyMemberEvent extends FamilyManagementEvent {
  const SelectFamilyMemberEvent(this.member);
  final FamilyMemberSummaryEntity member;
}

class RenewFamilyMemberSubscriptionEvent extends FamilyManagementEvent {
  const RenewFamilyMemberSubscriptionEvent(this.renewalPath);
  final String renewalPath;
}
