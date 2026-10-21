import 'package:meal_meat_user/features/offers/domain/usecase/restore_campaign_checkout_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/errors/failures.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/offers/domain/entities/campaign_flow_entity.dart';
import 'package:meal_meat_user/features/offers/domain/entities/campaign_quote_request_entity.dart';
import 'package:meal_meat_user/features/offers/domain/usecase/get_campaigns_usecase.dart';
import 'package:meal_meat_user/features/offers/domain/usecase/get_campaign_details_usecase.dart';
import 'package:meal_meat_user/features/offers/domain/usecase/get_campaign_quote_usecase.dart';
import 'package:meal_meat_user/features/offers/domain/usecase/create_campaign_checkout_session_usecase.dart';
import 'campaign_selection_state.dart';

@injectable
class CampaignSelectionViewModel extends Cubit<CampaignSelectionState> {
  CampaignSelectionViewModel(
    this._list,
    this._details,
    this._quote,
    this._checkout, {
    this.restoreCampaignCheckoutUseCase,
  }) : super(const CampaignSelectionState());
  final GetCampaignsUseCase _list;
  final GetCampaignDetailsUseCase _details;
  final GetCampaignQuoteUseCase _quote;
  final CreateCampaignCheckoutSessionUseCase _checkout;
  final RestoreCampaignCheckoutUseCase? restoreCampaignCheckoutUseCase;
  int _selectionVersion = 0;
  int _detailsVersion = 0;

  Future<void> loadCampaigns({bool loadMore = false}) async {
    if (state.listLoading || (loadMore && state.nextCursor == null)) return;
    final cursor = loadMore ? state.nextCursor : null;
    emit(state.copyWith(listLoading: true, clearListFailure: true));
    final result = await _list(cursor: cursor);
    if (isClosed) return;
    switch (result) {
      case ApiSuccessResult(:final data):
        final items = <String, CampaignListItemEntity>{};
        if (loadMore) {
          for (final item in state.campaigns) {
            if (item.campaignId != null) items[item.campaignId!] = item;
          }
        }
        for (final item in data.items) {
          if (item.campaignId?.isNotEmpty == true) {
            items[item.campaignId!] = item;
          }
        }
        emit(
          state.copyWith(
            campaigns: items.values.toList(),
            listLoading: false,
            nextCursor: data.nextCursor,
            clearCursor: data.nextCursor == null || data.nextCursor == cursor,
          ),
        );
      case ApiErrorResult(:final failure):
        emit(state.copyWith(listLoading: false, listFailure: failure));
    }
  }

  Future<void> open(String campaignId) async {
    if (state.checkoutLoading) return;
    final generation = ++_detailsVersion;
    ++_selectionVersion;
    emit(
      CampaignSelectionState(
        campaigns: state.campaigns,
        nextCursor: state.nextCursor,
        detailsLoading: true,
      ),
    );
    if (restoreCampaignCheckoutUseCase != null) {
      final restored = await restoreCampaignCheckoutUseCase!();
      if (isClosed || generation != _detailsVersion) return;
      switch (restored) {
        case ApiSuccessResult(:final data):
          if (data != null) {
            emit(state.copyWith(session: data, detailsLoading: false));
            return;
          }
        case ApiErrorResult(:final failure):
          emit(state.copyWith(detailsLoading: false, failure: failure));
          return;
      }
    }
    final result = await _details(campaignId);
    if (isClosed || generation != _detailsVersion) return;
    switch (result) {
      case ApiSuccessResult(:final data):
        emit(state.copyWith(details: data, detailsLoading: false));
        final programs = data.options
            .map((o) => o.programId)
            .whereType<String>()
            .where((id) => id.isNotEmpty)
            .toSet();
        if (programs.length == 1) selectProgram(programs.single);
      case ApiErrorResult(:final failure):
        emit(state.copyWith(detailsLoading: false, failure: failure));
    }
  }

  void selectProgram(String programId) {
    if (state.checkoutLoading || state.programId == programId) return;
    ++_selectionVersion;
    final options =
        state.details?.options
            .where((o) => o.programId == programId)
            .toList() ??
        <CampaignOptionEntity>[];
    final bundles = options
        .map((o) => o.campaignBundleId)
        .whereType<String>()
        .where((id) => id.isNotEmpty)
        .toSet();
    final bundle = bundles.length == 1 ? bundles.single : null;
    final durations = options
        .where((o) => o.campaignBundleId == bundle)
        .map((o) => o.durationDays)
        .whereType<int>()
        .toSet();
    emit(
      state.copyWith(
        clearSelection: true,
        programId: programId,
        bundleId: bundle,
        durationDays: durations.length == 1 ? durations.single : null,
        clearQuote: true,
        quoteLoading: false,
        clearSession: true,
        clearFailure: true,
      ),
    );
  }

  void selectBundle(String bundleId) {
    if (state.checkoutLoading || state.bundleId == bundleId) return;
    final options =
        state.details?.options
            .where(
              (o) =>
                  o.programId == state.programId &&
                  o.campaignBundleId == bundleId,
            )
            .toList() ??
        <CampaignOptionEntity>[];
    if (options.isEmpty) return;
    ++_selectionVersion;
    final durations = options
        .map((o) => o.durationDays)
        .whereType<int>()
        .toSet();
    emit(
      state.copyWith(
        clearSelection: true,
        programId: state.programId,
        bundleId: bundleId,
        durationDays: durations.length == 1 ? durations.single : null,
        clearQuote: true,
        quoteLoading: false,
        clearSession: true,
        clearFailure: true,
      ),
    );
  }

  void selectDuration(int durationDays) {
    if (state.checkoutLoading || state.durationDays == durationDays) return;
    if (state.details?.options.any(
          (o) =>
              o.programId == state.programId &&
              o.campaignBundleId == state.bundleId &&
              o.durationDays == durationDays,
        ) !=
        true) {
      return;
    }
    ++_selectionVersion;
    emit(
      state.copyWith(
        durationDays: durationDays,
        clearQuote: true,
        quoteLoading: false,
        clearSession: true,
        clearFailure: true,
      ),
    );
  }

  void updateContext({
    String? startDate,
    String? addressId,
    String? promoCode,
    bool clearPromoCode = false,
  }) {
    if (state.checkoutLoading) return;
    ++_selectionVersion;
    emit(
      state.copyWith(
        startDate: startDate,
        addressId: addressId,
        promoCode: promoCode,
        clearPromoCode: clearPromoCode || promoCode == '',
        clearQuote: true,
        quoteLoading: false,
        clearSession: true,
        clearFailure: true,
      ),
    );
  }

  Future<void> requestQuote() async {
    if (!state.canRequestQuote || state.checkoutLoading) return;
    final generation = ++_selectionVersion;
    final request = CampaignQuoteRequestEntity(
      campaignId: state.details!.campaignId!,
      programId: state.programId!,
      campaignBundleId: state.bundleId!,
      durationDays: state.durationDays!,
      startDate: state.startDate!,
      addressId: state.addressId!,
      promoCode: state.promoCode,
    );
    emit(
      state.copyWith(
        quoteLoading: true,
        clearQuote: true,
        clearSession: true,
        clearFailure: true,
      ),
    );
    final result = await _quote(request);
    if (isClosed || generation != _selectionVersion) return;
    switch (result) {
      case ApiSuccessResult(:final data):
        emit(state.copyWith(quote: data, quoteLoading: false));
      case ApiErrorResult(:final failure):
        emit(state.copyWith(quoteLoading: false, failure: failure));
    }
  }

  Future<void> checkout() async {
    if (!state.canCheckout || !state.canRequestQuote) return;
    final quote = state.quote!;
    emit(state.copyWith(checkoutLoading: true, clearFailure: true));
    final result = await _checkout(
      campaignId: state.details!.campaignId!,
      bundleId: state.bundleId!,
      durationDays: state.durationDays!,
      quoteId: quote.quoteId,
      expectedFinalPrice: quote.price?.finalPrice,
    );
    if (isClosed) return;
    switch (result) {
      case ApiSuccessResult(:final data):
        if (data.finalCustomerPrice != quote.price?.finalPrice ||
            data.sessionId.isEmpty) {
          emit(
            state.copyWith(
              checkoutLoading: false,
              clearQuote: true,
              failure: Failure(
                errorMessage: 'Campaign.SelectionMismatch',
                code: 'Campaign.SelectionMismatch',
              ),
            ),
          );
        } else {
          emit(state.copyWith(checkoutLoading: false, session: data));
        }
      case ApiErrorResult(:final failure):
        final refresh =
            failure.statusCode == 410 ||
            const {
              'Campaign.QuoteStale',
              'Campaign.SelectionMismatch',
              'campaign.invalid_start_date',
              'Campaign.ScheduleUnavailable',
            }.contains(failure.code);
        emit(
          state.copyWith(
            checkoutLoading: false,
            failure: failure,
            clearQuote: refresh,
          ),
        );
    }
  }
}
