import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/features/subscription_checkout/data/mapper/subscription_availability_mapper.dart';
import 'package:meal_meat_user/features/subscription_checkout/data/mapper/subscription_summary_mapper.dart';
import 'package:meal_meat_user/features/subscription_checkout/data/models/response/subscription_availability_response_dto.dart';
import 'package:meal_meat_user/features/subscription_checkout/data/models/response/subscription_restaurant_availability_response_dto.dart';
import 'package:meal_meat_user/features/subscription_checkout/data/models/response/subscription_summary_response_dto.dart';

void main() {
  group('Subscription Availability DTO & Mapper Tests', () {
    test('parses spec example JSON correctly and maps to entity', () {
      final json = {
        'availability': {
          'status': 'no_restaurants_for_address',
          'coveredRestaurantCount': 0,
          'eligibleRestaurantCount': 0,
          'checkedAtUtc': '2026-10-08T10:00:00Z',
          'effectiveStartDate': '2026-10-11',
          'messageCode': 'subscription_flow.no_restaurants_for_address',
        },
        'totalCount': 0,
        'pagination': null,
        'restaurants': <Map<String, dynamic>>[],
      };

      final dto = SubscriptionRestaurantAvailabilityResponseDto.fromJson(json);
      expect(dto.availability?.status, 'no_restaurants_for_address');
      expect(dto.availability?.coveredRestaurantCount, 0);
      expect(dto.availability?.eligibleRestaurantCount, 0);
      expect(dto.availability?.checkedAtUtc, '2026-10-08T10:00:00Z');
      expect(dto.availability?.effectiveStartDate, '2026-10-11');
      expect(
        dto.availability?.messageCode,
        'subscription_flow.no_restaurants_for_address',
      );
      expect(dto.totalCount, 0);
      expect(dto.pagination, isNull);
      expect(dto.restaurants, isEmpty);

      final entity = dto.toEntity();
      expect(entity.availability.status, 'no_restaurants_for_address');
      expect(entity.availability.coveredRestaurantCount, 0);
      expect(entity.availability.eligibleRestaurantCount, 0);
      expect(
        entity.availability.checkedAtUtc,
        DateTime.parse('2026-10-08T10:00:00Z'),
      );
      expect(entity.availability.effectiveStartDate, '2026-10-11');
      expect(
        entity.availability.messageCode,
        'subscription_flow.no_restaurants_for_address',
      );
      expect(entity.totalCount, 0);
      expect(entity.pagination, isNull);
      expect(entity.restaurants, isEmpty);
    });

    test(
      'preserves unknown status and messageCode verbatim without transforming to available',
      () {
        final json = {
          'availability': {
            'status': 'custom_future_status',
            'coveredRestaurantCount': 5,
            'eligibleRestaurantCount': 2,
            'checkedAtUtc': null,
            'effectiveStartDate': '2026-10-12',
            'messageCode': 'subscription_flow.custom_future_status',
          },
          'totalCount': 10,
          'pagination': {
            'page': 1,
            'pageSize': 10,
            'totalPages': 1,
            'totalItems': 10,
          },
          'restaurants': [
            {
              'restaurantId': 'rest-1',
              'nameAr': 'مطعم 1',
              'nameEn': 'Restaurant 1',
              'logoUrl': 'https://example.com/logo.png',
              'tier': 'Basic',
            },
          ],
        };

        final dto = SubscriptionRestaurantAvailabilityResponseDto.fromJson(
          json,
        );
        final entity = dto.toEntity();

        expect(entity.availability.status, 'custom_future_status');
        expect(
          entity.availability.messageCode,
          'subscription_flow.custom_future_status',
        );
        expect(entity.availability.coveredRestaurantCount, 5);
        expect(entity.availability.eligibleRestaurantCount, 2);
        expect(entity.totalCount, 10);
        expect(entity.pagination?.page, 1);
        expect(entity.restaurants.length, 1);
        expect(entity.restaurants.first.restaurantId, 'rest-1');
      },
    );

    test(
      'SubscriptionSummaryResponseDto maps canCheckout null to false, false to false, true to true',
      () {
        const dtoNull = SubscriptionSummaryResponseDto(canCheckout: null);
        const dtoFalse = SubscriptionSummaryResponseDto(canCheckout: false);
        const dtoTrue = SubscriptionSummaryResponseDto(canCheckout: true);

        expect(
          dtoNull.toEntity().canCheckout,
          isFalse,
          reason: 'missing/null must be treated as false',
        );
        expect(dtoFalse.toEntity().canCheckout, isFalse);
        expect(dtoTrue.toEntity().canCheckout, isTrue);
      },
    );

    test(
      'SubscriptionSummaryResponseDto preserves availability entity when present or null when absent',
      () {
        const dtoWithoutAvailability = SubscriptionSummaryResponseDto();
        expect(dtoWithoutAvailability.toEntity().availability, isNull);

        const dtoWithAvailability = SubscriptionSummaryResponseDto(
          availability: SubscriptionAvailabilityResponseDto(
            status: 'available',
            coveredRestaurantCount: 3,
            eligibleRestaurantCount: 3,
            effectiveStartDate: '2026-10-11',
            messageCode: 'subscription_flow.available',
          ),
        );
        final entity = dtoWithAvailability.toEntity();
        expect(entity.availability, isNotNull);
        expect(entity.availability?.status, 'available');
        expect(entity.availability?.coveredRestaurantCount, 3);
        expect(entity.availability?.eligibleRestaurantCount, 3);
      },
    );
  });
}
