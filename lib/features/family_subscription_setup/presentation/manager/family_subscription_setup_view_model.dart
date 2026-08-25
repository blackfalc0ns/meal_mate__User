import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/addresses/domain/usecase/get_customer_addresses_usecase.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/entities/family_conversion_draft_session.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/usecase/abandon_family_draft_usecase.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/usecase/add_family_member_usecase.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/usecase/delete_family_member_usecase.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/usecase/get_family_flow_current_usecase.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/usecase/get_family_relationships_usecase.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/usecase/update_family_group_usecase.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/usecase/update_family_member_usecase.dart';
import 'package:meal_meat_user/features/family_subscription_setup/presentation/manager/family_subscription_setup_event.dart';
import 'package:meal_meat_user/features/family_subscription_setup/presentation/manager/family_subscription_setup_state.dart';

@injectable
class FamilySubscriptionSetupViewModel extends Cubit<FamilyPlanState> {
  FamilySubscriptionSetupViewModel(
    this._getFamilyFlowCurrentUseCase,
    this._updateFamilyGroupUseCase,
    this._getFamilyRelationshipsUseCase,
    this._addFamilyMemberUseCase,
    this._updateFamilyMemberUseCase,
    this._deleteFamilyMemberUseCase,
    this._abandonFamilyDraftUseCase,
    this._getCustomerAddressesUseCase,
  ) : super(const FamilyPlanState());

  final GetFamilyFlowCurrentUseCase _getFamilyFlowCurrentUseCase;
  final UpdateFamilyGroupUseCase _updateFamilyGroupUseCase;
  final GetFamilyRelationshipsUseCase _getFamilyRelationshipsUseCase;
  final AddFamilyMemberUseCase _addFamilyMemberUseCase;
  final UpdateFamilyMemberUseCase _updateFamilyMemberUseCase;
  final DeleteFamilyMemberUseCase _deleteFamilyMemberUseCase;
  final AbandonFamilyDraftUseCase _abandonFamilyDraftUseCase;
  final GetCustomerAddressesUseCase _getCustomerAddressesUseCase;

  void doIntent(FamilyPlanEvent event) {
    switch (event) {
      case SelectFamilySizePackageEvent():
        emit(state.copyWith(selectedPackage: event.package));
      case GetFamilySubscriptionCurrentEvent():
        _getFamilySubscriptionCurrent();
      case UpdateFamilyGroupEvent():
        _updateFamilyGroup(
          name: event.name,
          familyPackageId: event.familyPackageId,
        );
      case GetFamilyRelationshipsEvent():
        _getFamilyRelationships();
      case GetFamilyAddressesEvent():
        _getFamilyAddresses();
      case AddFamilyMemberEvent():
        _addFamilyMember(
          displayName: event.displayName,
          relationshipCode: event.relationshipCode,
          gender: event.gender,
          ageYears: event.ageYears,
          deliveryAddressId: event.deliveryAddressId,
        );
      case UpdateFamilyMemberEvent():
        _updateFamilyMember(
          memberId: event.memberId,
          displayName: event.displayName,
          relationshipCode: event.relationshipCode,
          gender: event.gender,
          ageYears: event.ageYears,
          deliveryAddressId: event.deliveryAddressId,
        );
      case DeleteFamilyMemberEvent():
        _deleteFamilyMember(event.memberId);
      case AbandonFamilyDraftEvent():
        _abandonFamilyDraft();
    }
  }

  Future<void> _getFamilySubscriptionCurrent() async {
    emit(state.copyWith(isCurrentFlowLoading: true, clearFailure: true));
    final result = await _getFamilyFlowCurrentUseCase();
    switch (result) {
      case ApiSuccessResult():
        if (result.data.status == 2) {
          FamilyConversionDraftSession.clearConvertedFamilyDraft();
        } else if (result.data.managerPrepaid) {
          FamilyConversionDraftSession.markConvertedFamilyDraft();
        }
        emit(
          state.copyWith(isCurrentFlowLoading: false, currentFlow: result.data),
        );
      case ApiErrorResult():
        emit(
          state.copyWith(isCurrentFlowLoading: false, failure: result.failure),
        );
    }
  }

  Future<void> _updateFamilyGroup({
    required String name,
    String? familyPackageId,
  }) async {
    emit(state.copyWith(isCurrentFlowLoading: true, clearFailure: true));
    final result = await _updateFamilyGroupUseCase(
      name: name,
      familyPackageId: familyPackageId ?? state.selectedPackage?.id,
    );
    switch (result) {
      case ApiSuccessResult():
        emit(
          state.copyWith(isCurrentFlowLoading: false, currentFlow: result.data),
        );
      case ApiErrorResult():
        emit(
          state.copyWith(isCurrentFlowLoading: false, failure: result.failure),
        );
    }
  }

  Future<void> _getFamilyRelationships() async {
    final result = await _getFamilyRelationshipsUseCase();
    switch (result) {
      case ApiSuccessResult():
        emit(state.copyWith(relationships: result.data));
      case ApiErrorResult():
        emit(state.copyWith(failure: result.failure));
    }
  }

  Future<void> _getFamilyAddresses() async {
    final result = await _getCustomerAddressesUseCase();
    switch (result) {
      case ApiSuccessResult():
        emit(state.copyWith(addresses: result.data));
      case ApiErrorResult():
        emit(state.copyWith(failure: result.failure));
    }
  }

  Future<void> _addFamilyMember({
    required String displayName,
    required String relationshipCode,
    required int gender,
    required int ageYears,
    String? deliveryAddressId,
  }) async {
    emit(state.copyWith(isCurrentFlowLoading: true, clearFailure: true));
    final result = await _addFamilyMemberUseCase(
      displayName: displayName,
      relationshipCode: relationshipCode,
      gender: gender,
      ageYears: ageYears,
      deliveryAddressId: deliveryAddressId,
    );
    switch (result) {
      case ApiSuccessResult():
        emit(
          state.copyWith(isCurrentFlowLoading: false, currentFlow: result.data),
        );
      case ApiErrorResult():
        emit(
          state.copyWith(isCurrentFlowLoading: false, failure: result.failure),
        );
    }
  }

  Future<void> _updateFamilyMember({
    required String memberId,
    required String displayName,
    required String relationshipCode,
    required int gender,
    required int ageYears,
    String? deliveryAddressId,
  }) async {
    emit(state.copyWith(isCurrentFlowLoading: true, clearFailure: true));
    final result = await _updateFamilyMemberUseCase(
      memberId: memberId,
      displayName: displayName,
      relationshipCode: relationshipCode,
      gender: gender,
      ageYears: ageYears,
      deliveryAddressId: deliveryAddressId,
    );
    switch (result) {
      case ApiSuccessResult():
        emit(
          state.copyWith(isCurrentFlowLoading: false, currentFlow: result.data),
        );
      case ApiErrorResult():
        emit(
          state.copyWith(isCurrentFlowLoading: false, failure: result.failure),
        );
    }
  }

  Future<void> _deleteFamilyMember(String memberId) async {
    emit(state.copyWith(isCurrentFlowLoading: true, clearFailure: true));
    final result = await _deleteFamilyMemberUseCase(memberId);
    switch (result) {
      case ApiSuccessResult():
        emit(
          state.copyWith(isCurrentFlowLoading: false, currentFlow: result.data),
        );
      case ApiErrorResult():
        emit(
          state.copyWith(isCurrentFlowLoading: false, failure: result.failure),
        );
    }
  }

  Future<void> _abandonFamilyDraft() async {
    emit(
      state.copyWith(
        isAbandonDraftLoading: true,
        isAbandonDraftSuccess: false,
        clearFailure: true,
      ),
    );
    final result = await _abandonFamilyDraftUseCase();
    switch (result) {
      case ApiSuccessResult():
        FamilyConversionDraftSession.clearConvertedFamilyDraft();
        emit(
          state.copyWith(
            isAbandonDraftLoading: false,
            isAbandonDraftSuccess: true,
            clearCurrentFlow: true,
          ),
        );
      case ApiErrorResult():
        emit(
          state.copyWith(
            isAbandonDraftLoading: false,
            isAbandonDraftSuccess: false,
            failure: result.failure,
          ),
        );
    }
  }
}
