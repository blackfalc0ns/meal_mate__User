import 'package:meal_meat_user/core/errors/failures.dart';
import 'package:meal_meat_user/features/offers/domain/entities/offer_calendar_entry_entity.dart';
import 'package:meal_meat_user/features/offers/domain/entities/offer_entity.dart';

class OffersState {
  const OffersState({
    this.isLoading = false,
    this.isRefreshing = false,
    this.failure,
    this.allOffers = const [],
    this.filteredOffers = const [],
    this.heroOffers = const [],
    this.savedOffers = const [],
    this.calendarEntries = const [],
    this.selectedCategoryIndex = 0,
    this.referralCode,
    this.referralLink,
    this.referralRewardRate,
    this.serverTimeUtc,
    this.savingOfferIds = const {},
    this.actionFailure,
  });

  final bool isLoading;
  final bool isRefreshing;
  final Failure? failure;
  final List<OfferEntity> allOffers;
  final List<OfferEntity> filteredOffers;
  final List<OfferEntity> heroOffers;
  final List<OfferEntity> savedOffers;
  final List<OfferCalendarEntryEntity> calendarEntries;
  final int selectedCategoryIndex;
  final String? referralCode;
  final String? referralLink;
  final double? referralRewardRate;
  final DateTime? serverTimeUtc;
  final Set<String> savingOfferIds;
  final Failure? actionFailure;

  bool get isEmpty => !isLoading && failure == null && allOffers.isEmpty;

  OffersState copyWith({
    bool? isLoading,
    bool? isRefreshing,
    Failure? failure,
    bool clearFailure = false,
    List<OfferEntity>? allOffers,
    List<OfferEntity>? filteredOffers,
    List<OfferEntity>? heroOffers,
    List<OfferEntity>? savedOffers,
    List<OfferCalendarEntryEntity>? calendarEntries,
    int? selectedCategoryIndex,
    String? referralCode,
    String? referralLink,
    double? referralRewardRate,
    DateTime? serverTimeUtc,
    Set<String>? savingOfferIds,
    Failure? actionFailure,
    bool clearActionFailure = false,
  }) {
    return OffersState(
      isLoading: isLoading ?? this.isLoading,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      failure: clearFailure ? null : (failure ?? this.failure),
      allOffers: allOffers ?? this.allOffers,
      filteredOffers: filteredOffers ?? this.filteredOffers,
      heroOffers: heroOffers ?? this.heroOffers,
      savedOffers: savedOffers ?? this.savedOffers,
      calendarEntries: calendarEntries ?? this.calendarEntries,
      selectedCategoryIndex:
          selectedCategoryIndex ?? this.selectedCategoryIndex,
      referralCode: referralCode ?? this.referralCode,
      referralLink: referralLink ?? this.referralLink,
      referralRewardRate: referralRewardRate ?? this.referralRewardRate,
      serverTimeUtc: serverTimeUtc ?? this.serverTimeUtc,
      savingOfferIds: savingOfferIds ?? this.savingOfferIds,
      actionFailure: clearActionFailure ? null : (actionFailure ?? this.actionFailure),
    );
  }
}
