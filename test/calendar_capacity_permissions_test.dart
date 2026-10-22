import 'package:meal_meat_user/features/calendar/domain/entities/calendar_operational_clock.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_subscription_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_day_entity.dart';
import 'package:meal_meat_user/features/calendar/presentation/helpers/calendar_days_builder.dart';

void main() {
  test('cutoffs use server time despite a different device date', () {
    final day = CalendarDayEntity(
      dayNumber: 24,
      weekday: '',
      canSelectMeal: true,
      mealSelectionClosesAt: DateTime.utc(2000, 1, 2),
      operationalClock: CalendarOperationalClock(DateTime.utc(2000, 1, 1)),
    );
    expect(day.isEditable, isTrue);
    expect(
      day
          .copyWith(
            operationalClock: CalendarOperationalClock(
              DateTime.utc(2000, 1, 3),
            ),
          )
          .isEditable,
      isFalse,
    );
    const noClock = CalendarDayEntity(
      dayNumber: 24,
      weekday: '',
      canSelectMeal: true,
    );
    expect(
      noClock.copyWith(mealSelectionClosesAt: DateTime.utc(2000)).isEditable,
      isTrue,
    );
  });
  test('freeze range rejects blocked interior days and absent permission', () {
    final calendar = CalendarSubscriptionEntity(
      subscriptionId: 's',
      days: [
        CalendarDayEntity(
          dayNumber: 24,
          weekday: '',
          date: DateTime(2026, 10, 24),
          canFreeze: true,
        ),
        CalendarDayEntity(
          dayNumber: 25,
          weekday: '',
          date: DateTime(2026, 10, 25),
        ),
        CalendarDayEntity(
          dayNumber: 26,
          weekday: '',
          date: DateTime(2026, 10, 26),
          canFreeze: true,
        ),
      ],
    );
    expect(
      calendar.canFreezeRange(DateTime(2026, 10, 24), DateTime(2026, 10, 26)),
      isFalse,
    );
    expect(
      calendar.canFreezeRange(DateTime(2026, 10, 24), DateTime(2026, 10, 24)),
      isTrue,
    );
  });
  test(
    'unknown freeze days fail closed while excluded Friday permits ranges',
    () {
      final calendar = CalendarSubscriptionEntity(
        subscriptionId: 's',
        includeFriday: false,
        days: [
          CalendarDayEntity(
            dayNumber: 22,
            weekday: '',
            date: DateTime(2026, 10, 22),
            canFreeze: true,
          ),
          CalendarDayEntity(
            dayNumber: 24,
            weekday: '',
            date: DateTime(2026, 10, 24),
            canFreeze: true,
          ),
        ],
      );
      expect(
        calendar.canFreezeRange(DateTime(2026, 10, 22), DateTime(2026, 10, 24)),
        isTrue,
      );
      expect(calendar.canFreezeDate(DateTime(2026, 10, 25)), isFalse);
      expect(calendar.canFreezeDate(DateTime(2026, 10, 23)), isFalse);
      expect(calendar.canFreezeInteriorDate(DateTime(2026, 10, 23)), isTrue);
      expect(
        calendar.canFreezeRange(DateTime(2026, 10, 23), DateTime(2026, 10, 23)),
        isFalse,
      );
      expect(
        calendar.canFreezeRange(DateTime(2026, 10, 22), DateTime(2026, 10, 23)),
        isFalse,
      );
    },
  );
  test('server permissions close independent actions at their own cutoff', () {
    final past = DateTime.now().subtract(const Duration(hours: 1));
    final future = DateTime.now().add(const Duration(hours: 1));
    final day = CalendarDayEntity(
      dayNumber: 24,
      weekday: '',
      canSelectMeal: true,
      operationalClock: CalendarOperationalClock(DateTime.now().toUtc()),
      canChangeAddress: true,
      canFreeze: true,
      mealSelectionClosesAt: past,
      addressEditClosesAt: future,
      freezeClosesAt: past,
    );
    expect(day.isEditable, isFalse);
    expect(day.canEditAddress, isTrue);
    expect(day.canFreezeDay, isFalse);
    expect(day.copyWith(mealSelectionClosesAt: future).isEditable, isTrue);
    expect(
      day
          .copyWith(canSelectMeal: false, mealSelectionClosesAt: future)
          .isEditable,
      isFalse,
    );
  });
  test(
    'missing permissions do not grant actions or invent a lead deadline',
    () {
      const day = CalendarDayEntity(dayNumber: 24, weekday: '');
      expect(day.isEditable, isFalse);
      expect(day.canEditAddress, isFalse);
      expect(day.canFreezeDay, isFalse);
    },
  );
  test('Friday-free monthly rows retain Saturday to Thursday alignment', () {
    for (var month = 1; month <= 12; month++) {
      final days = CalendarDaysBuilder.monthDays(
        focusedMonth: DateTime(2026, month),
        selectedDate: null,
        serviceDays: [],
        includeFriday: false,
      );
      expect(days.length % 6, 0);
      expect(days.any((day) => day.date!.weekday == DateTime.friday), isFalse);
      for (var index = 0; index < days.length; index += 6) {
        expect(days[index].date!.weekday, DateTime.saturday);
        expect(days[index + 5].date!.weekday, DateTime.thursday);
      }
    }
  });
}
