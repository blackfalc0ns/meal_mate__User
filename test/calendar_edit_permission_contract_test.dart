import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/features/calendar/data/mapper/calendar_mapper.dart';
import 'package:meal_meat_user/features/calendar/data/models/response/calendar_day_response_dto.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_day_entity.dart';

void main() {
  group('Calendar Edit Permission Contract Tests (Task 7)', () {
    test(
      'isEditable is strictly governed by canEdit == true regardless of status',
      () {
        // status=Confirmed with canEdit=true -> isEditable is true
        const confirmedEditable = CalendarDayEntity(
          dayNumber: 1,
          weekday: 'Monday',
          status: 'Confirmed',
          uiStatus: 'confirmed',
          canEdit: true,
        );
        expect(confirmedEditable.isEditable, isTrue);

        // status=Pending with canEdit=true -> isEditable is true
        const pendingEditable = CalendarDayEntity(
          dayNumber: 2,
          weekday: 'Tuesday',
          status: 'Pending',
          uiStatus: 'senttorestaurant',
          canEdit: true,
        );
        expect(pendingEditable.isEditable, isTrue);

        // status=Locked with canEdit=true -> isEditable is true
        const lockedWithCanEditTrue = CalendarDayEntity(
          dayNumber: 3,
          weekday: 'Wednesday',
          status: 'Locked',
          uiStatus: 'locked',
          canEdit: true,
        );
        expect(lockedWithCanEditTrue.isEditable, isTrue);

        // future day with countdown > 0 but canEdit=false -> isEditable is false
        const futureUneditable = CalendarDayEntity(
          dayNumber: 4,
          weekday: 'Thursday',
          status: 'Scheduled',
          canEdit: false,
          lockRemainingSeconds: 3600,
        );
        expect(futureUneditable.isEditable, isFalse);

        // null canEdit -> isEditable is false
        const nullCanEdit = CalendarDayEntity(
          dayNumber: 5,
          weekday: 'Friday',
          status: 'Scheduled',
          canEdit: null,
        );
        expect(nullCanEdit.isEditable, isFalse);
      },
    );

    test(
      'CalendarDayResponseDto maps new server contract fields accurately',
      () {
        const dto = CalendarDayResponseDto(
          id: 'day-1',
          date: '2026-10-15',
          serviceDate: '2026-10-15',
          status: 'Scheduled',
          uiStatus: 'scheduled',
          canEdit: true,
          editBlockReason: 'selection_deadline_passed',
          selectionDeadlineUtc: '2026-10-14T20:00:00Z',
          lockAtUtc: '2026-10-14T21:00:00Z',
          lockRemainingSeconds: 7200,
          filledCount: 2,
          requiredCount: 3,
        );

        final entity = dto.toEntity('en');

        expect(entity.id, 'day-1');
        expect(entity.canEdit, isTrue);
        expect(entity.isEditable, isTrue);
        expect(entity.editBlockReason, 'selection_deadline_passed');
        expect(
          entity.selectionDeadlineUtc,
          DateTime.utc(2026, 10, 14, 20, 0, 0),
        );
        expect(entity.lockAtUtc, DateTime.utc(2026, 10, 14, 21, 0, 0));
        expect(entity.lockRemainingSeconds, 7200);
        expect(entity.filledCount, 2);
        expect(entity.requiredCount, 3);
        // isLocked does not override canEdit when canEdit is true
        expect(entity.isLocked, isFalse);
      },
    );

    test(
      'CalendarDayEntity copyWith preserves and updates new server fields properly',
      () {
        final original = CalendarDayEntity(
          id: 'day-1',
          dayNumber: 15,
          weekday: 'Thursday',
          canEdit: false,
          editBlockReason: 'day_locked',
          selectionDeadlineUtc: DateTime.utc(2026, 10, 14, 20, 0, 0),
          lockAtUtc: DateTime.utc(2026, 10, 14, 21, 0, 0),
          lockRemainingSeconds: 0,
          filledCount: 3,
          requiredCount: 3,
        );

        final updated = original.copyWith(
          canEdit: true,
          clearEditBlockReason: true,
          lockRemainingSeconds: 1800,
        );

        expect(updated.id, 'day-1');
        expect(updated.canEdit, isTrue);
        expect(updated.isEditable, isTrue);
        expect(updated.editBlockReason, isNull);
        expect(
          updated.selectionDeadlineUtc,
          DateTime.utc(2026, 10, 14, 20, 0, 0),
        );
        expect(updated.lockAtUtc, DateTime.utc(2026, 10, 14, 21, 0, 0));
        expect(updated.lockRemainingSeconds, 1800);
        expect(updated.filledCount, 3);
        expect(updated.requiredCount, 3);
      },
    );
  });
}
