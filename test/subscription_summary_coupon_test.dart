import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/features/subscription_checkout/data/models/response/subscription_pricing_preview_response_dto.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_coupon_entity.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_readiness_entity.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_summary_entity.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_summary_request_entity.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_restaurant_availability_entity.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/repo/subscription_summary_repository.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/usecase/get_subscription_summary_usecase.dart';
import 'package:meal_meat_user/features/subscription_checkout/presentation/manager/subscription_summary_event.dart';
import 'package:meal_meat_user/features/subscription_checkout/presentation/manager/subscription_summary_state.dart';
import 'package:meal_meat_user/features/subscription_checkout/presentation/manager/subscription_summary_view_model.dart';

class FakeSubscriptionSummaryRepository
    implements SubscriptionSummaryRepository {
  SubscriptionSummaryRequestEntity? lastRequest;
  Completer<ApiResult<SubscriptionSummaryEntity>>? nextResultCompleter;
  ApiResult<SubscriptionSummaryEntity>? immediateResult;

  @override
  Future<ApiResult<SubscriptionPricingPreviewResponseDto>> getPricingPreview(
    SubscriptionSummaryRequestEntity request,
  ) {
    throw UnimplementedError(
      'Pricing preview is outside this summary test fixture.',
    );
  }

  @override
  Future<ApiResult<SubscriptionSummaryEntity>> getSummary(
    SubscriptionSummaryRequestEntity request,
  ) async {
    lastRequest = request;
    if (nextResultCompleter != null) {
      return nextResultCompleter!.future;
    }
    if (immediateResult != null) {
      return immediateResult!;
    }
    throw UnimplementedError();
  }

  @override
  Future<ApiResult<SubscriptionRestaurantAvailabilityEntity>>
  getRestaurantAvailability(SubscriptionSummaryRequestEntity request) {
    throw UnimplementedError();
  }

  @override
  Future<ApiResult<SubscriptionReadinessEntity>> getReadiness(
    SubscriptionSummaryRequestEntity request,
  ) {
    throw UnimplementedError();
  }
}

SubscriptionSummaryEntity buildTestSummary({
  double finalPrice = 100.0,
  double basePrice = 100.0,
  SubscriptionCouponEntity? coupon,
  String startDate = '2026-10-10',
  bool canCheckout = true,
}) {
  return SubscriptionSummaryEntity(
    programId: 'prog-1',
    programNameAr: 'برنامج',
    programNameEn: 'Program',
    bundleId: 'bundle-1',
    bundleNameAr: 'باقة',
    bundleNameEn: 'Bundle',
    restaurantCount: 5,
    tier: 'Basic',
    tierNameAr: 'بيسك',
    tierNameEn: 'Basic',
    durationDays: 26,
    chosenStartDate: startDate,
    startDate: startDate,
    endDate: '2026-11-05',
    serviceDates: const ['2026-10-10'],
    slotRequirements: const [],
    basePrice: basePrice,
    campaignDiscount: 0,
    promoDiscount: coupon?.discountAmount ?? 0,
    walletCredit: 0,
    gatewayFee: 0,
    finalPrice: finalPrice,
    currencyCode: 'KWD',
    canCheckout: canCheckout,
    restaurants: const [],
    termsAcceptanceRequired: false,
    checkoutEndpoint: '/checkout',
    includeFriday: false,
    fridayDays: 0,
    totalServiceDays: 26,
    includes: const SubscriptionSummaryIncludesEntity(
      titleAr: '',
      titleEn: '',
      items: [],
    ),
    coupon: coupon,
  );
}

void main() {
  late FakeSubscriptionSummaryRepository fakeRepo;
  late GetSubscriptionSummaryUseCase useCase;

  const baseRequest = SubscriptionSummaryRequestEntity(
    includeFriday: false,
    durationDays: 26,
    tier: 'Basic',
    bundleId: 'bundle-1',
    programId: 'prog-1',
    startDate: '2026-10-10',
  );

  setUp(() {
    fakeRepo = FakeSubscriptionSummaryRepository();
    useCase = GetSubscriptionSummaryUseCase(fakeRepo);
  });

  group('Subscription Summary Coupon Flow Tests', () {
    test(
      'applying valid coupon sends trimmed uppercase code and updates state with server finalPrice',
      () async {
        final initialSummary = buildTestSummary(finalPrice: 100.0);
        final discountedSummary = buildTestSummary(
          finalPrice: 85.0,
          coupon: const SubscriptionCouponEntity(
            code: 'SAVE15',
            status: SubscriptionCouponStatus.valid,
            rawStatus: 'valid',
            discountAmount: 15.0,
            messageAr: 'تم تطبيق الكوبون بنجاح',
            messageEn: 'Coupon applied successfully',
          ),
        );

        final viewModel = SubscriptionSummaryViewModel.withState(
          useCase,
          initialState: SubscriptionSummaryState(
            summary: initialSummary,
            activeRequest: baseRequest,
          ),
        );

        fakeRepo.immediateResult = ApiSuccessResult(data: discountedSummary);

        viewModel.doIntent(const ApplySubscriptionPromoCodeEvent('  save15  '));
        await pumpEventQueue();

        expect(fakeRepo.lastRequest?.promoCode, equals('save15'));
        expect(viewModel.state.summary?.coupon?.code, equals('SAVE15'));
        expect(viewModel.state.summary?.coupon?.isValid, isTrue);
        expect(viewModel.state.summary?.finalPrice, equals(85.0));
        expect(viewModel.state.activeRequest?.promoCode, equals('SAVE15'));
        expect(viewModel.state.isApplyingCoupon, isFalse);
      },
    );

    test(
      'blank or whitespace promo code triggers remove and cleans up coupon',
      () async {
        final initialSummary = buildTestSummary(
          finalPrice: 85.0,
          coupon: const SubscriptionCouponEntity(
            code: 'SAVE15',
            status: SubscriptionCouponStatus.valid,
            rawStatus: 'valid',
            discountAmount: 15.0,
          ),
        );
        final clearedSummary = buildTestSummary(
          finalPrice: 100.0,
          coupon: null,
        );

        final viewModel = SubscriptionSummaryViewModel.withState(
          useCase,
          initialState: SubscriptionSummaryState(
            summary: initialSummary,
            activeRequest: baseRequest.copyWith(promoCode: 'SAVE15'),
          ),
        );

        fakeRepo.immediateResult = ApiSuccessResult(data: clearedSummary);

        viewModel.doIntent(const ApplySubscriptionPromoCodeEvent('   '));
        await pumpEventQueue();

        expect(fakeRepo.lastRequest?.promoCode, isNull);
        expect(viewModel.state.summary?.coupon, isNull);
        expect(viewModel.state.summary?.finalPrice, equals(100.0));
        expect(viewModel.state.activeRequest?.promoCode, isNull);
        expect(viewModel.state.isApplyingCoupon, isFalse);
      },
    );

    test(
      '200 rejected coupon displays message, server price, without fake Failure or blocking screen',
      () async {
        final initialSummary = buildTestSummary(finalPrice: 100.0);
        final rejectedSummary = buildTestSummary(
          finalPrice: 100.0,
          coupon: const SubscriptionCouponEntity(
            code: 'EXPIRED10',
            status: SubscriptionCouponStatus.expired,
            rawStatus: 'expired',
            discountAmount: 0.0,
            messageAr: 'انتهت صلاحية كود الخصم',
            messageEn: 'This coupon code has expired',
          ),
        );

        final viewModel = SubscriptionSummaryViewModel.withState(
          useCase,
          initialState: SubscriptionSummaryState(
            summary: initialSummary,
            activeRequest: baseRequest,
          ),
        );

        fakeRepo.immediateResult = ApiSuccessResult(data: rejectedSummary);

        viewModel.doIntent(const ApplySubscriptionPromoCodeEvent('EXPIRED10'));
        await pumpEventQueue();

        expect(viewModel.state.failure, isNull);
        expect(
          viewModel.state.summary?.coupon?.status,
          equals(SubscriptionCouponStatus.expired),
        );
        expect(viewModel.state.summary?.coupon?.isValid, isFalse);
        expect(
          viewModel.state.summary?.coupon?.message('ar'),
          equals('انتهت صلاحية كود الخصم'),
        );
        expect(
          viewModel.state.summary?.coupon?.message('en'),
          equals('This coupon code has expired'),
        );
        expect(viewModel.state.activeRequest?.promoCode, isNull);
      },
    );

    test(
      'race condition: stale apply response is ignored when newer request is pending',
      () async {
        final initialSummary = buildTestSummary(finalPrice: 100.0);
        final viewModel = SubscriptionSummaryViewModel.withState(
          useCase,
          initialState: SubscriptionSummaryState(
            summary: initialSummary,
            activeRequest: baseRequest,
          ),
        );

        final firstCompleter =
            Completer<ApiResult<SubscriptionSummaryEntity>>();
        final secondCompleter =
            Completer<ApiResult<SubscriptionSummaryEntity>>();

        fakeRepo.nextResultCompleter = firstCompleter;
        viewModel.doIntent(const ApplySubscriptionPromoCodeEvent('CODE_A'));

        fakeRepo.nextResultCompleter = secondCompleter;
        viewModel.doIntent(const ApplySubscriptionPromoCodeEvent('CODE_B'));

        final summaryB = buildTestSummary(
          finalPrice: 80.0,
          coupon: const SubscriptionCouponEntity(
            code: 'CODE_B',
            status: SubscriptionCouponStatus.valid,
            rawStatus: 'valid',
            discountAmount: 20.0,
          ),
        );
        secondCompleter.complete(ApiSuccessResult(data: summaryB));
        await pumpEventQueue();

        expect(viewModel.state.summary?.coupon?.code, equals('CODE_B'));
        expect(viewModel.state.summary?.finalPrice, equals(80.0));

        final summaryA = buildTestSummary(
          finalPrice: 90.0,
          coupon: const SubscriptionCouponEntity(
            code: 'CODE_A',
            status: SubscriptionCouponStatus.valid,
            rawStatus: 'valid',
            discountAmount: 10.0,
          ),
        );
        firstCompleter.complete(ApiSuccessResult(data: summaryA));
        await pumpEventQueue();

        // State remains B! A was discarded as stale.
        expect(viewModel.state.summary?.coupon?.code, equals('CODE_B'));
        expect(viewModel.state.summary?.finalPrice, equals(80.0));
        expect(viewModel.state.activeRequest?.promoCode, equals('CODE_B'));
      },
    );

    test('changing start date retains currently active promoCode', () async {
      final summary = buildTestSummary(
        finalPrice: 85.0,
        startDate: '2026-10-10',
        coupon: const SubscriptionCouponEntity(
          code: 'ACTIVE_CODE',
          status: SubscriptionCouponStatus.valid,
          rawStatus: 'valid',
          discountAmount: 15.0,
        ),
      );

      final viewModel = SubscriptionSummaryViewModel.withState(
        useCase,
        initialState: SubscriptionSummaryState(
          summary: summary,
          activeRequest: baseRequest.copyWith(promoCode: 'ACTIVE_CODE'),
        ),
      );

      final updatedDateSummary = buildTestSummary(
        finalPrice: 85.0,
        startDate: '2026-10-15',
        coupon: const SubscriptionCouponEntity(
          code: 'ACTIVE_CODE',
          status: SubscriptionCouponStatus.valid,
          rawStatus: 'valid',
          discountAmount: 15.0,
        ),
      );

      fakeRepo.immediateResult = ApiSuccessResult(data: updatedDateSummary);

      viewModel.doIntent(
        const ChangeSubscriptionStartDateEvent(
          startDate: '2026-10-15',
          baseRequest: baseRequest,
        ),
      );
      await pumpEventQueue();

      expect(fakeRepo.lastRequest?.startDate, equals('2026-10-15'));
      expect(fakeRepo.lastRequest?.promoCode, equals('ACTIVE_CODE'));
      expect(viewModel.state.summary?.startDate, equals('2026-10-15'));
    });
  });
}
