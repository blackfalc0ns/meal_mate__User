import 'package:meal_meat_user/core/errors/failures.dart';
import 'package:meal_meat_user/features/offers/domain/entities/offer_entity.dart';

class OffersState {
  const OffersState({
    this.isLoading = false,
    this.isRefreshing = false,
    this.failure,
    this.allOffers = const [],
    this.filteredOffers = const [],
    this.heroOffers = const [],
    this.selectedCategoryIndex = 0,
    this.referralCode,
    this.referralLink,
    this.referralRewardRate,
  });

  final bool isLoading;
  final bool isRefreshing;
  final Failure? failure;
  final List<OfferEntity> allOffers;
  final List<OfferEntity> filteredOffers;
  final List<OfferEntity> heroOffers;
  final int selectedCategoryIndex;
  final String? referralCode;
  final String? referralLink;
  final double? referralRewardRate;

  bool get isEmpty => !isLoading && failure == null && allOffers.isEmpty;

  OffersState copyWith({
    bool? isLoading,
    bool? isRefreshing,
    Failure? failure,
    bool clearFailure = false,
    List<OfferEntity>? allOffers,
    List<OfferEntity>? filteredOffers,
    List<OfferEntity>? heroOffers,
    int? selectedCategoryIndex,
    String? referralCode,
    String? referralLink,
    double? referralRewardRate,
  }) {
    return OffersState(
      isLoading: isLoading ?? this.isLoading,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      failure: clearFailure ? null : (failure ?? this.failure),
      allOffers: allOffers ?? this.allOffers,
      filteredOffers: filteredOffers ?? this.filteredOffers,
      heroOffers: heroOffers ?? this.heroOffers,
      selectedCategoryIndex:
          selectedCategoryIndex ?? this.selectedCategoryIndex,
      referralCode: referralCode ?? this.referralCode,
      referralLink: referralLink ?? this.referralLink,
      referralRewardRate: referralRewardRate ?? this.referralRewardRate,
    );
  }
}
