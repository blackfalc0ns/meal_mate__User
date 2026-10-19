import 'package:meal_meat_user/core/errors/failures.dart';
import 'package:meal_meat_user/features/offers/domain/entities/offer_eligible_restaurant_entity.dart';
import 'package:meal_meat_user/features/offers/domain/entities/offer_entity.dart';

class OfferDetailsState {
  const OfferDetailsState({
    this.isLoading = false,
    this.failure,
    this.offer,
    this.eligibleRestaurants = const [],
    this.isSaving = false,
    this.actionFailure,
    this.reminderAdded = false,
  });

  final bool isLoading;
  final Failure? failure;
  final OfferEntity? offer;
  final List<OfferEligibleRestaurantEntity> eligibleRestaurants;
  final bool isSaving;
  final Failure? actionFailure;
  final bool reminderAdded;

  OfferDetailsState copyWith({
    bool? isLoading,
    Failure? failure,
    bool clearFailure = false,
    OfferEntity? offer,
    List<OfferEligibleRestaurantEntity>? eligibleRestaurants,
    bool? isSaving,
    Failure? actionFailure,
    bool clearActionFailure = false,
    bool? reminderAdded,
  }) {
    return OfferDetailsState(
      isLoading: isLoading ?? this.isLoading,
      failure: clearFailure ? null : (failure ?? this.failure),
      offer: offer ?? this.offer,
      eligibleRestaurants: eligibleRestaurants ?? this.eligibleRestaurants,
      isSaving: isSaving ?? this.isSaving,
      actionFailure: clearActionFailure ? null : (actionFailure ?? this.actionFailure),
      reminderAdded: reminderAdded ?? this.reminderAdded,
    );
  }
}
