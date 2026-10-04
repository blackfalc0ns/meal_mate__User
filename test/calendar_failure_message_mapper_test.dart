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
  });
}
