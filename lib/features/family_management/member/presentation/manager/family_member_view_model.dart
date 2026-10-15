import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:math';
import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/family_management/member/data/models/request/update_family_member_access_request_dto.dart';
import 'package:meal_meat_user/features/family_management/member/data/models/request/update_family_member_permissions_request_dto.dart';
import 'package:meal_meat_user/features/family_management/member/domain/usecase/detach_family_member_usecase.dart';
import 'package:meal_meat_user/features/family_management/member/domain/usecase/get_family_member_access_usecase.dart';
import 'package:meal_meat_user/features/family_management/member/domain/usecase/get_family_member_detail_usecase.dart';
import 'package:meal_meat_user/features/family_management/member/domain/usecase/get_family_member_permissions_usecase.dart';
import 'package:meal_meat_user/features/family_management/member/domain/usecase/renew_family_member_subscription_usecase.dart';
import 'package:meal_meat_user/features/family_management/member/domain/usecase/update_family_member_access_usecase.dart';
import 'package:meal_meat_user/features/family_management/member/domain/usecase/update_family_member_basic_info_usecase.dart';
import 'package:meal_meat_user/features/family_management/member/domain/usecase/update_family_member_permissions_usecase.dart';
import 'package:meal_meat_user/features/family_management/member/presentation/manager/family_member_event.dart';
import 'package:meal_meat_user/features/family_management/member/presentation/manager/family_member_state.dart';
import 'package:meal_meat_user/core/di/di.dart';
import 'package:meal_meat_user/features/family_context/presentation/manager/family_context_view_model.dart';
import 'package:meal_meat_user/features/family_management/shared/family_management_failure.dart';

@injectable
class FamilyMemberViewModel extends Cubit<FamilyMemberState> {
  FamilyMemberViewModel([
    GetFamilyMemberDetailUseCase? getDetail,
    GetFamilyMemberAccessUseCase? getAccess,
    UpdateFamilyMemberAccessUseCase? updateAccess,
    GetFamilyMemberPermissionsUseCase? getPermissions,
    UpdateFamilyMemberPermissionsUseCase? updatePermissions,
    UpdateFamilyMemberBasicInfoUseCase? updateBasicInfo,
    RenewFamilyMemberSubscriptionUseCase? renewSubscription,
    DetachFamilyMemberUseCase? detachMemberUseCase,
  ]) : _getDetail = getDetail ??
           (getIt.isRegistered<GetFamilyMemberDetailUseCase>()
               ? getIt<GetFamilyMemberDetailUseCase>()
               : null),
       _getAccess = getAccess ??
           (getIt.isRegistered<GetFamilyMemberAccessUseCase>()
               ? getIt<GetFamilyMemberAccessUseCase>()
               : null),
       _updateAccess = updateAccess ??
           (getIt.isRegistered<UpdateFamilyMemberAccessUseCase>()
               ? getIt<UpdateFamilyMemberAccessUseCase>()
               : null),
       _getPermissions = getPermissions ??
           (getIt.isRegistered<GetFamilyMemberPermissionsUseCase>()
               ? getIt<GetFamilyMemberPermissionsUseCase>()
               : null),
       _updatePermissions = updatePermissions ??
           (getIt.isRegistered<UpdateFamilyMemberPermissionsUseCase>()
               ? getIt<UpdateFamilyMemberPermissionsUseCase>()
               : null),
       _updateBasicInfo = updateBasicInfo ??
           (getIt.isRegistered<UpdateFamilyMemberBasicInfoUseCase>()
               ? getIt<UpdateFamilyMemberBasicInfoUseCase>()
               : null),
       _renewSubscription = renewSubscription ??
           (getIt.isRegistered<RenewFamilyMemberSubscriptionUseCase>()
               ? getIt<RenewFamilyMemberSubscriptionUseCase>()
               : null),
       _detachMember = detachMemberUseCase ??
           (getIt.isRegistered<DetachFamilyMemberUseCase>()
               ? getIt<DetachFamilyMemberUseCase>()
               : null),
       super(const FamilyMemberState());

  final GetFamilyMemberDetailUseCase? _getDetail;
  final GetFamilyMemberAccessUseCase? _getAccess;
  final UpdateFamilyMemberAccessUseCase? _updateAccess;
  final GetFamilyMemberPermissionsUseCase? _getPermissions;
  final UpdateFamilyMemberPermissionsUseCase? _updatePermissions;
  final UpdateFamilyMemberBasicInfoUseCase? _updateBasicInfo;
  final RenewFamilyMemberSubscriptionUseCase? _renewSubscription;
  final DetachFamilyMemberUseCase? _detachMember;

  void doIntent(FamilyMemberEvent event) {
    switch (event) {
      case LoadFamilyMemberDetailEvent():
        _loadDetail(event.memberId, event.locale);
      case LoadFamilyMemberAccessEvent():
        _loadAccess(event.memberId);
      case UpdateFamilyMemberAccessEvent():
        _saveAccess(event);
      case ClearGeneratedPasswordEvent():
        if (state.access != null) {
          emit(
            state.copyWith(
              access: state.access!.clearGeneratedPassword(),
              clearLastCredentialOperationKey: true,
            ),
          );
        }
      case LoadFamilyMemberPermissionsEvent():
        _loadPermissions(event.memberId, event.locale);
      case ToggleFamilyPermissionEvent():
        emit(
          state.copyWith(
            permissionValues: {
              ...state.permissionValues,
              event.key: event.value,
            },
          ),
        );
      case UpdateFamilyMemberPermissionsEvent():
        _savePermissions(event.memberId, event.locale);
      case UpdateFamilyMemberBasicInfoEvent():
        _saveBasicInfo(event);
      case RenewFamilyMemberSubscriptionEvent():
        _renew(event.renewalPath);
      case DetachFamilyMemberEvent():
        _detach(event.memberId);
    }
  }

  Future<void> _detach(String memberId) async {
    final detail = state.detail;
    if (detail != null && !detail.isDetached && !state.isDetached) {
      if (detail.checkoutSelected == true ||
          detail.paymentStatus?.toLowerCase() == 'pending') {
        emit(
          state.copyWith(
            saveFailure: FamilyManagementFailure(
              errorMessage: 'Cannot detach member with pending checkout or payment.',
              code: 'family.detach_blocked_financial_intent',
            ),
          ),
        );
        return;
      }

      if (!detail.hasSeparateAccount && state.access?.hasExistingLogin != true) {
        emit(
          state.copyWith(
            saveFailure: FamilyManagementFailure(
              errorMessage: 'Member must have completed active account login before detachment.',
              code: 'family.detach_requires_active_account',
            ),
          ),
        );
        return;
      }
    }

    if (_detachMember == null) return;

    emit(state.copyWith(isSaving: true, clearSaveFailure: true));
    final result = await _detachMember.call(memberId);
    switch (result) {
      case ApiSuccessResult():
        emit(
          state.copyWith(
            isSaving: false,
            isDetached: true,
            saveSuccessCount: state.saveSuccessCount + 1,
          ),
        );
        if (getIt.isRegistered<FamilyContextViewModel>()) {
          getIt<FamilyContextViewModel>().loadFamilyContext();
        }
      case ApiErrorResult(:final failure):
        emit(state.copyWith(saveFailure: failure, isSaving: false));
    }
  }

  Future<void> _loadDetail(String memberId, String locale) async {
    if (_getDetail == null) return;
    emit(state.copyWith(isLoadingDetail: true, clearFailure: true));
    final result = await _getDetail.call(memberId, locale: locale);
    switch (result) {
      case ApiSuccessResult(:final data):
        emit(state.copyWith(detail: data, isLoadingDetail: false));
      case ApiErrorResult(:final failure):
        emit(state.copyWith(failure: failure, isLoadingDetail: false));
    }
  }

  Future<void> _loadAccess(String memberId) async {
    if (_getAccess == null) return;
    emit(state.copyWith(isLoadingAccess: true, clearFailure: true));
    final result = await _getAccess.call(memberId);
    switch (result) {
      case ApiSuccessResult(:final data):
        emit(state.copyWith(access: data, isLoadingAccess: false));
      case ApiErrorResult(:final failure):
        emit(state.copyWith(failure: failure, isLoadingAccess: false));
    }
  }

  Future<void> _saveAccess(UpdateFamilyMemberAccessEvent event) async {
    if (_updateAccess == null) return;
    emit(state.copyWith(isSaving: true, clearSaveFailure: true));
    final operationKey = event.credentialOperationKey ??
        (event.generateTemporaryPassword == true
            ? (event.isExplicitReset
                ? '${DateTime.now().toUtc().microsecondsSinceEpoch}-${Random.secure().nextInt(1 << 32)}'
                : (event.isRetry && state.lastCredentialOperationKey != null
                    ? state.lastCredentialOperationKey
                    : '${DateTime.now().toUtc().microsecondsSinceEpoch}-${Random.secure().nextInt(1 << 32)}'))
            : null);
    final request = UpdateFamilyMemberAccessRequestDto(
      hasSeparateAccount: event.hasSeparateAccount,
      isPaused: event.isPaused,
      removeAccess: event.removeAccess,
      generateTemporaryPassword: event.generateTemporaryPassword,
      credentialOperationKey: operationKey,
    );
    final result = await _updateAccess.call(event.memberId, request);
    switch (result) {
      case ApiSuccessResult(:final data):
        emit(
          state.copyWith(
            access: data,
            isSaving: false,
            saveSuccessCount: state.saveSuccessCount + 1,
            lastCredentialOperationKey: operationKey,
            requiresExplicitReset: false,
          ),
        );
        if (getIt.isRegistered<FamilyContextViewModel>()) {
          getIt<FamilyContextViewModel>().loadFamilyContext();
        }
      case ApiErrorResult(:final failure):
        final code = (failure.code).toLowerCase();
        final isAlreadyIssued = code.contains('password_already_issued') ||
            code.contains('passwordalreadyissued') ||
            code.contains('requires_explicit_reset') ||
            code.contains('requiresexplicitreset') ||
            (failure is FamilyManagementFailure && failure.isPasswordAlreadyIssued) ||
            failure.exception.statusCode == 409;
        emit(
          state.copyWith(
            saveFailure: failure,
            isSaving: false,
            lastCredentialOperationKey: operationKey,
            requiresExplicitReset: isAlreadyIssued,
          ),
        );
    }
  }

  Future<void> _loadPermissions(String memberId, String locale) async {
    if (_getPermissions == null) return;
    emit(state.copyWith(isLoadingPermissions: true, clearFailure: true));
    final result = await _getPermissions.call(memberId, locale: locale);
    switch (result) {
      case ApiSuccessResult(:final data):
        emit(
          state.copyWith(
            permissions: data,
            permissionValues: Map.of(data.values),
            isLoadingPermissions: false,
          ),
        );
      case ApiErrorResult(:final failure):
        emit(state.copyWith(failure: failure, isLoadingPermissions: false));
    }
  }

  Future<void> _savePermissions(String memberId, String locale) async {
    final permissions = state.permissions;
    if (permissions == null || _updatePermissions == null) return;

    final original = permissions.values;
    final current = state.permissionValues;
    final changedPatch = <String, bool>{};

    for (final entry in current.entries) {
      final key = entry.key;
      if (key == 'changeProgram' || key == 'changeDeliveryTime') continue;
      final originalVal = original[key] ?? false;
      if (entry.value != originalVal) {
        changedPatch[key] = entry.value;
      }
    }

    if (changedPatch.isEmpty) {
      return;
    }

    emit(state.copyWith(isSaving: true, clearSaveFailure: true));

    final request = UpdateFamilyMemberPermissionsRequestDto(
      expectedVersion: permissions.version ?? 1,
      patch: changedPatch,
    );

    final result = await _updatePermissions.call(memberId, request, locale: locale);
    switch (result) {
      case ApiSuccessResult(:final data):
        emit(
          state.copyWith(
            permissions: data,
            permissionValues: Map.of(data.values),
            isSaving: false,
            saveSuccessCount: state.saveSuccessCount + 1,
          ),
        );
        if (getIt.isRegistered<FamilyContextViewModel>()) {
          getIt<FamilyContextViewModel>().loadFamilyContext();
        }
      case ApiErrorResult(:final failure):
        // If conflict (409 / family.permissions_changed), reload latest permissions from server and discard stale patch
        if (failure is FamilyManagementFailure &&
            failure.isPermissionConflict) {
          await _loadPermissions(memberId, locale);
        } else if (failure is FamilyManagementFailure &&
            failure.isAuthForbidden) {
          // On 403, show the server denial and refresh context; do not claim the toggle succeeded
          if (getIt.isRegistered<FamilyContextViewModel>()) {
            getIt<FamilyContextViewModel>().loadFamilyContext();
          }
          await _loadPermissions(memberId, locale);
        }
        emit(state.copyWith(saveFailure: failure, isSaving: false));
    }
  }

  Future<void> _saveBasicInfo(UpdateFamilyMemberBasicInfoEvent event) async {
    if (_updateBasicInfo == null) return;
    emit(state.copyWith(isSaving: true, clearSaveFailure: true));
    final result = await _updateBasicInfo.call(event.memberId, event.request);
    switch (result) {
      case ApiSuccessResult():
        emit(
          state.copyWith(
            isSaving: false,
            saveSuccessCount: state.saveSuccessCount + 1,
          ),
        );
      case ApiErrorResult(:final failure):
        emit(state.copyWith(saveFailure: failure, isSaving: false));
    }
  }

  Future<void> _renew(String renewalPath) async {
    if (_renewSubscription == null) return;
    emit(state.copyWith(isSaving: true, clearSaveFailure: true));
    final result = await _renewSubscription.call(renewalPath);
    switch (result) {
      case ApiSuccessResult():
        emit(
          state.copyWith(
            isSaving: false,
            saveSuccessCount: state.saveSuccessCount + 1,
          ),
        );
      case ApiErrorResult(:final failure):
        emit(state.copyWith(saveFailure: failure, isSaving: false));
    }
  }
}
