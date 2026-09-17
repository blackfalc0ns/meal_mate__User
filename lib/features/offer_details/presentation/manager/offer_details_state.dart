import 'package:meal_meat_user/core/network/failures.dart';
import 'package:meal_meat_user/features/offers/domain/entities/offer_entity.dart';

class OfferDetailsState {
  const OfferDetailsState({this.isLoading = false, this.failure, this.offer});

  final bool isLoading;
  final Failure? failure;
  final OfferEntity? offer;

  OfferDetailsState copyWith({
    bool? isLoading,
    Failure? failure,
    bool clearFailure = false,
    OfferEntity? offer,
  }) {
    return OfferDetailsState(
      isLoading: isLoading ?? this.isLoading,
      failure: clearFailure ? null : (failure ?? this.failure),
      offer: offer ?? this.offer,
    );
  }
}
