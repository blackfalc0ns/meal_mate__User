import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_day_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_meal_entity.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/entities/family_day_details_entity.dart';
import 'package:meal_meat_user/features/family_management/overview/domain/entities/family_member_summary_entity.dart';
import 'package:meal_meat_user/features/family_management/calendar/presentation/manager/family_calendar_state.dart';

void main() {
  group('Family Member Calendar, Meals, and Routing Contract Tests', () {
    test(
      'FamilyDayMemberEntity preserves memberId and subscriptionId correctly',
      () {
        const member = FamilyDayMemberEntity(
          name: 'Sarah',
          ageLabel: '8 years',
          statusLabel: 'Active',
          imageAsset: 'assets/avatar.png',
          memberId: 'mem-101',
          subscriptionId: 'sub-202',
        );

        expect(member.name, 'Sarah');
        expect(member.memberId, 'mem-101');
        expect(member.subscriptionId, 'sub-202');
      },
    );

    test('FamilyDayMealEntity handles empty/incomplete slots safely', () {
      const meal = FamilyDayMealEntity(
        mealType: 'Lunch',
        restaurantName: 'Healthy Choice',
        mealName: 'Grilled Chicken',
        actionLabel: 'Change',
        imageAsset: 'assets/lunch.png',
        iconType: FamilyDayMealIconType.lunch,
        isEmpty: false,
      );

      expect(meal.isEmpty, isFalse);
      expect(meal.mealType, 'Lunch');
      expect(meal.calories, '480');

      const emptyMeal = FamilyDayMealEntity(
        mealType: 'Dinner',
        restaurantName: '',
        mealName: '',
        actionLabel: 'Select',
        imageAsset: '',
        iconType: FamilyDayMealIconType.dinner,
        isEmpty: true,
      );

      expect(emptyMeal.isEmpty, isTrue);
    });

    test(
      'FamilyCalendarState activeSubscriptionId routes to selected member subscriptionId',
      () {
        const member1 = FamilyMemberSummaryEntity(
          memberId: 'm1',
          displayName: 'Dad',
          role: 1,
          ageYears: 40,
          isPaused: false,
          subscriptionId: 'sub-dad-1',
          programName: 'Keto',
          remainingDays: 14,
          setupStatus: 2,
        );

        const member2 = FamilyMemberSummaryEntity(
          memberId: 'm2',
          displayName: 'Son',
          role: 2,
          ageYears: 12,
          isPaused: false,
          subscriptionId: 'sub-son-2',
          programName: 'Fit',
          remainingDays: 14,
          setupStatus: 2,
        );

        final state = FamilyCalendarState(
          members: [member1, member2],
          selectedMemberIndex: 1,
        );

        expect(state.activeSubscriptionId, 'sub-son-2');
        expect(state.displayName, 'Son');
      },
    );

    test('CalendarDayEntity gates edits on frozen/protected/cutoff days', () {
      final editableDay = CalendarDayEntity(
        dayNumber: 15,
        weekday: 'Monday',
        date: DateTime.now().add(const Duration(days: 3)),
        status: 'confirmed',
        canEdit: true,
      );
      expect(editableDay.isEditable, isTrue);

      final protectedDay = CalendarDayEntity(
        dayNumber: 13,
        weekday: 'Saturday',
        date: DateTime.now().add(const Duration(days: 1)),
        status: 'cutoff',
        canEdit: false,
        editBlockReason: 'selection_deadline_passed',
      );
      expect(protectedDay.isEditable, isFalse);
      expect(protectedDay.isLocked, isTrue);
    });
  });
}
