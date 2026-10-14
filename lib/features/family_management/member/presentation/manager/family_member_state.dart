import 'package:meal_meat_user/core/network/failures.dart';
import 'package:meal_meat_user/features/family_management/member/domain/entities/family_member_access_entity.dart';
import 'package:meal_meat_user/features/family_management/member/domain/entities/family_member_detail_entity.dart';
import 'package:meal_meat_user/features/family_management/member/domain/entities/family_member_permissions_entity.dart';

class FamilyMemberState {
  const FamilyMemberState({
    this.detail,
    this.access,
    this.permissions,
    this.permissionValues = const {},
    this.isLoadingDetail = false,
    this.isLoadingAccess = false,
    this.isLoadingPermissions = false,
    this.isSaving = false,
    this.saveSuccessCount = 0,
    this.failure,
    this.saveFailure,
  });

  final FamilyMemberDetailEntity? detail;
  final FamilyMemberAccessEntity? access;
  final FamilyMemberPermissionsEntity? permissions;
  final Map<String, bool> permissionValues;
  final bool isLoadingDetail;
  final bool isLoadingAccess;
  final bool isLoadingPermissions;
  final bool isSaving;
  final int saveSuccessCount;
  final Failure? failure;
  final Failure? saveFailure;

  bool get isLoading =>
      isLoadingDetail || isLoadingAccess || isLoadingPermissions || isSaving;

  FamilyMemberState copyWith({
    FamilyMemberDetailEntity? detail,
    FamilyMemberAccessEntity? access,
    FamilyMemberPermissionsEntity? permissions,
    Map<String, bool>? permissionValues,
    bool? isLoadingDetail,
    bool? isLoadingAccess,
    bool? isLoadingPermissions,
    bool? isSaving,
    int? saveSuccessCount,
    Failure? failure,
    Failure? saveFailure,
    bool clearFailure = false,
    bool clearSaveFailure = false,
  }) {
    return FamilyMemberState(
      detail: detail ?? this.detail,
      access: access ?? this.access,
      permissions: permissions ?? this.permissions,
      permissionValues: permissionValues ?? this.permissionValues,
      isLoadingDetail: isLoadingDetail ?? this.isLoadingDetail,
      isLoadingAccess: isLoadingAccess ?? this.isLoadingAccess,
      isLoadingPermissions:
          isLoadingPermissions ?? this.isLoadingPermissions,
      isSaving: isSaving ?? this.isSaving,
      saveSuccessCount: saveSuccessCount ?? this.saveSuccessCount,
      failure: clearFailure ? null : (failure ?? this.failure),
      saveFailure:
          clearSaveFailure ? null : (saveFailure ?? this.saveFailure),
    );
  }
}
