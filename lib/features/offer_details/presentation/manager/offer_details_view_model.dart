import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/offers/domain/usecase/get_customer_offer_details_usecase.dart';
import 'package:meal_meat_user/features/offer_details/presentation/manager/offer_details_event.dart';
import 'package:meal_meat_user/features/offer_details/presentation/manager/offer_details_state.dart';

@injectable
class OfferDetailsViewModel extends Cubit<OfferDetailsState> {
  OfferDetailsViewModel(this._getOfferDetailsUseCase)
    : super(const OfferDetailsState());

  final GetCustomerOfferDetailsUseCase _getOfferDetailsUseCase;

  void doIntent(OfferDetailsEvent event) {
    switch (event) {
      case LoadOfferDetailsEvent(:final offerId):
        _loadOfferDetails(offerId);
    }
  }

  Future<void> _loadOfferDetails(String offerId) async {
    if (offerId.isEmpty) {
      // If no ID passed, stay with default/fake or empty state
      return;
    }

    emit(state.copyWith(isLoading: true, clearFailure: true));

    final result = await _getOfferDetailsUseCase(offerId);

    switch (result) {
      case ApiSuccessResult(:final data):
        emit(state.copyWith(isLoading: false, offer: data, clearFailure: true));
      case ApiErrorResult(:final failure):
        emit(state.copyWith(isLoading: false, failure: failure));
    }
  }
}
