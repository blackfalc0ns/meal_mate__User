import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/core/network/failures.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_availability_entity.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_readiness_entity.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_restaurant_availability_entity.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_summary_entity.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_summary_request_entity.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/repo/subscription_summary_repository.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/usecase/get_subscription_summary_usecase.dart';
import 'package:meal_meat_user/features/subscription_checkout/presentation/manager/subscription_summary_event.dart';
import 'package:meal_meat_user/features/subscription_checkout/presentation/manager/subscription_summary_view_model.dart';

class AddressRefreshSummaryRepo implements SubscriptionSummaryRepository {
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
    return ApiSuccessResult(
      data: _buildSummaryWithAddress(addressId: 'addr-1', canCheckout: true),
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

SubscriptionSummaryEntity _buildSummaryWithAddress({
  required String addressId,
  required bool canCheckout,
  String? checkoutBlockReason,
}) {
  return SubscriptionSummaryEntity(
    programId: 'prog-1',
    programNameAr: 'برنامج',
    programNameEn: 'Program',
    bundleId: 'bundle-1',
    bundleNameAr: 'باقة',
    bundleNameEn: 'Bundle',
    restaurantCount: canCheckout ? 2 : 0,
    tier: 'Basic',
    tierNameAr: 'أساسي',
    tierNameEn: 'Basic',
    durationDays: 26,
    chosenStartDate: '2026-10-08',
    startDate: '2026-10-11',
    endDate: '2026-11-05',
    serviceDates: const ['2026-10-11'],
    slotRequirements: const [],
    basePrice: 100.0,
    campaignDiscount: 0.0,
    promoDiscount: 0.0,
    walletCredit: 0.0,
    gatewayFee: 0.0,
    finalPrice: 100.0,
    currencyCode: 'KWD',
    canCheckout: canCheckout,
    checkoutBlockReason: checkoutBlockReason,
    address: SubscriptionSummaryAddressEntity(
      id: addressId,
      governorate: 'العاصمة',
      area: 'الشرق',
      block: '1',
      addressLine: 'شارع 1، مبنى 5',
      label: 'المنزل',
    ),
    restaurants: canCheckout
        ? const [
            SubscriptionSummaryRestaurantEntity(
              restaurantId: 'rest-1',
              nameAr: 'مطعم 1',
              nameEn: 'Restaurant 1',
              tier: 'Basic',
            ),
          ]
        : const [],
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
  );
}

void main() {
  group('Subscription Address Availability Refresh Tests (Task 4)', () {
    late AddressRefreshSummaryRepo repo;
    late GetSubscriptionSummaryUseCase useCase;
    late SubscriptionSummaryViewModel viewModel;

    setUp(() {
      repo = AddressRefreshSummaryRepo();
      useCase = GetSubscriptionSummaryUseCase(repo);
      viewModel = SubscriptionSummaryViewModel(useCase);
    });

    tearDown(() {
      viewModel.close();
    });

    const initialRequest = SubscriptionSummaryRequestEntity(
      includeFriday: false,
      durationDays: 26,
      tier: 'Basic',
      bundleId: 'bundle-1',
      programId: 'prog-1',
      startDate: '2026-10-08',
    );

    test(
      'Address change refresh preserves the original chosen anchor date (2026-10-08)',
      () async {
        repo.responder = (req) =>
            _buildSummaryWithAddress(addressId: 'addr-1', canCheckout: true);

        viewModel.doIntent(const GetSubscriptionSummaryEvent(initialRequest));
        await pumpEventQueue();

        expect(viewModel.state.summary, isNotNull);
        expect(viewModel.state.selectedStartDate, equals('2026-10-08'));

        // User returns from address selection, trigger refresh using active request
        final refreshRequest = viewModel.state.activeRequest ?? initialRequest;
        viewModel.doIntent(GetSubscriptionSummaryEvent(refreshRequest));
        await pumpEventQueue();

        expect(repo.recordedRequests.length, equals(2));
        expect(repo.recordedRequests[1].startDate, equals('2026-10-08'));
        expect(viewModel.state.selectedStartDate, equals('2026-10-08'));
      },
    );

    test(
      'When new address has no coverage, refreshed summary blocks checkout with reason',
      () async {
        int requestCount = 0;
        repo.responder = (req) {
          requestCount++;
          if (requestCount == 1) {
            return _buildSummaryWithAddress(
              addressId: 'addr-1',
              canCheckout: true,
            );
          } else {
            return _buildSummaryWithAddress(
              addressId: 'addr-2',
              canCheckout: false,
              checkoutBlockReason:
                  'subscription_flow.no_restaurants_for_address',
            );
          }
        };

        viewModel.doIntent(const GetSubscriptionSummaryEvent(initialRequest));
        await pumpEventQueue();
        expect(viewModel.state.canCheckout, isTrue);

        // Trigger refresh after address change
        viewModel.doIntent(
          GetSubscriptionSummaryEvent(
            viewModel.state.activeRequest ?? initialRequest,
          ),
        );
        await pumpEventQueue();

        expect(viewModel.state.summary!.canCheckout, isFalse);
        expect(
          viewModel.state.summary!.checkoutBlockReason,
          equals('subscription_flow.no_restaurants_for_address'),
        );
        expect(viewModel.state.canCheckout, isFalse);
      },
    );
  });
}
