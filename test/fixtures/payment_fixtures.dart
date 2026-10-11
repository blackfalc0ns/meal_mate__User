import 'package:meal_meat_user/features/subscription_settings/domain/entities/subscription_billing_entity.dart';

/// Sanitized synthetic fixtures matching OpenAPI schema and backend contracts.
/// Contains no real user secrets, tokens, or personal identifiers.
abstract class PaymentFixtures {
  static const Map<String, dynamic> payzahHostedMethodJson = {
    'paymentMethodId': 3,
    'code': 'PAYZAH',
    'integrationType': 'PAYZAH_HOSTED',
    'nameAr': 'الدفع عبر Payzah',
    'nameEn': 'Payzah hosted checkout',
    'serviceCharge': null,
    'totalAmount': null,
    'currencyCode': 'KWD',
    'isAvailable': true,
    'unavailableReason': null,
    'imageUrl': null,
  };

  static const Map<String, dynamic> walletUnavailableMethodJson = {
    'paymentMethodId': null,
    'code': 'MEALMATE_WALLET',
    'integrationType': null,
    'nameAr': 'المحفظة',
    'nameEn': 'MealMate Wallet',
    'serviceCharge': null,
    'totalAmount': null,
    'currencyCode': 'KWD',
    'isAvailable': false,
    'unavailableReason': 'wallet_not_implemented',
    'imageUrl': null,
  };

  static const Map<String, dynamic> checkoutStartedJson = {
    'subscriptionId': '11111111-2222-3333-4444-555555555555',
    'paymentUrl': 'https://sandbox.payzah.net/hosted-checkout?session=test',
    'holdExpiresAtUtc': '2026-10-08T05:00:00Z',
    'finalPrice': 45.0,
    'paymentStatus': 'PendingPayment',
    'fulfillmentStatus': 'Pending',
    'paymentId': 'pz-test-track-123',
  };

  static const Map<String, dynamic> statusPaidJson = {
    'subscriptionId': '11111111-2222-3333-4444-555555555555',
    'paymentStatus': 'Paid',
    'isPaid': true,
    'isFailed': false,
    'amount': 45.0,
    'currencyCode': 'KWD',
  };

  static const Map<String, dynamic> statusPendingJson = {
    'subscriptionId': '11111111-2222-3333-4444-555555555555',
    'paymentStatus': 'PendingPayment',
    'isPaid': false,
    'isFailed': false,
    'amount': 45.0,
    'currencyCode': 'KWD',
  };

  static const Map<String, dynamic> statusFailedJson = {
    'subscriptionId': '11111111-2222-3333-4444-555555555555',
    'paymentStatus': 'PaymentFailed',
    'isPaid': false,
    'isFailed': true,
    'amount': 45.0,
    'currencyCode': 'KWD',
  };

  static const Map<String, dynamic> statusReviewJson = {
    'subscriptionId': '11111111-2222-3333-4444-555555555555',
    'paymentStatus': 'SuspendedForReview',
    'isPaid': false,
    'isFailed': false,
    'amount': 45.0,
    'currencyCode': 'KWD',
  };

  static const Map<String, dynamic> currentActiveJson = {
    'subscription': {
      'subscriptionId': '11111111-2222-3333-4444-555555555555',
      'status': 'Active',
      'statusNameAr': 'نشط',
      'paidAmount': 45.0,
      'currencyCode': 'KWD',
    },
    'emptyStateCode': null,
  };

  static const Map<String, dynamic> currentScheduledJson = {
    'subscription': {
      'subscriptionId': '11111111-2222-3333-4444-555555555555',
      'status': 'Scheduled',
      'statusNameAr': 'مجدول',
      'paidAmount': 45.0,
      'currencyCode': 'KWD',
    },
    'emptyStateCode': null,
  };

  static const List<Map<String, dynamic>> uncompletedListJson = [
    {
      'subscriptionId': '11111111-2222-3333-4444-555555555555',
      'status': 'PendingPayment',
      'amount': 45.0,
      'isHoldActive': true,
      'holdRemainingSeconds': 900,
    },
  ];

  static SubscriptionBillingCurrentEntity activeCurrentEntity({
    String subscriptionId = 'sub-accepted-1',
  }) {
    return SubscriptionBillingCurrentEntity(
      emptyStateCode: '',
      subscription: SubscriptionBillingSubscriptionEntity(
        subscriptionId: subscriptionId,
        status: 'Active',
        statusNameAr: 'نشط',
        programId: 'prog-1',
        programNameAr: 'برنامج',
        programNameEn: 'Program',
        bundleId: 'bundle-1',
        bundleNameAr: 'باقة',
        bundleNameEn: 'Bundle',
        tier: 'Basic',
        tierNameAr: 'بيسك',
        tierNameEn: 'Basic',
        tierLogoUrl: '',
        mealsPerDay: 3,
        imageUrl: '',
        startDate: '2026-10-10',
        endDate: '2026-10-22',
        nextRenewalDate: '',
        totalServiceDays: 12,
        completedServiceDays: 0,
        remainingServiceDays: 12,
        progressPercentage: 0,
        paidAmount: 45,
        currencyCode: 'KWD',
        restaurant: const SubscriptionBillingRestaurantEntity(
          restaurantId: 'rest-1',
          nameAr: '',
          nameEn: '',
          logoUrl: '',
        ),
        actions: const SubscriptionBillingActionsEntity(
          canRenew: false,
          canFreeze: false,
          canCancel: false,
          canUpgrade: false,
          renewUnavailableReason: '',
          freezeUnavailableReason: '',
          cancelUnavailableReason: '',
          upgradeUnavailableReason: '',
          freezeStartDelayDays: 0,
          maximumFreezeDays: 0,
          freezeExtendsSubscriptionEnd: false,
          earliestFreezeStartDate: '',
          renewalEndpoint: '',
          freezeEndpoint: '',
          cancellationEndpoint: '',
          upgradeEndpoint: '',
          cancellationQuoteEndpoint: '',
        ),
      ),
    );
  }
}
