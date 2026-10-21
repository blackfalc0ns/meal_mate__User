import 'package:meal_meat_user/core/errors/failures.dart';
import 'package:meal_meat_user/features/offers/domain/entities/campaign_flow_entity.dart';
import 'package:meal_meat_user/features/offers/domain/entities/campaign_session_entity.dart';

class CampaignSelectionState {
  const CampaignSelectionState({
    this.campaigns = const [],
    this.nextCursor,
    this.listLoading = false,
    this.listFailure,
    this.details,
    this.detailsLoading = false,
    this.failure,
    this.programId,
    this.bundleId,
    this.durationDays,
    this.startDate,
    this.addressId,
    this.promoCode,
    this.quote,
    this.quoteLoading = false,
    this.checkoutLoading = false,
    this.session,
  });
  final List<CampaignListItemEntity> campaigns;
  final String? nextCursor;
  final bool listLoading;
  final Failure? listFailure;
  final CampaignDetailsEntity? details;
  final bool detailsLoading;
  final Failure? failure;
  final String? programId;
  final String? bundleId;
  final int? durationDays;
  final String? startDate;
  final String? addressId;
  final String? promoCode;
  final CampaignQuoteEntity? quote;
  final bool quoteLoading;
  final bool checkoutLoading;
  final CampaignSessionEntity? session;
  bool get canRequestQuote =>
      details?.campaignId?.isNotEmpty == true &&
      details?.canCheckout == true &&
      programId != null &&
      bundleId != null &&
      durationDays != null &&
      startDate?.isNotEmpty == true &&
      addressId?.isNotEmpty == true;
  bool get canCheckout =>
      !checkoutLoading && !quoteLoading && quote?.isUsable == true;
  CampaignSelectionState copyWith({
    List<CampaignListItemEntity>? campaigns,
    String? nextCursor,
    bool clearCursor = false,
    bool? listLoading,
    Failure? listFailure,
    bool clearListFailure = false,
    CampaignDetailsEntity? details,
    bool? detailsLoading,
    Failure? failure,
    bool clearFailure = false,
    String? programId,
    String? bundleId,
    int? durationDays,
    bool clearSelection = false,
    String? startDate,
    String? addressId,
    String? promoCode,
    bool clearPromoCode = false,
    CampaignQuoteEntity? quote,
    bool clearQuote = false,
    bool? quoteLoading,
    bool? checkoutLoading,
    CampaignSessionEntity? session,
    bool clearSession = false,
  }) => CampaignSelectionState(
    campaigns: campaigns ?? this.campaigns,
    nextCursor: clearCursor ? null : nextCursor ?? this.nextCursor,
    listLoading: listLoading ?? this.listLoading,
    listFailure: clearListFailure ? null : listFailure ?? this.listFailure,
    details: details ?? this.details,
    detailsLoading: detailsLoading ?? this.detailsLoading,
    failure: clearFailure ? null : failure ?? this.failure,
    programId: clearSelection ? programId : programId ?? this.programId,
    bundleId: clearSelection ? bundleId : bundleId ?? this.bundleId,
    durationDays: clearSelection
        ? durationDays
        : durationDays ?? this.durationDays,
    startDate: startDate ?? this.startDate,
    addressId: addressId ?? this.addressId,
    promoCode: clearPromoCode ? null : promoCode ?? this.promoCode,
    quote: clearQuote ? null : quote ?? this.quote,
    quoteLoading: quoteLoading ?? this.quoteLoading,
    checkoutLoading: checkoutLoading ?? this.checkoutLoading,
    session: clearSession ? null : session ?? this.session,
  );
}
