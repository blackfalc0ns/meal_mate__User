import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_day_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_meal_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_restaurant_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_restaurant_option_entity.dart';

class CalendarFakeDataSource {
  const CalendarFakeDataSource();

  static const _monthNames = [
    'يناير',
    'فبراير',
    'مارس',
    'أبريل',
    'مايو',
    'يونيو',
    'يوليو',
    'أغسطس',
    'سبتمبر',
    'أكتوبر',
    'نوفمبر',
    'ديسمبر',
  ];

  static const _weekdayNames = [
    'الإثنين',
    'الثلاثاء',
    'الأربعاء',
    'الخميس',
    'الجمعة',
    'السبت',
    'الأحد',
  ];

  String getMonthTitle(DateTime month) {
    return '${_monthNames[month.month - 1]} ${month.year}';
  }

  CalendarRestaurantEntity getRestaurant() => const CalendarRestaurantEntity(
    name: 'هيليثي بايتس',
    category: 'أكل صحي',
    rating: '4.5',
    deliveryDuration: 'بيزك',
    deliveryWindow: 'وقت التوصيل المعتاد: 6:00 م - 7:00 م',
  );

  CalendarRestaurantEntity getRestaurantFromOption(
    CalendarRestaurantOptionEntity option,
  ) {
    return CalendarRestaurantEntity(
      name: option.name,
      category: 'أكل صحي',
      rating: option.rating,
      deliveryDuration: 'بيزك',
      deliveryWindow: 'وقت التوصيل المعتاد: 6:00 م - 7:00 م',
    );
  }

  List<CalendarRestaurantOptionEntity> getRestaurantOptions() => const [
    CalendarRestaurantOptionEntity(
      name: 'هيلثي بول',
      description: 'وجبات صحية متوازنة بمكونات طبيعية',
      mealCount: 28,
      rating: '4.8',
      logoType: CalendarRestaurantLogoType.healthyBowl,
    ),
    CalendarRestaurantOptionEntity(
      name: 'دايت هاوس',
      description: 'وجبات صحية متوازنة بمكونات طبيعية',
      mealCount: 28,
      rating: '4.8',
      logoType: CalendarRestaurantLogoType.dietHouse,
    ),
    CalendarRestaurantOptionEntity(
      name: 'بروتين كيتشن',
      description: 'وجبات صحية متوازنة بمكونات طبيعية',
      mealCount: 28,
      rating: '4.8',
      logoType: CalendarRestaurantLogoType.proteinKitchen,
    ),
    CalendarRestaurantOptionEntity(
      name: 'ستاربكس',
      description: 'وجبات صحية متوازنة بمكونات طبيعية',
      mealCount: 28,
      rating: '4.8',
      logoType: CalendarRestaurantLogoType.starbucks,
    ),
    CalendarRestaurantOptionEntity(
      name: 'برجر كينج',
      description: 'وجبات صحية متوازنة بمكونات طبيعية',
      mealCount: 28,
      rating: '4.8',
      logoType: CalendarRestaurantLogoType.burgerKing,
    ),
    CalendarRestaurantOptionEntity(
      name: 'دايت هاوس',
      description: 'وجبات صحية متوازنة بمكونات طبيعية',
      mealCount: 28,
      rating: '4.8',
      logoType: CalendarRestaurantLogoType.dietHouse,
    ),
    CalendarRestaurantOptionEntity(
      name: 'بروتين كيتشن',
      description: 'وجبات صحية متوازنة بمكونات طبيعية',
      mealCount: 28,
      rating: '4.8',
      logoType: CalendarRestaurantLogoType.proteinKitchen,
    ),
  ];

  List<CalendarDayEntity> getWeekDays({
    required DateTime selectedDate,
    required DateTime focusedMonth,
  }) {
    final startOfWeek = selectedDate.subtract(
      Duration(days: _daysFromSaturday(selectedDate)),
    );

    return List.generate(7, (index) {
      final date = _dateOnly(startOfWeek.add(Duration(days: index)));
      final inFocusedMonth = _isSameMonth(date, focusedMonth);

      return CalendarDayEntity(
        dayNumber: date.day,
        weekday: _weekdayNames[date.weekday - 1],
        date: date,
        isSelected: _isSameDay(date, selectedDate),
        isMuted: !inFocusedMonth,
        hasMeals: inFocusedMonth,
      );
    });
  }

  List<CalendarDayEntity> getMonthDays({
    required DateTime focusedMonth,
    required DateTime selectedDate,
  }) {
    final firstDay = DateTime(focusedMonth.year, focusedMonth.month);
    final leadingDays = (firstDay.weekday + 1) % 7;
    final gridStart = firstDay.subtract(Duration(days: leadingDays));
    final daysInMonth = DateTime(
      focusedMonth.year,
      focusedMonth.month + 1,
      0,
    ).day;
    final totalCells = ((leadingDays + daysInMonth + 6) ~/ 7) * 7;

    return List.generate(totalCells, (index) {
      final date = _dateOnly(gridStart.add(Duration(days: index)));
      final inFocusedMonth = _isSameMonth(date, focusedMonth);
      return CalendarDayEntity(
        dayNumber: date.day,
        weekday: '',
        date: date,
        isSelected: _isSameDay(date, selectedDate),
        isMuted: !inFocusedMonth,
        hasMeals: inFocusedMonth,
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

  int _daysFromSaturday(DateTime date) {
    return (date.weekday + 1) % 7;
  }

  DateTime _dateOnly(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  bool _isSameMonth(DateTime date, DateTime month) {
    return date.year == month.year && date.month == month.month;
  }
}
