import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/errors/subscription_error_codes.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations_en.dart';
import 'package:meal_meat_user/core/network/failures.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_day_entity.dart';
import 'package:meal_meat_user/features/calendar/presentation/mapper/calendar_failure_message_mapper.dart';
import 'package:meal_meat_user/features/food_preferences/domain/entities/food_preferences_entity.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_availability_entity.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_prerequisite_destination.dart';
import 'package:meal_meat_user/features/subscription_packages/domain/entities/subscription_bundle_entity.dart';
import 'package:meal_meat_user/features/subscription_programs/domain/entities/subscription_program_entity.dart';

void main() {
  group('Task 1: Mandatory Order and Readiness Prerequisite Tests', () {
    test(
      'enforces strict mandatory order ADDRESS -> ALLERGIES -> DIETARY_PREFERENCES',
      () {
        final list = SubscriptionPrerequisiteDestination.listFromProfileStatus(
          hasDeliveryAddress: false,
          hasAllergies: false,
          hasDietaryPreferences: false,
        );

        expect(list, [
          SubscriptionPrerequisiteDestination.address,
          SubscriptionPrerequisiteDestination.allergies,
          SubscriptionPrerequisiteDestination.dietaryPreferences,
        ]);
      },
    );

    test(
      'parses missingStep from availability with mandatory order precedence',
      () {
        expect(
          SubscriptionPrerequisiteDestination.fromMissingStep('ADDRESS'),
          SubscriptionPrerequisiteDestination.address,
        );
        expect(
          SubscriptionPrerequisiteDestination.fromMissingStep('ALLERGIES'),
          SubscriptionPrerequisiteDestination.allergies,
        );
        expect(
          SubscriptionPrerequisiteDestination.fromMissingStep(
            'DIETARY_PREFERENCES',
          ),
          SubscriptionPrerequisiteDestination.dietaryPreferences,
        );
      },
    );

    test(
      'treats empty allergies/preferences as complete ONLY when completed timestamp is present',
      () {
        // Unconfirmed empty preferences
        const unconfirmedPrefs = FoodPreferencesEntity(
          allergies: [],
          dislikedFoods: [],
          dietaryPreferences: [],
          allergiesCompletedAtUtc: null,
          dietaryPreferencesCompletedAtUtc: null,
        );

        expect(
          SubscriptionPrerequisiteDestination.isAllergiesCompleted(
            hasAllergiesFlag: false,
            allergiesCount: unconfirmedPrefs.allergies.length,
            completedAtUtc: unconfirmedPrefs.allergiesCompletedAtUtc,
          ),
          isFalse,
        );

        expect(
          SubscriptionPrerequisiteDestination.isDietaryPreferencesCompleted(
            hasDietaryPreferencesFlag: false,
            preferencesCount: unconfirmedPrefs.dietaryPreferences.length,
            completedAtUtc: unconfirmedPrefs.dietaryPreferencesCompletedAtUtc,
          ),
          isFalse,
        );

        expect(unconfirmedPrefs.isAllergiesConfirmed, isFalse);
        expect(unconfirmedPrefs.isDietaryPreferencesConfirmed, isFalse);

        // Confirmed empty preferences with timestamp
        final confirmedPrefs = FoodPreferencesEntity(
          allergies: const [],
          dislikedFoods: const [],
          dietaryPreferences: const [],
          allergiesCompletedAtUtc: DateTime.parse('2026-10-11T07:00:00Z'),
          dietaryPreferencesCompletedAtUtc: DateTime.parse(
            '2026-10-11T07:00:00Z',
          ),
        );

        expect(
          SubscriptionPrerequisiteDestination.isAllergiesCompleted(
            hasAllergiesFlag: false,
            allergiesCount: confirmedPrefs.allergies.length,
            completedAtUtc: confirmedPrefs.allergiesCompletedAtUtc,
          ),
          isTrue,
        );

        expect(
          SubscriptionPrerequisiteDestination.isDietaryPreferencesCompleted(
            hasDietaryPreferencesFlag: false,
            preferencesCount: confirmedPrefs.dietaryPreferences.length,
            completedAtUtc: confirmedPrefs.dietaryPreferencesCompletedAtUtc,
          ),
          isTrue,
        );

        expect(confirmedPrefs.isAllergiesConfirmed, isTrue);
        expect(confirmedPrefs.isDietaryPreferencesConfirmed, isTrue);
      },
    );

    test(
      'SubscriptionAvailabilityEntity correctly reflects address requirement and canSelect',
      () {
        const addressRequiredAvailability = SubscriptionAvailabilityEntity(
          status: 'address_required',
          canSelect: false,
          messageCode: 'checkout.address_required',
          missingStep: 'ADDRESS',
          coveredRestaurantCount: 5,
          effectiveStartDate: '2026-10-12',
        );

        expect(addressRequiredAvailability.isAddressRequired, isTrue);
        expect(addressRequiredAvailability.effectiveCanSelect, isFalse);
      },
    );
  });

  group('Task 2: Catalog Contracts and Program/Bundle Selection', () {
    test(
      'SubscriptionProgramEntity respects canSelect=false and availability',
      () {
        const programWithDisabledAvailability = SubscriptionProgramEntity(
          programId: 'prog-1',
          code: 'PROG1',
          shortCode: 'P1',
          nameAr: 'برنامج',
          nameEn: 'Program',
          descriptionAr: 'وصف',
          descriptionEn: 'Description',
          keywordsAr: [],
          keywordsEn: [],
          imageUrl: null,
          bundleCount: 2,
          supportedSlots: [],
          fallbackImageAsset: '',
          isAvailable: true,
          availability: SubscriptionAvailabilityEntity(
            status: 'unavailable',
            canSelect: false,
            messageCode: 'no_restaurants_for_address',
            coveredRestaurantCount: 0,
            effectiveStartDate: '2026-10-12',
          ),
        );

        expect(programWithDisabledAvailability.canSelect, isFalse);

        const availableProgram = SubscriptionProgramEntity(
          programId: 'prog-2',
          code: 'PROG2',
          shortCode: 'P2',
          nameAr: 'برنامج متاح',
          nameEn: 'Available Program',
          descriptionAr: 'وصف',
          descriptionEn: 'Description',
          keywordsAr: [],
          keywordsEn: [],
          imageUrl: null,
          bundleCount: 2,
          supportedSlots: [],
          fallbackImageAsset: '',
          isAvailable: true,
          availability: SubscriptionAvailabilityEntity(
            status: 'available',
            canSelect: true,
            messageCode: '',
            coveredRestaurantCount: 3,
            effectiveStartDate: '2026-10-12',
          ),
        );

        expect(availableProgram.canSelect, isTrue);
      },
    );

    test('SubscriptionBundleEntity respects canSelect=false', () {
      const unselectableBundle = SubscriptionBundleEntity(
        bundleId: 'bundle-1',
        programId: 'prog-1',
        code: 'BUNDLE1',
        nameAr: 'باقة',
        nameEn: 'Bundle',
        descriptionAr: 'وصف',
        descriptionEn: 'Description',
        imageUrl: null,
        mealsPerDay: 3,
        breakfastCount: 1,
        lunchCount: 1,
        dinnerCount: 1,
        snackCount: 0,
        slots: [],
        restaurantCount: 0,
        restaurants: [],
        selectionCount: 0,
        isMostSelected: false,
        badge: null,
        isAvailable: true,
        availability: SubscriptionAvailabilityEntity(
          status: 'unavailable',
          canSelect: false,
          messageCode: 'no_restaurants_for_address',
          coveredRestaurantCount: 0,
          effectiveStartDate: '2026-10-12',
        ),
      );

      expect(unselectableBundle.canSelect, isFalse);
    });

    test(
      'coveredRestaurantCount without address is incidental count and eligibleRestaurantCount=null means no period check',
      () {
        const incidentalAvailability = SubscriptionAvailabilityEntity(
          status: 'address_required',
          canSelect: true,
          messageCode: 'address_required',
          missingStep: 'ADDRESS',
          coveredRestaurantCount: 12,
          eligibleRestaurantCount: null,
          effectiveStartDate: '2026-10-12',
        );

        expect(incidentalAvailability.isAddressRequired, isTrue);
        expect(incidentalAvailability.eligibleRestaurantCount, isNull);
      },
    );
  });

  group('Task 4: Calendar Day Entity, Lock Reason, and Replacement Window', () {
    test(
      'distinguishes CustomerSelected (saved) from SentToRestaurant (sent)',
      () {
        const savedDay = CalendarDayEntity(
          dayNumber: 1,
          weekday: 'Sunday',
          status: 'CustomerSelected',
          uiStatus: 'Saved',
        );

        expect(savedDay.isCustomerSelected, isTrue);
        expect(savedDay.isSentToRestaurant, isFalse);
        expect(savedDay.isAwaitingRestaurantConfirmation, isFalse);

        const sentDay = CalendarDayEntity(
          dayNumber: 2,
          weekday: 'Monday',
          status: 'SentToRestaurant',
          uiStatus: 'AwaitingConfirmation',
        );

        expect(sentDay.isCustomerSelected, isFalse);
        expect(sentDay.isSentToRestaurant, isTrue);
        expect(sentDay.isAwaitingRestaurantConfirmation, isTrue);
      },
    );

    test(
      'locks day when canEdit is false or editBlockReason is a lock reason',
      () {
        const deadlinePassedDay = CalendarDayEntity(
          dayNumber: 3,
          weekday: 'Tuesday',
          canEdit: true,
          editBlockReason: 'selection_deadline_passed',
        );

        expect(deadlinePassedDay.isLockedReason, isTrue);
        expect(deadlinePassedDay.isLocked, isTrue);
        expect(deadlinePassedDay.isEditable, isFalse);

        const dayLockedDay = CalendarDayEntity(
          dayNumber: 4,
          weekday: 'Wednesday',
          canEdit: true,
          editBlockReason: 'day_locked',
        );

        expect(dayLockedDay.isLocked, isTrue);

        const frozenDay = CalendarDayEntity(
          dayNumber: 5,
          weekday: 'Thursday',
          canEdit: true,
          editBlockReason: 'day_frozen',
        );

        expect(frozenDay.isLocked, isTrue);

        const cancelledDay = CalendarDayEntity(
          dayNumber: 6,
          weekday: 'Friday',
          canEdit: true,
          editBlockReason: 'day_cancelled',
        );

        expect(cancelledDay.isLocked, isTrue);

        const normalEditableDay = CalendarDayEntity(
          dayNumber: 7,
          weekday: 'Saturday',
          canEdit: true,
          editBlockReason: null,
        );

        expect(normalEditableDay.isLocked, isFalse);
        expect(normalEditableDay.isEditable, isTrue);
      },
    );
  });

  group('Task 6: Freeze Error Codes and Localizations', () {
    final locale = AppLocalizationsEn();

    test('maps all freeze contract codes in English', () {
      expect(
        CalendarFailureMessageMapper.map(
          failure: Failure(
            code: SubscriptionErrorCodes.freezePreparationUnavailable,
            errorMessage: '',
          ),
          locale: locale,
        ),
        locale.freeze_preparation_failed,
      );

      expect(
        CalendarFailureMessageMapper.map(
          failure: Failure(
            code: SubscriptionErrorCodes.replacementCapacityUnavailable,
            errorMessage: '',
          ),
          locale: locale,
        ),
        locale.freeze_replacement_capacity_unavailable,
      );

      expect(
        CalendarFailureMessageMapper.map(
          failure: Failure(
            code: SubscriptionErrorCodes.replacementRestaurantsUnavailable,
            errorMessage: '',
          ),
          locale: locale,
        ),
        locale.freeze_replacement_restaurants_unavailable,
      );

      expect(
        CalendarFailureMessageMapper.map(
          failure: Failure(
            code: SubscriptionErrorCodes.freezeReplacementPoolUnavailable,
            errorMessage: '',
          ),
          locale: locale,
        ),
        locale.freeze_replacement_pool_unavailable,
      );

      expect(
        CalendarFailureMessageMapper.map(
          failure: Failure(
            code: SubscriptionErrorCodes.freezeNoServiceDays,
            errorMessage: '',
          ),
          locale: locale,
        ),
        locale.freeze_no_service_days,
      );

      expect(
        CalendarFailureMessageMapper.map(
          failure: Failure(
            code: SubscriptionErrorCodes.freezeLockedDaysCannotBeFrozen,
            errorMessage: '',
          ),
          locale: locale,
        ),
        locale.billing_freeze_locked_days_cannot_be_frozen,
      );
    });
  });
}
