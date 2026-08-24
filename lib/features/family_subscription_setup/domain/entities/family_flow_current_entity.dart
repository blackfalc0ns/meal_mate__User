import 'package:meal_meat_user/features/family_subscription_setup/domain/entities/family_member_entity.dart';

class FamilyFlowCurrentEntity {
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
  final List<FamilyMemberEntity> members;

  const FamilyFlowCurrentEntity({
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
    this.members = const [],
  });

  String packageName(String languageCode) {
    if (languageCode.toLowerCase().startsWith('en') &&
        (packageNameEn?.isNotEmpty ?? false)) {
      return packageNameEn!;
    }
    return (packageNameAr?.isNotEmpty ?? false)
        ? packageNameAr!
        : (packageNameEn ?? '');
  }

  FamilyFlowCurrentEntity copyWith({
    String? familyGroupId,
    String? name,
    int? status,
    String? selectedFamilyPackageId,
    String? packageNameAr,
    String? packageNameEn,
    int? minMembers,
    int? maxMembers,
    double? discountPercent,
    int? currentStep,
    List<FamilyMemberEntity>? members,
  }) {
    return FamilyFlowCurrentEntity(
      familyGroupId: familyGroupId ?? this.familyGroupId,
      name: name ?? this.name,
      status: status ?? this.status,
      selectedFamilyPackageId:
          selectedFamilyPackageId ?? this.selectedFamilyPackageId,
      packageNameAr: packageNameAr ?? this.packageNameAr,
      packageNameEn: packageNameEn ?? this.packageNameEn,
      minMembers: minMembers ?? this.minMembers,
      maxMembers: maxMembers ?? this.maxMembers,
      discountPercent: discountPercent ?? this.discountPercent,
      currentStep: currentStep ?? this.currentStep,
      members: members ?? this.members,
    );
  }
}
