import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/core/address/domain/entities/customer_address_entity.dart';
import 'package:meal_meat_user/features/family_allergies/domain/entities/family_member_allergy_selection.dart';
import 'package:meal_meat_user/features/family_shared/presentation/manager/family_subscription_flow_state.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/entities/family_flow_current_entity.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/entities/family_flow_snapshot_store.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/entities/family_conversion_draft_session.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/usecase/abandon_family_draft_usecase.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/usecase/get_family_flow_current_usecase.dart';

@injectable
class FamilySubscriptionFlowViewModel
    extends Cubit<FamilySubscriptionFlowState> {
  FamilySubscriptionFlowViewModel(
    this._getFamilyFlowCurrentUseCase,
    this._snapshotStore,
    this._abandonFamilyDraftUseCase,
  ) : super(FamilySubscriptionFlowState(flow: _snapshotStore.current));

  final GetFamilyFlowCurrentUseCase _getFamilyFlowCurrentUseCase;
  final FamilyFlowSnapshotStore _snapshotStore;
  final AbandonFamilyDraftUseCase _abandonFamilyDraftUseCase;

  Future<void> abandonDraft() async {
    if (state.isAbandonDraftLoading) return;
    emit(
      state.copyWith(isAbandonDraftLoading: true, isAbandonDraftSuccess: false),
    );
    final result = await _abandonFamilyDraftUseCase();
    if (isClosed) return;
    switch (result) {
      case ApiSuccessResult():
        FamilyConversionDraftSession.clearConvertedFamilyDraft();
        _snapshotStore.clear();
        emit(
          state.copyWith(
            isAbandonDraftLoading: false,
            isAbandonDraftSuccess: true,
            clearFlow: true,
          ),
        );
      case ApiErrorResult(failure: final failure):
        emit(state.copyWith(isAbandonDraftLoading: false, failure: failure));
    }
  }

  Future<void> load({bool forceRefresh = false}) async {
    final cached = _snapshotStore.current;
    if (!forceRefresh && cached != null) {
      final restoredStep =
          cached.currentStep != null && cached.currentStep! >= 0
          ? cached.currentStep!
          : state.currentStep;
      final restoredTarget =
          state.targetMemberId ?? _resolveTargetMember(cached, restoredStep);
      emit(
        state.copyWith(
          flow: cached,
          isLoading: false,
          currentStep: restoredStep,
          targetMemberId: restoredTarget,
        ),
      );
      return;
    }

    emit(state.copyWith(isLoading: true, clearFailure: true));
    final result = await _getFamilyFlowCurrentUseCase();
    if (isClosed) return;

    switch (result) {
      case ApiSuccessResult(data: final flow):
        _snapshotStore.update(flow);
        final restoredStep = flow.currentStep != null && flow.currentStep! >= 0
            ? flow.currentStep!
            : state.currentStep;
        final restoredTarget =
            state.targetMemberId ?? _resolveTargetMember(flow, restoredStep);
        emit(
          state.copyWith(
            isLoading: false,
            flow: flow,
            currentStep: restoredStep,
            targetMemberId: restoredTarget,
          ),
        );
      case ApiErrorResult(failure: final failure):
        emit(state.copyWith(isLoading: false, failure: failure));
    }
  }

  String? _resolveTargetMember(FamilyFlowCurrentEntity flow, int step) {
    final subscribing = flow.members.where((m) => m.subscribeNow).toList();
    if (subscribing.isEmpty) return null;
    switch (step) {
      case 1:
        final incomplete = subscribing.where(
          (m) => m.programId == null || m.programId!.isEmpty,
        );
        return (incomplete.isNotEmpty ? incomplete.first : subscribing.first)
            .memberId;
      case 2:
        final incomplete = subscribing.where(
          (m) =>
              (m.deliveryAddressId == null || m.deliveryAddressId!.isEmpty) &&
              m.deliveryAddress == null,
        );
        return (incomplete.isNotEmpty ? incomplete.first : subscribing.first)
            .memberId;
      case 3:
        final incomplete = subscribing.where((m) => !m.allergiesCompleted);
        return (incomplete.isNotEmpty ? incomplete.first : subscribing.first)
            .memberId;
      default:
        return subscribing.first.memberId;
    }
  }

  void updateFlow(FamilyFlowCurrentEntity flow) {
    _snapshotStore.update(flow);
    emit(state.copyWith(flow: flow));
  }

  void updateMemberAddress(String memberId, CustomerAddressEntity address) {
    _snapshotStore.updateMemberDeliveryAddress(memberId, address);
    if (_snapshotStore.current != null) {
      emit(state.copyWith(flow: _snapshotStore.current));
    }
  }

  void updateMemberAllergies(
    String memberId,
    List<FamilyMemberAllergySelection> allergies,
  ) {
    _snapshotStore.updateMemberAllergies(memberId, allergies);
    if (_snapshotStore.current != null) {
      emit(state.copyWith(flow: _snapshotStore.current));
    }
  }

  void updateMemberProgram(String memberId, String programId) {
    _snapshotStore.updateMemberProgram(memberId, programId);
    if (_snapshotStore.current != null) {
      emit(state.copyWith(flow: _snapshotStore.current));
    }
  }

  void updateMemberDislikedIngredients(
    String memberId,
    List<String> ingredientCodes,
  ) {
    _snapshotStore.updateMemberDislikedIngredients(memberId, ingredientCodes);
    if (_snapshotStore.current != null) {
      emit(state.copyWith(flow: _snapshotStore.current));
    }
  }

  void setStep(int step) {
    if (state.currentStep == step) return;
    emit(state.copyWith(currentStep: step));
  }

  void setTargetMember(String? memberId) {
    if (state.targetMemberId == memberId) return;
    emit(
      state.copyWith(
        targetMemberId: memberId,
        clearTargetMemberId: memberId == null,
      ),
    );
  }

  bool canProceedFromMembers() {
    final members = state.flow?.members ?? [];
    final subscribingMembers = members.where((m) => m.subscribeNow).toList();
    final minMembers = state.flow?.minMembers ?? 1;
    return subscribingMembers.length >= minMembers;
  }

  bool canProceedFromPrograms() {
    final members = (state.flow?.members ?? [])
        .where((m) => m.subscribeNow)
        .toList();
    if (members.isEmpty) return false;
    return members.every((m) => m.programId != null && m.programId!.isNotEmpty);
  }

  bool canProceedFromAddresses() {
    final members = (state.flow?.members ?? [])
        .where((m) => m.subscribeNow)
        .toList();
    if (members.isEmpty) return false;
    return members.every(
      (m) =>
          (m.deliveryAddressId != null && m.deliveryAddressId!.isNotEmpty) ||
          m.deliveryAddress != null,
    );
  }

  bool canProceedFromAllergies() {
    final members = (state.flow?.members ?? [])
        .where((m) => m.subscribeNow)
        .toList();
    if (members.isEmpty) return false;
    return members.every((m) => m.allergiesCompleted);
  }

  bool canProceedTo(int step) {
    switch (step) {
      case 0:
        return true;
      case 1:
        return canProceedFromMembers();
      case 2:
        return canProceedFromMembers() && canProceedFromPrograms();
      case 3:
        return canProceedFromMembers() &&
            canProceedFromPrograms() &&
            canProceedFromAddresses();
      case 4:
      case 5:
        return canProceedFromMembers() &&
            canProceedFromPrograms() &&
            canProceedFromAddresses() &&
            canProceedFromAllergies();
      default:
        return false;
    }
  }

  bool canProceedToNextStep() => canProceedTo(state.currentStep + 1);
}
