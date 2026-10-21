import 'package:meal_meat_user/core/errors/failures.dart';
import 'package:meal_meat_user/features/offers/domain/entities/campaign_quote_request_entity.dart';
import 'package:meal_meat_user/features/offers/domain/entities/campaign_session_entity.dart';
import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/offers/domain/entities/campaign_flow_entity.dart';
import 'package:meal_meat_user/features/offers/domain/repo/offers_repository.dart';
import 'package:meal_meat_user/features/offers/domain/usecase/get_campaigns_usecase.dart';
import 'package:meal_meat_user/features/offers/domain/usecase/get_campaign_details_usecase.dart';
import 'package:meal_meat_user/features/offers/domain/usecase/get_campaign_quote_usecase.dart';
import 'package:meal_meat_user/features/offers/domain/usecase/create_campaign_checkout_session_usecase.dart';
import 'package:meal_meat_user/features/offers/presentation/manager/campaign_selection_view_model.dart';

class _Repo extends Fake implements OffersRepository {
  Completer<ApiResult<CampaignQuoteEntity>>? deferredQuote;
  @override
  Future<ApiResult<CampaignQuoteEntity>> getCampaignQuote(
    CampaignQuoteRequestEntity request,
  ) async =>
      deferredQuote?.future ??
      const ApiSuccessResult(
        data: CampaignQuoteEntity(
          quoteId: 'q',
          canCheckout: true,
          expiresAtUtc: '2026-11-01T10:00:00Z',
          price: CampaignPriceEntity(finalPrice: 48.125),
        ),
      );
  @override
  Future<ApiResult<CampaignSessionEntity>> createCampaignCheckoutSession({
    String? quoteId,
    String? idempotencyKey,
    double? expectedFinalPrice,
    required String campaignId,
    required String bundleId,
    required int durationDays,
    List<String>? requestedServiceDates,
    String? deliveryGovernorate,
  }) async => ApiErrorResult(
    failure: Failure(
      errorMessage: 'Campaign.SelectionMismatch',
      code: 'Campaign.SelectionMismatch',
      statusCode: 400,
    ),
  );

  @override
  Future<ApiResult<CampaignDetailsEntity>> getCampaignDetails(
    String id, {
    String? bundleId,
    int? durationDays,
  }) async => ApiSuccessResult(
    data: CampaignDetailsEntity(
      campaignId: id,
      canCheckout: true,
      options: const [
        CampaignOptionEntity(
          programId: 'p',
          campaignBundleId: 'cb',
          catalogBundleId: 'catalog',
          durationDays: 6,
        ),
        CampaignOptionEntity(
          programId: 'other',
          campaignBundleId: 'other-cb',
          durationDays: 26,
        ),
      ],
    ),
  );
  @override
  Future<ApiResult<CampaignPageEntity>> getCampaigns({
    int pageSize = 20,
    String? cursor,
  }) async => CampaignPageEntity(
    nextCursor: 'opaque',
    items: [CampaignListItemEntity(campaignId: cursor ?? 'first')],
  ).success;
}

extension on CampaignPageEntity {
  ApiResult<CampaignPageEntity> get success => ApiSuccessResult(data: this);
}

void main() {
  test(
    'changing program clears bundle, duration and quote; list pagination deduplicates',
    () async {
      final repo = _Repo();
      final vm = CampaignSelectionViewModel(
        GetCampaignsUseCase(repo),
        GetCampaignDetailsUseCase(repo),
        GetCampaignQuoteUseCase(repo),
        CreateCampaignCheckoutSessionUseCase(repo),
      );
      await vm.open('c');
      vm.selectProgram('p');
      expect(vm.state.bundleId, 'cb');
      expect(vm.state.durationDays, 6);
      vm.selectProgram('missing');
      expect(vm.state.bundleId, isNull);
      expect(vm.state.durationDays, isNull);
      expect(vm.state.quote, isNull);
      await vm.loadCampaigns();
      await vm.loadCampaigns(loadMore: true);
      await vm.loadCampaigns(loadMore: true);
      expect(vm.state.campaigns.map((item) => item.campaignId), [
        'first',
        'opaque',
      ]);
      await vm.close();
    },
  );

  test(
    'late quote cannot overwrite changed selection and rejected selection needs a fresh quote',
    () async {
      final repo = _Repo();
      final vm = CampaignSelectionViewModel(
        GetCampaignsUseCase(repo),
        GetCampaignDetailsUseCase(repo),
        GetCampaignQuoteUseCase(repo),
        CreateCampaignCheckoutSessionUseCase(repo),
      );
      await vm.open('c');
      vm.selectProgram('p');
      vm.updateContext(startDate: '2026-11-01', addressId: 'address');
      repo.deferredQuote = Completer<ApiResult<CampaignQuoteEntity>>();
      final pending = vm.requestQuote();
      vm.selectProgram('other');
      repo.deferredQuote!.complete(
        const ApiSuccessResult(data: CampaignQuoteEntity(quoteId: 'stale')),
      );
      await pending;
      expect(vm.state.quote, isNull);
      expect(vm.state.quoteLoading, false);
      repo.deferredQuote = null;
      vm.selectProgram('p');
      await vm.requestQuote();
      expect(vm.state.canCheckout, true);
      await vm.checkout();
      expect(vm.state.canCheckout, false);
      expect(vm.state.quote, isNull);
      await vm.close();
    },
  );
}
