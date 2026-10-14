import 'package:meal_meat_user/features/family_management/member/data/models/request/family_member_write_request_dto.dart';

sealed class FamilyMemberEvent {
  const FamilyMemberEvent();
}

class LoadFamilyMemberDetailEvent extends FamilyMemberEvent {
  const LoadFamilyMemberDetailEvent(this.memberId, {this.locale = 'ar'});
  final String memberId;
  final String locale;
}

class LoadFamilyMemberAccessEvent extends FamilyMemberEvent {
  const LoadFamilyMemberAccessEvent(this.memberId);
  final String memberId;
}

class UpdateFamilyMemberAccessEvent extends FamilyMemberEvent {
  const UpdateFamilyMemberAccessEvent({
    required this.memberId,
    this.hasSeparateAccount,
    this.isPaused,
    this.removeAccess = false,
  });

  final String memberId;
  final bool? hasSeparateAccount;
  final bool? isPaused;
  final bool removeAccess;
}

class ClearGeneratedPasswordEvent extends FamilyMemberEvent {
  const ClearGeneratedPasswordEvent();
}

class LoadFamilyMemberPermissionsEvent extends FamilyMemberEvent {
  const LoadFamilyMemberPermissionsEvent(this.memberId, {this.locale = 'ar'});
  final String memberId;
  final String locale;
}

class ToggleFamilyPermissionEvent extends FamilyMemberEvent {
  const ToggleFamilyPermissionEvent(this.key, this.value);
  final String key;
  final bool value;
}

class UpdateFamilyMemberPermissionsEvent extends FamilyMemberEvent {
  const UpdateFamilyMemberPermissionsEvent(this.memberId, {this.locale = 'ar'});
  final String memberId;
  final String locale;
}

class UpdateFamilyMemberBasicInfoEvent extends FamilyMemberEvent {
  const UpdateFamilyMemberBasicInfoEvent(this.memberId, this.request);
  final String memberId;
  final FamilyMemberWriteRequestDto request;
}

class RenewFamilyMemberSubscriptionEvent extends FamilyMemberEvent {
  const RenewFamilyMemberSubscriptionEvent(this.renewalPath);
  final String renewalPath;
}
