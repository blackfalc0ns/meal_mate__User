sealed class FamilyAllergiesEvent {
  const FamilyAllergiesEvent();
}

final class LoadFamilyAllergiesEvent extends FamilyAllergiesEvent {
  const LoadFamilyAllergiesEvent({this.memberId});

  final String? memberId;
}

final class ToggleFamilyAllergyEvent extends FamilyAllergiesEvent {
  const ToggleFamilyAllergyEvent(this.code);

  final String code;
}

final class ToggleRejectedIngredientEvent extends FamilyAllergiesEvent {
  const ToggleRejectedIngredientEvent(this.code);

  final String code;
}

final class ChangeAllergySearchEvent extends FamilyAllergiesEvent {
  const ChangeAllergySearchEvent(this.value);

  final String value;
}

final class ChangeIngredientSearchEvent extends FamilyAllergiesEvent {
  const ChangeIngredientSearchEvent(this.value);

  final String value;
}

final class SelectFamilyAllergyMemberEvent extends FamilyAllergiesEvent {
  const SelectFamilyAllergyMemberEvent(this.index);

  final int index;
}

final class SaveCurrentFamilyAllergiesEvent extends FamilyAllergiesEvent {
  const SaveCurrentFamilyAllergiesEvent();
}
