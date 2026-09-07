import 'package:meal_meat_user/features/family_packages/domain/entities/family_size_package_entity.dart';

sealed class FamilyPlanEvent {
  const FamilyPlanEvent();
}

class GetFamilySubscriptionCurrentEvent extends FamilyPlanEvent {
  const GetFamilySubscriptionCurrentEvent();
}

class SelectFamilySizePackageEvent extends FamilyPlanEvent {
  const SelectFamilySizePackageEvent(this.package);

  final FamilySizePackageEntity package;
}

class UpdateFamilyGroupEvent extends FamilyPlanEvent {
  const UpdateFamilyGroupEvent({required this.name, this.familyPackageId});

  final String name;
  final String? familyPackageId;
}

class GetFamilyRelationshipsEvent extends FamilyPlanEvent {
  const GetFamilyRelationshipsEvent();
}

class GetFamilyAddressesEvent extends FamilyPlanEvent {
  const GetFamilyAddressesEvent();
}

class AddFamilyMemberEvent extends FamilyPlanEvent {
  const AddFamilyMemberEvent({
    required this.phone,
    required this.displayName,
    this.occupation,
    required this.relationshipCode,
    required this.gender,
    required this.ageYears,
    this.deliveryAddressId,
  });

  final String phone;
  final String displayName;
  final String? occupation;
  final String relationshipCode;
  final int gender;
  final int ageYears;
  final String? deliveryAddressId;
}

class UpdateFamilyMemberEvent extends FamilyPlanEvent {
  const UpdateFamilyMemberEvent({
    required this.memberId,
    required this.phone,
    required this.displayName,
    this.occupation,
    required this.relationshipCode,
    required this.gender,
    required this.ageYears,
    this.deliveryAddressId,
  });

  final String memberId;
  final String phone;
  final String displayName;
  final String? occupation;
  final String relationshipCode;
  final int gender;
  final int ageYears;
  final String? deliveryAddressId;
}

class LookupFamilyMemberEvent extends FamilyPlanEvent {
  const LookupFamilyMemberEvent(this.phone);

  final String phone;
}

class DeleteFamilyMemberEvent extends FamilyPlanEvent {
  const DeleteFamilyMemberEvent(this.memberId);

  final String memberId;
}

class AbandonFamilyDraftEvent extends FamilyPlanEvent {
  const AbandonFamilyDraftEvent();
}
