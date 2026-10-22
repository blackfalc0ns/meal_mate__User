import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/core/errors/failures.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/usecase/get_eligible_start_dates_usecase.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_summary_request_entity.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/usecase/get_subscription_summary_usecase.dart';
import 'package:meal_meat_user/features/subscription_checkout/presentation/manager/subscription_summary_event.dart';
import 'package:meal_meat_user/features/subscription_checkout/presentation/manager/subscription_summary_state.dart';

@injectable
class SubscriptionSummaryViewModel extends Cubit<SubscriptionSummaryState> {
  SubscriptionSummaryViewModel(
    this._getSubscriptionSummaryUseCase, {
    this.getEligibleStartDatesUseCase,
  }) : super(const SubscriptionSummaryState());

  @visibleForTesting
  SubscriptionSummaryViewModel.withState(
    this._getSubscriptionSummaryUseCase, {
    SubscriptionSummaryState? initialState,
    this.getEligibleStartDatesUseCase,
  }) : super(initialState ?? const SubscriptionSummaryState());

  final GetSubscriptionSummaryUseCase _getSubscriptionSummaryUseCase;
  final GetEligibleStartDatesUseCase? getEligibleStartDatesUseCase;

  int _summaryGeneration = 0;
  int _restaurantsGeneration = 0;

  void doIntent(SubscriptionSummaryEvent event) {
    switch (event) {
      case GetSubscriptionSummaryEvent():
        unawaited(_getSummary(event.request));
      case ChangeSubscriptionStartDateEvent():
        unawaited(
          _changeStartDate(
            startDate: event.startDate,
            baseRequest: event.baseRequest,
          ),
        );
      case ApplySubscriptionPromoCodeEvent():
        unawaited(_applyPromoCode(event.promoCode));
      case RemoveSubscriptionPromoCodeEvent():
        unawaited(_removePromoCode());
      case UpdateSubscriptionCouponDraftEvent():
        emit(state.copyWith(couponDraft: event.draft));
      case LoadMoreSubscriptionSummaryRestaurantsEvent():
        unawaited(_loadMoreRestaurants());
      case RetrySubscriptionSummaryRestaurantsEvent():
        unawaited(_loadMoreRestaurants());
    }
  }

  Future<void> _changeStartDate({
    required String startDate,
    required SubscriptionSummaryRequestEntity baseRequest,
  }) async {
    final currentPromoCode =
        state.activeRequest?.promoCode ?? state.summary?.coupon?.code;
    final updatedRequest = (state.activeRequest ?? baseRequest).copyWith(
      startDate: startDate,
      promoCode: currentPromoCode,
      clearPromoCode: currentPromoCode == null || currentPromoCode.isEmpty,
    );
    await _getSummary(updatedRequest, requireRequestedDate: true);
  }

  Future<void> _getSummary(
    SubscriptionSummaryRequestEntity request, {
    bool requireRequestedDate = false,
  }) async {
    final generation = ++_summaryGeneration;
    final isInitial = state.summary == null;

    emit(
      state.copyWith(
        requiresEligibleStartDate: getEligibleStartDatesUseCase != null,
        includeFriday: request.includeFriday,
        isLoading: isInitial,
        isSummaryRefreshing: !isInitial,
        clearSummary: isInitial,
        clearFailure: true,
        selectedStartDate: !requireRequestedDate && request.startDate.isNotEmpty
            ? request.startDate
            : state.selectedStartDate,
      ),
    );

    final getDates = getEligibleStartDatesUseCase;
    if (getDates != null) {
      final hasCached =
          state.eligibleStartDates.isNotEmpty &&
          state.includeFriday == request.includeFriday &&
          (request.startDate.isEmpty ||
              state.eligibleStartDates.contains(request.startDate));

      if (hasCached) {
        final effectiveStartDate = request.startDate.isNotEmpty
            ? request.startDate
            : (state.selectedStartDate.isNotEmpty
                  ? state.selectedStartDate
                  : (state.eligibleStartDates.firstOrNull ?? ''));
        request = request.copyWith(startDate: effectiveStartDate);
        emit(state.copyWith(selectedStartDate: effectiveStartDate));
      } else {
        final eligibility = await getDates(
          includeFriday: request.includeFriday,
        );
        if (isClosed || generation != _summaryGeneration) return;
        switch (eligibility) {
          case ApiSuccessResult(:final data):
            final first = data.earliestDate;
            if (first == null ||
                (requireRequestedDate && !data.contains(request.startDate))) {
              emit(
                state.copyWith(
                  isLoading: false,
                  isSummaryRefreshing: false,
                  eligibleStartDates: data.dates,
                  failure: Failure(
                    errorMessage: 'subscription.start_dates_unavailable',
                    code: 'subscription.start_dates_unavailable',
                  ),
                ),
              );
              return;
            }
            request = request.copyWith(
              startDate: data.contains(request.startDate)
                  ? request.startDate
                  : first,
            );
            emit(
              state.copyWith(
                eligibleStartDates: data.dates,
                earliestStartDate: first,
                includeFriday: data.includeFriday,
                selectedStartDate: request.startDate,
              ),
            );
          case ApiErrorResult(:final failure):
            emit(
              state.copyWith(
                isLoading: false,
                isSummaryRefreshing: false,
                eligibleStartDates: const [],
                failure: failure,
              ),
            );
            return;
        }
      }
    }
    final result = await _getSubscriptionSummaryUseCase(request);
    if (isClosed || generation != _summaryGeneration) return;

    switch (result) {
      case ApiSuccessResult():
        final coupon = result.data.coupon;
        final approvedPromoCode = coupon != null && coupon.isValid
            ? coupon.code
            : null;

        final effectiveStartDate = result.data.startDate.trim().isNotEmpty
            ? result.data.startDate.trim()
            : (request.startDate.trim().isNotEmpty
                  ? request.startDate.trim()
                  : state.selectedStartDate);

        final activeRequest = request.copyWith(
          startDate: effectiveStartDate,
          promoCode: approvedPromoCode,
          clearPromoCode: approvedPromoCode == null,
          restaurantsPage: 1,
        );

        emit(
          state.copyWith(
            isLoading: false,
            isSummaryRefreshing: false,
            summary: result.data,
            activeRequest: activeRequest,
            selectedStartDate: effectiveStartDate,
            earliestStartDate:
                result.data.earliestStartDate?.trim().isNotEmpty == true
                ? result.data.earliestStartDate!.trim()
                : state.earliestStartDate,
            couponDraft: coupon?.code ?? state.couponDraft,
            clearFailure: true,
            clearAppendFailure: true,
          ),
        );
      case ApiErrorResult():
        emit(
          state.copyWith(
            isLoading: false,
            isSummaryRefreshing: false,
            failure: result.failure,
          ),
        );
    }
  }

  Future<void> _applyPromoCode(String code) async {
    final trimmedCode = code.trim();
    if (trimmedCode.isEmpty) {
      await _removePromoCode();
      return;
    }

    final currentRequest = state.activeRequest;
    if (currentRequest == null) return;

    final requestWithCode = currentRequest.copyWith(
      promoCode: trimmedCode,
      restaurantsPage: 1,
    );
    final generation = ++_summaryGeneration;

    emit(
      state.copyWith(
        isApplyingCoupon: true,
        couponDraft: trimmedCode,
        clearFailure: true,
      ),
    );

    final result = await _getSubscriptionSummaryUseCase(requestWithCode);
    if (isClosed || generation != _summaryGeneration) return;

    switch (result) {
      case ApiSuccessResult():
        final coupon = result.data.coupon;
        final isCouponValid = coupon != null && coupon.isValid;
        final approvedPromoCode = isCouponValid ? coupon.code : null;

        final updatedActiveRequest = currentRequest.copyWith(
          promoCode: approvedPromoCode,
          clearPromoCode: approvedPromoCode == null,
          restaurantsPage: 1,
        );

        emit(
          state.copyWith(
            isApplyingCoupon: false,
            summary: result.data,
            activeRequest: updatedActiveRequest,
            couponDraft: coupon?.code ?? trimmedCode,
            clearFailure: true,
            clearAppendFailure: true,
          ),
        );
      case ApiErrorResult():
        emit(state.copyWith(isApplyingCoupon: false, failure: result.failure));
    }
  }

  Future<void> _removePromoCode() async {
    final currentRequest = state.activeRequest;
    if (currentRequest == null) return;

    final requestWithoutCode = currentRequest.copyWith(
      clearPromoCode: true,
      restaurantsPage: 1,
    );
    final generation = ++_summaryGeneration;

    emit(
      state.copyWith(
        isApplyingCoupon: true,
        couponDraft: '',
        clearFailure: true,
      ),
    );

    final result = await _getSubscriptionSummaryUseCase(requestWithoutCode);
    if (isClosed || generation != _summaryGeneration) return;

    switch (result) {
      case ApiSuccessResult():
        final updatedActiveRequest = currentRequest.copyWith(
          clearPromoCode: true,
          restaurantsPage: 1,
        );

        emit(
          state.copyWith(
            isApplyingCoupon: false,
            summary: result.data,
            activeRequest: updatedActiveRequest,
            clearCouponDraft: true,
            clearFailure: true,
            clearAppendFailure: true,
          ),
        );
      case ApiErrorResult():
        emit(state.copyWith(isApplyingCoupon: false, failure: result.failure));
    }
  }

  Future<void> _loadMoreRestaurants() async {
    final summary = state.summary;
    final pagination = summary?.restaurantsPagination;

    if (summary == null ||
        pagination == null ||
        !pagination.hasNextPage ||
        state.isLoadingMoreRestaurants) {
      return;
    }

    final nextPage = pagination.page + 1;
    final expectedFinalPrice = summary.finalPrice;
    final expectedCanCheckout = summary.canCheckout;
    final expectedCouponCode = summary.coupon?.code;

    final parentSummaryGen = _summaryGeneration;
    final appendGen = ++_restaurantsGeneration;

    final currentRequest = state.activeRequest;
    if (currentRequest == null) return;

    final appendRequest = currentRequest.copyWith(
      restaurantsPage: nextPage,
      restaurantsPageSize: pagination.pageSize,
    );

    emit(
      state.copyWith(isLoadingMoreRestaurants: true, clearAppendFailure: true),
    );

    final result = await _getSubscriptionSummaryUseCase(appendRequest);
    if (isClosed ||
        parentSummaryGen != _summaryGeneration ||
        appendGen != _restaurantsGeneration) {
      return;
    }

    switch (result) {
      case ApiSuccessResult():
        // If pricing or quote changed unexpectedly, update full summary with new quote
        if (result.data.finalPrice != expectedFinalPrice ||
            result.data.canCheckout != expectedCanCheckout ||
            result.data.coupon?.code != expectedCouponCode) {
          emit(
            state.copyWith(
              isLoadingMoreRestaurants: false,
              summary: result.data,
              activeRequest: appendRequest.copyWith(restaurantsPage: 1),
            ),
          );
        } else {
          // Merge restaurants without duplicates
          final existingIds = summary.restaurants
              .map((r) => r.restaurantId)
              .toSet();
          final newRestaurants = result.data.restaurants
              .where((r) => !existingIds.contains(r.restaurantId))
              .toList();
          final mergedRestaurants = [...summary.restaurants, ...newRestaurants];
          final updatedSummary = summary.copyWithRestaurants(
            restaurants: mergedRestaurants,
            restaurantsPagination: result.data.restaurantsPagination,
          );

          emit(
            state.copyWith(
              isLoadingMoreRestaurants: false,
              summary: updatedSummary,
            ),
          );
        }
      case ApiErrorResult():
        emit(
          state.copyWith(
            isLoadingMoreRestaurants: false,
            restaurantsAppendFailure: result.failure,
          ),
        );
    }
  }
}
