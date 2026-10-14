class FamilyMemberWriteRequestDto {
  const FamilyMemberWriteRequestDto({
    required this.displayName,
    required this.relationshipCode,
    required this.gender,
    required this.ageYears,
    this.deliveryAddressId,
    this.phone,
    this.occupation,
  });

  final String displayName;
  final String relationshipCode;
  final int gender;
  final int ageYears;
  final String? deliveryAddressId;
  final String? phone;
  final String? occupation;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'displayName': displayName,
      'relationshipCode': relationshipCode,
      'gender': gender,
      'ageYears': ageYears,
    };
    if (deliveryAddressId != null) {
      map['deliveryAddressId'] = deliveryAddressId;
    }
    if (phone != null) {
      map['phone'] = phone;
    }
    if (occupation != null) {
      map['occupation'] = occupation;
    }
    return map;
  }
}
