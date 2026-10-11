import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/errors/subscription_error_codes.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations_en.dart';
import 'package:meal_meat_user/core/network/failures.dart';
import 'package:meal_meat_user/features/calendar/presentation/mapper/calendar_failure_message_mapper.dart';

void main() {
  final locale = AppLocalizationsEn();

  group('CalendarFailureMessageMapper', () {
    test('maps calendarBoxIncomplete to localized message', () {
      final failure = Failure(
        code: SubscriptionErrorCodes.calendarBoxIncomplete,
        errorMessage: 'Raw message',
      );
      final message = CalendarFailureMessageMapper.map(
        failure: failure,
        locale: locale,
      );
      expect(message, locale.calendar_error_box_incomplete);
    });

    test('maps calendarSelectionLocked to localized message', () {
      final failure = Failure(
        code: SubscriptionErrorCodes.calendarSelectionLocked,
        errorMessage: 'Raw message',
      );
      final message = CalendarFailureMessageMapper.map(
        failure: failure,
        locale: locale,
      );
      expect(message, locale.calendar_error_selection_locked);
    });

    test('maps calendarDayUnavailable to localized message', () {
      final failure = Failure(
        code: SubscriptionErrorCodes.calendarDayUnavailable,
        errorMessage: 'Raw message',
      );
      final message = CalendarFailureMessageMapper.map(
        failure: failure,
        locale: locale,
      );
      expect(message, locale.calendar_error_day_unavailable);
    });

    test('maps calendarFulfillmentNotReady to localized message', () {
      final failure = Failure(
        code: SubscriptionErrorCodes.calendarFulfillmentNotReady,
        errorMessage: 'Raw message',
      );
      final message = CalendarFailureMessageMapper.map(
        failure: failure,
        locale: locale,
      );
      expect(message, locale.calendar_error_fulfillment_not_ready);
    });

    test(
      'maps unknown failure with safe errorMessage to that errorMessage',
      () {
        final failure = Failure(
          code: 'unknown_code',
          errorMessage: 'Custom backend error',
        );
        final message = CalendarFailureMessageMapper.map(
          failure: failure,
          locale: locale,
        );
        expect(message, 'Custom backend error');
      },
    );

    test(
      'maps unknown failure with empty errorMessage to locale.error_unknown_desc',
      () {
        final failure = Failure(code: 'unknown_code', errorMessage: '');
        final message = CalendarFailureMessageMapper.map(
          failure: failure,
          locale: locale,
        );
        expect(message, locale.error_unknown_desc);
      },
    );

    test('returns empty string when failure is null', () {
      final message = CalendarFailureMessageMapper.map(
        failure: null,
        locale: locale,
      );
      expect(message, '');
    });

    test('maps calendarRestaurantCoverageUnavailable to localized message', () {
      final failure = Failure(
        code: SubscriptionErrorCodes.calendarRestaurantCoverageUnavailable,
        errorMessage: 'Raw message',
      );
      final message = CalendarFailureMessageMapper.map(
        failure: failure,
        locale: locale,
      );
      expect(message, locale.calendar_restaurant_coverage_unavailable);
    });

    test('maps calendarBoxNotReady to localized message', () {
      final failure = Failure(
        code: SubscriptionErrorCodes.calendarBoxNotReady,
        errorMessage: 'Raw message',
      );
      final message = CalendarFailureMessageMapper.map(
        failure: failure,
        locale: locale,
      );
      expect(message, locale.calendar_box_not_ready);
    });

    test('maps restaurantCapacityFull to localized message', () {
      final failure = Failure(
        code: SubscriptionErrorCodes.restaurantCapacityFull,
        errorMessage: 'Raw message',
      );
      final message = CalendarFailureMessageMapper.map(
        failure: failure,
        locale: locale,
      );
      expect(message, locale.calendar_restaurant_capacity_full);
    });

    test('maps calendarNoSafeBox to localized message', () {
      final failure = Failure(
        code: SubscriptionErrorCodes.calendarNoSafeBox,
        errorMessage: 'Raw message',
      );
      final message = CalendarFailureMessageMapper.map(
        failure: failure,
        locale: locale,
      );
      expect(message, locale.calendar_no_safe_box);
    });

    test('maps calendarRestaurantBusy to localized message', () {
      final failure = Failure(
        code: SubscriptionErrorCodes.calendarRestaurantBusy,
        errorMessage: 'Raw message',
      );
      final message = CalendarFailureMessageMapper.map(
        failure: failure,
        locale: locale,
      );
      expect(message, locale.calendar_restaurant_busy);
    });

    test('maps calendarQuotaExhausted to localized message', () {
      final failure = Failure(
        code: SubscriptionErrorCodes.calendarQuotaExhausted,
        errorMessage: 'Raw message',
      );
      final message = CalendarFailureMessageMapper.map(
        failure: failure,
        locale: locale,
      );
      expect(message, locale.calendar_quota_exhausted);
    });

    test('maps autoSelectionFailed to localized message', () {
      final failure = Failure(
        code: SubscriptionErrorCodes.autoSelectionFailed,
        errorMessage: 'Raw message',
      );
      final message = CalendarFailureMessageMapper.map(
        failure: failure,
        locale: locale,
      );
      expect(message, locale.calendar_auto_selection_failed);
    });

    test('maps freeze codes to localized messages', () {
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
