import 'package:meal_meat_user/core/network/failures.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/entities/family_management_entity.dart';

class FamilyManagementState {
  const FamilyManagementState({
    this.home,
    this.members = const [],
    this.filteredMembers = const [],
    this.selectedMember,
    this.memberDetail,
    this.access,
    this.permissions,
    this.permissionValues = const {},
    this.isLoading = false,
    this.isSaving = false,
    this.failure,
    this.saveFailure,
    this.saveSuccessCount = 0,
  });
  final FamilyHomeEntity? home;
  final List<FamilyMemberSummaryEntity> members;
  final List<FamilyMemberSummaryEntity> filteredMembers;
  final FamilyMemberSummaryEntity? selectedMember;
  final FamilyMemberDetailEntity? memberDetail;
  final FamilyMemberAccessEntityV2? access;
  final FamilyMemberPermissionsEntity? permissions;
  final Map<String, bool> permissionValues;
  final bool isLoading;
  final bool isSaving;
  final Failure? failure;
  final Failure? saveFailure;
  final int saveSuccessCount;

  FamilyManagementState copyWith({
    FamilyHomeEntity? home,
    List<FamilyMemberSummaryEntity>? members,
    List<FamilyMemberSummaryEntity>? filteredMembers,
    FamilyMemberSummaryEntity? selectedMember,
    FamilyMemberDetailEntity? memberDetail,
    FamilyMemberAccessEntityV2? access,
    FamilyMemberPermissionsEntity? permissions,
    Map<String, bool>? permissionValues,
    bool? isLoading,
    bool? isSaving,
    Failure? failure,
    Failure? saveFailure,
    int? saveSuccessCount,
    bool clearFailure = false,
    bool clearSaveFailure = false,
  }) => FamilyManagementState(
    home: home ?? this.home,
    members: members ?? this.members,
    filteredMembers: filteredMembers ?? this.filteredMembers,
    selectedMember: selectedMember ?? this.selectedMember,
    memberDetail: memberDetail ?? this.memberDetail,
    access: access ?? this.access,
    permissions: permissions ?? this.permissions,
    permissionValues: permissionValues ?? this.permissionValues,
    isLoading: isLoading ?? this.isLoading,
    isSaving: isSaving ?? this.isSaving,
    failure: clearFailure ? null : failure ?? this.failure,
    saveFailure: clearSaveFailure ? null : saveFailure ?? this.saveFailure,
    saveSuccessCount: saveSuccessCount ?? this.saveSuccessCount,
  );
}
