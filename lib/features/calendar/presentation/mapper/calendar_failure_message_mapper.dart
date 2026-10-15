import 'package:meal_meat_user/core/errors/subscription_error_codes.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/core/errors/failures.dart';

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
    } else if (failure.code == SubscriptionErrorCodes.fulfillmentPending ||
        failure.code == SubscriptionErrorCodes.fulfillmentNotReady) {
      return locale.calendar_fulfillment_pending;
    } else if (failure.code ==
        SubscriptionErrorCodes.calendarRestaurantCoverageUnavailable) {
      return locale.calendar_restaurant_coverage_unavailable;
    } else if (failure.code == SubscriptionErrorCodes.calendarBoxNotReady) {
      return locale.calendar_box_not_ready;
    } else if (failure.code == SubscriptionErrorCodes.restaurantCapacityFull) {
      return locale.calendar_restaurant_capacity_full;
    } else if (failure.code == SubscriptionErrorCodes.calendarNoSafeBox) {
      return locale.calendar_no_safe_box;
    } else if (failure.code == SubscriptionErrorCodes.calendarRestaurantBusy) {
      return locale.calendar_restaurant_busy;
    } else if (failure.code == SubscriptionErrorCodes.calendarQuotaExhausted) {
      return locale.calendar_quota_exhausted;
    } else if (failure.code == SubscriptionErrorCodes.autoSelectionFailed) {
      return locale.calendar_auto_selection_failed;
    } else if (failure.code == SubscriptionErrorCodes.deadlinePassed ||
        failure.code == SubscriptionErrorCodes.selectionDeadlinePassed ||
        failure.code ==
            SubscriptionErrorCodes.calendarSelectionDeadlinePassed) {
      return locale.calendar_selection_deadline_passed;
    } else if (failure.code == SubscriptionErrorCodes.firstDayDeadline) {
      return locale.calendar_first_day_deadline;
    } else if (failure.code == SubscriptionErrorCodes.ordinaryDeadline) {
      return locale.calendar_ordinary_deadline;
    } else if (failure.code == SubscriptionErrorCodes.dayLocked ||
        failure.code == SubscriptionErrorCodes.calendarDayLocked) {
      return locale.calendarDayLocked;
    } else if (failure.code == SubscriptionErrorCodes.dayFrozen ||
        failure.code == SubscriptionErrorCodes.calendarDayFrozen) {
      return locale.calendarDayFrozen;
    } else if (failure.code == SubscriptionErrorCodes.dayCancelled ||
        failure.code == SubscriptionErrorCodes.calendarDayCancelled) {
      return locale.calendarDayCancelled;
    } else if (failure.code == SubscriptionErrorCodes.freezePreparationFailed ||
        failure.code == SubscriptionErrorCodes.freezePreparationUnavailable) {
      return locale.freeze_preparation_failed;
    } else if (failure.code ==
        SubscriptionErrorCodes.replacementCapacityUnavailable) {
      return locale.freeze_replacement_capacity_unavailable;
    } else if (failure.code ==
        SubscriptionErrorCodes.replacementRestaurantsUnavailable) {
      return locale.freeze_replacement_restaurants_unavailable;
    } else if (failure.code ==
        SubscriptionErrorCodes.freezeReplacementPoolUnavailable) {
      return locale.freeze_replacement_pool_unavailable;
    } else if (failure.code == SubscriptionErrorCodes.freezeNoServiceDays) {
      return locale.freeze_no_service_days;
    } else if (failure.code ==
        SubscriptionErrorCodes.freezeLockedDaysCannotBeFrozen) {
      return locale.billing_freeze_locked_days_cannot_be_frozen;
    }

    return failure.errorMessage.isNotEmpty
        ? failure.errorMessage
        : locale.error_unknown_desc;
  }
}
