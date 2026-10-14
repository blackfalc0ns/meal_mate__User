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
  final bool managerPrepaid;
  final List<FamilyMemberEntity> members;
  final bool sessionExpired;
  final DateTime? sessionExpiresAtUtc;
  final String? sessionMessage;
  final bool packageAvailable;

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
    this.managerPrepaid = false,
    this.members = const [],
    this.sessionExpired = false,
    this.sessionExpiresAtUtc,
    this.sessionMessage,
    this.packageAvailable = false,
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
    bool? managerPrepaid,
    List<FamilyMemberEntity>? members,
    bool? sessionExpired,
    DateTime? sessionExpiresAtUtc,
    String? sessionMessage,
    bool? packageAvailable,
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
      managerPrepaid: managerPrepaid ?? this.managerPrepaid,
      members: members ?? this.members,
      sessionExpired: sessionExpired ?? this.sessionExpired,
      sessionExpiresAtUtc: sessionExpiresAtUtc ?? this.sessionExpiresAtUtc,
      sessionMessage: sessionMessage ?? this.sessionMessage,
      packageAvailable: packageAvailable ?? this.packageAvailable,
    );
  }
}
