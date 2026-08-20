import 'package:meal_meat_user/features/family_plans/data/models/response/family_member_response_dto.dart';

class FamilyFlowCurrentResponseDto {
  final String? familyGroupId;
  final String? name;
  final int? status;
  final String? selectedFamilyPackageId;
  final String? packageNameAr;
  final String? packageNameEn;
  final int? minMembers;
  final int? maxMembers;
  final double? discountPercent;
  final int? currentStep;
  final List<FamilyMemberResponseDto> members;

  FamilyFlowCurrentResponseDto({
    this.familyGroupId,
    this.name,
    this.status,
    this.selectedFamilyPackageId,
    this.packageNameAr,
    this.packageNameEn,
    this.minMembers,
    this.maxMembers,
    this.discountPercent,
    this.currentStep,
    required this.members,
  });

  factory FamilyFlowCurrentResponseDto.fromJson(Map<String, dynamic> json) {
    int? parseStatus(dynamic val) {
      if (val == null) return null;
      if (val is int) return val;
      if (val is String) {
        final lower = val.toLowerCase();
        if (lower == 'draft') return 1;
        if (lower == 'active') return 2;
        if (lower == 'cancelled') return 3;
        return int.tryParse(val) ?? 1;
      }
      return null;
    }

    int? parseNullableInt(dynamic val) {
      if (val == null) return null;
      if (val is num) return val.toInt();
      if (val is String) return int.tryParse(val);
      return null;
    }

    return FamilyFlowCurrentResponseDto(
      familyGroupId: json['familyGroupId'] as String?,
      name: json['name'] as String?,
      status: parseStatus(json['status']),
      selectedFamilyPackageId: json['selectedFamilyPackageId'] as String?,
      packageNameAr: json['packageNameAr'] as String?,
      packageNameEn: json['packageNameEn'] as String?,
      minMembers: parseNullableInt(json['minMembers']),
      maxMembers: parseNullableInt(json['maxMembers']),
      discountPercent: (json['discountPercent'] as num?)?.toDouble(),
      currentStep: parseNullableInt(json['currentStep']),
      members: (json['members'] as List<dynamic>?)
              ?.map(
                (e) => FamilyMemberResponseDto.fromJson(
                  e as Map<String, dynamic>,
                ),
              )
              .toList() ??
          const [],
    );
  }

  Map<String, dynamic> toJson() => {
        'familyGroupId': familyGroupId,
        'name': name,
        'status': status,
        'selectedFamilyPackageId': selectedFamilyPackageId,
        'packageNameAr': packageNameAr,
        'packageNameEn': packageNameEn,
        'minMembers': minMembers,
        'maxMembers': maxMembers,
        'discountPercent': discountPercent,
        'currentStep': currentStep,
        'members': members.map((e) => e.toJson()).toList(),
      };
}
