import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/features/offers/data/mapper/offer_mapper.dart';
import 'package:meal_meat_user/features/offers/data/models/request/validate_discount_request_dto.dart';
import 'package:meal_meat_user/features/offers/data/models/response/offer_calendar_entry_dto.dart';
import 'package:meal_meat_user/features/offers/data/models/response/offer_eligible_restaurant_dto.dart';
import 'package:meal_meat_user/features/offers/data/models/response/offer_response_dto.dart';
import 'package:meal_meat_user/features/offers/data/models/response/offers_hub_response_dto.dart';
import 'package:meal_meat_user/features/offers/data/models/response/validate_discount_response_dto.dart';
import 'package:meal_meat_user/features/subscription_checkout/data/models/request/payment_checkout_request_dto.dart';
import 'package:meal_meat_user/features/payment/data/models/response/payment_checkout_response_dto.dart';
import 'package:meal_meat_user/features/subscription_checkout/data/models/request/subscription_pricing_preview_request_dto.dart';
import 'package:meal_meat_user/features/subscription_checkout/data/models/response/subscription_confirmation_response_dto.dart';
import 'package:meal_meat_user/features/subscription_checkout/data/models/response/subscription_pricing_preview_response_dto.dart';
import 'package:meal_meat_user/features/subscription_checkout/data/mapper/subscription_confirmation_mapper.dart';
import 'package:meal_meat_user/features/wallet/data/models/customer_referral_summary_response_dto.dart';
import 'package:meal_meat_user/features/wallet/data/models/customer_wallet_response_dto.dart';
import 'package:meal_meat_user/features/wallet/data/models/wallet_transactions_response_dto.dart';

void main() {
  group('Offers & Promotions v2 Contract Tests', () {
    test('PaymentCheckoutRequestDto serialization: offerId only', () {
      const dto = PaymentCheckoutRequestDto(
        programId: 'p-1',
        bundleId: 'b-1',
        tier: '1',
        durationDays: 20,
        startDate: '2026-11-01',
        paymentMethodId: 3,
        callbackUrl: 'mealmate://payment-callback',
        errorUrl: 'mealmate://payment-error',
        correlationId: 'corr-offer-only',
        offerId: 'offer-uuid-1',
        promoCode: null,
        idempotencyKey: 'stable-key-offer-only',
        includeFriday: false,
      );

      final json = dto.toJson();
      expect(json['offerId'], equals('offer-uuid-1'));
      expect(json['promoCode'], isNull);
      expect(json['idempotencyKey'], equals('stable-key-offer-only'));
      expect(json['startDate'], equals('2026-11-01'));
      expect(json['paymentMethodId'], equals(3));
      expect(json['callbackUrl'], equals('mealmate://payment-callback'));
      expect(json['errorUrl'], equals('mealmate://payment-error'));
    });

    test('PaymentCheckoutRequestDto serialization: promoCode only', () {
      const dto = PaymentCheckoutRequestDto(
        programId: 'p-1',
        bundleId: 'b-1',
        tier: '1',
        durationDays: 20,
        startDate: '2026-11-01',
        paymentMethodId: 3,
        callbackUrl: 'mealmate://payment-callback',
        errorUrl: 'mealmate://payment-error',
        correlationId: 'corr-promo-only',
        offerId: null,
        promoCode: 'WEEKLY25',
        idempotencyKey: 'stable-key-promo-only',
        includeFriday: false,
      );

      final json = dto.toJson();
      expect(json['offerId'], isNull);
      expect(json['promoCode'], equals('WEEKLY25'));
      expect(json['idempotencyKey'], equals('stable-key-promo-only'));
    });

    test('PaymentCheckoutRequestDto serialization: both offerId and promoCode', () {
      const dto = PaymentCheckoutRequestDto(
        programId: 'p-1',
        bundleId: 'b-1',
        tier: '1',
        durationDays: 20,
        startDate: '2026-11-01',
        paymentMethodId: 3,
        callbackUrl: 'mealmate://payment-callback',
        errorUrl: 'mealmate://payment-error',
        correlationId: 'corr-both',
        offerId: 'offer-uuid-1',
        promoCode: 'STACK10',
        idempotencyKey: 'stable-key-both',
        includeFriday: false,
      );

      final json = dto.toJson();
      expect(json['offerId'], equals('offer-uuid-1'));
      expect(json['promoCode'], equals('STACK10'));
      expect(json['idempotencyKey'], equals('stable-key-both'));
    });

    test('PaymentCheckoutRequestDto serialization: neither offerId nor promoCode', () {
      const dto = PaymentCheckoutRequestDto(
        programId: 'p-1',
        bundleId: 'b-1',
        tier: '1',
        durationDays: 20,
        startDate: '2026-11-01',
        paymentMethodId: 3,
        callbackUrl: 'mealmate://payment-callback',
        errorUrl: 'mealmate://payment-error',
        correlationId: 'corr-neither',
        offerId: null,
        promoCode: null,
        idempotencyKey: 'stable-key-neither',
        includeFriday: false,
      );

      final json = dto.toJson();
      expect(json['offerId'], isNull);
      expect(json['promoCode'], isNull);
      expect(json['idempotencyKey'], equals('stable-key-neither'));
    });

    test('PaymentCheckoutResponseDto parses v2 checkout result', () {
      final json = {
        'subscriptionId': 'sub-uuid-123',
        'paymentUrl': 'https://payzah.com/checkout/session_998877',
        'holdExpiresAtUtc': '2026-10-19T06:45:00Z',
        'finalPrice': 40.0,
        'paymentStatus': 'Pending',
      };

      final dto = PaymentCheckoutResponseDto.fromJson(json);
      expect(dto.subscriptionId, equals('sub-uuid-123'));
      expect(dto.paymentUrl, equals('https://payzah.com/checkout/session_998877'));
      expect(dto.finalPrice, equals(40.0));
      expect(dto.paymentStatus, equals('Pending'));
    });

    test('OfferResponseDto and OfferEntity handle discount units and new v2 fields', () {
      // Case A: discountRate as decimal (0.25 -> 25%)
      final jsonA = {
        'id': 'offer-1',
        'nameAr': 'عرض الصيف',
        'nameEn': 'Summer Offer',
        'discountRate': 0.25,
        'isSaved': true,
        'isAvailable': true,
        'eligibleProgramIds': ['prog-1'],
        'eligibleBundleIds': ['b-1'],
        'eligibleRestaurantIds': ['r-1'],
      };
      final dtoA = OfferResponseDto.fromJson(jsonA);
      final entityA = dtoA.toEntity();
      expect(entityA.isSaved, isTrue);
      expect(entityA.isAvailable, isTrue);
      expect(entityA.programIds, equals(['prog-1']));
      expect(entityA.formattedDiscount(), equals('25%'));

      // Case B: discountRate as percentage (25.0 -> 25%)
      final jsonB = {
        'id': 'offer-2',
        'nameAr': 'عرض خاص',
        'nameEn': 'Special Offer',
        'discountRate': 25.0,
        'isSaved': false,
        'isAvailable': false,
      };
      final dtoB = OfferResponseDto.fromJson(jsonB);
      final entityB = dtoB.toEntity();
      expect(entityB.isSaved, isFalse);
      expect(entityB.isAvailable, isFalse);
      expect(entityB.formattedDiscount(), equals('25%'));

      // Case C: fixed discount amount
      final jsonC = {
        'id': 'offer-3',
        'nameAr': 'خصم ثابت',
        'nameEn': 'Fixed Discount',
        'discountAmountKwd': 15.0,
      };
      final dtoC = OfferResponseDto.fromJson(jsonC);
      final entityC = dtoC.toEntity();
      expect(entityC.discountAmount, equals(15.0));
      expect(entityC.formattedDiscount(), equals('15.000 KWD'));
    });

    test('ValidateDiscountRequestDto and ValidateDiscountResponseDto contract', () {
      const req = ValidateDiscountRequestDto(
        code: 'WEEKLY25',
        programId: 'prog-1',
        bundleId: 'bundle-1',
      );
      final reqJson = req.toJson();
      expect(reqJson['code'], equals('WEEKLY25'));
      expect(reqJson['programId'], equals('prog-1'));
      expect(reqJson['bundleId'], equals('bundle-1'));

      final resJson = {
        'isValid': true,
        'code': 'WEEKLY25',
        'codeType': 'Offer',
        'calculatedDiscountKwd': 12.5,
        'discountPercent': 25.0,
        'eligibilityCode': 'rule_only_amount_set_at_quote',
        'failureMessageAr': 'تم تطبيق الكوبون بنجاح',
        'failureMessageEn': 'Coupon applied successfully',
      };
      final resDto = ValidateDiscountResponseDto.fromJson(resJson);
      expect(resDto.isValid, isTrue);
      expect(resDto.code, equals('WEEKLY25'));
      expect(resDto.codeType, equals('Offer'));
      expect(resDto.resolvedDiscountAmount, equals(12.5));
      expect(resDto.resolvedDiscountPercent, equals(25.0));
      expect(resDto.resolvedMessageAr, equals('تم تطبيق الكوبون بنجاح'));
      expect(resDto.resolvedMessageEn, equals('Coupon applied successfully'));
    });

    test('SubscriptionPricingPreviewRequestDto and ResponseDto contract', () {
      const req = SubscriptionPricingPreviewRequestDto(
        programId: 'prog-1',
        bundleId: 'bundle-1',
        tier: 1,
        durationDays: 20,
        offerId: 'offer-1',
        promoCode: 'CODE10',
        includeFriday: true,
        fridayDays: 4,
      );
      final reqJson = req.toJson();
      expect(reqJson['programId'], equals('prog-1'));
      expect(reqJson['bundleId'], equals('bundle-1'));
      expect(reqJson['tier'], equals(1));
      expect(reqJson['durationDays'], equals(20));
      expect(reqJson['offerId'], equals('offer-1'));
      expect(reqJson['promoCode'], equals('CODE10'));
      expect(reqJson['includeFriday'], isTrue);
      expect(reqJson['fridayDays'], equals(4));

      final resJson = {
        'basePlanPrice': 60.0,
        'fridayAddonPrice': 10.0,
        'grossAmount': 70.0,
        'campaignDiscountApplied': 15.0,
        'promoCodeDiscountApplied': 5.0,
        'totalDiscountApplied': 20.0,
        'walletCreditApplied': 5.0,
        'finalCustomerPrice': 45.0,
        'currencyCode': 'KWD',
        'serviceDatesCount': 20,
        'fridayCount': 4,
      };
      final resDto = SubscriptionPricingPreviewResponseDto.fromJson(resJson);
      expect(resDto.resolvedGross, equals(70.0));
      expect(resDto.resolvedOfferDiscount, equals(15.0));
      expect(resDto.resolvedCodeDiscount, equals(5.0));
      expect(resDto.resolvedTotalDiscount, equals(20.0));
      expect(resDto.resolvedWalletCredit, equals(5.0));
      expect(resDto.resolvedFinalPrice, equals(45.0));
      expect(resDto.resolvedCurrency, equals('KWD'));
      expect(resDto.resolvedServiceDays, equals(20));
      expect(resDto.resolvedFridayDays, equals(4));
    });

    test('SubscriptionConfirmationResponseDto contract', () {
      final json = {
        'subscriptionId': 'sub-1',
        'status': 'Active',
        'programNameAr': 'برنامج كيتو',
        'programNameEn': 'Keto Program',
        'bundleNameAr': 'باقة 20 يوم',
        'bundleNameEn': '20 Days Bundle',
        'paidAmount': 40.0,
        'appliedDiscount': 15.0,
        'currency': 'KWD',
        'referralShareCode': 'REF123',
        'referralShareUrl': 'https://mealmate.app/ref/REF123',
      };
      final dto = SubscriptionConfirmationResponseDto.fromJson(json);
      expect(dto.subscriptionId, equals('sub-1'));
      expect(dto.paidAmount, equals(40.0));
      expect(dto.appliedDiscount, equals(15.0));
      expect(dto.referralShareCode, equals('REF123'));
    });

    test('SubscriptionConfirmationResponseDto parses real backend API response keys', () {
      final json = {
        'subscriptionId': '3c2ae58d-e4b1-4fad-8a2f-2681d5f61a8e',
        'status': 'Scheduled',
        'isPaid': true,
        'isFailed': false,
        'programId': 'dd12dfbc-3987-4e38-83af-664b6963c04c',
        'programNameAr': 'خسارة الوزن',
        'bundleId': 'ae827912-199d-49e8-b1fc-3390fc96b2e6',
        'bundleNameAr': 'ريوق + غداء + سناك',
        'tier': 'Basic',
        'tierNameAr': 'أساسي',
        'durationDays': 12,
        'includeFriday': false,
        'startDate': '2026-10-26',
        'endDate': '2026-11-08',
        'amountPaidKwd': 53.0,
        'currencyCode': 'KWD',
        'paymentVerifiedAtUtc': '2026-10-22T04:03:25.643272Z',
        'discount': null,
        'referralShare': null,
        'programName': 'خسارة الوزن',
        'bundleName': 'ريوق + غداء + سناك',
        'tierName': 'أساسي',
      };
      final dto = SubscriptionConfirmationResponseDto.fromJson(json);
      expect(dto.subscriptionId, equals('3c2ae58d-e4b1-4fad-8a2f-2681d5f61a8e'));
      expect(dto.paidAmount, equals(53.0));
      expect(dto.currency, equals('KWD'));
      expect(dto.durationDays, equals(12));
      expect(dto.tier, equals('Basic'));
      expect(dto.tierNameAr, equals('أساسي'));
      expect(dto.programNameAr, equals('خسارة الوزن'));
      expect(dto.bundleNameAr, equals('ريوق + غداء + سناك'));
      expect(dto.paymentDate, equals('2026-10-22'));

      final entity = dto.toEntity();
      expect(entity.paidAmount, equals(53.0));
      expect(entity.durationDays, equals(12));
      expect(entity.bundleName('ar'), equals('ريوق + غداء + سناك'));
      expect(entity.tierName('ar'), equals('أساسي'));
      expect(entity.tierName('en'), equals('Basic'));
    });

    test('CustomerWalletResponseDto and WalletTransactionsResponseDto contract', () {
      final walletJson = {
        'cashBalanceKwd': 10.0,
        'promotionalBalanceKwd': 5.0,
        'totalAvailableBalanceKwd': 15.0,
        'currencyCode': 'KWD',
      };
      final walletDto = CustomerWalletResponseDto.fromJson(walletJson);
      expect(walletDto.resolvedCashBalance, equals(10.0));
      expect(walletDto.resolvedPromotionalBalance, equals(5.0));
      expect(walletDto.resolvedTotalBalance, equals(15.0));
      expect(walletDto.resolvedCurrency, equals('KWD'));

      final txJson = {
        'items': [
          {
            'id': 'tx-1',
            'type': 'Credit',
            'amount': 5.0,
            'walletType': 'promotional',
            'description': 'مكافأة إحالة صديق',
            'createdAtUtc': '2026-10-19T06:00:00Z',
          }
        ],
        'page': 1,
        'pageSize': 20,
        'totalCount': 1,
      };
      final txDto = WalletTransactionsResponseDto.fromJson(txJson);
      expect(txDto.items?.length, equals(1));
      expect(txDto.items?.first.amount, equals(5.0));
      expect(txDto.items?.first.walletType, equals('promotional'));
    });

    test('CustomerReferralSummaryResponseDto contract', () {
      final json = {
        'referralCode': 'REF99',
        'rewardPercentage': 10.0,
        'referralCount': 4,
        'earnedCreditsKwd': 20.0,
        'shareMessage': 'اشترك بكودي واحصل على خصم',
        'shareUrl': 'https://mealmate.app/ref/REF99',
      };
      final dto = CustomerReferralSummaryResponseDto.fromJson(json);
      expect(dto.referralCode, equals('REF99'));
      expect(dto.rewardPercentage, equals(10.0));
      expect(dto.referralCount, equals(4));
      expect(dto.resolvedEarnedCredits, equals(20.0));
      expect(dto.shareUrl, equals('https://mealmate.app/ref/REF99'));
    });

    test('OffersHubResponseDto, EligibleRestaurantDto, and CalendarEntryDto contract', () {
      final hubJson = {
        'heroOffers': [
          {'id': 'hero-1', 'nameAr': 'عرض رئيسي', 'nameEn': 'Hero Offer'}
        ],
        'availableOffers': [
          {'id': 'offer-1', 'nameAr': 'عرض متاح', 'nameEn': 'Available Offer'}
        ],
        'serverTimeUtc': '2026-10-19T07:00:00Z',
      };
      final hubDto = OffersHubResponseDto.fromJson(hubJson);
      expect(hubDto.heroOffers?.length, equals(1));
      expect(hubDto.availableOffers?.length, equals(1));
      expect(hubDto.serverTimeUtc, equals('2026-10-19T07:00:00Z'));

      final restJson = {
        'id': 'rest-1',
        'nameAr': 'مطعم دايت',
        'nameEn': 'Diet Restaurant',
        'rating': 4.8,
      };
      final restDto = OfferEligibleRestaurantDto.fromJson(restJson);
      expect(restDto.id, equals('rest-1'));
      expect(restDto.rating, equals(4.8));

      final calJson = {
        'id': 'cal-1',
        'offerId': 'offer-1',
        'scheduledDate': '2026-10-25',
        'status': 1,
      };
      final calDto = OfferCalendarEntryDto.fromJson(calJson);
      expect(calDto.offerId, equals('offer-1'));
      expect(calDto.scheduledDate, equals('2026-10-25'));
      expect(calDto.status, equals(1));
    });
  });
}
