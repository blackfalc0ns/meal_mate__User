import 'package:meal_meat_user/core/errors/subscription_error_codes.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/core/network/failures.dart';

class CalendarFailureMessageMapper {
  const CalendarFailureMessageMapper._();

  static String map({
    required Failure? failure,
    required AppLocalizations locale,
  }) {
    if (failure == null) return '';

    if (failure.code == SubscriptionErrorCodes.calendarBoxIncomplete) {
      return locale.calendar_error_box_incomplete;
    } else if (failure.code == SubscriptionErrorCodes.calendarSelectionLocked) {
      return locale.calendar_error_selection_locked;
    } else if (failure.code == SubscriptionErrorCodes.calendarDayUnavailable) {
      return locale.calendar_error_day_unavailable;
    } else if (failure.code ==
        SubscriptionErrorCodes.calendarFulfillmentNotReady) {
      return locale.calendar_error_fulfillment_not_ready;
    }

    return failure.errorMessage.isNotEmpty
        ? failure.errorMessage
        : locale.error_unknown_desc;
  }
}
