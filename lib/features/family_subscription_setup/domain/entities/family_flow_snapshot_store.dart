import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/features/addresses/domain/entities/customer_address_entity.dart';
import 'package:meal_meat_user/features/family_allergies/domain/entities/family_member_allergy_selection.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/entities/family_flow_current_entity.dart';
import 'package:meal_meat_user/features/food_preferences/domain/entities/food_preferences_entity.dart';

@lazySingleton
class FamilyFlowSnapshotStore {
  FamilyFlowCurrentEntity? current;
  int _revision = 0;

  int get revision => _revision;

  void update(FamilyFlowCurrentEntity value) {
    current = value;
    _revision++;
  }

  bool updateIfUnchanged(int expectedRevision, FamilyFlowCurrentEntity value) {
    if (_revision != expectedRevision) return false;
    update(value);
    return true;
  }

  void updateMemberDeliveryAddress(
    String memberId,
    CustomerAddressEntity address,
  ) {
    final snapshot = current;
    if (snapshot == null) return;
    final updatedMembers = snapshot.members.map((member) {
      if (member.memberId != memberId) return member;
      return member.copyWith(
        deliveryAddressId: address.addressId,
        deliveryAddress: address,
      );
    }).toList();
    current = snapshot.copyWith(members: updatedMembers);
    _revision++;
  }

  void updateMemberAllergies(
    String memberId,
    List<FamilyMemberAllergySelection> allergies,
  ) {
    final snapshot = current;
    if (snapshot == null) return;
    final hasNoAllergies = allergies.any(
      (item) => item.code == FoodPreferenceItemEntity.noneCode,
    );
    final updatedMembers = snapshot.members.map((member) {
      if (member.memberId != memberId) return member;
      final allergyEntities = allergies
          .where((item) => item.code != FoodPreferenceItemEntity.noneCode)
          .map(
            (item) => FoodPreferenceItemEntity(
              code: item.code,
              nameAr: '',
              nameEn: '',
              severity: item.severity ?? 'High',
            ),
          )
          .toList();
      return member.copyWith(
        allergies: allergyEntities,
        allergiesCompleted: true,
        hasNoAllergies: hasNoAllergies,
      );
    }).toList();
    current = snapshot.copyWith(members: updatedMembers);
    _revision++;
  }

  void updateMemberProgram(
    String memberId,
    String programId,
  ) {
    final snapshot = current;
    if (snapshot == null) return;
    final updatedMembers = snapshot.members.map((member) {
      if (member.memberId != memberId) return member;
      return member.copyWith(
        programId: programId,
      );
    }).toList();
    current = snapshot.copyWith(members: updatedMembers);
    _revision++;
  }

  void invalidate() {
    current = null;
    _revision++;
  }
}
