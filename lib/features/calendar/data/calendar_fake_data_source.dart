import 'package:meal_meat_user/core/constants/assets_fake.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_day_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_meal_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_restaurant_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_restaurant_option_entity.dart';

typedef CalendarMealPickerOption = ({
  String title,
  String imageAsset,
  String calories,
  String protein,
  String carbs,
  String fat,
  List<String> ingredients,
  bool selected,
  String? blockReason,
});

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

  static const _mealCatalog = [
    CalendarMealEntity(
      mealType: 'الإفطار',
      title: 'شوفان بالتوت والمكسرات',
      time: '07:30 ص',
      calories: '450',
      protein: '24 جم',
      carbs: '62 جم',
      fat: '12 جم',
      ingredients: ['شوفان', 'توت', 'لوز', 'المزيد ..'],
      imageAsset: AssetsFake.homeOatmeal,
      actionLabel: 'تغيير الوجبة',
    ),
    CalendarMealEntity(
      mealType: 'الإفطار',
      title: 'توست البيض والأفوكادو',
      time: '08:15 ص',
      calories: '390',
      protein: '22 جم',
      carbs: '34 جم',
      fat: '18 جم',
      ingredients: ['بيض', 'أفوكادو', 'توست', 'المزيد ..'],
      imageAsset: AssetsFake.calendarMealPickerBreakfast,
      actionLabel: 'تغيير الوجبة',
    ),
    CalendarMealEntity(
      mealType: 'الغداء',
      title: 'بول دجاج مشوي بالكينوا',
      time: '01:00 م',
      calories: '550',
      protein: '35 جم',
      carbs: '55 جم',
      fat: '18 جم',
      ingredients: ['دجاج مشوي', 'كينوا', 'بروكلي', 'المزيد ..'],
      imageAsset: AssetsFake.calendarMealBowl,
      actionLabel: 'تغيير الوجبة',
    ),
    CalendarMealEntity(
      mealType: 'الغداء',
      title: 'طبق سلمون مع أرز',
      time: '02:30 م',
      calories: '610',
      protein: '42 جم',
      carbs: '48 جم',
      fat: '21 جم',
      ingredients: ['سلمون', 'أرز بني', 'خضار', 'المزيد ..'],
      imageAsset: AssetsFake.grilledPlate,
      actionLabel: 'تغيير الوجبة',
    ),
    CalendarMealEntity(
      mealType: 'العشاء',
      title: 'سلطة دجاج بالليمون',
      time: '07:00 م',
      calories: '420',
      protein: '28 جم',
      carbs: '39 جم',
      fat: '14 جم',
      ingredients: ['دجاج', 'خس', 'ليمون', 'المزيد ..'],
      imageAsset: AssetsFake.homeHotdog,
      actionLabel: 'تغيير الوجبة',
    ),
    CalendarMealEntity(
      mealType: 'العشاء',
      title: 'بول فاهيتا لايت',
      time: '08:30 م',
      calories: '510',
      protein: '39 جم',
      carbs: '43 جم',
      fat: '15 جم',
      ingredients: ['فاهيتا', 'فلفل', 'أرز بني', 'المزيد ..'],
      imageAsset: AssetsFake.homeDonut,
      actionLabel: 'تغيير الوجبة',
    ),
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
      description: 'خطط وجبات خفيفة ومناسبة للدايت',
      mealCount: 34,
      rating: '4.7',
      logoType: CalendarRestaurantLogoType.dietHouse,
    ),
    CalendarRestaurantOptionEntity(
      name: 'بروتين كيتشن',
      description: 'وجبات عالية البروتين للرياضة والرشاقة',
      mealCount: 42,
      rating: '4.9',
      logoType: CalendarRestaurantLogoType.proteinKitchen,
    ),
    CalendarRestaurantOptionEntity(
      name: 'ستاربكس',
      description: 'سناكات ومشروبات خفيفة لليوم الطويل',
      mealCount: 18,
      rating: '4.4',
      logoType: CalendarRestaurantLogoType.starbucks,
    ),
    CalendarRestaurantOptionEntity(
      name: 'برجر كينج',
      description: 'اختيارات سريعة مع بدائل أخف',
      mealCount: 22,
      rating: '4.2',
      logoType: CalendarRestaurantLogoType.burgerKing,
    ),
    CalendarRestaurantOptionEntity(
      name: 'جرين بايتس',
      description: 'سلطات وبولات خضراء بمكونات طازجة',
      mealCount: 31,
      rating: '4.6',
      logoType: CalendarRestaurantLogoType.healthyBowl,
    ),
    CalendarRestaurantOptionEntity(
      name: 'فيت كيتشن',
      description: 'وجبات محسوبة السعرات ومناسبة للاشتراكات',
      mealCount: 36,
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
    final start = selectedDay % _mealCatalog.length;
    return List.generate(4, (index) {
      return _mealCatalog[(start + index) % _mealCatalog.length];
    });
  }

  List<CalendarMealPickerOption> getMealPickerOptions({
    required AppLocalizations locale,
    required int selectedTab,
  }) {
    final ingredients = [
      locale.calendar_grilled_chicken,
      locale.calendar_brown_rice,
      locale.calendar_broccoli,
      locale.calendar_carrot,
      locale.calendar_more,
    ];

    return switch (selectedTab) {
      0 => [
        (
          title: locale.calendar_meal_overnight_oats,
          imageAsset: AssetsFake.homeOatmeal,
          calories: '450',
          protein: '24',
          carbs: '62',
          fat: '12',
          ingredients: ingredients,
          selected: false,
          blockReason: null,
        ),
        (
          title: locale.calendar_meal_egg_avocado_toast,
          imageAsset: AssetsFake.homeDonut,
          calories: '180',
          protein: '8',
          carbs: '34',
          fat: '5',
          ingredients: ingredients,
          selected: true,
          blockReason: null,
        ),
        (
          title: locale.calendar_meal_greek_yogurt_parfait,
          imageAsset: AssetsFake.calendarMealPickerBreakfast,
          calories: '390',
          protein: '18',
          carbs: '58',
          fat: '9',
          ingredients: ingredients,
          selected: false,
          blockReason: null,
        ),
        (
          title: locale.calendar_meal_turkey_cheese_wrap,
          imageAsset: AssetsFake.calendarMealBowl,
          calories: '520',
          protein: '36',
          carbs: '42',
          fat: '16',
          ingredients: ingredients,
          selected: false,
          blockReason: null,
        ),
        (
          title: locale.calendar_meal_banana_protein_pancakes,
          imageAsset: AssetsFake.homeOatmeal,
          calories: '430',
          protein: '30',
          carbs: '50',
          fat: '13',
          ingredients: ingredients,
          selected: false,
          blockReason: null,
        ),
        (
          title: locale.calendar_meal_smoked_salmon_bagel,
          imageAsset: AssetsFake.grilledPlate,
          calories: '470',
          protein: '29',
          carbs: '44',
          fat: '17',
          ingredients: ingredients,
          selected: false,
          blockReason: null,
        ),
      ],
      1 => [
        (
          title: locale.calendar_meal_grilled_chicken_bowl,
          imageAsset: AssetsFake.grilledPlate,
          calories: '550',
          protein: '35',
          carbs: '55',
          fat: '18',
          ingredients: ingredients,
          selected: false,
          blockReason: null,
        ),
        (
          title: locale.calendar_meal_salmon_rice_plate,
          imageAsset: AssetsFake.calendarMealBowl,
          calories: '610',
          protein: '42',
          carbs: '48',
          fat: '21',
          ingredients: ingredients,
          selected: true,
          blockReason: null,
        ),
        (
          title: locale.calendar_meal_beef_vegetable_box,
          imageAsset: AssetsFake.homeHotdog,
          calories: '420',
          protein: '28',
          carbs: '39',
          fat: '14',
          ingredients: ingredients,
          selected: false,
          blockReason: null,
        ),
        (
          title: locale.calendar_meal_shrimp_noodle_bowl,
          imageAsset: AssetsFake.calendarMealPickerBreakfast,
          calories: '480',
          protein: '22',
          carbs: '64',
          fat: '11',
          ingredients: ingredients,
          selected: false,
          blockReason: null,
        ),
        (
          title: locale.calendar_meal_chicken_caesar_wrap,
          imageAsset: AssetsFake.grilledPlate,
          calories: '530',
          protein: '37',
          carbs: '46',
          fat: '16',
          ingredients: ingredients,
          selected: false,
          blockReason: null,
        ),
        (
          title: locale.calendar_meal_veggie_pasta_box,
          imageAsset: AssetsFake.homeDonut,
          calories: '500',
          protein: '21',
          carbs: '70',
          fat: '12',
          ingredients: ingredients,
          selected: false,
          blockReason: null,
        ),
      ],
      _ => [
        (
          title: locale.calendar_meal_lemon_chicken_salad,
          imageAsset: AssetsFake.homeHotdog,
          calories: '420',
          protein: '28',
          carbs: '39',
          fat: '14',
          ingredients: ingredients,
          selected: false,
          blockReason: null,
        ),
        (
          title: locale.calendar_meal_tuna_potato_plate,
          imageAsset: AssetsFake.grilledPlate,
          calories: '550',
          protein: '35',
          carbs: '55',
          fat: '18',
          ingredients: ingredients,
          selected: true,
          blockReason: null,
        ),
        (
          title: locale.calendar_meal_steak_mushroom_plate,
          imageAsset: AssetsFake.homeDonut,
          calories: '180',
          protein: '8',
          carbs: '34',
          fat: '5',
          ingredients: ingredients,
          selected: false,
          blockReason: null,
        ),
        (
          title: locale.calendar_meal_chicken_soup_box,
          imageAsset: AssetsFake.homeOatmeal,
          calories: '450',
          protein: '24',
          carbs: '62',
          fat: '12',
          ingredients: ingredients,
          selected: false,
          blockReason: null,
        ),
        (
          title: locale.calendar_meal_halloumi_salad,
          imageAsset: AssetsFake.calendarMealPickerBreakfast,
          calories: '390',
          protein: '24',
          carbs: '34',
          fat: '20',
          ingredients: ingredients,
          selected: false,
          blockReason: null,
        ),
        (
          title: locale.calendar_meal_light_fajita_bowl,
          imageAsset: AssetsFake.calendarMealBowl,
          calories: '510',
          protein: '39',
          carbs: '43',
          fat: '15',
          ingredients: ingredients,
          selected: false,
          blockReason: null,
        ),
      ],
    };
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
