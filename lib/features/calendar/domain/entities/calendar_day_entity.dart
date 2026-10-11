import 'package:meal_meat_user/features/calendar/domain/entities/calendar_available_meals_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_meal_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_nutrition_totals_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_restaurant_entity.dart';

class CalendarDayEntity {
  const CalendarDayEntity({
    this.id = '',
    this.status = '',
    this.uiStatus,
    this.canEdit,
    this.failureReasonCode,
    this.editBlockReason,
    this.selectionDeadlineUtc,
    this.lockAtUtc,
    this.lockRemainingSeconds,
    this.filledCount,
    this.requiredCount,
    this.restaurantId,
    this.restaurant,
    this.meals = const [],
    this.selectedMealIds = const [],
    this.nutritionTotals = const CalendarNutritionTotalsEntity(),
    this.slotRequirements = const [],
    bool isLocked = false,
    this.editDeadlineUtc,
    required this.dayNumber,
    required this.weekday,
    this.date,
    this.isSelected = false,
    this.isMuted = false,
    this.hasMeals = true,
    // ignore: prefer_initializing_formals
  }) : _isLocked = isLocked;

  final String id;
  final String status;
  final String? uiStatus;
  final bool? canEdit;
  final String? failureReasonCode;
  final String? editBlockReason;
  final DateTime? selectionDeadlineUtc;
  final DateTime? lockAtUtc;
  final int? lockRemainingSeconds;
  final int? filledCount;
  final int? requiredCount;
  final String? restaurantId;
  final CalendarRestaurantEntity? restaurant;
  final List<CalendarMealEntity> meals;
  final List<String> selectedMealIds;
  final CalendarNutritionTotalsEntity nutritionTotals;
  final List<CalendarSlotRequirementEntity> slotRequirements;
  final bool _isLocked;
  final DateTime? editDeadlineUtc;
  final int dayNumber;
  final String weekday;
  final DateTime? date;
  final bool isSelected;
  final bool isMuted;
  final bool hasMeals;

  bool get isLockedReason {
    final r = editBlockReason?.toLowerCase();
    return r == 'selection_deadline_passed' ||
        r == 'day_locked' ||
        r == 'day_frozen' ||
        r == 'day_cancelled';
  }

  bool get isLocked => _isLocked || canEdit == false || isLockedReason;

  bool get isCustomerSelected {
    final s = status.toLowerCase();
    final ui = (uiStatus ?? '').toLowerCase();
    return s.contains('customerselected') || ui.contains('customerselected');
  }

  bool get isSentToRestaurant {
    final s = status.toLowerCase();
    final ui = (uiStatus ?? '').toLowerCase();
    return s.contains('senttorestaurant') || ui.contains('senttorestaurant');
  }

  bool get isFrozen {
    final normalizedStatus = status.toLowerCase();
    final normalizedUiStatus = (uiStatus ?? '').toLowerCase();
    return normalizedStatus == 'frozen' ||
        normalizedStatus == '12' ||
        normalizedUiStatus == 'frozen' ||
        failureReasonCode == 'subscription.day_frozen' ||
        editBlockReason == 'day_frozen';
  }

  bool get hasSelectedMeals {
    return selectedMealIds.isNotEmpty || meals.any((meal) => meal.selected);
  }

  bool get isConfirmed {
    final s = status.toLowerCase();
    final ui = (uiStatus ?? '').toLowerCase();
    return s.contains('confirmed') || ui.contains('confirmed');
  }

  bool get isAwaitingRestaurantConfirmation {
    if (isConfirmed) return false;
    if (isCustomerSelected && !isSentToRestaurant) return false;
    final s = '${status}_$uiStatus'.toLowerCase();
    return s.contains('senttorestaurant') ||
        (s.contains('awaiting') && !s.contains('customerselected'));
  }

  bool get isRestaurantClosed {
    if (isFrozen || isLocked) return true;
    final s = '${status}_$uiStatus'.toLowerCase();
    return s.contains('restaurant') ||
        s.contains('lock') ||
        s.contains('completed') ||
        s.contains('cancelled');
  }

  /// Server is the single source of truth for editing permission.
  bool get isEditable => canEdit == true && !isLocked;

  CalendarDayEntity copyWith({
    String? id,
    String? status,
    String? uiStatus,
    bool? canEdit,
    String? failureReasonCode,
    String? editBlockReason,
    DateTime? selectionDeadlineUtc,
    DateTime? lockAtUtc,
    int? lockRemainingSeconds,
    int? filledCount,
    int? requiredCount,
    String? restaurantId,
    CalendarRestaurantEntity? restaurant,
    List<CalendarMealEntity>? meals,
    List<String>? selectedMealIds,
    CalendarNutritionTotalsEntity? nutritionTotals,
    List<CalendarSlotRequirementEntity>? slotRequirements,
    bool? isLocked,
    DateTime? editDeadlineUtc,
    int? dayNumber,
    String? weekday,
    DateTime? date,
    bool? isSelected,
    bool? isMuted,
    bool? hasMeals,
    bool clearEditBlockReason = false,
  }) {
    return CalendarDayEntity(
      id: id ?? this.id,
      status: status ?? this.status,
      uiStatus: uiStatus ?? this.uiStatus,
      canEdit: canEdit ?? this.canEdit,
      failureReasonCode: failureReasonCode ?? this.failureReasonCode,
      editBlockReason: clearEditBlockReason
          ? null
          : (editBlockReason ?? this.editBlockReason),
      selectionDeadlineUtc: selectionDeadlineUtc ?? this.selectionDeadlineUtc,
      lockAtUtc: lockAtUtc ?? this.lockAtUtc,
      lockRemainingSeconds: lockRemainingSeconds ?? this.lockRemainingSeconds,
      filledCount: filledCount ?? this.filledCount,
      requiredCount: requiredCount ?? this.requiredCount,
      restaurantId: restaurantId ?? this.restaurantId,
      restaurant: restaurant ?? this.restaurant,
      meals: meals ?? this.meals,
      selectedMealIds: selectedMealIds ?? this.selectedMealIds,
      nutritionTotals: nutritionTotals ?? this.nutritionTotals,
      slotRequirements: slotRequirements ?? this.slotRequirements,
      isLocked: isLocked ?? this.isLocked,
      editDeadlineUtc: editDeadlineUtc ?? this.editDeadlineUtc,
      dayNumber: dayNumber ?? this.dayNumber,
      weekday: weekday ?? this.weekday,
      date: date ?? this.date,
      isSelected: isSelected ?? this.isSelected,
      isMuted: isMuted ?? this.isMuted,
      hasMeals: hasMeals ?? this.hasMeals,
    );
  }
}
