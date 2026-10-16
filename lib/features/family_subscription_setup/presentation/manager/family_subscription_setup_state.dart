import 'package:meal_meat_user/core/errors/failures.dart';
import 'package:meal_meat_user/features/family_packages/domain/entities/family_size_package_entity.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/entities/family_flow_current_entity.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/entities/family_member_entity.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/entities/family_member_lookup_entity.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/entities/family_relationship_entity.dart';

class FamilySubscriptionSetupState {
  const FamilySubscriptionSetupState({
    this.isPackagesLoading = false,
    this.packages = const [],
    this.selectedPackage,
    this.isCurrentFlowLoading = false,
    this.isDeletingMember = false,
    this.deleteMemberSuccess = false,
    this.deleteMemberFailure,
    this.currentFlow,
    this.isRelationshipsLoading = false,
    this.relationships = const [],
    this.isMemberLookupLoading = false,
    this.isMemberSaving = false,
    this.memberSaveSuccess = false,
    this.memberSaveFailure,
    this.memberLookup,
    this.memberLookupPhone,
    this.memberLookupFailure,
    this.selectedMemberIndex = 0,
    this.failure,
  });

  final bool isPackagesLoading;
  final List<FamilySizePackageEntity> packages;
  final FamilySizePackageEntity? selectedPackage;

  final bool isCurrentFlowLoading;
  final bool isDeletingMember;
  final bool deleteMemberSuccess;
  final Failure? deleteMemberFailure;
  final FamilyFlowCurrentEntity? currentFlow;

  final bool isRelationshipsLoading;
  final List<FamilyRelationshipEntity> relationships;

  final bool isMemberLookupLoading;
  final bool isMemberSaving;
  final bool memberSaveSuccess;
  final Failure? memberSaveFailure;
  final FamilyMemberLookupEntity? memberLookup;
  final String? memberLookupPhone;
  final Failure? memberLookupFailure;

  final int selectedMemberIndex;
  final Failure? failure;

  bool get isLoading =>
      isPackagesLoading || isCurrentFlowLoading || isRelationshipsLoading;

  int get maxMembers =>
      selectedPackage?.maxMembers ?? currentFlow?.maxMembers ?? 6;

  int get minMembers =>
      selectedPackage?.minMembers ?? currentFlow?.minMembers ?? 2;

  double get discountPercent =>
      selectedPackage?.discountPercent ?? currentFlow?.discountPercent ?? 0.0;

  List<FamilyMemberEntity> get members => currentFlow?.members ?? const [];

  int get rosterCount => members.length;

  int get selectedNewSubscriberCount =>
      members.where((m) => m.isInCheckoutBasket).length;

  List<FamilyMemberEntity> get plannedMembers =>
      members.where((member) => member.hasProgram).toList();

  FamilyMemberEntity? get selectedMember {
    final list = members;
    if (list.isEmpty ||
        selectedMemberIndex < 0 ||
        selectedMemberIndex >= list.length) {
      return null;
    }
    return list[selectedMemberIndex];
  }

  FamilySubscriptionSetupState copyWith({
    bool? isPackagesLoading,
    List<FamilySizePackageEntity>? packages,
    FamilySizePackageEntity? selectedPackage,
    bool clearSelectedPackage = false,
    bool? isCurrentFlowLoading,
    bool? isDeletingMember,
    bool? deleteMemberSuccess,
    Failure? deleteMemberFailure,
    bool clearDeleteMemberFailure = false,
    FamilyFlowCurrentEntity? currentFlow,
    bool clearCurrentFlow = false,
    bool? isRelationshipsLoading,
    List<FamilyRelationshipEntity>? relationships,
    bool? isMemberLookupLoading,
    bool? isMemberSaving,
    bool? memberSaveSuccess,
    Failure? memberSaveFailure,
    bool clearMemberSaveFailure = false,
    FamilyMemberLookupEntity? memberLookup,
    bool clearMemberLookup = false,
    String? memberLookupPhone,
    bool clearMemberLookupPhone = false,
    Failure? memberLookupFailure,
    bool clearMemberLookupFailure = false,
    int? selectedMemberIndex,
    Failure? failure,
    bool clearFailure = false,
  }) {
    return FamilySubscriptionSetupState(
      isPackagesLoading: isPackagesLoading ?? this.isPackagesLoading,
      packages: packages ?? this.packages,
      selectedPackage: clearSelectedPackage
          ? null
          : (selectedPackage ?? this.selectedPackage),
      isCurrentFlowLoading: isCurrentFlowLoading ?? this.isCurrentFlowLoading,
      isDeletingMember: isDeletingMember ?? this.isDeletingMember,
      deleteMemberSuccess: deleteMemberSuccess ?? this.deleteMemberSuccess,
      deleteMemberFailure: clearDeleteMemberFailure
          ? null
          : (deleteMemberFailure ?? this.deleteMemberFailure),
      currentFlow: clearCurrentFlow ? null : (currentFlow ?? this.currentFlow),
      isRelationshipsLoading:
          isRelationshipsLoading ?? this.isRelationshipsLoading,
      relationships: relationships ?? this.relationships,
      isMemberLookupLoading:
          isMemberLookupLoading ?? this.isMemberLookupLoading,
      isMemberSaving: isMemberSaving ?? this.isMemberSaving,
      memberSaveSuccess: memberSaveSuccess ?? this.memberSaveSuccess,
      memberSaveFailure: clearMemberSaveFailure
          ? null
          : (memberSaveFailure ?? this.memberSaveFailure),
      memberLookup: clearMemberLookup
          ? null
          : (memberLookup ?? this.memberLookup),
      memberLookupPhone: clearMemberLookupPhone
          ? null
          : (memberLookupPhone ?? this.memberLookupPhone),
      memberLookupFailure: clearMemberLookupFailure
          ? null
          : (memberLookupFailure ?? this.memberLookupFailure),
      selectedMemberIndex: selectedMemberIndex ?? this.selectedMemberIndex,
      failure: clearFailure ? null : (failure ?? this.failure),
    );
  }
}
