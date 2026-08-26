import 'package:intl/intl.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/features/calendar/data/models/request/calendar_save_meals_request_dto.dart';
import 'package:meal_meat_user/features/calendar/data/models/request/calendar_set_restaurant_request_dto.dart';
import 'package:meal_meat_user/features/calendar/data/models/response/calendar_available_meals_response_dto.dart';
import 'package:meal_meat_user/features/calendar/data/models/response/calendar_day_response_dto.dart';
import 'package:meal_meat_user/features/calendar/data/models/response/calendar_response_dto.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_available_meals_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_day_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_meal_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_restaurant_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_restaurant_option_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_subscription_entity.dart';

extension CalendarDayResponseDtoMapper on CalendarDayResponseDto {
  CalendarDayEntity toEntity(String localeName) {
    final parsedDate = _parseDate(serviceDate ?? date);
    final selectedRestaurant =
        restaurant?.toRestaurantEntity(localeName) ??
        _flatRestaurantEntity(localeName);
    final dayMeals = selectedMeals ?? meals ?? const [];
    return CalendarDayEntity(
      id: id ?? '',
      status: status ?? '',
      restaurantId: restaurantId ?? selectedRestaurant?.id,
      restaurant: selectedRestaurant,
      meals: dayMeals
          .map(
            (meal) =>
                meal.toMealEntity(localeName, selectedMealIds ?? const []),
          )
          .toList(),
      selectedMealIds: selectedMealIds ?? const [],
      slotRequirements: (slotRequirements ?? const [])
          .map((requirement) => requirement.toEntity())
          .where(
            (requirement) =>
                requirement.slot.isNotEmpty && requirement.count > 0,
          )
          .toList(),
      isLocked: isLocked ?? !(canEdit ?? true),
      editDeadlineUtc: _parseDateTime(
        selectionDeadlineUtc ?? editDeadlineUtc ?? lockAtUtc ?? lockedAtUtc,
      ),
      dayNumber: parsedDate?.day ?? 0,
      weekday: parsedDate == null
          ? ''
          : DateFormat.E(localeName).format(parsedDate),
      date: parsedDate,
      hasMeals: true,
    );
  }

  CalendarRestaurantEntity? _flatRestaurantEntity(String localeName) {
    if ((restaurantId == null || restaurantId!.isEmpty) &&
        (restaurantNameAr == null || restaurantNameAr!.isEmpty) &&
        (restaurantNameEn == null || restaurantNameEn!.isEmpty)) {
      return null;
    }

    return CalendarRestaurantEntity(
      id: restaurantId ?? '',
      name: _localized(
        localeName,
        ar: restaurantNameAr,
        en: restaurantNameEn,
        fallback: restaurantNameEn ?? restaurantNameAr,
      ),
      category: '',
      rating: '',
      deliveryDuration: '',
      deliveryWindow: '',
    );
  }
}

extension CalendarRestaurantResponseDtoMapper on CalendarRestaurantResponseDto {
  CalendarRestaurantEntity toRestaurantEntity(String localeName) {
    return CalendarRestaurantEntity(
      id: _firstNotEmpty([restaurantId, id]),
      logoUrl: _firstNullableNotEmpty([logoUrl, imageUrl]),
      maxUsageCount: maxUsageCount,
      name: _localized(localeName, ar: nameAr, en: nameEn, fallback: name),
      category: _localized(
        localeName,
        ar: categoryAr,
        en: categoryEn,
        fallback: category,
      ),
      rating: rating?.toString() ?? '',
      deliveryDuration: deliveryDuration ?? '',
      deliveryWindow: deliveryWindow ?? '',
    );
  }

  CalendarRestaurantOptionEntity toOptionEntity(
    String localeName, {
    bool isUsageLimitReached = false,
    int? calculatedMaxUsageCount,
  }) {
    return CalendarRestaurantOptionEntity(
      id: _firstNotEmpty([restaurantId, id]),
      logoUrl: _firstNullableNotEmpty([logoUrl, imageUrl]),
      maxUsageCount: maxUsageCount ?? calculatedMaxUsageCount,
      isUsageLimitReached: isUsageLimitReached,
      name: _localized(localeName, ar: nameAr, en: nameEn, fallback: name),
      description: _localized(
        localeName,
        ar: descriptionAr,
        en: descriptionEn,
        fallback: description,
      ),
      mealCount: safeMealCount ?? mealCount ?? 0,
      rating: rating?.toString() ?? '',
      logoType: CalendarRestaurantLogoType.healthyBowl,
    );
  }
}

extension CalendarMealResponseDtoMapper on CalendarMealResponseDto {
  CalendarMealEntity toMealEntity(String localeName, List<String> selectedIds) {
    final resolvedId = _firstNotEmpty([mealId, id]);
    final ingredientNames = (ingredients ?? const [])
        .map(
          (ingredient) => _localized(
            localeName,
            ar: ingredient.nameAr,
            en: ingredient.nameEn,
            fallback: ingredient.name,
          ),
        )
        .where((ingredient) => ingredient.isNotEmpty)
        .take(5)
        .toList();

    return CalendarMealEntity(
      id: resolvedId,
      slot: slot ?? mealType ?? '',
      imageUrl: imageUrl,
      blockReason: blockReason,
      selected: (isSelected ?? false) || selectedIds.contains(resolvedId),
      mealType: _localized(
        localeName,
        ar: slotNameAr,
        en: slotNameEn,
        fallback: slotName ?? mealType ?? slot,
      ),
      title: _localized(
        localeName,
        ar: nameAr,
        en: nameEn,
        fallback: name ?? title,
      ),
      time: time ?? '',
      calories: calories?.toString() ?? '',
      protein: proteinG?.toString() ?? '',
      carbs: carbsG?.toString() ?? '',
      fat: fatG?.toString() ?? '',
      ingredients: ingredientNames,
      imageAsset: Assets.calendarMealPickerHero,
      actionLabel: '',
    );
  }
}

extension CalendarSlotRequirementResponseDtoMapper
    on CalendarSlotRequirementResponseDto {
  CalendarSlotRequirementEntity toEntity() {
    return CalendarSlotRequirementEntity(
      slot: slot ?? '',
      slotNameAr: slotNameAr ?? slotName ?? '',
      slotNameEn: slotNameEn ?? slotName ?? slotNameAr ?? '',
      count: count ?? 0,
    );
  }
}

extension CalendarAvailableMealsResponseDtoMapper
    on CalendarAvailableMealsResponseDto {
  CalendarAvailableMealsEntity toEntity(String localeName) {
    return CalendarAvailableMealsEntity(
      restaurant:
          restaurant?.toRestaurantEntity(localeName) ??
          _flatRestaurantEntity(localeName),
      meals: (meals ?? const [])
          .map((meal) => meal.toMealEntity(localeName, const []))
          .where((meal) => meal.id.isNotEmpty)
          .toList(),
      slotRequirements: (slotRequirements ?? const [])
          .map((requirement) => requirement.toEntity())
          .where(
            (requirement) =>
                requirement.slot.isNotEmpty && requirement.count > 0,
          )
          .toList(),
    );
  }

  CalendarRestaurantEntity? _flatRestaurantEntity(String localeName) {
    if ((restaurantId == null || restaurantId!.isEmpty) &&
        (nameAr == null || nameAr!.isEmpty) &&
        (nameEn == null || nameEn!.isEmpty)) {
      return null;
    }

    return CalendarRestaurantEntity(
      id: restaurantId ?? '',
      logoUrl: logoUrl,
      name: _localized(localeName, ar: nameAr, en: nameEn, fallback: nameEn),
      category: '',
      rating: '',
      deliveryDuration: '',
      deliveryWindow: '',
    );
  }
}

extension CalendarResponseMapper on CalendarResponseDto {
  CalendarSubscriptionEntity toSubscriptionEntity({
    required String subscriptionId,
    required String localeName,
  }) {
    final globalSlotRequirements = slotRequirements ?? const [];
    final mappedDays =
        (days ?? const [])
            .map((day) => _withGlobalSlots(day, globalSlotRequirements))
            .map((day) => day.toEntity(localeName))
            .where((day) => day.date != null)
            .toList()
          ..sort((a, b) => a.date!.compareTo(b.date!));

    return CalendarSubscriptionEntity(
      subscriptionId: this.subscriptionId ?? subscriptionId,
      days: mappedDays,
    );
  }

  CalendarDayResponseDto _withGlobalSlots(
    CalendarDayResponseDto day,
    List<CalendarSlotRequirementResponseDto> globalSlotRequirements,
  ) {
    if (day.slotRequirements != null || globalSlotRequirements.isEmpty) {
      return day;
    }

    return CalendarDayResponseDto(
      id: day.id,
      date: day.date,
      serviceDate: day.serviceDate,
      status: day.status,
      isLocked: day.isLocked,
      lockedAtUtc: day.lockedAtUtc,
      editDeadlineUtc: day.editDeadlineUtc,
      restaurantId: day.restaurantId,
      restaurantNameAr: day.restaurantNameAr,
      restaurantNameEn: day.restaurantNameEn,
      restaurant: day.restaurant,
      selectedMealIds: day.selectedMealIds,
      selectedMeals: day.selectedMeals,
      meals: day.meals,
      slotRequirements: globalSlotRequirements,
      canEdit: day.canEdit,
      selectionDeadlineUtc: day.selectionDeadlineUtc,
      lockAtUtc: day.lockAtUtc,
    );
  }
}

extension CalendarSetRestaurantRequestMapper on String {
  CalendarSetRestaurantRequestDto toSetRestaurantDto() {
    return CalendarSetRestaurantRequestDto(restaurantId: this);
  }
}

extension CalendarMealRequestMapper on CalendarMealEntity {
  CalendarSaveMealsRequestDto toSaveMealsDto() {
    return CalendarSaveMealsRequestDto(mealId: id, slot: slot.toLowerCase());
  }
}

DateTime? _parseDate(String? value) {
  if (value == null || value.isEmpty) return null;
  return DateTime.tryParse(value);
}

DateTime? _parseDateTime(String? value) {
  if (value == null || value.isEmpty) return null;
  return DateTime.tryParse(value);
}

String _localized(
  String localeName, {
  String? ar,
  String? en,
  String? fallback,
}) {
  final value = localeName.startsWith('ar')
      ? ar ?? fallback ?? en
      : en ?? fallback ?? ar;
  return value ?? '';
}

String _firstNotEmpty(List<String?> values) {
  return _firstNullableNotEmpty(values) ?? '';
}

String? _firstNullableNotEmpty(List<String?> values) {
  for (final value in values) {
    if (value != null && value.trim().isNotEmpty) return value.trim();
  }
  return null;
}
