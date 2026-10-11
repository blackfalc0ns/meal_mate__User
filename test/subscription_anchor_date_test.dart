import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_coupon_entity.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_readiness_entity.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_summary_entity.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_summary_request_entity.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_restaurant_availability_entity.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/repo/subscription_summary_repository.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/usecase/get_subscription_summary_usecase.dart';
import 'package:meal_meat_user/features/subscription_checkout/presentation/manager/subscription_summary_event.dart';
import 'package:meal_meat_user/features/subscription_checkout/presentation/manager/subscription_summary_view_model.dart';

class RecordingSubscriptionSummaryRepository
    implements SubscriptionSummaryRepository {
  final List<SubscriptionSummaryRequestEntity> recordedRequests = [];
  SubscriptionSummaryEntity Function(SubscriptionSummaryRequestEntity request)?
  responder;

  @override
  Future<ApiResult<SubscriptionSummaryEntity>> getSummary(
    SubscriptionSummaryRequestEntity request,
  ) async {
    recordedRequests.add(request);
    if (responder != null) {
      return ApiSuccessResult(data: responder!(request));
    }
    throw UnimplementedError('responder not set');
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

SubscriptionSummaryEntity buildTestSummaryWithServerFirstDelivery({
  required String chosenAnchorDate,
  required String serverFirstDeliveryDate,
  SubscriptionCouponEntity? coupon,
  double finalPrice = 100.0,
}) {
  return SubscriptionSummaryEntity(
    programId: 'prog-1',
    programNameAr: 'برنامج تجريبي',
    programNameEn: 'Test Program',
    bundleId: 'bundle-1',
    bundleNameAr: 'باقة تجريبية',
    bundleNameEn: 'Test Bundle',
    restaurantCount: 5,
    tier: 'Basic',
    tierNameAr: 'بيسك',
    tierNameEn: 'Basic',
    durationDays: 26,
    chosenStartDate: chosenAnchorDate,
    startDate: serverFirstDeliveryDate,
    endDate: '2026-11-05',
    serviceDates: [serverFirstDeliveryDate],
    slotRequirements: const [],
    basePrice: 100.0,
    campaignDiscount: 0,
    promoDiscount: coupon?.discountAmount ?? 0,
    walletCredit: 0,
    gatewayFee: 0,
    finalPrice: finalPrice,
    currencyCode: 'KWD',
    canCheckout: true,
    restaurants: const [],
    termsAcceptanceRequired: false,
    checkoutEndpoint: '/api/v1/customer/subscriptions/checkout',
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
  late RecordingSubscriptionSummaryRepository repository;
  late GetSubscriptionSummaryUseCase useCase;
  late SubscriptionSummaryViewModel viewModel;

  setUp(() {
    repository = RecordingSubscriptionSummaryRepository();
    useCase = GetSubscriptionSummaryUseCase(repository);
    viewModel = SubscriptionSummaryViewModel(useCase);
  });

  tearDown(() {
    viewModel.close();
  });

  group('Subscription Anchor Date Preservation Tests', () {
    test(
      'chosen anchor date (2026-10-08) is preserved in activeRequest & selectedStartDate when server returns first delivery (2026-10-11)',
      () async {
        repository.responder = (req) => buildTestSummaryWithServerFirstDelivery(
          chosenAnchorDate: '2026-10-08',
          serverFirstDeliveryDate: '2026-10-11',
        );

        const initialRequest = SubscriptionSummaryRequestEntity(
          programId: 'prog-1',
          bundleId: 'bundle-1',
          tier: 'Basic',
          durationDays: 26,
          startDate: '2026-10-08',
          includeFriday: false,
        );

        viewModel.doIntent(const GetSubscriptionSummaryEvent(initialRequest));
        await pumpEventQueue();

        expect(
          viewModel.state.selectedStartDate,
          '2026-10-08',
          reason: 'selectedStartDate must remain the customer anchor date',
        );
        expect(
          viewModel.state.activeRequest?.startDate,
          '2026-10-08',
          reason: 'activeRequest.startDate must remain 2026-10-08',
        );
        expect(
          viewModel.state.summary?.startDate,
          '2026-10-11',
          reason:
              'summary.startDate reflects server first delivery for UI display',
        );
      },
    );

    test(
      'subsequent actions (apply coupon, remove coupon) continue to send anchor date (2026-10-08), NOT 2026-10-11',
      () async {
        repository.responder = (req) => buildTestSummaryWithServerFirstDelivery(
          chosenAnchorDate: '2026-10-08',
          serverFirstDeliveryDate: '2026-10-11',
          coupon: req.promoCode == 'SAVE10'
              ? const SubscriptionCouponEntity(
                  code: 'SAVE10',
                  status: SubscriptionCouponStatus.valid,
                  rawStatus: 'valid',
                  discountAmount: 10,
                )
              : null,
        );

        const initialRequest = SubscriptionSummaryRequestEntity(
          programId: 'prog-1',
          bundleId: 'bundle-1',
          tier: 'Basic',
          durationDays: 26,
          startDate: '2026-10-08',
          includeFriday: false,
        );

        viewModel.doIntent(const GetSubscriptionSummaryEvent(initialRequest));
        await pumpEventQueue();

        // Apply coupon
        viewModel.doIntent(const ApplySubscriptionPromoCodeEvent('SAVE10'));
        await pumpEventQueue();

        // Remove coupon
        viewModel.doIntent(const RemoveSubscriptionPromoCodeEvent());
        await pumpEventQueue();

        // Verify all 3 requests had startDate == 2026-10-08
        expect(repository.recordedRequests.length, 3);
        for (var i = 0; i < repository.recordedRequests.length; i++) {
          expect(
            repository.recordedRequests[i].startDate,
            '2026-10-08',
            reason: 'Request #$i should have anchor date 2026-10-08',
          );
        }
      },
    );

    test(
      'user explicitly changing anchor date updates anchor to the new date (2026-10-15)',
      () async {
        repository.responder = (req) => buildTestSummaryWithServerFirstDelivery(
          chosenAnchorDate: req.startDate,
          serverFirstDeliveryDate: '2026-10-18',
        );

        const initialRequest = SubscriptionSummaryRequestEntity(
          programId: 'prog-1',
          bundleId: 'bundle-1',
          tier: 'Basic',
          durationDays: 26,
          startDate: '2026-10-08',
          includeFriday: false,
        );

        viewModel.doIntent(const GetSubscriptionSummaryEvent(initialRequest));
        await pumpEventQueue();

        viewModel.doIntent(
          const ChangeSubscriptionStartDateEvent(
            startDate: '2026-10-15',
            baseRequest: initialRequest,
          ),
        );
        await pumpEventQueue();

        expect(viewModel.state.selectedStartDate, '2026-10-15');
        expect(viewModel.state.activeRequest?.startDate, '2026-10-15');
        expect(repository.recordedRequests.last.startDate, '2026-10-15');
      },
    );
  });
}
