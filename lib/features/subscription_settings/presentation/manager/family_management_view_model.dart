import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/errors/subscription_error_codes.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/usecase/get_family_home_usecase.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/usecase/get_family_member_usecase.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/usecase/get_family_members_usecase.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/usecase/manage_family_member_access_usecase.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/usecase/manage_family_member_permissions_usecase.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/usecase/renew_family_member_subscription_usecase.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/manager/family_management_event.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/manager/family_management_state.dart';

@injectable
class FamilyManagementViewModel extends Cubit<FamilyManagementState> {
  FamilyManagementViewModel(
    this._getHome,
    this._getMembers,
    this._getMember,
    this._access,
    this._permissions,
    this._renewSubscription,
  ) : super(const FamilyManagementState());
  final GetFamilyHomeUseCase _getHome;
  final GetFamilyMembersUseCase _getMembers;
  final GetFamilyMemberUseCase _getMember;
  final ManageFamilyMemberAccessUseCase _access;
  final ManageFamilyMemberPermissionsUseCase _permissions;
  final RenewFamilyMemberSubscriptionUseCase _renewSubscription;

  void doIntent(FamilyManagementEvent event) {
    switch (event) {
      case LoadFamilyHomeEvent():
        _loadHome(event.localeName);
      case LoadFamilyMembersEvent():
        _loadMembers(event.localeName);
      case SearchFamilyMembersEvent():
        _search(event.query);
      case LoadFamilyMemberEvent():
        _loadMember(event.memberId, event.localeName);
      case LoadFamilyMemberAccessEvent():
        _loadAccess(event.memberId);
      case UpdateFamilyMemberAccessEvent():
        _updateAccess(event);
      case ClearGeneratedPasswordEvent():
        final access = state.access;
        if (access != null) {
          emit(state.copyWith(access: access.clearGeneratedPassword()));
        }
      case LoadFamilyMemberPermissionsEvent():
        _loadPermissions(event.memberId, event.localeName);
      case UpdateFamilyMemberPermissionsEvent():
        _updatePermissions(event);
      case ToggleFamilyPermissionEvent():
        emit(
          state.copyWith(
            permissionValues: {
              ...state.permissionValues,
              event.key: event.value,
            },
          ),
        );
      case SelectFamilyMemberEvent():
        emit(state.copyWith(selectedMember: event.member));
      case RenewFamilyMemberSubscriptionEvent():
        _renew(event.renewalPath);
    }
  }

  Future<void> _loadHome(String localeName) async {
    emit(state.copyWith(isLoading: true, clearFailure: true));
    final result = await _getHome(localeName);
    if (isClosed) return;
    switch (result) {
      case ApiSuccessResult():
        emit(
          state.copyWith(
            home: result.data,
            members: result.data.members,
            filteredMembers: result.data.members,
            isLoading: false,
          ),
        );
      case ApiErrorResult():
        emit(state.copyWith(isLoading: false, failure: result.failure));
    }
  }

  Future<void> _loadMembers(String localeName) async {
    emit(state.copyWith(isLoading: true, clearFailure: true));
    final result = await _getMembers(localeName);
    if (isClosed) return;
    switch (result) {
      case ApiSuccessResult():
        emit(
          state.copyWith(
            members: result.data,
            filteredMembers: result.data,
            isLoading: false,
          ),
        );
      case ApiErrorResult():
        emit(state.copyWith(isLoading: false, failure: result.failure));
    }
  }

  void _search(String query) {
    final normalized = query.trim().toLowerCase();
    emit(
      state.copyWith(
        filteredMembers: normalized.isEmpty
            ? state.members
            : state.members
                  .where(
                    (member) =>
                        member.displayName.toLowerCase().contains(normalized),
                  )
                  .toList(),
      ),
    );
  }

  Future<void> _loadMember(String memberId, String localeName) async {
    emit(state.copyWith(isLoading: true, clearFailure: true));
    final result = await _getMember(memberId: memberId, localeName: localeName);
    if (isClosed) return;
    switch (result) {
      case ApiSuccessResult():
        emit(state.copyWith(memberDetail: result.data, isLoading: false));
      case ApiErrorResult():
        emit(state.copyWith(isLoading: false, failure: result.failure));
    }
  }

  Future<void> _loadAccess(String memberId) async {
    emit(state.copyWith(isLoading: true, clearFailure: true));
    final result = await _access.get(memberId);
    if (isClosed) return;
    switch (result) {
      case ApiSuccessResult():
        emit(state.copyWith(access: result.data, isLoading: false));
      case ApiErrorResult():
        emit(state.copyWith(isLoading: false, failure: result.failure));
    }
  }

  Future<void> _updateAccess(UpdateFamilyMemberAccessEvent event) async {
    emit(state.copyWith(isSaving: true, clearSaveFailure: true));
    final result = await _access.update(
      memberId: event.memberId,
      hasSeparateAccount: event.hasSeparateAccount,
      isPaused: event.isPaused,
      remove: event.remove,
      expectedVersion: state.access?.version,
    );
    if (isClosed) return;
    switch (result) {
      case ApiSuccessResult():
        emit(
          state.copyWith(
            access: result.data,
            isSaving: false,
            saveSuccessCount: state.saveSuccessCount + 1,
          ),
        );
      case ApiErrorResult():
        emit(state.copyWith(isSaving: false, saveFailure: result.failure));
        if (result.failure.code ==
                SubscriptionErrorCodes.familyPermissionsChanged ||
            result.failure.code == 'family.permissions_changed') {
          await _loadAccess(event.memberId);
        }
    }
  }

  Future<void> _loadPermissions(String memberId, String localeName) async {
    emit(state.copyWith(isLoading: true, clearFailure: true));
    final result = await _permissions.get(
      memberId: memberId,
      localeName: localeName,
    );
    if (isClosed) return;
    switch (result) {
      case ApiSuccessResult():
        emit(
          state.copyWith(
            permissions: result.data,
            permissionValues: result.data.values,
            isLoading: false,
          ),
        );
      case ApiErrorResult():
        emit(state.copyWith(isLoading: false, failure: result.failure));
    }
  }

  Future<void> _updatePermissions(
    UpdateFamilyMemberPermissionsEvent event,
  ) async {
    emit(state.copyWith(isSaving: true, clearSaveFailure: true));
    final result = await _permissions.update(
      memberId: event.memberId,
      values: event.values,
      localeName: event.localeName,
      expectedVersion: state.permissions?.version,
    );
    if (isClosed) return;
    switch (result) {
      case ApiSuccessResult():
        emit(
          state.copyWith(
            permissions: result.data,
            permissionValues: result.data.values,
            isSaving: false,
            saveSuccessCount: state.saveSuccessCount + 1,
          ),
        );
      case ApiErrorResult():
        emit(state.copyWith(isSaving: false, saveFailure: result.failure));
        if (result.failure.code ==
                SubscriptionErrorCodes.familyPermissionsChanged ||
            result.failure.code == 'family.permissions_changed') {
          await _loadPermissions(event.memberId, event.localeName);
        }
    }
  }

  Future<void> _renew(String renewalPath) async {
    if (renewalPath.trim().isEmpty) return;
    emit(state.copyWith(isSaving: true, clearSaveFailure: true));
    final result = await _renewSubscription(renewalPath);
    if (isClosed) return;
    switch (result) {
      case ApiSuccessResult():
        emit(
          state.copyWith(
            isSaving: false,
            saveSuccessCount: state.saveSuccessCount + 1,
          ),
        );
      case ApiErrorResult():
        emit(state.copyWith(isSaving: false, saveFailure: result.failure));
    }
  }
}
