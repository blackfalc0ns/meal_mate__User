import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/family_plans/domain/entities/family_checkout_request_entity.dart';
import 'package:meal_meat_user/features/family_plans/domain/entities/family_group_request_entity.dart';
import 'package:meal_meat_user/features/family_plans/domain/entities/family_member_plan_request_entity.dart';
import 'package:meal_meat_user/features/family_plans/domain/entities/family_member_request_entity.dart';
import 'package:meal_meat_user/features/family_plans/domain/usecase/add_family_member_usecase.dart';
import 'package:meal_meat_user/features/family_plans/domain/usecase/checkout_family_subscription_usecase.dart';
import 'package:meal_meat_user/features/family_plans/domain/usecase/delete_family_member_usecase.dart';
import 'package:meal_meat_user/features/family_plans/domain/usecase/get_current_family_group_usecase.dart';
import 'package:meal_meat_user/features/family_plans/domain/usecase/get_family_metadata_usecase.dart';
import 'package:meal_meat_user/features/family_plans/domain/usecase/get_family_payment_methods_usecase.dart';
import 'package:meal_meat_user/features/family_plans/domain/usecase/get_family_summary_usecase.dart';
import 'package:meal_meat_user/features/family_plans/domain/usecase/update_family_group_name_usecase.dart';
import 'package:meal_meat_user/features/family_plans/domain/usecase/update_family_member_plan_usecase.dart';
import 'package:meal_meat_user/features/family_plans/domain/usecase/update_family_member_usecase.dart';
import 'package:meal_meat_user/features/family_plans/presentation/manager/family_plans_event.dart';
import 'package:meal_meat_user/features/family_plans/presentation/manager/family_plans_state.dart';
import 'package:meal_meat_user/features/monthly_plans/domain/usecase/get_subscription_durations_usecase.dart';
import 'package:meal_meat_user/features/monthly_plans/domain/usecase/get_subscription_tier_restaurants_usecase.dart';
import 'package:meal_meat_user/features/monthly_plans/domain/usecase/get_subscription_tiers_usecase.dart';
import 'package:meal_meat_user/features/subscription_programs/domain/usecase/get_subscription_program_bundles_usecase.dart';
import 'package:meal_meat_user/features/subscription_programs/domain/usecase/get_subscription_programs_usecase.dart';

@injectable
class FamilyPlansViewModel extends Cubit<FamilyPlansState> {
  FamilyPlansViewModel(
    this._getFamilyMetadataUseCase,
    this._getCurrentFamilyGroupUseCase,
    this._updateFamilyGroupNameUseCase,
    this._addFamilyMemberUseCase,
    this._updateFamilyMemberUseCase,
    this._deleteFamilyMemberUseCase,
    this._updateFamilyMemberPlanUseCase,
    this._getFamilySummaryUseCase,
    this._getFamilyPaymentMethodsUseCase,
    this._checkoutFamilySubscriptionUseCase,
    this._getSubscriptionProgramsUseCase,
    this._getSubscriptionProgramBundlesUseCase,
    this._getSubscriptionDurationsUseCase,
    this._getSubscriptionTiersUseCase,
    this._getSubscriptionTierRestaurantsUseCase,
  ) : super(const FamilyPlansState());

  final GetFamilyMetadataUseCase _getFamilyMetadataUseCase;
  final GetCurrentFamilyGroupUseCase _getCurrentFamilyGroupUseCase;
  final UpdateFamilyGroupNameUseCase _updateFamilyGroupNameUseCase;
  final AddFamilyMemberUseCase _addFamilyMemberUseCase;
  final UpdateFamilyMemberUseCase _updateFamilyMemberUseCase;
  final DeleteFamilyMemberUseCase _deleteFamilyMemberUseCase;
  final UpdateFamilyMemberPlanUseCase _updateFamilyMemberPlanUseCase;
  final GetFamilySummaryUseCase _getFamilySummaryUseCase;
  final GetFamilyPaymentMethodsUseCase _getFamilyPaymentMethodsUseCase;
  final CheckoutFamilySubscriptionUseCase _checkoutFamilySubscriptionUseCase;
  final GetSubscriptionProgramsUseCase _getSubscriptionProgramsUseCase;
  final GetSubscriptionProgramBundlesUseCase
  _getSubscriptionProgramBundlesUseCase;
  final GetSubscriptionDurationsUseCase _getSubscriptionDurationsUseCase;
  final GetSubscriptionTiersUseCase _getSubscriptionTiersUseCase;
  final GetSubscriptionTierRestaurantsUseCase
  _getSubscriptionTierRestaurantsUseCase;

  void doIntent(FamilyPlansEvent event) {
    switch (event) {
      case GetFamilyMetadataEvent():
        _getMetadata();
      case GetCurrentFamilyGroupEvent():
        _getCurrentGroup();
      case UpdateFamilyGroupNameEvent():
        _updateGroupName(event.request);
      case AddFamilyMemberEvent():
        _addMember(event.request);
      case UpdateFamilyMemberEvent():
        _updateMember(event.memberId, event.request);
      case DeleteFamilyMemberEvent():
        _deleteMember(event.memberId);
      case UpdateFamilyMemberPlanEvent():
        _updateMemberPlan(event.memberId, event.request);
      case GetFamilySummaryEvent():
        _getSummary(event.memberId);
      case GetFamilyPaymentMethodsEvent():
        _getPaymentMethods(event.amount);
      case CheckoutFamilySubscriptionEvent():
        _checkout(event.request);
      case ClearFamilyFeedbackEvent():
        _clearFeedback();
      case GetFamilySubscriptionProgramsEvent():
        _getPrograms();
      case GetFamilySubscriptionBundlesEvent():
        _getBundles(event.programId);
      case GetFamilySubscriptionDurationsEvent():
        _getDurations(
          programId: event.programId,
          bundleId: event.bundleId,
          includeFriday: event.includeFriday,
        );
      case GetFamilySubscriptionTiersEvent():
        _getTiers(
          programId: event.programId,
          bundleId: event.bundleId,
          durationDays: event.durationDays,
          includeFriday: event.includeFriday,
        );
      case GetFamilySubscriptionTierRestaurantsEvent():
        _getTierRestaurants(
          programId: event.programId,
          bundleId: event.bundleId,
          tier: event.tier,
          restaurantIds: event.restaurantIds,
        );
    }
  }

  Future<void> _getMetadata() async {
    emit(
      state.copyWith(
        isMetadataLoading: true,
        isLoading: true,
        clearFailure: true,
        clearErrorMessage: true,
      ),
    );

    final result = await _getFamilyMetadataUseCase();

    switch (result) {
      case ApiSuccessResult():
        emit(
          state.copyWith(
            isMetadataLoading: false,
            isLoading: false,
            metadata: result.data,
            clearFailure: true,
            clearErrorMessage: true,
          ),
        );
      case ApiErrorResult():
        emit(
          state.copyWith(
            isMetadataLoading: false,
            isLoading: false,
            failure: result.failure,
            errorMessage: result.failure.errorMessage,
          ),
        );
    }
  }

  Future<void> _getCurrentGroup() async {
    emit(
      state.copyWith(
        isGroupLoading: true,
        isLoading: true,
        clearFailure: true,
        clearErrorMessage: true,
      ),
    );

    final result = await _getCurrentFamilyGroupUseCase();

    switch (result) {
      case ApiSuccessResult():
        emit(
          state.copyWith(
            isGroupLoading: false,
            isLoading: false,
            currentGroup: result.data,
            clearFailure: true,
            clearErrorMessage: true,
          ),
        );
      case ApiErrorResult():
        emit(
          state.copyWith(
            isGroupLoading: false,
            isLoading: false,
            failure: result.failure,
            errorMessage: result.failure.errorMessage,
          ),
        );
    }
  }

  Future<void> _updateGroupName(FamilyGroupRequestEntity request) async {
    emit(
      state.copyWith(
        isGroupLoading: true,
        isLoading: true,
        isSuccess: false,
        clearFailure: true,
        clearErrorMessage: true,
      ),
    );

    final result = await _updateFamilyGroupNameUseCase(request);

    switch (result) {
      case ApiSuccessResult():
        emit(
          state.copyWith(
            isGroupLoading: false,
            isLoading: false,
            isSuccess: true,
            currentGroup: result.data,
            clearFailure: true,
            clearErrorMessage: true,
          ),
        );
      case ApiErrorResult():
        emit(
          state.copyWith(
            isGroupLoading: false,
            isLoading: false,
            isSuccess: false,
            failure: result.failure,
            errorMessage: result.failure.errorMessage,
          ),
        );
    }
  }

  Future<void> _addMember(FamilyMemberRequestEntity request) async {
    emit(
      state.copyWith(
        isMemberActionLoading: true,
        isLoading: true,
        isSuccess: false,
        clearFailure: true,
        clearErrorMessage: true,
      ),
    );

    final result = await _addFamilyMemberUseCase(request);

    switch (result) {
      case ApiSuccessResult():
        emit(
          state.copyWith(
            isMemberActionLoading: false,
            isLoading: false,
            isSuccess: true,
            currentGroup: result.data,
            clearFailure: true,
            clearErrorMessage: true,
          ),
        );
      case ApiErrorResult():
        emit(
          state.copyWith(
            isMemberActionLoading: false,
            isLoading: false,
            isSuccess: false,
            failure: result.failure,
            errorMessage: result.failure.errorMessage,
          ),
        );
    }
  }

  Future<void> _updateMember(
    String memberId,
    FamilyMemberRequestEntity request,
  ) async {
    emit(
      state.copyWith(
        isMemberActionLoading: true,
        isLoading: true,
        isSuccess: false,
        clearFailure: true,
        clearErrorMessage: true,
      ),
    );

    final result = await _updateFamilyMemberUseCase(
      memberId: memberId,
      request: request,
    );

    switch (result) {
      case ApiSuccessResult():
        emit(
          state.copyWith(
            isMemberActionLoading: false,
            isLoading: false,
            isSuccess: true,
            currentGroup: result.data,
            clearFailure: true,
            clearErrorMessage: true,
          ),
        );
      case ApiErrorResult():
        emit(
          state.copyWith(
            isMemberActionLoading: false,
            isLoading: false,
            isSuccess: false,
            failure: result.failure,
            errorMessage: result.failure.errorMessage,
          ),
        );
    }
  }

  Future<void> _deleteMember(String memberId) async {
    emit(
      state.copyWith(
        isMemberActionLoading: true,
        isLoading: true,
        isSuccess: false,
        clearFailure: true,
        clearErrorMessage: true,
      ),
    );

    final result = await _deleteFamilyMemberUseCase(memberId);

    switch (result) {
      case ApiSuccessResult():
        emit(
          state.copyWith(
            isMemberActionLoading: false,
            isLoading: false,
            isSuccess: true,
            currentGroup: result.data,
            clearFailure: true,
            clearErrorMessage: true,
          ),
        );
      case ApiErrorResult():
        emit(
          state.copyWith(
            isMemberActionLoading: false,
            isLoading: false,
            isSuccess: false,
            failure: result.failure,
            errorMessage: result.failure.errorMessage,
          ),
        );
    }
  }

  Future<void> _updateMemberPlan(
    String memberId,
    FamilyMemberPlanRequestEntity request,
  ) async {
    emit(
      state.copyWith(
        isMemberActionLoading: true,
        isLoading: true,
        isSuccess: false,
        clearFailure: true,
        clearErrorMessage: true,
      ),
    );

    final result = await _updateFamilyMemberPlanUseCase(
      memberId: memberId,
      request: request,
    );

    switch (result) {
      case ApiSuccessResult():
        emit(
          state.copyWith(
            isMemberActionLoading: false,
            isLoading: false,
            isSuccess: true,
            currentGroup: result.data,
            clearFailure: true,
            clearErrorMessage: true,
          ),
        );
      case ApiErrorResult():
        emit(
          state.copyWith(
            isMemberActionLoading: false,
            isLoading: false,
            isSuccess: false,
            failure: result.failure,
            errorMessage: result.failure.errorMessage,
          ),
        );
    }
  }

  Future<void> _getSummary(String? memberId) async {
    emit(
      state.copyWith(
        isSummaryLoading: true,
        isLoading: true,
        clearFailure: true,
        clearErrorMessage: true,
      ),
    );

    final result = await _getFamilySummaryUseCase(memberId: memberId);

    switch (result) {
      case ApiSuccessResult():
        emit(
          state.copyWith(
            isSummaryLoading: false,
            isLoading: false,
            summary: result.data,
            clearFailure: true,
            clearErrorMessage: true,
          ),
        );
      case ApiErrorResult():
        emit(
          state.copyWith(
            isSummaryLoading: false,
            isLoading: false,
            failure: result.failure,
            errorMessage: result.failure.errorMessage,
          ),
        );
    }
  }

  Future<void> _getPaymentMethods(double amount) async {
    emit(
      state.copyWith(
        isPaymentMethodsLoading: true,
        isLoading: true,
        clearFailure: true,
        clearErrorMessage: true,
      ),
    );

    final result = await _getFamilyPaymentMethodsUseCase(amount);

    switch (result) {
      case ApiSuccessResult():
        emit(
          state.copyWith(
            isPaymentMethodsLoading: false,
            isLoading: false,
            paymentMethods: result.data,
            clearFailure: true,
            clearErrorMessage: true,
          ),
        );
      case ApiErrorResult():
        emit(
          state.copyWith(
            isPaymentMethodsLoading: false,
            isLoading: false,
            failure: result.failure,
            errorMessage: result.failure.errorMessage,
          ),
        );
    }
  }

  Future<void> _checkout(FamilyCheckoutRequestEntity request) async {
    emit(
      state.copyWith(
        isCheckoutLoading: true,
        isLoading: true,
        isSuccess: false,
        clearCheckoutResult: true,
        clearFailure: true,
        clearErrorMessage: true,
      ),
    );

    final result = await _checkoutFamilySubscriptionUseCase(request);

    switch (result) {
      case ApiSuccessResult():
        emit(
          state.copyWith(
            isCheckoutLoading: false,
            isLoading: false,
            isSuccess: true,
            checkoutResult: result.data,
            clearFailure: true,
            clearErrorMessage: true,
          ),
        );
      case ApiErrorResult():
        emit(
          state.copyWith(
            isCheckoutLoading: false,
            isLoading: false,
            isSuccess: false,
            failure: result.failure,
            errorMessage: result.failure.errorMessage,
          ),
        );
    }
  }

  Future<void> _getPrograms() async {
    emit(
      state.copyWith(
        isProgramsLoading: true,
        isLoading: true,
        clearFailure: true,
        clearErrorMessage: true,
      ),
    );

    final result = await _getSubscriptionProgramsUseCase();

    switch (result) {
      case ApiSuccessResult():
        emit(
          state.copyWith(
            isProgramsLoading: false,
            isLoading: false,
            programs: result.data,
            clearFailure: true,
            clearErrorMessage: true,
          ),
        );
      case ApiErrorResult():
        emit(
          state.copyWith(
            isProgramsLoading: false,
            isLoading: false,
            failure: result.failure,
            errorMessage: result.failure.errorMessage,
          ),
        );
    }
  }

  Future<void> _getBundles(String programId) async {
    emit(
      state.copyWith(
        isBundlesLoading: true,
        isLoading: true,
        clearFailure: true,
        clearErrorMessage: true,
      ),
    );

    final result = await _getSubscriptionProgramBundlesUseCase(programId);

    switch (result) {
      case ApiSuccessResult():
        emit(
          state.copyWith(
            isBundlesLoading: false,
            isLoading: false,
            bundles: result.data,
            clearFailure: true,
            clearErrorMessage: true,
          ),
        );
      case ApiErrorResult():
        emit(
          state.copyWith(
            isBundlesLoading: false,
            isLoading: false,
            failure: result.failure,
            errorMessage: result.failure.errorMessage,
          ),
        );
    }
  }

  Future<void> _getDurations({
    required String programId,
    required String bundleId,
    required bool includeFriday,
  }) async {
    emit(
      state.copyWith(
        isDurationsLoading: true,
        isLoading: true,
        clearFailure: true,
        clearErrorMessage: true,
      ),
    );

    final result = await _getSubscriptionDurationsUseCase(
      programId: programId,
      bundleId: bundleId,
      includeFriday: includeFriday,
    );

    switch (result) {
      case ApiSuccessResult():
        emit(
          state.copyWith(
            isDurationsLoading: false,
            isLoading: false,
            durations: result.data,
            clearFailure: true,
            clearErrorMessage: true,
          ),
        );
      case ApiErrorResult():
        emit(
          state.copyWith(
            isDurationsLoading: false,
            isLoading: false,
            failure: result.failure,
            errorMessage: result.failure.errorMessage,
          ),
        );
    }
  }

  Future<void> _getTiers({
    required String programId,
    required String bundleId,
    required int? durationDays,
    required bool includeFriday,
  }) async {
    emit(
      state.copyWith(
        isTiersLoading: true,
        isLoading: true,
        clearFailure: true,
        clearErrorMessage: true,
      ),
    );

    final result = await _getSubscriptionTiersUseCase(
      programId: programId,
      bundleId: bundleId,
      durationDays: durationDays,
      includeFriday: includeFriday,
    );

    switch (result) {
      case ApiSuccessResult():
        emit(
          state.copyWith(
            isTiersLoading: false,
            isLoading: false,
            tiers: result.data,
            clearFailure: true,
            clearErrorMessage: true,
          ),
        );
      case ApiErrorResult():
        emit(
          state.copyWith(
            isTiersLoading: false,
            isLoading: false,
            failure: result.failure,
            errorMessage: result.failure.errorMessage,
          ),
        );
    }
  }

  Future<void> _getTierRestaurants({
    required String programId,
    required String bundleId,
    required String tier,
    required List<String> restaurantIds,
  }) async {
    emit(
      state.copyWith(
        isRestaurantsLoading: true,
        isLoading: true,
        clearFailure: true,
        clearErrorMessage: true,
      ),
    );

    final result = await _getSubscriptionTierRestaurantsUseCase(
      programId: programId,
      bundleId: bundleId,
      tier: tier,
      restaurantIds: restaurantIds,
    );

    switch (result) {
      case ApiSuccessResult():
        emit(
          state.copyWith(
            isRestaurantsLoading: false,
            isLoading: false,
            restaurants: result.data,
            clearFailure: true,
            clearErrorMessage: true,
          ),
        );
      case ApiErrorResult():
        emit(
          state.copyWith(
            isRestaurantsLoading: false,
            isLoading: false,
            failure: result.failure,
            errorMessage: result.failure.errorMessage,
          ),
        );
    }
  }

  void _clearFeedback() {
    emit(
      state.copyWith(
        isSuccess: false,
        clearFailure: true,
        clearErrorMessage: true,
      ),
    );
  }
}
