class FamilyMemberWriteRequestDto {
  final String displayName;
  final String relationshipCode;
  final int gender;
  final int ageYears;
  final String? deliveryAddressId;

  FamilyMemberWriteRequestDto({
    required this.displayName,
    required this.relationshipCode,
    required this.gender,
    required this.ageYears,
    this.deliveryAddressId,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'displayName': displayName,
      'relationshipCode': relationshipCode,
      'gender': gender,
      'ageYears': ageYears,
    };
    if (deliveryAddressId != null && deliveryAddressId!.trim().isNotEmpty) {
      map['deliveryAddressId'] = deliveryAddressId;
    }
    return map;
  }
}
