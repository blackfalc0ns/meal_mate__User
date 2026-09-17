import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/offers/domain/entities/offer_entity.dart';
import 'package:meal_meat_user/features/offers/domain/usecase/get_available_offers_usecase.dart';
import 'package:meal_meat_user/features/offers/presentation/manager/offers_event.dart';
import 'package:meal_meat_user/features/offers/presentation/manager/offers_state.dart';

@injectable
class OffersViewModel extends Cubit<OffersState> {
  OffersViewModel(this._getAvailableOffersUseCase) : super(const OffersState());

  final GetAvailableOffersUseCase _getAvailableOffersUseCase;

  void doIntent(OffersEvent event) {
    switch (event) {
      case GetOffersEvent():
        _getOffers(isRefresh: false);
      case RefreshOffersEvent():
        _getOffers(isRefresh: true);
      case SelectOfferCategoryEvent(:final index):
        _selectCategory(index);
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
        final heroOffers = data.where((o) => o.bannerImageUrl != null).toList();
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
