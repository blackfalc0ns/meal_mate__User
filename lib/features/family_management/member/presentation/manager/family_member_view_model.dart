import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/family_management/member/data/models/request/update_family_member_access_request_dto.dart';
import 'package:meal_meat_user/features/family_management/member/data/models/request/update_family_member_permissions_request_dto.dart';
import 'package:meal_meat_user/features/family_management/member/domain/usecase/get_family_member_access_usecase.dart';
import 'package:meal_meat_user/features/family_management/member/domain/usecase/get_family_member_detail_usecase.dart';
import 'package:meal_meat_user/features/family_management/member/domain/usecase/get_family_member_permissions_usecase.dart';
import 'package:meal_meat_user/features/family_management/member/domain/usecase/renew_family_member_subscription_usecase.dart';
import 'package:meal_meat_user/features/family_management/member/domain/usecase/update_family_member_access_usecase.dart';
import 'package:meal_meat_user/features/family_management/member/domain/usecase/update_family_member_basic_info_usecase.dart';
import 'package:meal_meat_user/features/family_management/member/domain/usecase/update_family_member_permissions_usecase.dart';
import 'package:meal_meat_user/features/family_management/member/presentation/manager/family_member_event.dart';
import 'package:meal_meat_user/features/family_management/member/presentation/manager/family_member_state.dart';
import 'package:meal_meat_user/features/family_management/shared/family_management_failure.dart';

@injectable
class FamilyMemberViewModel extends Cubit<FamilyMemberState> {
  FamilyMemberViewModel(
    this._getDetail,
    this._getAccess,
    this._updateAccess,
    this._getPermissions,
    this._updatePermissions,
    this._updateBasicInfo,
    this._renewSubscription,
  ) : super(const FamilyMemberState());

  final GetFamilyMemberDetailUseCase _getDetail;
  final GetFamilyMemberAccessUseCase _getAccess;
  final UpdateFamilyMemberAccessUseCase _updateAccess;
  final GetFamilyMemberPermissionsUseCase _getPermissions;
  final UpdateFamilyMemberPermissionsUseCase _updatePermissions;
  final UpdateFamilyMemberBasicInfoUseCase _updateBasicInfo;
  final RenewFamilyMemberSubscriptionUseCase _renewSubscription;

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
          emit(state.copyWith(access: state.access!.clearGeneratedPassword()));
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
    }
  }

  Future<void> _loadDetail(String memberId, String locale) async {
    emit(state.copyWith(isLoadingDetail: true, clearFailure: true));
    final result = await _getDetail(memberId, locale: locale);
    switch (result) {
      case ApiSuccessResult(:final data):
        emit(state.copyWith(
          detail: data,
          isLoadingDetail: false,
        ));
      case ApiErrorResult(:final failure):
        emit(state.copyWith(
          failure: failure,
          isLoadingDetail: false,
        ));
    }
  }

  Future<void> _loadAccess(String memberId) async {
    emit(state.copyWith(isLoadingAccess: true, clearFailure: true));
    final result = await _getAccess(memberId);
    switch (result) {
      case ApiSuccessResult(:final data):
        emit(state.copyWith(
          access: data,
          isLoadingAccess: false,
        ));
      case ApiErrorResult(:final failure):
        emit(state.copyWith(
          failure: failure,
          isLoadingAccess: false,
        ));
    }
  }

  Future<void> _saveAccess(UpdateFamilyMemberAccessEvent event) async {
    emit(state.copyWith(isSaving: true, clearSaveFailure: true));
    final request = UpdateFamilyMemberAccessRequestDto(
      hasSeparateAccount: event.hasSeparateAccount,
      isPaused: event.isPaused,
      removeAccess: event.removeAccess,
    );
    final result = await _updateAccess(event.memberId, request);
    switch (result) {
      case ApiSuccessResult(:final data):
        emit(state.copyWith(
          access: data,
          isSaving: false,
          saveSuccessCount: state.saveSuccessCount + 1,
        ));
      case ApiErrorResult(:final failure):
        emit(state.copyWith(
          saveFailure: failure,
          isSaving: false,
        ));
    }
  }

  Future<void> _loadPermissions(String memberId, String locale) async {
    emit(state.copyWith(isLoadingPermissions: true, clearFailure: true));
    final result = await _getPermissions(memberId, locale: locale);
    switch (result) {
      case ApiSuccessResult(:final data):
        emit(state.copyWith(
          permissions: data,
          permissionValues: Map.of(data.values),
          isLoadingPermissions: false,
        ));
      case ApiErrorResult(:final failure):
        emit(state.copyWith(
          failure: failure,
          isLoadingPermissions: false,
        ));
    }
  }

  Future<void> _savePermissions(String memberId, String locale) async {
    final permissions = state.permissions;
    if (permissions == null) return;

    emit(state.copyWith(isSaving: true, clearSaveFailure: true));

    final values = state.permissionValues;
    bool val(String key) => values[key] ?? permissions.values[key] ?? false;

    final request = UpdateFamilyMemberPermissionsRequestDto(
      expectedVersion: permissions.version ?? 1,
      editDailyMeals: val('editDailyMeals'),
      changeDeliveryTime: val('changeDeliveryTime'),
      viewProgram: val('viewProgram'),
      changeProgram: val('changeProgram'),
      editMealsAndDays: val('editMealsAndDays'),
      editAddress: val('editAddress'),
      unitExchange: val('unitExchange'),
      changePassword: val('changePassword'),
      viewCalendar: values['viewCalendar'],
      viewInvoices: values['viewInvoices'],
      selectRestaurant: values['selectRestaurant'],
      confirmMeals: values['confirmMeals'],
      requestFreeze: values['requestFreeze'],
      requestRenewal: values['requestRenewal'],
      requestUpgrade: values['requestUpgrade'],
      cancelSubscription: values['cancelSubscription'],
      viewFamilyCalendars: values['viewFamilyCalendars'],
      viewFamilyPlans: values['viewFamilyPlans'],
      viewFamilyInvoices: values['viewFamilyInvoices'],
    );

    final result = await _updatePermissions(memberId, request, locale: locale);
    switch (result) {
      case ApiSuccessResult(:final data):
        emit(state.copyWith(
          permissions: data,
          permissionValues: Map.of(data.values),
          isSaving: false,
          saveSuccessCount: state.saveSuccessCount + 1,
        ));
      case ApiErrorResult(:final failure):
        // If conflict, reload latest permissions from server
        if (failure is FamilyManagementFailure && failure.isPermissionConflict) {
          await _loadPermissions(memberId, locale);
        }
        emit(state.copyWith(
          saveFailure: failure,
          isSaving: false,
        ));
    }
  }

  Future<void> _saveBasicInfo(UpdateFamilyMemberBasicInfoEvent event) async {
    emit(state.copyWith(isSaving: true, clearSaveFailure: true));
    final result = await _updateBasicInfo(event.memberId, event.request);
    switch (result) {
      case ApiSuccessResult():
        emit(state.copyWith(
          isSaving: false,
          saveSuccessCount: state.saveSuccessCount + 1,
        ));
      case ApiErrorResult(:final failure):
        emit(state.copyWith(
          saveFailure: failure,
          isSaving: false,
        ));
    }
  }

  Future<void> _renew(String renewalPath) async {
    emit(state.copyWith(isSaving: true, clearSaveFailure: true));
    final result = await _renewSubscription(renewalPath);
    switch (result) {
      case ApiSuccessResult():
        emit(state.copyWith(
          isSaving: false,
          saveSuccessCount: state.saveSuccessCount + 1,
        ));
      case ApiErrorResult(:final failure):
        emit(state.copyWith(
          saveFailure: failure,
          isSaving: false,
        ));
    }
  }
}
