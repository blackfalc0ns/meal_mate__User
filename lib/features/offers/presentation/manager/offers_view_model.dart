import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/offers/domain/entities/offer_calendar_entry_entity.dart';
import 'package:meal_meat_user/features/offers/domain/entities/offer_entity.dart';
import 'package:meal_meat_user/features/offers/domain/usecase/get_available_offers_usecase.dart';
import 'package:meal_meat_user/features/offers/domain/usecase/get_offer_calendar_usecase.dart';
import 'package:meal_meat_user/features/offers/domain/usecase/get_offers_hub_usecase.dart';
import 'package:meal_meat_user/features/offers/domain/usecase/get_saved_offers_usecase.dart';
import 'package:meal_meat_user/features/offers/domain/usecase/save_offer_usecase.dart';
import 'package:meal_meat_user/features/offers/domain/usecase/unsave_offer_usecase.dart';
import 'package:meal_meat_user/features/offers/presentation/manager/offers_event.dart';
import 'package:meal_meat_user/features/offers/presentation/manager/offers_state.dart';
import 'package:meal_meat_user/features/wallet/domain/entities/customer_wallet_entity.dart';
import 'package:meal_meat_user/features/wallet/domain/usecase/get_customer_referral_summary_usecase.dart';

@injectable
class OffersViewModel extends Cubit<OffersState> {
  OffersViewModel(
    this._getAvailableOffersUseCase,
    this._getOffersHubUseCase,
    this._getSavedOffersUseCase,
    this._saveOfferUseCase,
    this._unsaveOfferUseCase,
    this._getOfferCalendarUseCase, {
    this.getCustomerReferralSummaryUseCase,
  }) : super(const OffersState());

  final GetAvailableOffersUseCase _getAvailableOffersUseCase;
  final GetOffersHubUseCase _getOffersHubUseCase;
  final GetSavedOffersUseCase _getSavedOffersUseCase;
  final SaveOfferUseCase _saveOfferUseCase;
  final UnsaveOfferUseCase _unsaveOfferUseCase;
  final GetOfferCalendarUseCase _getOfferCalendarUseCase;
  final GetCustomerReferralSummaryUseCase? getCustomerReferralSummaryUseCase;

  void doIntent(OffersEvent event) {
    switch (event) {
      case GetOffersEvent():
        unawaited(_getOffers(isRefresh: false));
      case RefreshOffersEvent():
        unawaited(_getOffers(isRefresh: true));
      case SelectOfferCategoryEvent(:final index):
        _selectCategory(index);
      case ToggleSaveOfferEvent(:final offerId):
        unawaited(_toggleSaveOffer(offerId));
      case LoadOffersHubEvent():
        unawaited(_loadOffersHub());
      case LoadSavedOffersEvent():
        unawaited(_loadSavedOffers());
      case LoadOfferCalendarEvent():
        unawaited(_loadOfferCalendar());
    }
  }

  Future<void> _getOffers({required bool isRefresh}) async {
    if (isRefresh) {
      emit(state.copyWith(isRefreshing: true, clearFailure: true));
    } else {
      emit(state.copyWith(isLoading: true, clearFailure: true));
    }

    final result = await _getAvailableOffersUseCase();

    switch (result) {
      case ApiSuccessResult(:final data):
        final heroOffers =
            data.where((o) => o.bannerImageUrl != null).toList();
        final heroList = heroOffers.isNotEmpty
            ? heroOffers
            : (data.isNotEmpty ? [data.first] : <OfferEntity>[]);
        final filtered = _filterOffers(data, state.selectedCategoryIndex);

        emit(
          state.copyWith(
            isLoading: false,
            isRefreshing: false,
            allOffers: data,
            filteredOffers: filtered,
            heroOffers: heroList,
            clearFailure: true,
          ),
        );
      case ApiErrorResult(:final failure):
        emit(
          state.copyWith(
            isLoading: false,
            isRefreshing: false,
            failure: failure,
          ),
        );
    }
  }

  Future<void> _loadOffersHub() async {
    emit(state.copyWith(isLoading: true, clearFailure: true));
    final result = await _getOffersHubUseCase();
    switch (result) {
      case ApiSuccessResult(:final data):
        final heroList = data.heroOffers.isNotEmpty
            ? data.heroOffers
            : (data.availableOffers.isNotEmpty ? [data.availableOffers.first] : <OfferEntity>[]);
        final filtered = _filterOffers(data.availableOffers, state.selectedCategoryIndex);
        emit(
          state.copyWith(
            isLoading: false,
            allOffers: data.availableOffers,
            filteredOffers: filtered,
            heroOffers: heroList,
            savedOffers: data.savedOffers,
            serverTimeUtc: data.serverTimeUtc,
            clearFailure: true,
          ),
        );
        final referralUseCase = getCustomerReferralSummaryUseCase;
        if (referralUseCase != null) {
          final referralRes = await referralUseCase();
          if (referralRes is ApiSuccessResult<CustomerReferralEntity>) {
            emit(
              state.copyWith(
                referralCode: referralRes.data.code,
                referralLink: referralRes.data.shareUrl,
                referralRewardRate: referralRes.data.rewardPercentage,
              ),
            );
          }
        }
      case ApiErrorResult(:final failure):
        emit(state.copyWith(isLoading: false, failure: failure));
    }
  }

  Future<void> _loadSavedOffers() async {
    final result = await _getSavedOffersUseCase();
    if (result is ApiSuccessResult<List<OfferEntity>>) {
      emit(state.copyWith(savedOffers: result.data));
    }
  }

  Future<void> _loadOfferCalendar() async {
    final result = await _getOfferCalendarUseCase();
    if (result is ApiSuccessResult<List<OfferCalendarEntryEntity>>) {
      emit(state.copyWith(calendarEntries: result.data));
    }
  }

  Future<void> _toggleSaveOffer(String offerId) async {
    if (state.savingOfferIds.contains(offerId)) return;

    final targetIndex = state.allOffers.indexWhere((o) => o.id == offerId);
    if (targetIndex < 0) return;

    final targetOffer = state.allOffers[targetIndex];
    final wasSaved = targetOffer.isSaved;
    final nextSaved = !wasSaved;

    // Optimistic update
    final updatedList = List<OfferEntity>.from(state.allOffers);
    updatedList[targetIndex] = targetOffer.copyWith(isSaved: nextSaved);

    final updatedFiltered = _filterOffers(updatedList, state.selectedCategoryIndex);
    final updatedHero = state.heroOffers.map((o) => o.id == offerId ? o.copyWith(isSaved: nextSaved) : o).toList();

    emit(
      state.copyWith(
        allOffers: updatedList,
        filteredOffers: updatedFiltered,
        heroOffers: updatedHero,
        savingOfferIds: {...state.savingOfferIds, offerId},
        clearActionFailure: true,
      ),
    );

    final result = nextSaved
        ? await _saveOfferUseCase(offerId)
        : await _unsaveOfferUseCase(offerId);

    final remainingSavingIds = Set<String>.from(state.savingOfferIds)..remove(offerId);

    switch (result) {
      case ApiSuccessResult():
        emit(state.copyWith(savingOfferIds: remainingSavingIds));
      case ApiErrorResult(:final failure):
        // Rollback
        final rollbackList = List<OfferEntity>.from(state.allOffers);
        final rbIndex = rollbackList.indexWhere((o) => o.id == offerId);
        if (rbIndex >= 0) {
          rollbackList[rbIndex] = targetOffer.copyWith(isSaved: wasSaved);
        }
        final rollbackFiltered = _filterOffers(rollbackList, state.selectedCategoryIndex);
        final rollbackHero = state.heroOffers.map((o) => o.id == offerId ? o.copyWith(isSaved: wasSaved) : o).toList();

        emit(
          state.copyWith(
            allOffers: rollbackList,
            filteredOffers: rollbackFiltered,
            heroOffers: rollbackHero,
            savingOfferIds: remainingSavingIds,
            actionFailure: failure,
          ),
        );
    }
  }

  void _selectCategory(int index) {
    final filtered = _filterOffers(state.allOffers, index);
    emit(
      state.copyWith(selectedCategoryIndex: index, filteredOffers: filtered),
    );
  }

  List<OfferEntity> _filterOffers(List<OfferEntity> list, int categoryIndex) {
    return switch (categoryIndex) {
      1 =>
        list
            .where(
              (o) =>
                  (o.discountRate != null && o.discountRate! > 0) ||
                  (o.discountAmount != null && o.discountAmount! > 0),
            )
            .toList(),
      2 =>
        list
            .where((o) => o.campaignId != null || o.restaurantIds.isNotEmpty)
            .toList(),
      3 =>
        list
            .where(
              (o) => o.minSubscriptionDays != null || o.programIds.isNotEmpty,
            )
            .toList(),
      _ => list,
    };
  }
}
