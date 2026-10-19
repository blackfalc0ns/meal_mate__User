import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/offer_details/presentation/manager/offer_details_event.dart';
import 'package:meal_meat_user/features/offer_details/presentation/manager/offer_details_state.dart';
import 'package:meal_meat_user/features/offers/domain/entities/offer_eligible_restaurant_entity.dart';
import 'package:meal_meat_user/features/offers/domain/usecase/add_offer_to_calendar_usecase.dart';
import 'package:meal_meat_user/features/offers/domain/usecase/get_customer_offer_details_usecase.dart';
import 'package:meal_meat_user/features/offers/domain/usecase/get_offer_eligible_restaurants_usecase.dart';
import 'package:meal_meat_user/features/offers/domain/usecase/save_offer_usecase.dart';
import 'package:meal_meat_user/features/offers/domain/usecase/unsave_offer_usecase.dart';

@injectable
class OfferDetailsViewModel extends Cubit<OfferDetailsState> {
  OfferDetailsViewModel(
    this._getOfferDetailsUseCase,
    this._saveOfferUseCase,
    this._unsaveOfferUseCase,
    this._getOfferEligibleRestaurantsUseCase,
    this._addOfferToCalendarUseCase,
  ) : super(const OfferDetailsState());

  final GetCustomerOfferDetailsUseCase _getOfferDetailsUseCase;
  final SaveOfferUseCase _saveOfferUseCase;
  final UnsaveOfferUseCase _unsaveOfferUseCase;
  final GetOfferEligibleRestaurantsUseCase _getOfferEligibleRestaurantsUseCase;
  final AddOfferToCalendarUseCase _addOfferToCalendarUseCase;

  void doIntent(OfferDetailsEvent event) {
    switch (event) {
      case LoadOfferDetailsEvent(:final offerId):
        unawaited(_loadOfferDetails(offerId));
      case ToggleSaveOfferDetailEvent():
        unawaited(_toggleSaveOffer());
      case AddReminderToCalendarEvent(:final date):
        unawaited(_addReminder(date));
    }
  }

  Future<void> _loadOfferDetails(String offerId) async {
    if (offerId.isEmpty) {
      return;
    }

    emit(state.copyWith(isLoading: true, clearFailure: true));

    final result = await _getOfferDetailsUseCase(offerId);
    if (isClosed) return;

    switch (result) {
      case ApiSuccessResult(:final data):
        emit(state.copyWith(isLoading: false, offer: data, clearFailure: true));
        // Also fetch eligible restaurants
        final restResult = await _getOfferEligibleRestaurantsUseCase(offerId);
        if (isClosed) return;
        if (restResult is ApiSuccessResult<List<OfferEligibleRestaurantEntity>>) {
          emit(state.copyWith(eligibleRestaurants: restResult.data));
        }
      case ApiErrorResult(:final failure):
        emit(state.copyWith(isLoading: false, failure: failure));
    }
  }

  Future<void> _toggleSaveOffer() async {
    final currentOffer = state.offer;
    if (currentOffer == null || state.isSaving) return;

    final wasSaved = currentOffer.isSaved;
    final nextSaved = !wasSaved;

    // Optimistic update
    emit(
      state.copyWith(
        offer: currentOffer.copyWith(isSaved: nextSaved),
        isSaving: true,
        clearActionFailure: true,
      ),
    );

    final result = nextSaved
        ? await _saveOfferUseCase(currentOffer.id)
        : await _unsaveOfferUseCase(currentOffer.id);
    if (isClosed) return;

    switch (result) {
      case ApiSuccessResult():
        emit(state.copyWith(isSaving: false));
      case ApiErrorResult(:final failure):
        // Rollback
        emit(
          state.copyWith(
            offer: currentOffer.copyWith(isSaved: wasSaved),
            isSaving: false,
            actionFailure: failure,
          ),
        );
    }
  }

  Future<void> _addReminder(String scheduledDate) async {
    final currentOffer = state.offer;
    if (currentOffer == null) return;

    final result = await _addOfferToCalendarUseCase(
      offerId: currentOffer.id,
      scheduledDate: scheduledDate,
    );
    if (isClosed) return;

    switch (result) {
      case ApiSuccessResult():
        emit(state.copyWith(reminderAdded: true));
      case ApiErrorResult(:final failure):
        emit(state.copyWith(actionFailure: failure));
    }
  }
}
