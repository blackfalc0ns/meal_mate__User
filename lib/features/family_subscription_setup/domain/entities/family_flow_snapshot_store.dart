import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/address/domain/entities/customer_address_entity.dart';
import 'package:meal_meat_user/features/family_allergies/domain/entities/family_member_allergy_selection.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/entities/family_flow_current_entity.dart';
import 'package:meal_meat_user/features/food_preferences/domain/entities/food_preferences_entity.dart';

@lazySingleton
class FamilyFlowSnapshotStore {
  FamilyFlowCurrentEntity? current;
  int _revision = 0;

  int get revision => _revision;

  void clear() {
    current = null;
    _revision++;
  }

  void update(FamilyFlowCurrentEntity value) {
    final previous = current;
    if (previous == null) {
      current = value;
    } else {
      final mergedMembers = value.members.map((newMember) {
        final oldMember = previous.members
            .where((m) => m.memberId == newMember.memberId)
            .firstOrNull;
        if (oldMember == null) return newMember;
        return newMember.copyWith(
          programId: newMember.programId ?? oldMember.programId,
          bundleId: newMember.bundleId ?? oldMember.bundleId,
          selectedTier: newMember.selectedTier ?? oldMember.selectedTier,
          durationDays: newMember.durationDays ?? oldMember.durationDays,
          includeFriday: newMember.includeFriday || oldMember.includeFriday,
          deliveryAddressId:
              newMember.deliveryAddressId ?? oldMember.deliveryAddressId,
          deliveryAddress:
              newMember.deliveryAddress ?? oldMember.deliveryAddress,
          allergies: newMember.allergiesCompleted || newMember.hasNoAllergies
              ? newMember.allergies
              : oldMember.allergies,
          allergiesCompleted: newMember.allergiesCompleted
              ? true
              : oldMember.allergiesCompleted,
          hasNoAllergies: newMember.allergiesCompleted
              ? newMember.hasNoAllergies
              : oldMember.hasNoAllergies,
          dislikedFoods: newMember.dislikedFoods.isNotEmpty
              ? newMember.dislikedFoods
              : oldMember.dislikedFoods,
          dietaryPreferences:
              newMember.dietaryCompleted || newMember.hasNoDietaryRestriction
              ? newMember.dietaryPreferences
              : oldMember.dietaryPreferences,
          dietaryCompleted: newMember.dietaryCompleted
              ? true
              : oldMember.dietaryCompleted,
          hasNoDietaryRestriction: newMember.dietaryCompleted
              ? newMember.hasNoDietaryRestriction
              : oldMember.hasNoDietaryRestriction,
        );
      }).toList();
      current = value.copyWith(members: mergedMembers);
    }
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

  void clearMemberDeliveryAddress(String memberId) {
    final snapshot = current;
    if (snapshot == null) return;
    final updatedMembers = snapshot.members.map((member) {
      if (member.memberId != memberId) return member;
      return member.copyWith(clearDeliveryAddress: true);
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

  void updateMemberProgram(String memberId, String programId) {
    final snapshot = current;
    if (snapshot == null) return;
    final updatedMembers = snapshot.members.map((member) {
      if (member.memberId != memberId) return member;
      return member.copyWith(programId: programId);
    }).toList();
    current = snapshot.copyWith(members: updatedMembers);
    _revision++;
  }

  void updateMemberDislikedIngredients(
    String memberId,
    List<String> ingredientCodes,
  ) {
    final snapshot = current;
    if (snapshot == null) return;
    final updatedMembers = snapshot.members.map((member) {
      if (member.memberId != memberId) return member;
      return member.copyWith(
        dislikedFoods: ingredientCodes
            .map(
              (code) =>
                  FoodPreferenceItemEntity(code: code, nameAr: '', nameEn: ''),
            )
            .toList(),
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
