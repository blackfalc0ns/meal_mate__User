import 'package:meal_meat_user/features/family_packages/domain/entities/family_size_package_entity.dart';

sealed class FamilySubscriptionSetupEvent {
  const FamilySubscriptionSetupEvent();
}

class GetFamilySubscriptionCurrentEvent extends FamilySubscriptionSetupEvent {
  const GetFamilySubscriptionCurrentEvent();
}

class SelectFamilySizePackageEvent extends FamilySubscriptionSetupEvent {
  const SelectFamilySizePackageEvent(this.package);

  final FamilySizePackageEntity package;
}

class UpdateFamilyGroupEvent extends FamilySubscriptionSetupEvent {
  const UpdateFamilyGroupEvent({required this.name, this.familyPackageId});

  final String name;
  final String? familyPackageId;
}

class GetFamilyRelationshipsEvent extends FamilySubscriptionSetupEvent {
  const GetFamilyRelationshipsEvent();
}

class AddFamilyMemberEvent extends FamilySubscriptionSetupEvent {
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

class UpdateFamilyMemberEvent extends FamilySubscriptionSetupEvent {
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

class LookupFamilyMemberEvent extends FamilySubscriptionSetupEvent {
  const LookupFamilyMemberEvent(this.phone);

  final String phone;
}

class DeleteFamilyMemberEvent extends FamilySubscriptionSetupEvent {
  const DeleteFamilyMemberEvent(this.memberId);

  final String memberId;
}
