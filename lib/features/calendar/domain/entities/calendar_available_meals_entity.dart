import 'package:meal_meat_user/features/calendar/domain/entities/calendar_meal_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_restaurant_entity.dart';

class CalendarAvailableMealsEntity {
  const CalendarAvailableMealsEntity({
    required this.restaurant,
    required this.meals,
    required this.slotRequirements,
    this.slots = const [],
    this.coreIngredients = const [],
    this.serviceDate,
    this.requiredCount,
    this.filledCount,
  });

  final CalendarRestaurantEntity? restaurant;
  final List<CalendarMealEntity> meals;
  final List<CalendarSlotRequirementEntity> slotRequirements;
  final List<CalendarSlotMealsEntity> slots;
  final List<CalendarCoreIngredientEntity> coreIngredients;
  final String? serviceDate;
  final int? requiredCount;
  final int? filledCount;

  int get requiredMealsCount {
    if (requiredCount != null && requiredCount! > 0) {
      return requiredCount!;
    }
    return slotRequirements.fold<int>(
      0,
      (total, requirement) => total + requirement.count,
    );
  }

  CalendarAvailableMealsEntity copyWith({
    CalendarRestaurantEntity? restaurant,
    List<CalendarMealEntity>? meals,
    List<CalendarSlotRequirementEntity>? slotRequirements,
    List<CalendarSlotMealsEntity>? slots,
    List<CalendarCoreIngredientEntity>? coreIngredients,
    String? serviceDate,
    int? requiredCount,
    int? filledCount,
  }) {
    return CalendarAvailableMealsEntity(
      restaurant: restaurant ?? this.restaurant,
      meals: meals ?? this.meals,
      slotRequirements: slotRequirements ?? this.slotRequirements,
      slots: slots ?? this.slots,
      coreIngredients: coreIngredients ?? this.coreIngredients,
      serviceDate: serviceDate ?? this.serviceDate,
      requiredCount: requiredCount ?? this.requiredCount,
      filledCount: filledCount ?? this.filledCount,
    );
  }
}

class CalendarSlotMealsEntity {
  const CalendarSlotMealsEntity({
    required this.slot,
    required this.displayName,
    required this.slotNameAr,
    required this.slotNameEn,
    required this.count,
    this.page = 1,
    this.pageSize = 20,
    this.totalCount = 0,
    this.totalPages = 1,
    this.hasNextPage = false,
    this.hasPreviousPage = false,
    this.meals = const [],
  });

  final String slot;
  final String displayName;
  final String slotNameAr;
  final String slotNameEn;
  final int count;
  final int page;
  final int pageSize;
  final int totalCount;
  final int totalPages;
  final bool hasNextPage;
  final bool hasPreviousPage;
  final List<CalendarMealEntity> meals;

  String name(String localeName) => displayName.isNotEmpty
      ? displayName
      : localeName == 'ar'
      ? slotNameAr
      : slotNameEn;

  CalendarSlotMealsEntity copyWith({
    String? slot,
    String? displayName,
    String? slotNameAr,
    String? slotNameEn,
    int? count,
    int? page,
    int? pageSize,
    int? totalCount,
    int? totalPages,
    bool? hasNextPage,
    bool? hasPreviousPage,
    List<CalendarMealEntity>? meals,
  }) {
    return CalendarSlotMealsEntity(
      slot: slot ?? this.slot,
      displayName: displayName ?? this.displayName,
      slotNameAr: slotNameAr ?? this.slotNameAr,
      slotNameEn: slotNameEn ?? this.slotNameEn,
      count: count ?? this.count,
      page: page ?? this.page,
      pageSize: pageSize ?? this.pageSize,
      totalCount: totalCount ?? this.totalCount,
      totalPages: totalPages ?? this.totalPages,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      hasPreviousPage: hasPreviousPage ?? this.hasPreviousPage,
      meals: meals ?? this.meals,
    );
  }
}

class CalendarCoreIngredientEntity {
  const CalendarCoreIngredientEntity({
    required this.id,
    required this.name,
    required this.iconUrl,
    required this.isLocal,
    required this.originCountryCode,
    required this.originCountryName,
    required this.flagEmoji,
  });

  final String id;
  final String name;
  final String? iconUrl;
  final bool isLocal;
  final String originCountryCode;
  final String originCountryName;
  final String? flagEmoji;
}

class CalendarSlotRequirementEntity {
  const CalendarSlotRequirementEntity({
    required this.slot,
    required this.displayName,
    required this.slotNameAr,
    required this.slotNameEn,
    required this.count,
  });

  final String slot;
  final String displayName;
  final String slotNameAr;
  final String slotNameEn;
  final int count;

  String name(String localeName) => displayName.isNotEmpty
      ? displayName
      : localeName == 'ar'
      ? slotNameAr
      : slotNameEn;
}
