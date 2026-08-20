class FamilyGroupWriteRequestDto {
  final String name;
  final String? familyPackageId;

  FamilyGroupWriteRequestDto({
    required this.name,
    this.familyPackageId,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        if (familyPackageId != null && familyPackageId!.isNotEmpty)
          'familyPackageId': familyPackageId,
      };
}
