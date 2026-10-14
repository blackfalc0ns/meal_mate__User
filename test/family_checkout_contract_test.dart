import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/features/family_checkout/data/models/request/family_checkout_request_dto.dart';
import 'package:meal_meat_user/features/family_checkout/data/models/request/family_checkout_selection_request_dto.dart';
import 'package:meal_meat_user/features/family_checkout/data/models/response/family_checkout_selection_response_dto.dart';
import 'package:meal_meat_user/features/family_checkout/data/mapper/family_checkout_mapper.dart';
import 'package:meal_meat_user/features/family_checkout/data/models/response/family_summary_response_dto.dart';
import 'package:meal_meat_user/features/family_checkout/domain/entities/family_summary_entity.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/features/family_allergies/data/models/request/family_member_allergies_request_dto.dart';
import 'package:meal_meat_user/features/family_checkout/domain/entities/family_checkout_blocker_destination.dart';
import 'package:meal_meat_user/features/food_preferences/data/models/request/food_preferences_dietary_request_dto.dart';
import 'package:meal_meat_user/features/food_preferences/data/models/request/food_preferences_disliked_ingredients_request_dto.dart';
import 'package:meal_meat_user/features/family_checkout/presentation/manager/family_checkout_event.dart';

void main() {
  group('Family Checkout Contract Tests', () {
    test(
      'FamilyCheckoutRequestDto serializes contract version and idempotency key',
      () {
        const dto = FamilyCheckoutRequestDto(
          callbackUrl: 'mealmate://checkout/success',
          errorUrl: 'mealmate://checkout/error',
          correlationId: 'corr-123',
          paymentMethodId: 4,
          idempotencyKey: 'idemp-xyz',
          batchId: 'batch-999',
          batchVersion: 3,
          clientContractVersion: 1,
        );

        final json = dto.toJson();
        expect(json['clientContractVersion'], 1);
        expect(json['idempotencyKey'], 'idemp-xyz');
        expect(json['batchId'], 'batch-999');
        expect(json['batchVersion'], 3);
        expect(json['paymentMethodId'], 4);
      },
    );

    test('FamilyCheckoutSelectionRequestDto serializes subscribeNow', () {
      const req = FamilyCheckoutSelectionRequestDto(subscribeNow: true);
      expect(req.toJson(), {'subscribeNow': true});
    });

    test('FamilyCheckoutSelectionResponseDto maps correctly to entity', () {
      final dto = FamilyCheckoutSelectionResponseDto.fromJson({
        'batchId': 'batch-01',
        'batchVersion': 5,
        'memberId': 'mem-01',
        'checkoutSelected': true,
        'selectedNewSubscriberCount': 2,
      });

      final entity = dto.toEntity();
      expect(entity.batchId, 'batch-01');
      expect(entity.batchVersion, 5);
      expect(entity.memberId, 'mem-01');
      expect(entity.checkoutSelected, isTrue);
      expect(entity.selectedNewSubscriberCount, 2);
    });

    test(
      'FamilySummary invoice scope uses selectedNewSubscriberCount over rosterCount',
      () {
        final dto = FamilySummaryResponseDto.fromJson({
          'subtotal': 120.0,
          'familyDiscountPercent': 0.1,
          'familyDiscountAmount': 12.0,
          'finalPrice': 108.0,
          'canCheckout': true,
          'newMembersCount': 3,
          'rosterCount': 5,
          'selectedNewSubscriberCount': 2,
          'batchId': 'batch-77',
          'batchVersion': 2,
        });

        final entity = dto.toEntity();
        expect(entity.rosterCount, 5);
        expect(entity.selectedNewSubscriberCount, 2);
        expect(entity.invoiceSubscribersCount, 2);
        expect(entity.canCheckout, isTrue);
      },
    );

    test('FamilySummary canCheckout is false when blocker is present', () {
      const entity = FamilySummaryEntity(
        subtotal: 100,
        familyDiscountPercent: 0,
        familyDiscountAmount: 0,
        finalPrice: 100,
        canCheckout: false,
        checkoutBlockReason: 'family.member_account_required',
        rosterCount: 3,
        selectedNewSubscriberCount: 0,
      );

      expect(entity.canCheckout, isFalse);
      expect(entity.checkoutBlockReason, 'family.member_account_required');
    });

    test(
      'UpdateMemberStartDateEvent holds memberId and formatted startDate',
      () {
        const event = UpdateMemberStartDateEvent(
          memberId: 'mem-10',
          startDate: '2026-09-23',
        );
        expect(event.memberId, 'mem-10');
        expect(event.startDate, '2026-09-23');
      },
    );

    test(
      'Allergies payload serializes selectedCodes and defaults to NONE when empty',
      () {
        const emptyDto = FamilyMemberAllergiesRequestDto(selectedCodes: []);
        final emptyJson = emptyDto.toJson();
        expect(emptyJson, {
          'selectedCodes': ['NONE'],
        });
        expect(emptyJson.length, 1);

        const codesDto = FamilyMemberAllergiesRequestDto(
          selectedCodes: ['MILK', 'EGG'],
        );
        final codesJson = codesDto.toJson();
        expect(codesJson, {
          'selectedCodes': ['MILK', 'EGG'],
        });
        expect(codesJson.length, 1);
      },
    );

    test(
      'Disliked ingredients payload serializes ingredientCodes and defaults to NONE when empty',
      () {
        const emptyDto = FoodPreferencesDislikedIngredientsRequestDto(
          ingredientCodes: [],
        );
        final emptyJson = emptyDto.toJson();
        expect(emptyJson, {
          'ingredientCodes': ['NONE'],
        });
        expect(emptyJson.length, 1);

        const codesDto = FoodPreferencesDislikedIngredientsRequestDto(
          ingredientCodes: ['INGREDIENT:guid-1'],
        );
        final codesJson = codesDto.toJson();
        expect(codesJson, {
          'ingredientCodes': ['INGREDIENT:guid-1'],
        });
        expect(codesJson.length, 1);
      },
    );

    test(
      'Dietary preferences payload serializes dietaryPreferenceCodes and defaults to NONE when empty',
      () {
        const emptyDto = FoodPreferencesDietaryRequestDto(
          dietaryPreferenceCodes: [],
        );
        final emptyJson = emptyDto.toJson();
        expect(emptyJson, {
          'dietaryPreferenceCodes': ['NONE'],
        });
        expect(emptyJson.length, 1);

        const codesDto = FoodPreferencesDietaryRequestDto(
          dietaryPreferenceCodes: ['KETO'],
        );
        final codesJson = codesDto.toJson();
        expect(codesJson, {
          'dietaryPreferenceCodes': ['KETO'],
        });
        expect(codesJson.length, 1);
      },
    );

    test(
      'FamilySummary maps participantCount and memberSchedules accurately',
      () {
        final dto = FamilySummaryResponseDto.fromJson({
          'subtotal': 120.0,
          'familyDiscountPercent': 0.1,
          'familyDiscountAmount': 12.0,
          'finalPrice': 108.0,
          'canCheckout': true,
          'rosterCount': 3,
          'participantCount': 2,
          'memberSchedules': [
            {
              'memberId': 'mem-1',
              'paymentDate': '2026-10-15',
              'firstDeliveryDate': '2026-10-20',
              'endDate': '2026-11-15',
              'deliveryDaysCount': 20,
              'mealsPerDay': 2,
              'totalMeals': 40,
              'restaurants': ['Diet Kitchen', 'Healthy Corner'],
            },
          ],
        });

        final entity = dto.toEntity();
        expect(entity.participantCount, 2);
        expect(entity.invoiceSubscribersCount, 2);
        expect(entity.memberSchedules.length, 1);

        final schedule = entity.memberSchedules.first;
        expect(schedule.memberId, 'mem-1');
        expect(schedule.paymentDate, '2026-10-15');
        expect(schedule.firstDeliveryDate, '2026-10-20');
        expect(schedule.endDate, '2026-11-15');
        expect(schedule.deliveryDaysCount, 20);
        expect(schedule.mealsPerDay, 2);
        expect(schedule.totalMeals, 40);
        expect(schedule.restaurants, ['Diet Kitchen', 'Healthy Corner']);
      },
    );

    test('familyCheckoutBlockerRoute maps all required blocker reasons', () {
      expect(
        familyCheckoutBlockerRoute('family.min_members'),
        AppRoutes.familySubscriptionSetup,
      );
      expect(
        familyCheckoutBlockerRoute('family.manager_subscription_required'),
        AppRoutes.familySubscriptionSetup,
      );
      expect(
        familyCheckoutBlockerRoute('family.max_members'),
        AppRoutes.familySubscriptionSetup,
      );
      expect(
        familyCheckoutBlockerRoute('family.start_date_required'),
        AppRoutes.familyPackageDaysSetup,
      );
      expect(
        familyCheckoutBlockerRoute('family.address_required'),
        AppRoutes.familyAddresses,
      );
      expect(
        familyCheckoutBlockerRoute('family.allergies_required'),
        AppRoutes.familyAllergies,
      );
      expect(
        familyCheckoutBlockerRoute('restaurant.not_eligible'),
        AppRoutes.familyProgramSetup,
      );
      expect(
        familyCheckoutBlockerRoute('family.checkout_no_selection'),
        isNull,
      );
      expect(familyCheckoutBlockerRoute('family.quote_changed'), isNull);
    });
  });
}
