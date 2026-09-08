import 'package:meal_meat_user/features/family_subscription_setup/domain/entities/family_relationship_entity.dart';

List<FamilyRelationshipEntity> buildFamilyRelationshipOptions(
  List<FamilyRelationshipEntity> relationships, {
  String? selectedCode,
  bool includeSelectedRelationship = true,
}) {
  final uniqueRelationships = <String, FamilyRelationshipEntity>{};

  for (final relationship in relationships) {
    final code = relationship.code;
    if (code.trim().isEmpty) continue;
    if (relationship.forDependents ||
        (includeSelectedRelationship && code == selectedCode)) {
      uniqueRelationships.putIfAbsent(code, () => relationship);
    }
  }

  return uniqueRelationships.values.toList(growable: false);
}

String? resolveFamilyRelationshipSelection(
  List<FamilyRelationshipEntity> options, {
  String? selectedCode,
}) {
  if (selectedCode != null &&
      options.any((relationship) => relationship.code == selectedCode)) {
    return selectedCode;
  }
  return options.firstOrNull?.code;
}
