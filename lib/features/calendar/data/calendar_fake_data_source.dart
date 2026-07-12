import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_day_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_meal_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_restaurant_entity.dart';

class CalendarFakeDataSource {
  const CalendarFakeDataSource();

  String get monthTitle => 'سبتمبر 2026';

  CalendarRestaurantEntity getRestaurant() => const CalendarRestaurantEntity(
    name: 'هيليثي بايتس',
    category: 'أكل صحي',
    rating: '4.5',
    deliveryDuration: 'بيزك',
    deliveryWindow: 'وقت التوصيل المعتاد: 6:00 م - 7:00 م',
  );

  List<CalendarDayEntity> getWeekDays({required int selectedDay}) {
    const days = [
      CalendarDayEntity(dayNumber: 25, weekday: 'الأحد', isMuted: true),
      CalendarDayEntity(dayNumber: 26, weekday: 'الأثنين'),
      CalendarDayEntity(dayNumber: 27, weekday: 'الثلاثاء'),
      CalendarDayEntity(dayNumber: 28, weekday: 'الأربعاء'),
      CalendarDayEntity(dayNumber: 29, weekday: 'الخميس'),
      CalendarDayEntity(dayNumber: 30, weekday: 'الجمعة'),
      CalendarDayEntity(dayNumber: 1, weekday: 'السبت', isMuted: true),
    ];

    return [
      for (final day in days)
        CalendarDayEntity(
          dayNumber: day.dayNumber,
          weekday: day.weekday,
          isSelected: day.dayNumber == selectedDay,
          isMuted: day.isMuted,
          hasMeals: day.hasMeals,
        ),
    ];
  }

  List<CalendarDayEntity> getMonthDays({required int selectedDay}) {
    const visibleDays = [
      28,
      29,
      30,
      31,
      1,
      2,
      3,
      4,
      5,
      6,
      7,
      8,
      9,
      10,
      11,
      12,
      13,
      14,
      15,
      16,
      17,
      18,
      19,
      20,
      21,
      22,
      23,
      24,
      25,
      26,
      27,
      28,
      29,
      30,
      1,
    ];

    return List.generate(visibleDays.length, (index) {
      final day = visibleDays[index];
      final inCurrentMonth = index >= 4 && index <= 33;

      return CalendarDayEntity(
        dayNumber: day,
        weekday: '',
        isSelected: day == selectedDay && inCurrentMonth,
        isMuted: !inCurrentMonth,
        hasMeals: inCurrentMonth,
      );
    });
  }

  List<CalendarMealEntity> getMeals(int selectedDay) {
    return [
      CalendarMealEntity(
        mealType: 'الإفطار',
        title: 'دجاج مشوي مع أرز بني وخضار',
        time: '01:00 م',
        calories: '550',
        protein: '35 جم',
        carbs: '55 جم',
        fat: '18 م',
        ingredients: const ['أرز بني', 'بروكلي', 'جزر', 'المزيد ..'],
        imageAsset: Assets.calendarFigmaMealBowl,
        actionLabel: 'تغيير الوجبة',
      ),
      CalendarMealEntity(
        mealType: 'الغداء',
        title: 'دجاج مشوي مع أرز بني وخضار',
        time: '04:30 م',
        calories: '550',
        protein: '35 جم',
        carbs: '55 جم',
        fat: '18 م',
        ingredients: const ['أرز بني', 'بروكلي', 'جزر', 'المزيد ..'],
        imageAsset: Assets.calendarFigmaMealBowl,
        actionLabel: 'تغيير الوجبة',
      ),
      CalendarMealEntity(
        mealType: 'العشاء',
        title: 'دجاج مشوي مع أرز بني وخضار',
        time: '07:00 م',
        calories: '550',
        protein: '35 جم',
        carbs: '55 جم',
        fat: '18 م',
        ingredients: const ['أرز بني', 'بروكلي', 'جزر', 'المزيد ..'],
        imageAsset: Assets.calendarFigmaMealBowl,
        actionLabel: 'تغيير الوجبة',
      ),
    ];
  }
}
