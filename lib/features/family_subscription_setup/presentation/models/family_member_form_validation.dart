enum FamilyMemberPhoneValidationError { invalid }

enum FamilyMemberNameValidationError { required }

enum FamilyMemberAgeValidationError { invalid }

FamilyMemberPhoneValidationError? validateFamilyMemberPhone(String? phone) {
  if (phone == null || phone.trim().isEmpty) {
    return FamilyMemberPhoneValidationError.invalid;
  }
  return null;
}

FamilyMemberNameValidationError? validateFamilyMemberName(String? name) {
  if (name == null || name.trim().isEmpty) {
    return FamilyMemberNameValidationError.required;
  }
  return null;
}

FamilyMemberAgeValidationError? validateFamilyMemberAge(String? ageText) {
  final age = int.tryParse(ageText?.trim() ?? '');
  if (age == null || age < 1 || age > 120) {
    return FamilyMemberAgeValidationError.invalid;
  }
  return null;
}
